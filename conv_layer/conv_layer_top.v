// version 1.0 -- setup
// Description:
// In the test, the input image is 8x8, and we suggest that we take 16 DWORDS in a single step,
// so we can calculate 12 convolution in this step.
// The conv_kernel is 3x3.

module conv_layer_top(
	
	//--input
	clk,
	rst_n,
	pixel_in,	// 32 bit
	enable,
	
	//--output
	o_pixel_bus,	// 6x32bit
	rom_addr
);

parameter	WIDTH				=	32;
parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

parameter	INIT				=	3'd0;
parameter	PREPARE_LOAD		=	3'd1;	
parameter	STAGE_ROW_0			=	3'd2;
parameter	STAGE_ROW_1			=	3'd3;
parameter	STAGE_ROW_2			=	3'd4;
parameter	IDLE				=	3'd7;


input							clk;
input							rst_n;
input	[WIDTH-1:0]				pixel_in;
input							enable;

//input	[WIDTH-1:0]				data_in;
//input	[WIDTH-1:0]				weight_in;

//output	[WIDTH-1:0]				feature;
output	[ARRAY_SIZE*WIDTH-1:0]	o_pixel_bus;
output	[5:0]					rom_addr;

//	register connected to covolution kernel

reg		[ARRAY_SIZE*WIDTH-1:0]	i_pixel_bus;
reg		[WIDTH-1:0]				i_weight;

reg		[3:0]					calc_counter;

wire	[1:0]					input_interface_cmd;
wire	[1:0]					input_interface_ack;


conv_layer_input_interface U_conv_layer_input_interface_0(
// --input
	.clk			(clk),
	.rst_n			(rst_n),
	.enable			(enable),
	.pixel_in		(pixel_in),
	.cmd			(input_interface_cmd),
	.ack			(input_interface_ack),

// --output
	.rom_addr		(rom_addr),
	.out_kernel_port(o_pixel_bus)
	
);

/* conv_kernel_array U_conv_kernel_array_0(
	//--input
	.clk			(clk),
	.rst_n			(rst_n),
	.i_pixel_bus	(i_pixel_bus),
	.i_weight		(i_weight),
		
	//--output	
	.o_pixel_bus	(o_pixel_bus)
	
); */

conv_layer_controller U_conv_layer_controller_0(
	
	//--input
	.clk			(clk),
	.rst_n			(rst_n),
	.enable			(enable),
	.input_interface_ack	(input_interface_ack),
	
	//--output
	.input_interface_cmd	(input_interface_cmd)
//	.kernel_array_cmd		(),
//	.output_inteface_cmd	(),
);


endmodule
