// 	version 1.0 --	2015.12.02	
//				-- 	setup

`include "../../global_define.v"

module	cell_test;

bit			clk;
bit			rst_n;
shortreal	a_real;
bit		[`DATA_WIDTH-1:0]	a;
bit		[`DATA_WIDTH-1:0]	result;

always
	#5 	clk		=	~clk;
	
initial begin
	clk			=	0;
	rst_n		=	1;
	
	a	=	32'h0;
	
	#10
	rst_n	=	0;
	
	#10
	rst_n	=	1;
	
	#10
	a	=	32'h3F000000;	//	0.5
	
	#10
	a	=	32'h3F800000;	//	1.0
	
	#10
	a	=	32'h41C80000;	//	25.0
	
	#10
	a	=	32'h41400000;	//	12.0
	
	#10
	a	=	32'h41400000;	//	12.0
	
	#10
	a	=	32'h42480000;	//	50.0	
	
	#10
	a	=	32'h41700000;	//	15.0
		
	#100
	$stop;
	
end

pooling_max_cell U_pooling_max_cell_0(
//--input
	.clk	(clk),
	.rst_n	(rst_n),
	.a		(a),
//--output	
	.result	(result)
);

endmodule