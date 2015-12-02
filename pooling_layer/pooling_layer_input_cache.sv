//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"

module	pooling_layer_input_cache(
//--input
	clk,
	rst_n,
	
	data_in,
	data_out
);

`include "../../conv_layer/pooling_layer_param.v"

input	clk;
input	rst_n;

input	[INPUT_SIZE-1:0]	data_in;
output	[INPUT_SIZE-1:0]	data_out;


