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
	data_in,	
	enable,	
//--output
	ext_rom_addr,
	valid,
	image_calc_fin,
	feature_idx,
	feature_row,
	feature_output
);

`include "../../conv_layer/conv_kernel_param.v"

input									clk;
input									rst_n;
input	[`DATA_WIDTH-1:0]				data_in;
input									enable;


output	[ARRAY_SIZE*`DATA_WIDTH-1:0]	feature_output;
wire	[ARRAY_SIZE*`DATA_WIDTH-1:0]	o_pixel_bus;
output	[`EXT_ADDR_WIDTH-1:0]			ext_rom_addr;

output									image_calc_fin;
output	[WEIGHT_WIDTH-1:0]							feature_idx;
//	register connected to covolution kernel

output	[ARRAY_WIDTH-1:0]							feature_row;

reg		[ARRAY_SIZE*`DATA_WIDTH-1:0]	i_pixel_bus;
wire	[`DATA_WIDTH-1:0]				i_weight;

wire						kernel_array_clear;
output						valid;

wire	[1:0]				input_interface_cmd;
wire	[1:0]				input_interface_ack;

wire	[ARRAY_SIZE*`DATA_WIDTH-1:0]	feature;

assign	feature_output	=	(valid)? feature: {ARRAY_SIZE{`DATA_WIDTH 'b0}};


conv_layer_controller U_conv_layer_controller_0(
//--input
	.clk					(clk),
	.rst_n					(rst_n),
	.enable					(enable),
	.input_interface_ack	(input_interface_ack),	
//--output
	.valid					(valid),
	.image_calc_fin			(image_calc_fin),
	.feature_idx			(feature_idx),
	.feature_row			(feature_row),
	.input_interface_cmd	(input_interface_cmd)
);

conv_layer_input_interface U_conv_layer_input_interface_0(
// --input
	.clk			(clk),
	.rst_n			(rst_n),
	.enable			(enable),
	.data_in		(data_in),
	.cmd			(input_interface_cmd),
	.ack			(input_interface_ack),
// --output
	.ext_rom_addr	(ext_rom_addr),
	.data_out		(o_pixel_bus),
	.o_weight		(i_weight)	
);

conv_kernel_array U_conv_kernel_array_0(
//--input
	.clk			(clk),
	.rst_n			(rst_n),
	.i_pixel_bus	(o_pixel_bus),
	.i_weight		(i_weight),
	.clear			(valid),	
//--output	
	.o_pixel_bus	(feature)	
);


`ifdef DEBUG
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
	o_pixel_bus_observe_0	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-0)*`DATA_WIDTH-1:(ARRAY_SIZE-1)*`DATA_WIDTH]);
	o_pixel_bus_observe_1	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-1)*`DATA_WIDTH-1:(ARRAY_SIZE-2)*`DATA_WIDTH]);
	o_pixel_bus_observe_2	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-2)*`DATA_WIDTH-1:(ARRAY_SIZE-3)*`DATA_WIDTH]);
	o_pixel_bus_observe_3	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-3)*`DATA_WIDTH-1:(ARRAY_SIZE-4)*`DATA_WIDTH]);
	o_pixel_bus_observe_4	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-4)*`DATA_WIDTH-1:(ARRAY_SIZE-5)*`DATA_WIDTH]);
	o_pixel_bus_observe_5	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-5)*`DATA_WIDTH-1:(ARRAY_SIZE-6)*`DATA_WIDTH]);	
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

always @(feature_output) begin
	feature_observe_0		=	$bitstoshortreal(feature_output[(ARRAY_SIZE-0)*`DATA_WIDTH-1:(ARRAY_SIZE-1)*`DATA_WIDTH]);
	feature_observe_1		=	$bitstoshortreal(feature_output[(ARRAY_SIZE-1)*`DATA_WIDTH-1:(ARRAY_SIZE-2)*`DATA_WIDTH]);
	feature_observe_2       =	$bitstoshortreal(feature_output[(ARRAY_SIZE-2)*`DATA_WIDTH-1:(ARRAY_SIZE-3)*`DATA_WIDTH]);
	feature_observe_3       =	$bitstoshortreal(feature_output[(ARRAY_SIZE-3)*`DATA_WIDTH-1:(ARRAY_SIZE-4)*`DATA_WIDTH]);
	feature_observe_4       =	$bitstoshortreal(feature_output[(ARRAY_SIZE-4)*`DATA_WIDTH-1:(ARRAY_SIZE-5)*`DATA_WIDTH]);
	feature_observe_5       =	$bitstoshortreal(feature_output[(ARRAY_SIZE-5)*`DATA_WIDTH-1:(ARRAY_SIZE-6)*`DATA_WIDTH]);	
end

/////////////////////////////////////////////////////////////////////////////
`endif


endmodule
