//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"

module	pooling_array(
//--input
	clk,
	rst_n,
	data_in,
//	clear,
	feature_idx,
	feature_row,
	input_valid,
//--output
	output_valid,
	data_out	
);

`include "../../pooling_layer/pooling_param.v"

parameter	STATE_IDLE	=	2'd0;
parameter	STATE_CMP	=	2'd1;

input	clk;
input	rst_n;
//input	clear;

input	[FEATURE_WIDTH-1:0]	feature_idx;
input	[ROW_WIDTH-1:0]	feature_row;

input	input_valid;

output	[`DATA_WIDTH-1:0]	data_out;

output reg	output_valid;

reg		clear;
reg		[`DATA_WIDTH-1:0]	prev_result [0:TOTAL_FEATURE - 1];

input	[`DATA_WIDTH-1:0]	data_in;

reg		[`DATA_WIDTH-1:0]	data_in_reg;

wire	[`DATA_WIDTH-1:0]	result;

reg		clear_prev_result;

reg		[1:0]	cmp_idx;

reg		[1:0]	current_state;
reg		[1:0]	next_state;

wire	lastCmp;
wire	lastFeature;

assign	lastCmp	=	(cmp_idx == KERNEL_SIZE); // (KERNEL_SIZE - 1) + 1 extra previous result
assign	lastFeature	=	(feature_idx == TOTAL_FEATURE - 1);

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		current_state	<=	STATE_IDLE;
	else
		current_state	<=	next_state;
end

always @(*) begin
	case (current_state)
		
		STATE_IDLE: 
			if(input_valid)
				next_state	=	STATE_CMP;
			else
				next_state	=	STATE_IDLE;
		
		STATE_CMP:
			if (lastCmp)
				next_state	=	STATE_IDLE;
			else
				next_state	=	STATE_CMP;
		
		default:
			next_state	=	current_state;
			
	endcase
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		cmp_idx	<=	2'd0;
	else
		case (current_state)
			
			STATE_IDLE:
				cmp_idx	<=	2'd0;
			
			STATE_CMP:
				if(lastCmp)
					cmp_idx	<=	2'd0;
				else
					cmp_idx	<=	cmp_idx + 1'd1;
									
			default:
				cmp_idx	<=	cmp_idx;
				
		endcase
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		output_valid	<=	0;
	else if (lastCmp)
		output_valid	<=	1;
	else
		output_valid	<=	0;
end


always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		clear_prev_result	<=	0;
	else if (output_valid && lastFeature) 
		case (feature_row)
			1, 3, 5:
				clear_prev_result	<=	1;
			default:
				clear_prev_result	<=	0;
		endcase	
	else
		clear_prev_result	<=	0;		
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		prev_result[0]	<=	`DATA_WIDTH 'b0;
		prev_result[1]	<=  `DATA_WIDTH 'b0;
		prev_result[2]	<=  `DATA_WIDTH 'b0;
		prev_result[3]	<=  `DATA_WIDTH 'b0;
	end	
	
	else if (output_valid) 
		case (feature_idx)
			2'd0: prev_result[0]	<= 	result;
			2'd1: prev_result[1]	<= 	result;
			2'd2: prev_result[2]	<= 	result;
			2'd3: prev_result[3]	<= 	result;
		endcase	
	
	else if (clear_prev_result) begin
		prev_result[0]	<=	`DATA_WIDTH 'b0;
		prev_result[1]	<=  `DATA_WIDTH 'b0;
		prev_result[2]	<=  `DATA_WIDTH 'b0;
		prev_result[3]	<=  `DATA_WIDTH 'b0;
	end		
	
	else begin
		prev_result[0]	<=	prev_result[0];
		prev_result[1]	<=  prev_result[1];
		prev_result[2]	<=  prev_result[2];
		prev_result[3]	<=  prev_result[3];
	end
end	

always @(*) begin
	if (lastCmp)
		case (feature_idx)
			2'd0: data_in_reg =	prev_result[0];
			2'd1: data_in_reg =	prev_result[1];
			2'd2: data_in_reg =	prev_result[2];
			2'd3: data_in_reg =	prev_result[3];
		endcase
	else
		data_in_reg	= data_in;
end

assign data_out = (output_valid)? result : `DATA_WIDTH 'b0;

			
pooling_max_cell U_pooling_max_cell_0(
//--input
	.clk	(clk),
	.rst_n	(rst_n),
	.a		(data_in_reg),
	.clear	(output_valid),
//--output	
	.result	(result)
);

`ifdef DEBUG

shortreal prev_result_ob[TOTAL_FEATURE];
always @(*) begin
	 prev_result_ob[0]	=	$bitstoshortreal(prev_result[0]);
	 prev_result_ob[1]	=	$bitstoshortreal(prev_result[1]);
	 prev_result_ob[2]	=	$bitstoshortreal(prev_result[2]);
	 prev_result_ob[3]	=	$bitstoshortreal(prev_result[3]);
end

shortreal data_in_reg_ob;
always @(*) begin
	 data_in_reg_ob	=	$bitstoshortreal(data_in_reg);
end

shortreal result_ob;
always @(*) begin
	 result_ob	=	$bitstoshortreal(result);
end

shortreal data_out_ob;
always @(*) begin
	 data_out_ob	=	$bitstoshortreal(data_out);
end
	 	 
`endif



endmodule