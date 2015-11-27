// version 1.0 -- setup
// Description:
// In the test, the input image is 8x8, and we suggest that we take 16 DWORDS in a single step,
// so we can calculate 12 convolution in this step.
// The conv_kernel is 3x3.


`include "../../global_define.v"
module conv_layer_top(
	
	//--input
	clk,
	rst_n,
	pixel_in,	// 32 bit
	enable,
	
	//--output
	o_pixel_bus,	// 6x32bit
	rom_addr,
	feature
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

output	[ARRAY_SIZE*WIDTH-1:0]	feature;
output	[ARRAY_SIZE*WIDTH-1:0]	o_pixel_bus;
output	[7:0]					rom_addr;

//	register connected to covolution kernel

reg		[ARRAY_SIZE*WIDTH-1:0]	i_pixel_bus;
wire	[WIDTH-1:0]				i_weight;

wire	[2:0]					current_state;
wire	[2:0]					interface_state;

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
	.current_state	(interface_state),
	.rom_addr		(rom_addr),
	.out_kernel_port(o_pixel_bus)
	
);

conv_kernel_array U_conv_kernel_array_0(
	//--input
	.clk			(clk),
	.rst_n			(rst_n),
	.i_pixel_bus	(o_pixel_bus),
	.i_weight		(i_weight),
	.current_state	(interface_state),
		
	//--output	
	.o_pixel_bus	(feature)
	
);

conv_layer_controller U_conv_layer_controller_0(
	
	//--input
	.clk			(clk),
	.rst_n			(rst_n),
	.enable			(enable),
	.input_interface_ack	(input_interface_ack),
	
	//--output
	.input_interface_cmd	(input_interface_cmd),
	.current_state			(current_state)
//	.kernel_array_cmd		(),
//	.output_inteface_cmd	(),
);

conv_weight_cache U_conv_weight_cache_0(
	//--input
	.clk				(clk),
	.rst_n				(rst_n),
	.current_state		(interface_state),
	// a signal to indicate the send state, eg. stop, hold or change the rom_addr
	//--output
	.o_weight			(i_weight)
		
);


// conv_layer_output_interface U_conv_layer_output_interface_0(
// );

// activation_layer


/////////////////////////////////////////////////////////////////////////////
// A type cast module for IEEE-754 to real. 
// When synthesize the project in Vivado, please turn off it.

//	--
shortreal		o_pixel_bus_observe_0;
shortreal		o_pixel_bus_observe_1;
shortreal		o_pixel_bus_observe_2;
shortreal		o_pixel_bus_observe_3;
shortreal		o_pixel_bus_observe_4;
shortreal		o_pixel_bus_observe_5;

always @(o_pixel_bus) begin
	o_pixel_bus_observe_0	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-0)*WIDTH-1:(ARRAY_SIZE-1)*WIDTH]);
	o_pixel_bus_observe_1	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-1)*WIDTH-1:(ARRAY_SIZE-2)*WIDTH]);
	o_pixel_bus_observe_2	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-2)*WIDTH-1:(ARRAY_SIZE-3)*WIDTH]);
	o_pixel_bus_observe_3	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-3)*WIDTH-1:(ARRAY_SIZE-4)*WIDTH]);
	o_pixel_bus_observe_4	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-4)*WIDTH-1:(ARRAY_SIZE-5)*WIDTH]);
	o_pixel_bus_observe_5	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-5)*WIDTH-1:(ARRAY_SIZE-6)*WIDTH]);	
end


//	--
shortreal		i_weight_observe;

always @(i_weight) begin
	i_weight_observe		=	$bitstoshortreal(i_weight);
end

//	--	
shortreal		feature_observe_0;
shortreal		feature_observe_1;
shortreal		feature_observe_2;
shortreal		feature_observe_3;
shortreal		feature_observe_4;
shortreal		feature_observe_5;

always @(feature) begin
	feature_observe_0		=	$bitstoshortreal(feature[(ARRAY_SIZE-0)*WIDTH-1:(ARRAY_SIZE-1)*WIDTH]);
	feature_observe_1		=	$bitstoshortreal(feature[(ARRAY_SIZE-1)*WIDTH-1:(ARRAY_SIZE-2)*WIDTH]);
	feature_observe_2       =	$bitstoshortreal(feature[(ARRAY_SIZE-2)*WIDTH-1:(ARRAY_SIZE-3)*WIDTH]);
	feature_observe_3       =	$bitstoshortreal(feature[(ARRAY_SIZE-3)*WIDTH-1:(ARRAY_SIZE-4)*WIDTH]);
	feature_observe_4       =	$bitstoshortreal(feature[(ARRAY_SIZE-4)*WIDTH-1:(ARRAY_SIZE-5)*WIDTH]);
	feature_observe_5       =	$bitstoshortreal(feature[(ARRAY_SIZE-5)*WIDTH-1:(ARRAY_SIZE-6)*WIDTH]);	
end

/////////////////////////////////////////////////////////////////////////////

endmodule
