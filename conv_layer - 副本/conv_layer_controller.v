//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"
module conv_layer_controller
#(parameter KERNEL_SIZE 	= 	2,
			ARRAY_SIZE		= 	6,
			ARRAY_WIDTH 	= 	3,
			BUFFER_ROW_WIDTH = 	2,
			TOTAL_WEIGHT 	= 	4,
			WEIGHT_WIDTH	=	2)
(	
//--input
	clk,
	rst_n,
	enable,
	input_interface_ack,
//--output
	input_interface_cmd,
	valid,
	
	image_calc_fin,
	
	feature_idx,
	feature_row
);

`include "../../conv_layer/conv_kernel_param.v"

input					clk;
input					rst_n;
input					enable;
input	[1:0]			input_interface_ack;


output 	[1:0]			input_interface_cmd;
reg		[1:0]			input_interface_cmd;

reg		[WEIGHT_WIDTH-1:0]			weight_idx;
reg		[ARRAY_WIDTH-1:0]			row_idx;

reg		[2:0]			current_state;
reg		[2:0]			next_state;

output reg				valid;

output reg				image_calc_fin;

output reg	[WEIGHT_WIDTH-1:0]		feature_idx;
output reg	[ARRAY_WIDTH-1:0]		feature_row;

reg		[BUFFER_ROW_WIDTH:0] 		preload_cycle;

wire		lastPreloadCycle;
wire		lastWeight;
wire		lastRow;

assign		lastPreloadCycle 	= 	(preload_cycle == KERNEL_SIZE -1);
assign		lastWeight			=	(weight_idx == TOTAL_WEIGHT - 1);
assign		lastRow				=	(row_idx  == ARRAY_SIZE - 1);

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		current_state	<=	STATE_IDLE;
	else begin
		if (enable)
			current_state	<=	next_state;
		else
			current_state	<= 	STATE_IDLE;
	end
end

always @(current_state, input_interface_ack, weight_idx) begin
	case (current_state)
		STATE_IDLE: 
			if(enable)
				next_state	=	STATE_PRELOAD;
			else
				next_state	=	STATE_IDLE;
		
		STATE_PRELOAD: 
			if ( input_interface_ack == ACK_LOAD_FIN )
				if ( lastPreloadCycle )
					next_state	=	STATE_SHIFT;
				else
					next_state	=	STATE_PRELOAD;	
			else
				next_state	=	STATE_PRELOAD;
		
		STATE_SHIFT: begin
			if ( input_interface_ack == ACK_SHIFT_FIN ) 
				if ( lastWeight  ) 
					if ( lastRow )
						next_state	<=	STATE_PRELOAD;
					else
						next_state	=	STATE_LOAD;				
				else
					next_state	=	STATE_SHIFT;			
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
		preload_cycle		<=	0;	
	else begin
		case (current_state)
		
			STATE_IDLE: 
				preload_cycle	<=	0;
						
			STATE_PRELOAD: 
				if (input_interface_ack == ACK_LOAD_FIN)
					if (lastPreloadCycle)
						preload_cycle	<=	0;
					else
						preload_cycle	<=	preload_cycle + 1'b1;
				else
					preload_cycle	<=	preload_cycle;
						
			STATE_SHIFT: 
				preload_cycle	<=	0;			

			STATE_LOAD: 
				preload_cycle	<=	0;
			
			default: 
				preload_cycle	<=	preload_cycle;
	
		endcase
	end
end


always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		input_interface_cmd	<=	CMD_IDLE;
	else begin
		case (current_state)
			
			STATE_IDLE:
				if (enable)
					input_interface_cmd <=	CMD_LOAD;
				else
					input_interface_cmd	<=	CMD_IDLE;
				
			
			STATE_PRELOAD:
				if ( input_interface_ack == ACK_LOAD_FIN )
					if ( lastPreloadCycle )
						input_interface_cmd	=	CMD_SHIFT;
					else
						input_interface_cmd	=	CMD_LOAD;	
				else
					input_interface_cmd	=	CMD_IDLE;

			
			STATE_SHIFT:
				if ( input_interface_ack == ACK_SHIFT_FIN) 
					if ( lastWeight ) 
						input_interface_cmd	<=	CMD_LOAD;					
					else
						input_interface_cmd	<=	CMD_SHIFT;
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
		weight_idx	<=	0;
	else if ( input_interface_ack == ACK_SHIFT_FIN)
		if ( lastWeight )
			weight_idx	<=	0;
		else
			weight_idx	<=	weight_idx	+ 1'd1; 
	else
		weight_idx	<=	weight_idx;	
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 	
		row_idx		<=	0;
	else if (input_interface_ack == ACK_SHIFT_FIN && lastWeight) 
		if ( lastRow )
			row_idx		<=	0;
		else
			row_idx		<=	row_idx	+ 1'b1;	 
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
		feature_idx	<=	0;
	else if(valid)
		feature_idx	<=	weight_idx;
	else
		feature_idx	<=	feature_idx;
end	

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		feature_row	<=	0;
	else if(valid)
		feature_row	<=	row_idx;
	else
		feature_row	<=	feature_row;
end

always @(*)	begin
	if(valid && feature_idx == TOTAL_WEIGHT-1 && feature_row == ARRAY_SIZE- 1)
		image_calc_fin	=	1;
	else
		image_calc_fin	=	0;
end

endmodule
		