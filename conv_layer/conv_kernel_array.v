// 	version 1.0 --	2015.11.01	
//				-- 	setup

`include "../../global_define.v"
module conv_kernel_array(	
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

wire	[`DATA_WIDTH-1:0]				i_pixel_0_0;
wire	[`DATA_WIDTH-1:0]				i_pixel_0_1;
wire	[`DATA_WIDTH-1:0]				i_pixel_0_2;
wire	[`DATA_WIDTH-1:0]				i_pixel_0_3;
wire	[`DATA_WIDTH-1:0]				i_pixel_0_4;
wire	[`DATA_WIDTH-1:0]				i_pixel_0_5;

wire	[`DATA_WIDTH-1:0]				o_pixel_0_0;
wire	[`DATA_WIDTH-1:0]				o_pixel_0_1;
wire	[`DATA_WIDTH-1:0]				o_pixel_0_2;
wire	[`DATA_WIDTH-1:0]				o_pixel_0_3;
wire	[`DATA_WIDTH-1:0]				o_pixel_0_4;
wire	[`DATA_WIDTH-1:0]				o_pixel_0_5;

reg										clear_delay_0;
reg										clear_delay_1;

// distribute the bus line to each kernel
assign	i_pixel_0_0	=	i_pixel_bus[(ARRAY_SIZE-0)*`DATA_WIDTH-1:(ARRAY_SIZE-1)*`DATA_WIDTH];
assign	i_pixel_0_1	=	i_pixel_bus[(ARRAY_SIZE-1)*`DATA_WIDTH-1:(ARRAY_SIZE-2)*`DATA_WIDTH];
assign	i_pixel_0_2	=	i_pixel_bus[(ARRAY_SIZE-2)*`DATA_WIDTH-1:(ARRAY_SIZE-3)*`DATA_WIDTH];
assign	i_pixel_0_3	=	i_pixel_bus[(ARRAY_SIZE-3)*`DATA_WIDTH-1:(ARRAY_SIZE-4)*`DATA_WIDTH];
assign	i_pixel_0_4	=	i_pixel_bus[(ARRAY_SIZE-4)*`DATA_WIDTH-1:(ARRAY_SIZE-5)*`DATA_WIDTH];
assign	i_pixel_0_5	=	i_pixel_bus[(ARRAY_SIZE-5)*`DATA_WIDTH-1:(ARRAY_SIZE-6)*`DATA_WIDTH];


assign	o_pixel_bus[(ARRAY_SIZE-0)*`DATA_WIDTH-1:(ARRAY_SIZE-1)*`DATA_WIDTH]	=  o_pixel_0_0;
assign	o_pixel_bus[(ARRAY_SIZE-1)*`DATA_WIDTH-1:(ARRAY_SIZE-2)*`DATA_WIDTH]	=  o_pixel_0_1;
assign	o_pixel_bus[(ARRAY_SIZE-2)*`DATA_WIDTH-1:(ARRAY_SIZE-3)*`DATA_WIDTH]	=  o_pixel_0_2;
assign	o_pixel_bus[(ARRAY_SIZE-3)*`DATA_WIDTH-1:(ARRAY_SIZE-4)*`DATA_WIDTH]	=  o_pixel_0_3;
assign	o_pixel_bus[(ARRAY_SIZE-4)*`DATA_WIDTH-1:(ARRAY_SIZE-5)*`DATA_WIDTH]	=  o_pixel_0_4;
assign	o_pixel_bus[(ARRAY_SIZE-5)*`DATA_WIDTH-1:(ARRAY_SIZE-6)*`DATA_WIDTH]	=  o_pixel_0_5;


//	--	Since the result will be late for 3 clk periods, so the clear signal needs 2 periods of delay.
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		clear_delay_0	<=	0;
		clear_delay_1	<=	0;
	end
	else begin
		clear_delay_0	<=	clear;
		clear_delay_1	<=	clear_delay_0;
	end
end
		
conv_kernel U_conv_kernel_0_0(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_1),
	.i_pixel	(i_pixel_0_0),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_0)
);

conv_kernel U_conv_kernel_0_1(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_1),	
	.i_pixel	(i_pixel_0_1),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_1)
);

conv_kernel U_conv_kernel_0_2(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_1),
	.i_pixel	(i_pixel_0_2),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_2)
);

conv_kernel U_conv_kernel_0_3(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_1),
	.i_pixel	(i_pixel_0_3),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_3)
);

conv_kernel U_conv_kernel_0_4(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_1),
	.i_pixel	(i_pixel_0_4),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel_0_4)
);

conv_kernel U_conv_kernel_0_5(
	.clk		(clk),
	.rst_n		(rst_n),
	.clear		(clear_delay_1),
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