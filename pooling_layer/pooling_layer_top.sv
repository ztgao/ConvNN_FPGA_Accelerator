// 	version 1.0 --	2015.12.01	
//				-- 	setup

`include "../../global_define.v"

module	pooling_layer_top(
//--input
	clk,
	rst_n,	
	kernel_calc_fin,
	data_in,
//--output
	data_out
);

`include "../../pooling_layer/pooling_param.v"

input	clk;
input	rst_n;
input	kernel_calc_fin;

input	[INPUT_SIZE*`DATA_WIDTH-1:0]	data_in;	//	6
output	[OUTPUT_SIZE*`DATA_WIDTH-1-1:0]	data_out;	//	3

wire	[OUTPUT_SIZE*`DATA_WIDTH-1-1:0]	data_from_cache;
wire	[OUTPUT_SIZE*`DATA_WIDTH-1-1:0]	data_from_array;


pooling_layer_input_cache U_pooling_layer_input_cache_0(
//--input
	.clk				(clk),
	.rst_n				(rst_n),
	.kernel_calc_fin	(kernel_calc_fin),
	.data_in			(data_in),		
//--.output
	.data_out			(data_from_cache)
);

pooling_array U_pooling_array_0(
//--input
	.clk		(clk),
	.rst_n		(rst_n),
	.data_in	(data_from_cache),
//--output
	.data_out	(data_from_array)	
);







endmodule