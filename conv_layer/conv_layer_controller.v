//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"
module conv_layer_controller(
	
	//--input
	clk,
	rst_n,
	enable,
	//
	input_interface_ack,
	//--output
	
	input_interface_cmd,
	kernel_array_clear,	
	kernel_calc_fin,
	
	feature_idx,
	feature_row
//	kernel_array_cmd,
//	output_inteface_cmd,
);

`include "../../conv_layer/conv_kernel_param.v"

input					clk;
input					rst_n;
input					enable;
input	[1:0]			input_interface_ack;


output 	[1:0]			input_interface_cmd;
reg		[1:0]			input_interface_cmd;

reg		[1:0]			weight_cycle;
reg		[2:0]			shift_cycle;

reg		[2:0]			current_state;
reg		[2:0]			next_state;

output reg				kernel_array_clear;
output reg				kernel_calc_fin;

output reg	[1:0]		feature_idx;
output reg	[1:0]		feature_row;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		current_state	<=	STATE_INIT;
	else begin
		if (enable)
			current_state	<=	next_state;
		else
			current_state	<= 	current_state;
	end
end

always @(current_state, input_interface_ack, weight_cycle) begin
	case (current_state)
		STATE_INIT: 
			next_state	=	STATE_PRELOAD;
		
		STATE_PRELOAD: 
			if ( input_interface_ack == ACK_PRELOAD_FIN )
				next_state	=	STATE_SHIFT;
			else
				next_state	=	STATE_PRELOAD;
		
		STATE_SHIFT: begin
			if ( input_interface_ack == ACK_SHIFT_FIN ) begin
				if ( weight_cycle == TOTAL_WEIGHT - 1  ) begin
					if ( shift_cycle  == TOTAL_SHIFT - 1 )
						next_state	<=	STATE_PRELOAD;
					else
						next_state	=	STATE_LOAD;
				end
				else
					next_state	=	STATE_SHIFT;
			end
			else
				next_state	= STATE_SHIFT;
		end
		
		STATE_LOAD: 
			if (input_interface_ack	==	ACK_LOAD_FIN)
				next_state	=	STATE_SHIFT;
			else
				next_state	=	STATE_LOAD;
		
		default:
			next_state	= current_state;
	endcase		
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		input_interface_cmd	<=	CMD_IDLE;
	else begin
		case (current_state)
			STATE_INIT:
				if (enable)
					input_interface_cmd <=	CMD_PRELOAD;
				else
					input_interface_cmd	<=	CMD_IDLE;
				
			STATE_PRELOAD:
				if ( input_interface_ack == ACK_PRELOAD_FIN )
					input_interface_cmd	<=	CMD_SHIFT;
				else
					input_interface_cmd	<=	CMD_IDLE;
					
			STATE_SHIFT:
				if ( input_interface_ack == ACK_SHIFT_FIN) begin
					if ( weight_cycle == TOTAL_WEIGHT - 1 ) begin
						if ( shift_cycle  == TOTAL_SHIFT - 1 )
							input_interface_cmd	<=	CMD_PRELOAD;
						else
							input_interface_cmd	<=	CMD_LOAD;
					end	
					else
						input_interface_cmd	<=	CMD_SHIFT;
				end
				else
					input_interface_cmd	<= CMD_IDLE;
			
			STATE_LOAD:
				if ( input_interface_ack == ACK_LOAD_FIN)
					input_interface_cmd	<=	CMD_SHIFT;
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
	else if (input_interface_ack == ACK_SHIFT_FIN && weight_cycle == TOTAL_WEIGHT - 1) 
		shift_cycle		<=	shift_cycle	+ 1'b1;	
	else if ( shift_cycle == TOTAL_SHIFT)
		shift_cycle		<=	3'd0;
	else
		shift_cycle	<=	shift_cycle;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		kernel_array_clear	<=	0;
	else if (input_interface_ack == ACK_SHIFT_FIN)
		kernel_array_clear	<=	1;
	else
		kernel_array_clear	<=	0;
end

reg		kernel_calc_fin_delay_0;
reg		kernel_calc_fin_delay_1;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		kernel_calc_fin			<=	0;
		kernel_calc_fin_delay_0	<=	0;
	end
	else begin
		kernel_calc_fin			<=	kernel_calc_fin_delay_0;
		kernel_calc_fin_delay_0	<=	kernel_calc_fin_delay_1;
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		kernel_calc_fin_delay_1	<=	0;
	else if (input_interface_ack == ACK_SHIFT_FIN)
		kernel_calc_fin_delay_1	<=	1;
	else
		kernel_calc_fin_delay_1	<=	0;				
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		feature_idx	<=	2'd0;
	else if(kernel_calc_fin)
		feature_idx	<=	weight_cycle;
	else
		feature_idx	<=	feature_idx;
end	


always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		feature_row	<=	2'd0;
	else if(kernel_calc_fin)
		feature_row	<=	shift_cycle;
	else
		feature_row	<=	feature_row;
end		

endmodule
		