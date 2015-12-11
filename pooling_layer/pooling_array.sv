//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"

module	pooling_array #(
	parameter
	KERNEL_SIZE		=	2,	
	TOTAL_FEATURE	=	4,
	FEATURE_WIDTH	=	2,
	ROW_WIDTH		=	3)
(
//--input
	clk,
	rst_n,
	data_in,
	feature_idx,
	feature_row,
	input_valid,
//--output
	output_valid,
	data_out	
);

`include "../../pooling_layer/pooling_param.v"


localparam	STATE_IDLE	=	2'd0;
localparam	STATE_CMP	=	2'd1;

localparam	CMP_CYCLE	=	KERNEL_SIZE + 1;
localparam	CMP_WIDTH	=	logb2(CMP_CYCLE);

input	clk;
input	rst_n;

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

reg		clrPrevResult;

reg		[CMP_WIDTH-1:0]	cmp_idx;

reg		[1:0]	current_state;
reg		[1:0]	next_state;

wire	lastCmp;
wire	lastFeature;

assign	lastCmp		=	(cmp_idx == KERNEL_SIZE); // (KERNEL_SIZE - 1) + 1 extra previous result
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
		cmp_idx	<=	'd0;
	else
		case (current_state)
			
			STATE_IDLE:
				cmp_idx	<=	'd0;
			
			STATE_CMP:
				if(lastCmp)
					cmp_idx	<=	'd0;
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
		clrPrevResult	<=	0;
	else if (output_valid && lastFeature) 
		case (feature_row)
			1, 3, 5:
				clrPrevResult	<=	1;
			default:
				clrPrevResult	<=	0;
		endcase	
	else
		clrPrevResult	<=	0;		
end

genvar	gv_prevResIdx;	

generate
	for (gv_prevResIdx = 0; gv_prevResIdx < TOTAL_FEATURE; gv_prevResIdx=gv_prevResIdx+1)
	begin: genPrevRes
	////////////////////////////////////////////
		always @(posedge clk, negedge rst_n) begin
			if(!rst_n) 
				prev_result[gv_prevResIdx]	<=	`DATA_WIDTH 'b0;	
			
			else if (output_valid) 
				case (feature_idx)		
					gv_prevResIdx: prev_result[gv_prevResIdx]	<=	result;
					default:
						prev_result[gv_prevResIdx]	<=	prev_result[gv_prevResIdx];
				endcase	
			
			else if (clrPrevResult) 
				prev_result[gv_prevResIdx]	<=	`DATA_WIDTH 'b0;						
			else 
				prev_result[gv_prevResIdx]	<=	prev_result[gv_prevResIdx];
		end	
	////////////////////////////////////////////
	end
endgenerate		
			
/* always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		prev_result[0]	<=	`DATA_WIDTH 'b0;
		prev_result[1]	<=  `DATA_WIDTH 'b0;
		prev_result[2]	<=  `DATA_WIDTH 'b0;
		prev_result[3]	<=  `DATA_WIDTH 'b0;
	end	
	
	else if (output_valid) 
		case (feature_idx)		
			feature_idx: prev_result[feature_idx]	<=	result;				
		endcase	
	
	else if (clrPrevResult) begin
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
end	 */		
						
always @(*) begin
	if (lastCmp)
		case (feature_idx)
			feature_idx: data_in_reg =	prev_result[feature_idx];
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
	for (int i = 0; i < TOTAL_FEATURE; i=i+1) begin
		prev_result_ob[i]	=	$bitstoshortreal(prev_result[i]);
	end
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