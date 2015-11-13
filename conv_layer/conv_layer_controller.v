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

parameter	WIDTH				=	32;
parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

parameter	ADDR_WIDTH			=	6;
parameter	ROM_DEPTH			=	64;

// parameter	INIT				=	3'd0;
// parameter	PRELOAD				=	3'd1;	
// parameter	SHIFT_ROW_0			=	3'd2;
// parameter	SHIFT_ROW_1			=	3'd3;
// parameter	SHIFT_ROW_2			=	3'd4;
// parameter	BIAS				=	3'd5;
// parameter	LOAD				=	3'd6;
// parameter	IDLE				=	3'd7;

parameter	ACK_IDLE			=	2'd0;
parameter	ACK_PRELOAD_FIN		=	2'd1;
parameter	ACK_SHIFT_FIN		=	2'd2;
parameter	ACK_LOAD_FIN		=	2'd3;

parameter	CMD_IDLE			=	2'd0;
parameter	CMD_PRELOAD_START	=	2'd1;
parameter	CMD_SHIFT_START		=	2'd2;
parameter	CMD_LOAD_START		=	2'd3;

parameter	TOTAL_WEIGHT		=	4;
parameter	TOTAL_SHIFT			=	ARRAY_SIZE;

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

parameter	STAGE_INIT			=	3'd0;
parameter	STAGE_PRELOAD		=	3'd1;	
parameter	STAGE_SHIFT			=	3'd2;
parameter	STAGE_LOAD			=	3'd3;
//parameter	STAGE_IDLE			=	3'd7;

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
		