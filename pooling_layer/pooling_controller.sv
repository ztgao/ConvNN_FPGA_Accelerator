//	version	1.0		--	12.12
//					--	setup
//	Description:

`include "../../global_define.v"

module	pooling_controller #(
	parameter
	INPUT_SIZE	=	6;
	KERNEL_SIZE		=	2,	
	TOTAL_FEATURE	=	4)
(
//--input
	clk,
	rst_n,
	feature_idx,
	feature_row,
	input_valid,
//--output
	output_valid,
	clrPrevResult
);

`include "../../pooling_layer/pooling_param.v"

localparam	CMP_CYCLE		=	KERNEL_SIZE + 1;
localparam	CMP_WIDTH		=	logb2(CMP_CYCLE);
localparam	ROW_WIDTH		=	logb2(INPUT_SIZE);
localparam	FEATURE_WIDTH	=	logb2(TOTAL_FEATURE);

localparam	POOLING_CELL_NUM	=	INPUT_SIZE / KERNEL_SIZE;

localparam	STATE_IDLE	=	2'd0;
localparam	STATE_CMP	=	2'd1;

input	clk;
input	rst_n;
input	[FEATURE_WIDTH-1:0]	feature_idx;
input	[ROW_WIDTH-1:0]		feature_row;
input	input_valid;

output reg	output_valid;
reg			clear;
output reg	clrPrevResult;

reg		[CMP_WIDTH-1:0]	cmp_idx;

reg		[1:0]	current_state;
reg		[1:0]	next_state;

wire	lastCmp;
wire	lastFeature;

assign	lastCmp		=	(cmp_idx == CMP_CYCLE); // (KERNEL_SIZE - 1) + 1 extra previous result
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

reg	[ROW_WIDTH-1:0]	rowValid;
always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		rowValid	<=	'd0;
	else if( feature_row == 0)
		rowValid	<=	KERNEL_SIZE - 1'd1;
	else if( feature_row == INPUT_SIZE - 1'd1)
		rowValid	<=	'd0;
	else if(feature_row == rowValid)	
		rowValid	<=	rowValid	+  KERNEL_SIZE;
	else
		rowValid	<=	rowValid;
end

reg	rowOutputFlag;
always @(feature_row) begin
	if (feature_row == 'd0)
		rowOutputFlag	=	0;
	else if(rowValid == feature_row)
		rowOutputFlag	=	1;
	else
		rowOutputFlag	=	0;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		clrPrevResult	<=	0;
	else if (output_valid && lastFeature) 
		// case (feature_row)
			// 1, 3, 5:
		if(rowOutputFlag)
			clrPrevResult	<=	1;
		else
			clrPrevResult	<=	0;
	else
		clrPrevResult	<=	0;		
end

endmodule










