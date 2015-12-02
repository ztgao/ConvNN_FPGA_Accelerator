// 	version 1.0 --	2015.12.02	
//				-- 	setup

`include "../../global_define.v"

module	tb_comparator;

bit		[`DATA_WIDTH-1:0]	a;
bit		[`DATA_WIDTH-1:0]	b;
bit		gt;	
bit		[`DATA_WIDTH-1:0]	result;

initial begin
	a	=	32'b0;
	b	=	32'b0;
	
	#10
	a	=	32'h3F000000;	//	0.5
	b	=	32'h3F800000;	//	1.0
	
	#10
	a	=	32'h3F800000;	//	1.0
	b	=	32'h3F000000;	//	0.5
	
	#10
	a	=	32'b0;
	b	=	32'b0;
	
	#100
	$stop;
end

floating_comparator_sim	U_floating_comparator_sim_0(
	.a		(a),
	.b		(b),
	.gt		(gt),
	.result	(result)
);

endmodule