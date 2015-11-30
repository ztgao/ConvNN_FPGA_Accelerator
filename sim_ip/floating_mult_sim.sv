// 	version 1.0 --	2015.11.30	
//				-- 	setup

module	floating_mult_sim(
	a_i,
	b_i,
	p_o
);

parameter	WIDTH	=	32;

input		[WIDTH-1:0]		a_i;
input		[WIDTH-1:0]		b_i;
output reg	[WIDTH-1:0]		p_o;

shortreal	a_real;
shortreal	b_real;
shortreal	p_real;

always @(*)	begin
	a_real	=	$bitstoshortreal(a_i);
	b_real	=	$bitstoshortreal(b_i);
	p_real	=	a_real	* b_real;
	p_o		=	$shortrealtobits(p_real);
end

endmodule

