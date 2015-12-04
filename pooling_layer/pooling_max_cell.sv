// 	version 1.0 --	2015.12.02	
//				-- 	setup

`include "../../global_define.v"

module	pooling_max_cell(
//--input
	clk,
	rst_n,
	a,
	clear,
//--output	
	result
);


input		clk;
input		rst_n;
input		[`DATA_WIDTH-1:0]	a;
input		clear;

output reg	[`DATA_WIDTH-1:0]	result;

wire		[`DATA_WIDTH-1:0]	temp_result;
wire		gt;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		result	<=	`DATA_WIDTH 'b0;
	else if (clear)
		result	<=	`DATA_WIDTH 'b0;
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