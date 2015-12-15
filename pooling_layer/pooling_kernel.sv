//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"

module	pooling_kernel #(
	parameter
	INPUT_SIZE		=	6,
	KERNEL_SIZE		=	2,	
	TOTAL_FEATURE	=	4)
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

localparam	CMP_CYCLE		=	KERNEL_SIZE;	//	2 -> 1, 3 -> 2, and an extra cycle
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

output	[`DATA_WIDTH-1:0]	data_out;

output reg	output_valid;

reg		[`DATA_WIDTH-1:0]	prev_result [0:TOTAL_FEATURE - 1];

input	[KERNEL_SIZE*`DATA_WIDTH-1:0]	data_in;

reg		[`DATA_WIDTH-1:0]	data_in_reg;

wire	[`DATA_WIDTH-1:0]	result;

reg		clrPrevResult;

reg		[CMP_WIDTH-1:0]	cmp_idx;

reg		[1:0]	current_state;
reg		[1:0]	next_state;

wire	lastCmp;
wire	lastFeature;

assign	lastCmp		=	(cmp_idx == CMP_CYCLE - 1); // (KERNEL_SIZE - 1) + 1 extra previous result
assign	lastFeature	=	(feature_idx == TOTAL_FEATURE - 1);

reg			[`DATA_WIDTH-1:0]	data_in_buf [0:KERNEL_SIZE-1];
reg			[ROW_WIDTH-1:0]	rowValid;
reg			rowOutputFlag;


	
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
	if(!rst_n)	begin
		data_in_buf[0]	<=	'd0;
		data_in_buf[1]	<=	'd0;
	end
	else
		case (current_state)
			
			STATE_IDLE: begin
				if(input_valid) begin
					data_in_buf[0]	<=	data_in[63:32];
					data_in_buf[1]	<=	data_in[31:0];
				end
				else begin
					data_in_buf[0]	<=	'd0;
					data_in_buf[1]	<=	'd0;
				end
			end
				
			STATE_CMP: begin
				if(rowOutputFlag) begin
					case (feature_idx)
						feature_idx: data_in_buf[0] =	prev_result[feature_idx];
					endcase
					data_in_buf[1]	<=	result;
				end
				else begin
					data_in_buf[0]	<=	`FLOAT32_NEG_INF;
					data_in_buf[1]	<=	result;
				end					
			end
			
			default: begin
					data_in_buf[0]	<=	data_in_buf[0];
					data_in_buf[1]	<=	data_in_buf[1];
			end	
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

genvar	gv_prevResIdx;	

generate
	for (gv_prevResIdx = 0; gv_prevResIdx < TOTAL_FEATURE; gv_prevResIdx=gv_prevResIdx+1)
	begin: genPrevRes
	////////////////////////////////////////
		always @(posedge clk, negedge rst_n) begin
			if(!rst_n) 
				prev_result[gv_prevResIdx]	<=	`DATA_WIDTH 'b0;
				// prev_result[gv_prevResIdx]	<=	`FLOAT32_NEG_INF;
			
			else if (output_valid) 
				case (feature_idx)		
					gv_prevResIdx: prev_result[gv_prevResIdx]	<=	result;
					default:
						prev_result[gv_prevResIdx]	<=	prev_result[gv_prevResIdx];
				endcase	
			
			else if (clrPrevResult) 
				prev_result[gv_prevResIdx]	<=	`DATA_WIDTH 'b0;
				// prev_result[gv_prevResIdx]	<=	`FLOAT32_NEG_INF;
			else 
				prev_result[gv_prevResIdx]	<=	prev_result[gv_prevResIdx];
		end	
	////////////////////////////////////////
	end
endgenerate		
									
always @(*) begin
	if (lastCmp)
		case (feature_idx)
			feature_idx: data_in_reg =	prev_result[feature_idx];
		endcase
	else
		data_in_reg	= data_in;
end

assign data_out = (output_valid)? result : `DATA_WIDTH 'b0;


// pooling_max_cell U_pooling_max_cell_0(
////--input
	// .clk	(clk),
	// .rst_n	(rst_n),
	// .a		(data_in_reg),
	// .clear	(output_valid),
////--output	
	// .result	(result)
// ); 

floating_comparator_sim	U_floating_comparator_sim_0(
	.a		(data_in_buf[0]),
	.b		(data_in_buf[1]),
	.gt		(gt),
	.result	(result)
);	

`ifdef DEBUG

shortreal data_in_ob[KERNEL_SIZE];
always @(*) begin
	for(int i = 0; i < KERNEL_SIZE; i = i + 1)
		data_in_ob[i]	=	$bitstoshortreal(data_in[(KERNEL_SIZE - i)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
end

shortreal data_in_buf_ob[KERNEL_SIZE];
always @(*) begin
	for(int i = 0; i < KERNEL_SIZE; i = i + 1)
		data_in_buf_ob[i]	=	$bitstoshortreal(data_in_buf[i]);
end

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