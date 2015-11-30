// 	version 1.0 --	2015.11.30	
//				-- 	setup

module	floating_adder_sim(
	a_i,
	b_i,
	s_o
);

parameter	WIDTH	=	32;

input		[WIDTH-1:0]		a_i;
input		[WIDTH-1:0]		b_i;
output reg	[WIDTH-1:0]		s_o;

shortreal	a_real;
shortreal	b_real;
shortreal	s_real;

always @(*)	begin
	a_real	=	$bitstoshortreal(a_i);
	b_real	=	$bitstoshortreal(b_i);
	s_real	=	a_real	+ b_real;
	s_o		=	$shortrealtobits(s_real);
end

endmodule

