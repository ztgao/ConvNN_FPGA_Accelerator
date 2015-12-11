// 	version 1.0 --	2015.11.01	
//				-- 	setup
//	version	1.1	--	2015.12.10
//				--	

`include "../../global_define.v"
module conv_kernel_array
#(parameter ARRAY_SIZE 	= 	6)
(	
//--input
	clk,
	rst_n,
	i_pixel_bus,
	i_weight,
	clear,
//--output
	o_pixel_bus	
);

`include "../../conv_layer/conv_kernel_param.v"

input 									clk;
input									rst_n;
input	[ARRAY_SIZE*`DATA_WIDTH-1:0]	i_pixel_bus;
input	[`DATA_WIDTH-1:0]				i_weight;
input									clear;
output	[ARRAY_SIZE*`DATA_WIDTH-1:0]	o_pixel_bus;

//Generate the convolution kernels automatically because they will be instantiated repeatedly.
genvar		gv_idx;
generate	
	for (gv_idx = 0; gv_idx < ARRAY_SIZE; gv_idx = gv_idx + 1)
		begin: kernel

		conv_kernel	U_conv_kernel(
			.clk		(clk),
			.rst_n		(rst_n),
			.clear		(clear),
			.i_pixel	(i_pixel_bus[(ARRAY_SIZE-gv_idx)*`DATA_WIDTH-1 -: `DATA_WIDTH]),
			.i_weight	(i_weight),
			.o_pixel	(o_pixel_bus[(ARRAY_SIZE-gv_idx)*`DATA_WIDTH-1 -: `DATA_WIDTH])	
		);
		
		end
endgenerate


endmodule