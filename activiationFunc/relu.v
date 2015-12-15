// 	version 1.0 --	2015.11.01	
//				-- 	setup

`include "../../global_define.v"
module	relu(
//	--	input
	clk,
	rst_n,
	data_in,
//	--	output
	data_out
);

`include "../../conv_layer/conv_kernel_param.v"

input 			clk;
input			rst_n;
input	[`DATA_WIDTH-1:0]	data_in;

output reg	[`DATA_WIDTH-1:0]	data_out;


always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		data_out	<=	`WIDTH 'b0;
	else if (data_in[`DATA_WIDTH-1] == 0)
		data_out	<=	data_in;
	else
		data_out	<=	`WIDTH 'b0;
end

endmodule

