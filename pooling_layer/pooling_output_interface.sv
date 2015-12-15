// 	version 1.0 --	2015.12.01	
//				-- 	setup

`include "../../global_define.v"

module pooling_output_interface #(
	parameter
	INPUT_SIZE		=	6,
	KERNEL_SIZE		=	2,
	TOTAL_FEATURE	=	4)
(
//--input
	clk,
	rst_n,
	feature_idx,
	feature_row,
	data_in,
	input_valid,
//--output
	output_valid,
	data_out
	
);

`include "../../pooling_layer/pooling_param.v"

localparam	ROW_WIDTH		=	logb2(INPUT_SIZE);
localparam	FEATURE_WIDTH	=	logb2(TOTAL_FEATURE);

input		clk;
input		rst_n;
input		[FEATURE_WIDTH-1:0]	feature_idx;
input		[ROW_WIDTH-1:0]	feature_row;
input 		input_valid;

input		[`DATA_WIDTH-1:0]	data_in;	
output reg 	[`DATA_WIDTH-1:0]	data_out;
output reg	output_valid;

reg		[`DATA_WIDTH-1:0]	buffer [0:TOTAL_FEATURE-1];

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


genvar	gvBufIdx;

generate
	for (gvBufIdx = 0; gvBufIdx < TOTAL_FEATURE; gvBufIdx = gvBufIdx + 1)
	begin:	genBuf
	///////////////////////
		always @(posedge clk, negedge rst_n) begin
			if(!rst_n) 
				buffer[gvBufIdx]	<=	`DATA_WIDTH 'b0;	
			else if (input_valid) begin
				if (rowOutputFlag)
					case (feature_idx)
						gvBufIdx:	buffer[gvBufIdx]	<=	data_in;
						default:
							buffer[gvBufIdx]	<=	buffer[gvBufIdx];
					endcase	
					else
						buffer[gvBufIdx]	<= buffer[gvBufIdx];
			end
			else 
				buffer[gvBufIdx]	<= buffer[gvBufIdx];
		end
	///////////////////////
	end
endgenerate

reg	input_valid_delay_0;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		input_valid_delay_0 <= 0;
	else
		input_valid_delay_0	<= input_valid;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		output_valid	<=	0;
	else if(rowOutputFlag)
		output_valid	<=	input_valid_delay_0;
	else
		output_valid	<=	0;
end


always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		data_out	<=	`DATA_WIDTH 'b0;
	else if (input_valid_delay_0) begin
		if(rowOutputFlag) 
			case(feature_idx)
				feature_idx: data_out	<=	buffer[feature_idx];
				default:
					data_out	<=	data_out;
			endcase			
		else
			data_out	<=	data_out;
	end
end

			

`ifdef DEBUG

shortreal data_in_ob;
always @(*) begin
	 data_in_ob	=	$bitstoshortreal(data_in);
end

shortreal buffer_ob[TOTAL_FEATURE];
always @(*) begin
	for(int i=0; i < TOTAL_FEATURE; i=i+1)
		buffer_ob[i]	=	$bitstoshortreal(buffer[i]);
end

shortreal data_out_ob;
always @(*) begin
	 data_out_ob	=	$bitstoshortreal(data_out);
end
	 	 
`endif


endmodule


