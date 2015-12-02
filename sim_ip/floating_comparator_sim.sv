// 	version 1.0 --	2015.12.02	
//				-- 	setup

`include "../../global_define.v"

module floating_comparator_sim(
//--input
	a,
	b,
//--output	
	gt,
	result
);

input		[`DATA_WIDTH-1:0]	a;
input		[`DATA_WIDTH-1:0]	b;

output reg	[`DATA_WIDTH-1:0]	result;
output			gt;

shortreal	a_real;
shortreal	b_real;

assign	a_real	=	$bitstoshortreal(a);
assign 	b_real	=	$bitstoshortreal(b);

assign	gt		=	(a_real > b_real)? 1:0;
assign	result	=	(a_real > b_real)? a:b;

endmodule