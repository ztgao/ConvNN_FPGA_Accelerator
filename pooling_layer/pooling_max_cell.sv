// 	version 1.0 --	2015.12.02	
//				-- 	setup

`include "../../global_define.v"

module	pooling_max_cell(
//--input
	clk,
	rst_n,
	a,
//--output	
	result
);


input		clk;
input		rst_n;
input		[`DATA_WIDTH-1:0]	a;

output reg	[`DATA_WIDTH-1:0]	result;

wire		[`DATA_WIDTH-1:0]	temp_result;
wire		gt;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		result	<=	0;
	else
		result	<=	temp_result;
end
	
	
		
floating_comparator_sim	U_floating_comparator_sim_0(
	.a		(a),
	.b		(result),
	.gt		(gt),
	.result	(temp_result)
);

endmodule