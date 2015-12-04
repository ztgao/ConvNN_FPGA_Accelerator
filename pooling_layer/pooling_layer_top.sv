// 	version 1.0 --	2015.12.01	
//				-- 	setup

`include "../../global_define.v"

module	pooling_layer_top(
//--input
	clk,
	rst_n,	
	kernel_calc_fin,
	data_in,
//--output
	data_out
);

`include "../../pooling_layer/pooling_param.v"

input	clk;
input	rst_n;
input	kernel_calc_fin;

input	[INPUT_SIZE*`DATA_WIDTH-1:0]	data_in;	//	6
output	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_out;	//	3

wire	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_from_cache;
wire	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_from_array;

reg		clear;
reg		kernel_calc_fin_delay_0;
reg		kernel_calc_fin_delay_1;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		kernel_calc_fin_delay_0	<=	0;
	else
		kernel_calc_fin_delay_0	<=	kernel_calc_fin_delay_1;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		kernel_calc_fin_delay_1	<=	0;
	else
		kernel_calc_fin_delay_1	<=	kernel_calc_fin;
end

// always @(posedge clk, negedge rst_n) begin
	// if(!rst_n) 
		// cache_output_idx	<=	2'b0;
	// else if(cache_output_idx ==	KERNEL_SIZE - 1 || kernel_calc_fin)
		// cache_output_idx	<=	2'b0;
	// else
		// cache_output_idx	<=	cache_output_idx + 1'd1;
// end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		clear	<=	0;
	else if(kernel_calc_fin_delay_0)
		clear	<=	1;
	else
		clear	<=	0;
end
		


pooling_layer_input_cache U_pooling_layer_input_cache_0(
//--input
	.clk				(clk),
	.rst_n				(rst_n),
	.kernel_calc_fin	(kernel_calc_fin),
	.data_in			(data_in),		
//--.output
	.data_out			(data_from_cache)
);

pooling_array U_pooling_array_0(
//--input
	.clk		(clk),
	.rst_n		(rst_n),
	.data_in	(data_from_cache),
	.clear		(clear),
//--output
	.data_out	(data_from_array)	
);




`ifdef DEBUG

shortreal data_from_cache_ob[OUTPUT_SIZE];
always @(*) begin
	 data_from_cache_ob[0]	=	$bitstoshortreal(data_from_cache[(OUTPUT_SIZE - 0)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
	 data_from_cache_ob[1]	=	$bitstoshortreal(data_from_cache[(OUTPUT_SIZE - 1)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
	 data_from_cache_ob[2]	=	$bitstoshortreal(data_from_cache[(OUTPUT_SIZE - 2)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
end

shortreal data_from_array_ob[OUTPUT_SIZE];
always @(*) begin
	 data_from_array_ob[0]	=	$bitstoshortreal(data_from_array[(OUTPUT_SIZE - 0)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
	 data_from_array_ob[1]	=	$bitstoshortreal(data_from_array[(OUTPUT_SIZE - 1)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
	 data_from_array_ob[2]	=	$bitstoshortreal(data_from_array[(OUTPUT_SIZE - 2)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
end		 
	 
`endif



endmodule