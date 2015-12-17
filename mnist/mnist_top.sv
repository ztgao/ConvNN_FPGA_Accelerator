// 	version 1.0 --	2015.12.01	
//				-- 	setup


`include "../../global_define.v"
module mnist_top(
	input	clk,
	input	rst_n,
	input	enable,
	
	input	[`DATA_WIDTH-1:0]	data_in,
	
	output	[`EXT_ADDR_WIDTH-1:0]	ext_rom_addr,	
	output	[12*`DATA_WIDTH-1:0]	pooling_output
);

wire				valid;
wire	[4:0]		feature_idx;
wire	[4:0]		feature_row;
wire				image_calc_fin;
wire				layer_0_en;
wire	[24*`DATA_WIDTH-1:0]	feature_output;

wire	output_valid;

wire	[4:0]		feature_idx_o;
wire    [4:0]		feature_row_o;

network_manager #(
	.IMAGE_NUM		(5)
)
U_network_manager_0(
//--input
	.clk		(clk),
	.rst_n		(rst_n),
	.start		(enable),
	.layer_0_calc_fin(image_calc_fin),
//--output
	.layer_0_en	(layer_0_en),	
	.data_out	()
);


// Convolution Layer 0
conv_layer_top #(
	.KERNEL_SIZE 		(5),
	.IMAGE_SIZE			(28),
	.ARRAY_SIZE  		(24),	
	.TOTAL_WEIGHT		(20),
	.WEIGHT_ROM_DEPTH	(1024)
)	
U_conv_layer_top_0(	
// --input
	.clk 			(clk),
	.rst_n			(rst_n),
	.enable			(layer_0_en),
	.data_in		(data_in),

// --output
	.ext_rom_addr	(ext_rom_addr),
	.valid			(valid),
	.image_calc_fin	(image_calc_fin),
	.feature_idx	(feature_idx),
	.feature_row	(feature_row),
	.feature_output	(feature_output)	
);


//	Pooling Layer 0
pooling_layer_top #(
	.INPUT_SIZE			(24),
	.KERNEL_SIZE    	(2),
	.OUTPUT_SIZE    	(12),
	.TOTAL_FEATURE  	(20)
)
U_pooling_layer_top_0(
//--input
	.clk				(clk),
	.rst_n				(rst_n),
	.input_valid		(valid),
	.data_in			(feature_output),
	.feature_idx		(feature_idx),
	.feature_row		(feature_row),
//--.output
	.output_valid		(output_valid),
	.feature_idx_o		(feature_idx_o),
	.feature_row_o	    (feature_row_o),
	.data_out			(pooling_output)
);

interlayer_buffer #(	
	.BUFFER_DEPTH	(4096),
	.INPUT_SIZE		(12),
	.TOTAL_FEATURE	(20)
)
U_interlayer_buffer_0(
//--input
	.clk		(clk),
	.rst_n		(rst_n),
	.data_i		(pooling_output),
	.valid_i	(output_valid),	
	.feature_row(feature_row_o),
	.feature_idx(feature_idx_o),
//	.rd,
//	.addr_rd,
//	.wr,
	
//--output
	.data_o		()
);



/* `ifdef	RTL_SIMULATION	
	rom_4kx32_sim U_rom_1 (
		.addr(ext_rom_addr),      // input wire [5 : 0] a
		.data_o(pixel_in)  // output wire [31 : 0] spo
	);

`else
	rom_256x32 U_rom_1 (
		.a(ext_rom_addr),      // input wire [5 : 0] a
		.spo(pixel_in)  // output wire [31 : 0] spo
	);
`endif	
 */

endmodule





