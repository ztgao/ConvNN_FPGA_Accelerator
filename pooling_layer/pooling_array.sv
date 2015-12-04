//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"

module	pooling_array(
//--input
	clk,
	rst_n,
	data_in,
	clear,
//--output
	data_out	
);

`include "../../pooling_layer/pooling_param.v"

input	clk;
input	rst_n;
input	clear;

input	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_in;

output	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_out;

wire	[`DATA_WIDTH-1:0]	data_in_port	[0:OUTPUT_SIZE-1];
wire	[`DATA_WIDTH-1:0]	data_out_port	[0:OUTPUT_SIZE-1];


assign	data_in_port[0]	= data_in[(OUTPUT_SIZE - 0)*`DATA_WIDTH-1 -: `DATA_WIDTH];	// 31:0
assign	data_in_port[1]	= data_in[(OUTPUT_SIZE - 1)*`DATA_WIDTH-1 -: `DATA_WIDTH];	// 63:32
assign	data_in_port[2]	= data_in[(OUTPUT_SIZE - 2)*`DATA_WIDTH-1 -: `DATA_WIDTH];	// 95:64

assign	data_out =	{data_out_port[0],data_out_port[1],data_out_port[2]};

pooling_max_cell U_pooling_max_cell_0(
//--input
	.clk	(clk),
	.rst_n	(rst_n),
	.a		(data_in_port[0]),
	.clear	(clear),
//--output	
	.result	(data_out_port[0])

);

pooling_max_cell U_pooling_max_cell_1(
//--input
	.clk	(clk),
	.rst_n	(rst_n),
	.a		(data_in_port[1]),
	.clear	(clear),
//--output	
	.result	(data_out_port[1])

);

pooling_max_cell U_pooling_max_cell_2(
//--input
	.clk	(clk),
	.rst_n	(rst_n),
	.a		(data_in_port[2]),
	.clear	(clear),
//--output	
	.result	(data_out_port[2])

);

endmodule