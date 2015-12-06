// version 1.0 -- setup
// Description:

`include "../../global_define.v"
`timescale 1ns/1ns
module tb_top;



logic 			clk;
logic 			rst_n;
logic 			enable;

logic 	[31:0]	pixel_in;
logic	[`EXT_ADDR_WIDTH-1:0]	ext_rom_addr;


logic	[191:0] feature_output;
logic	[31:0]	feature_output_0_0;
logic	[31:0]	feature_output_0_1;
logic	[31:0]	feature_output_0_2;
logic	[31:0]	feature_output_0_3;
logic	[31:0]	feature_output_0_4;
logic	[31:0]	feature_output_0_5;

bit				kernel_calc_fin;
bit		[1:0]	feature_idx;
bit		[2:0]	feature_row;
bit				image_calc_fin;

assign {feature_output_0_0,
        feature_output_0_1,
        feature_output_0_2,
        feature_output_0_3,
        feature_output_0_4,
        feature_output_0_5} = feature_output;

always
	#5 	clk		=	~clk;
	
initial begin
	clk			=	0;
	rst_n		=	1;
	enable		=	0;
	#10
	rst_n		=	0;
	#10
	rst_n		=	1;
	#10
	enable		=	1;
	
	// #400
	// idle		=	1;
	// #100
	// idle		=	0;
	#15000
	$stop;
end	
	
image_manager U_image_manager(
//--input
	.clk(clk),
	.rst_n(rst_n),
	.enable(enable),
//--output
	.layer_0_calc_fin(image_calc_fin),
	
	.data_out()
);

	
conv_layer_top U_conv_layer_top_0(	
// --input
	.clk 			(clk),
	.rst_n			(rst_n),
	.enable			(enable),
	.data_in		(pixel_in),

// --output
	.ext_rom_addr		(ext_rom_addr),
	.kernel_calc_fin	(kernel_calc_fin),
	.image_calc_fin		(image_calc_fin),
	.feature_idx		(feature_idx),
	.feature_row		(feature_row),
	.feature_output		(feature_output)
	
);

/* pooling_layer_input_cache U_pooling_layer_input_cache_0(
//--input
	.clk				(clk),
	.rst_n				(rst_n),
	.kernel_calc_fin	(kernel_calc_fin),
	.data_in			(feature_output),		
//--.output
	.data_out			()
); */

pooling_layer_top U_pooling_layer_top_0(
//--input
	.clk				(clk),
	.rst_n				(rst_n),
	.kernel_calc_fin	(kernel_calc_fin),
	.data_in			(feature_output),
	.feature_idx		(feature_idx),
	.feature_row		(feature_row),
//--.output
	.data_out			()
);



`ifdef	RTL_SIMULATION	
	rom_256x32_sim U_rom_1 (
		.addr(ext_rom_addr),      // input wire [5 : 0] a
		.data_o(pixel_in)  // output wire [31 : 0] spo
	);

`else
	rom_256x32 U_rom_1 (
		.a(ext_rom_addr),      // input wire [5 : 0] a
		.spo(pixel_in)  // output wire [31 : 0] spo
	);
`endif	
	
endmodule