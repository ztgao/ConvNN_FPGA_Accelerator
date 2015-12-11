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
//	kernel_array_clear,	
	valid,
	
	image_calc_fin,
	
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

reg		[1:0]			weight_idx;
reg		[2:0]			row_idx;

reg		[2:0]			current_state;
reg		[2:0]			next_state;

//output reg				kernel_array_clear;
output reg				valid;

output reg				image_calc_fin;

output reg	[1:0]		feature_idx;
output reg	[2:0]		feature_row;

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

always @(current_state, input_interface_ack, weight_idx) begin
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
				if ( weight_idx == TOTAL_WEIGHT - 1  ) begin
					if ( row_idx  == TOTAL_ROW - 1 )
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
					if ( weight_idx == TOTAL_WEIGHT - 1 ) begin
						if ( row_idx  == TOTAL_ROW - 1 )
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
		weight_idx	<=	2'd0;
	else if ( input_interface_ack == ACK_SHIFT_FIN) begin
		if ( weight_idx == TOTAL_WEIGHT - 1 )
			weight_idx	<=	2'd0;
		else
			weight_idx	<=	weight_idx	+ 1'd1;
	end 
	else
		weight_idx	<=	weight_idx;	
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 	
		row_idx		<=	3'd0;
	else if (input_interface_ack == ACK_SHIFT_FIN && weight_idx == TOTAL_WEIGHT - 1) 
		row_idx		<=	row_idx	+ 1'b1;	
	else if ( row_idx == TOTAL_ROW)
		row_idx		<=	3'd0;
	else
		row_idx	<=	row_idx;
end

//-------------------------------------
reg		valid_delay_0;
reg		valid_delay_1;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		valid			<=	0;
		valid_delay_0	<=	0;
	end
	else begin
		valid			<=	valid_delay_0;
		valid_delay_0	<=	valid_delay_1;
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		valid_delay_1	<=	0;
	else if (input_interface_ack == ACK_SHIFT_FIN)
		valid_delay_1	<=	1;
	else
		valid_delay_1	<=	0;				
end
//-------------------------------------

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		feature_idx	<=	2'd0;
	else if(valid)
		feature_idx	<=	weight_idx;
	else
		feature_idx	<=	feature_idx;
end	


always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		feature_row	<=	2'd0;
	else if(valid)
		feature_row	<=	row_idx;
	else
		feature_row	<=	feature_row;
end

// always @(posedge clk, negedge rst_n) begin
	// if(!rst_n) 
		// image_calc_fin	<=	0;
	// else if(valid && feature_idx == TOTAL_WEIGHT-1 && feature_row = TOTAL_ROW- 1)
		// image_calc_fin	<=	1;
	// else
		// image_calc_fin	<=	0;
// end	

always @(*)	begin
	if(valid && feature_idx == TOTAL_WEIGHT-1 && feature_row == TOTAL_ROW- 1)
		image_calc_fin	=	1;
	else
		image_calc_fin	=	0;
end

endmodule
		