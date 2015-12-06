// 	version 1.0 --	2015.11.29	
//				-- 	setup

`include "../../global_define.v"
module	image_manager(
//--input
	clk,
	rst_n,
	enable,
	layer_0_calc_fin,
//--output
	layer_0_calc_fin,
	
	data_out
);

`include "../../network/image_param.v"

input		clk;
input		rst_n;
input		enable;	

input		layer_0_calc_fin;

output		data_out;


reg			[3:0]	input_image_idx;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		input_image_idx	<=	4'b0;			
	else if(layer_0_calc_fin)
		if(input_image_idx	==	IMAGE_NUM - 1)
			input_image_idx	<=	4'b0;
		else 
			input_image_idx	<=	input_image_idx + 1'b1;
	else
		input_image_idx	<=	input_image_idx;
end



endmodule
		