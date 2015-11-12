//
module conv_kernel_array(	
	//--input
	clk,
	rst_n,
	i_pixel_bus,
	i_weight,
	
	//--output
	o_pixel_bus
	
);

parameter	WIDTH				=	32;
parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

input 							clk;
input							rst_n;
input	[ARRAY_SIZE*WIDTH-1:0]	i_pixel_bus;
input	[WIDTH-1:0]				i_weight;

output	[ARRAY_SIZE*WIDTH-1:0]	o_pixel_bus;

wire	[WIDTH-1:0]				i_pixel_0_0;
wire	[WIDTH-1:0]				i_pixel_0_1;
wire	[WIDTH-1:0]				i_pixel_0_2;
wire	[WIDTH-1:0]				i_pixel_0_3;
wire	[WIDTH-1:0]				i_pixel_0_4;
wire	[WIDTH-1:0]				i_pixel_0_5;

wire	[WIDTH-1:0]				o_pixel_0_0;
wire	[WIDTH-1:0]				o_pixel_0_1;
wire	[WIDTH-1:0]				o_pixel_0_2;
wire	[WIDTH-1:0]				o_pixel_0_3;
wire	[WIDTH-1:0]				o_pixel_0_4;
wire	[WIDTH-1:0]				o_pixel_0_5;

// distribute the bus line to each kernel
assign	i_pixel_0_0	=	i_pixel_bus[(ARRAY_SIZE-0)*WIDTH-1:(ARRAY_SIZE-1)*WIDTH];
assign	i_pixel_0_1	=	i_pixel_bus[(ARRAY_SIZE-1)*WIDTH-1:(ARRAY_SIZE-2)*WIDTH];
assign	i_pixel_0_2	=	i_pixel_bus[(ARRAY_SIZE-2)*WIDTH-1:(ARRAY_SIZE-3)*WIDTH];
assign	i_pixel_0_3	=	i_pixel_bus[(ARRAY_SIZE-3)*WIDTH-1:(ARRAY_SIZE-4)*WIDTH];
assign	i_pixel_0_4	=	i_pixel_bus[(ARRAY_SIZE-4)*WIDTH-1:(ARRAY_SIZE-5)*WIDTH];
assign	i_pixel_0_5	=	i_pixel_bus[(ARRAY_SIZE-5)*WIDTH-1:(ARRAY_SIZE-6)*WIDTH];

assign	o_pixel_bus[(ARRAY_SIZE-0)*WIDTH-1:(ARRAY_SIZE-1)*WIDTH]	=  o_pixel_0_0;
assign	o_pixel_bus[(ARRAY_SIZE-1)*WIDTH-1:(ARRAY_SIZE-2)*WIDTH]	=  o_pixel_0_1;
assign	o_pixel_bus[(ARRAY_SIZE-2)*WIDTH-1:(ARRAY_SIZE-3)*WIDTH]	=  o_pixel_0_2;
assign	o_pixel_bus[(ARRAY_SIZE-3)*WIDTH-1:(ARRAY_SIZE-4)*WIDTH]	=  o_pixel_0_3;
assign	o_pixel_bus[(ARRAY_SIZE-4)*WIDTH-1:(ARRAY_SIZE-5)*WIDTH]	=  o_pixel_0_4;
assign	o_pixel_bus[(ARRAY_SIZE-5)*WIDTH-1:(ARRAY_SIZE-6)*WIDTH]	=  o_pixel_0_5;


conv_kernel U_conv_kernel_0_0(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(i_pixel_0_0),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_0)
);

conv_kernel U_conv_kernel_0_1(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(i_pixel_0_1),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_1)
);

conv_kernel U_conv_kernel_0_2(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(i_pixel_0_2),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_2)
);

conv_kernel U_conv_kernel_0_3(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(i_pixel_0_3),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_3)
);

conv_kernel U_conv_kernel_0_4(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(i_pixel_0_4),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_4)
);

conv_kernel U_conv_kernel_0_5(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(i_pixel_0_5),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_5)
);

//	array_1

/* conv_kernel U_conv_kernel_1_0(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_0),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);

conv_kernel U_conv_kernel_1_1(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_1),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);

conv_kernel U_conv_kernel_1_2(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_2),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);

conv_kernel U_conv_kernel_1_3(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_3),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);

conv_kernel U_conv_kernel_1_4(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_4),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);

conv_kernel U_conv_kernel_1_5(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(cache_array_1_5),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
); */

endmodule