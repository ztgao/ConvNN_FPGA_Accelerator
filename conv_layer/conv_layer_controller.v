//	version	1.0	--	setup
//	Description:


module conv_layer_controller(
	
	//--input
	clk,
	rst_n,
	enable,
	input_interface_ack,
	
	//--output
	input_interface_cmd,
	current_state
//	kernel_array_cmd,
//	output_inteface_cmd,
);

`include "../conv_layer_param.v"

input					clk;
input					rst_n;
input					enable;
input	[1:0]			input_interface_ack;


output 	[1:0]			input_interface_cmd;
reg		[1:0]			input_interface_cmd;

reg		[1:0]			weight_cycle;
reg		[2:0]			shift_cycle;

output	[2:0]			current_state;
reg		[2:0]			current_state;
reg		[2:0]			next_state;



always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		current_state	<=	STAGE_INIT;
	end
	else begin
		if (enable)
			current_state	<=	next_state;
		else
			current_state	<= 	current_state;
	end
end

always @(current_state, input_interface_ack, weight_cycle) begin
	case (current_state)
		STAGE_INIT: begin
			next_state	=	STAGE_PRELOAD;
		end
		
		STAGE_PRELOAD: begin
			if ( input_interface_ack == ACK_PRELOAD_FIN )
				next_state	=	STAGE_SHIFT;
			else
				next_state	=	STAGE_PRELOAD;
		end
		
		STAGE_SHIFT: begin
			if ( input_interface_ack == ACK_SHIFT_FIN ) begin
				if ( weight_cycle == TOTAL_WEIGHT - 1  ) begin
					if ( shift_cycle  == TOTAL_SHIFT - 1 )
						next_state	<=	STAGE_PRELOAD;
					else
						next_state	=	STAGE_LOAD;
				end
				else
					next_state	=	STAGE_SHIFT;
			end
			else
				next_state	= STAGE_SHIFT;
		end
		
		STAGE_LOAD: begin
			if (input_interface_ack	==	ACK_LOAD_FIN)
				next_state	=	STAGE_SHIFT;
			else
				next_state	=	STAGE_LOAD;
		end
		
		default:
			next_state	= current_state;
	endcase		
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		input_interface_cmd	<=	CMD_IDLE;
	else begin
		case (current_state)
			STAGE_INIT:
				input_interface_cmd <=	CMD_PRELOAD_START;
				
			STAGE_PRELOAD:
				if ( input_interface_ack == ACK_PRELOAD_FIN )
					input_interface_cmd	<=	CMD_SHIFT_START;
				else
					input_interface_cmd	<=	CMD_IDLE;
					
			STAGE_SHIFT:
				if ( input_interface_ack == ACK_SHIFT_FIN) begin
					if ( weight_cycle == TOTAL_WEIGHT - 1 ) begin
						if ( shift_cycle  == TOTAL_SHIFT - 1 )
							input_interface_cmd	<=	CMD_PRELOAD_START;
						else
							input_interface_cmd	<=	CMD_LOAD_START;
					end	
					else
						input_interface_cmd	<=	CMD_SHIFT_START;
				end
				else
					input_interface_cmd	<= CMD_IDLE;
			
			STAGE_LOAD:
				if ( input_interface_ack == ACK_LOAD_FIN)
					input_interface_cmd	<=	CMD_SHIFT_START;
				else
					input_interface_cmd	<=	CMD_IDLE;
					
			default:
				input_interface_cmd	<=	CMD_IDLE;
		endcase
	end
end

//	--	
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 	
		weight_cycle	<=	2'd0;
	else if ( input_interface_ack == ACK_SHIFT_FIN) begin
		if ( weight_cycle == TOTAL_WEIGHT - 1 )
			weight_cycle	<=	2'd0;
		else
			weight_cycle	<=	weight_cycle	+ 1'd1;
	end 
	else
		weight_cycle	<=	weight_cycle;	
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 	
		shift_cycle		<=	3'd0;
	else if (input_interface_ack == ACK_SHIFT_FIN) begin
		if ( weight_cycle == TOTAL_WEIGHT - 1)
			shift_cycle		<=	shift_cycle	+ 1'b1;
		else
			shift_cycle		<=	shift_cycle;
	end
	else if ( shift_cycle == TOTAL_SHIFT)
		shift_cycle		<=	3'd0;
end

endmodule
		