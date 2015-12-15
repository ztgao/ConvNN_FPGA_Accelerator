// 	version 1.0 --	2015.11.29	
//				-- 	setup

`include "../../global_define.v"

module	network_manager #(
	parameter
	IMAGE_NUM	=	5)
(
//--input
	clk,
	rst_n,
	start,
	layer_0_calc_fin,
//--output
	layer_0_en,	
	data_out
);

`include "../../network/network_param.v"

localparam	IMAGE_WIDTH	=	logb2(IMAGE_NUM);

input		clk;
input		rst_n;
input		start;	

input		layer_0_calc_fin;

output		data_out;
output reg	layer_0_en;


reg			[IMAGE_WIDTH-1:0]	input_image_idx;

wire	lastImage	=	(input_image_idx	==	IMAGE_NUM - 1);
	
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		input_image_idx	<=	4'b0;			
	else if(layer_0_calc_fin)
		if ( lastImage )
			input_image_idx	<=	4'b0;
		else 
			input_image_idx	<=	input_image_idx + 1'b1;
	else
		input_image_idx	<=	input_image_idx;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		layer_0_en	<=	0;
	else if(lastImage && layer_0_calc_fin)
		layer_0_en	<=	0;
	else if(start)
		layer_0_en	<=	1;
	else
		layer_0_en	<=	layer_0_en;
end

endmodule
		