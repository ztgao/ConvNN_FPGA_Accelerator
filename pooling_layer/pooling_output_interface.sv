// 	version 1.0 --	2015.12.01	
//				-- 	setup

`include "../../global_define.v"

module	pooling_output_interface(
//--input
	clk,
	rst_n,
	feature_idx,
	data_in,
//--output
	data_out
);

`include "../../pooling_layer/pooling_param.v"


input	clk;
input	rst_n;
input	feature_idx;

input	[INPUT_SIZE*`DATA_WIDTH-1:0]	data_in;	//	6
output	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_out;

reg		[OUTPUT_SIZE`DATA_WIDTH-1:0]	buffer_array [0:TOTAL_FEATURE-1];

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		


