// version 1.0 -- setup
// Description:

`include "../../global_define.v"
`timescale 1ns/1ns
module tb_conv_layer_top;

logic 			clk;
logic 			rst_n;
logic 			enable;

logic 	[31:0]	pixel_in;
logic	[`EXT_ADDR_WIDTH-1:0]	rom_addr;


logic	[191:0] out_kernel_port;
logic	[31:0]	out_kernel_port_0_0;
logic	[31:0]	out_kernel_port_0_1;
logic	[31:0]	out_kernel_port_0_2;
logic	[31:0]	out_kernel_port_0_3;
logic	[31:0]	out_kernel_port_0_4;
logic	[31:0]	out_kernel_port_0_5;

assign {out_kernel_port_0_0,
        out_kernel_port_0_1,
        out_kernel_port_0_2,
        out_kernel_port_0_3,
        out_kernel_port_0_4,
        out_kernel_port_0_5} = out_kernel_port;

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
	#10000
	$stop;
end	
	
	
conv_layer_top U_conv_layer_top_0(	
// --input
	.clk 			(clk),
	.rst_n			(rst_n),
	.enable			(enable),
	.data_in		(pixel_in),
//	.idle			(idle),
	
// --output
	.rom_addr		(rom_addr),
	.o_pixel_bus	(out_kernel_port)
	
);

// rom_64x32 U_rom_1 (
	// .a(rom_addr),      // input wire [5 : 0] a
	// .spo(pixel_in)  // output wire [31 : 0] spo
// );

rom_256x32 U_rom_1 (
	.a(rom_addr),      // input wire [5 : 0] a
	.spo(pixel_in)  // output wire [31 : 0] spo
);	

endmodule