// version 1.0 -- setup
// Description:

`include "../../global_define.v"
`timescale 1ns/1ns
module tb_conv_layer_input_interface;

reg clk;
reg rst_n;
reg enable;
reg	idle;

wire 	[31:0]	data;
wire	[5:0]	rom_addr;
wire	[2:0]	current_state;

wire	[191:0] out_kernel_port;
wire	[31:0]	out_kernel_port_0_0;
wire	[31:0]	out_kernel_port_0_1;
wire	[31:0]	out_kernel_port_0_2;
wire	[31:0]	out_kernel_port_0_3;
wire	[31:0]	out_kernel_port_0_4;
wire	[31:0]	out_kernel_port_0_5;

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
	idle		=	0;
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
	
	
conv_layer_input_interface U_conv_layer_input_interface_1(	
// --input
	.clk 			(clk),
	.rst_n			(rst_n),
	.enable			(enable),
	.pixel_in		(data),
//	.idle			(idle),
	
// --output
	.rom_addr		(rom_addr),
	.out_kernel_port(out_kernel_port)
//	.current_state	(current_state)
	
);

rom_64x32 U_rom_1 (
	.a(rom_addr),      // input wire [5 : 0] a
	.spo(data)  // output wire [31 : 0] spo
);	

endmodule