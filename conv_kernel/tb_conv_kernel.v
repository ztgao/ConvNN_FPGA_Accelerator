`timescale 1ns/1ns

module tb_conv_kernel;

parameter	WIDTH	=	32;

reg						clk;
reg						rst_n;
reg		[WIDTH-1:0]		i_pixel;
reg		[WIDTH-1:0]		i_weight;

wire	[WIDTH-1:0]		o_pixel;


always
	#5 	clk		=	~clk;
	
initial begin
	clk			=	0;
	rst_n		=	1;
	i_pixel		=	32'h0;	
	i_weight	=	32'h0;
	#10
	rst_n		=	0;
	#10
	rst_n		=	1;
	#20
	i_pixel		=	32'h3F800000;	//	1
	i_weight	=	32'h40000000;	//	2
	#10
	i_pixel		=	32'h40000000;	//	2	
	i_weight	=	32'h40400000;	//	3
	#10
	i_pixel		=	32'h40400000;	//	3
	i_weight	=	32'h40800000;	//	4
	#10
	i_pixel		=	32'h40800000;	//	4
	i_weight	=	32'h40A00000;	//	5
	#10
	i_pixel		=	32'h40A00000;	//	5
	i_weight	=	32'h40C00000;	//	6
	#10
	i_pixel		=	32'h40C00000;	//	6
	i_weight	=	32'h40E00000;	//	7
	#10
	i_pixel		=	32'h40E00000;	//	7
	i_weight	=	32'h41000000;	//	8
	#10
	i_pixel		=	32'h41000000;	//	8
	i_weight	=	32'h41100000;	//	9
	#10
	i_pixel		=	32'h41100000;	//	9
	i_weight	=	32'h3F800000;	//	1
	#10
	i_pixel		=	32'h0;	
	i_weight	=	32'h0;
	#100
	$stop;
end

conv_kernel U_conv_kernel_0(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_pixel	(i_pixel),
	.i_weight	(i_weight),
	.o_pixel	(o_pixel)
);


endmodule
	
	
	
	