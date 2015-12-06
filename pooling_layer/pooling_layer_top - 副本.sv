// 	version 1.0 --	2015.12.01	
//				-- 	setup

`include "../../global_define.v"

module	pooling_layer_top(
//--input
	clk,
	rst_n,	
	kernel_calc_fin,
	feature_idx,
	feature_row,
	data_in,	
//--output
	data_out
);

`include "../../pooling_layer/pooling_param.v"

input	clk;
input	rst_n;
input	kernel_calc_fin;

input	[1:0]	feature_idx;
input	[2:0]	feature_row;

input	[INPUT_SIZE*`DATA_WIDTH-1:0]	data_in;	//	6
output	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_out;	//	3

wire	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_from_cache;
wire	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_from_array;

wire	[`DATA_WIDTH-1:0]	data_from_cache_0;
wire	[`DATA_WIDTH-1:0]	data_from_array_0;

wire	valid;

reg		clear;
reg		kernel_calc_fin_delay_0;
reg		kernel_calc_fin_delay_1;
reg		kernel_calc_fin_delay_2;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		kernel_calc_fin_delay_0	<=	0;
		kernel_calc_fin_delay_1	<=	0;
		kernel_calc_fin_delay_2	<=	0;	
	end
	else begin
		kernel_calc_fin_delay_0	<=	kernel_calc_fin_delay_1;
		kernel_calc_fin_delay_1	<=	kernel_calc_fin_delay_2;
		kernel_calc_fin_delay_2	<=	kernel_calc_fin;
	end
end


reg	[1:0]	feature_idx_delay_0;
reg	[1:0]	feature_idx_delay_1;
reg	[1:0]	feature_idx_delay_2;
reg	[1:0]	feature_idx_delay_3;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		feature_idx_delay_0	<= 2'd0;
		feature_idx_delay_1 <= 2'd0;
		feature_idx_delay_2 <= 2'd0;
		feature_idx_delay_3 <= 2'd0;
	end
	else begin
		feature_idx_delay_0	<= feature_idx_delay_1;
		feature_idx_delay_1 <= feature_idx_delay_2;
		feature_idx_delay_2 <= feature_idx_delay_3;
		feature_idx_delay_3 <= feature_idx;
	end
end

//---------------------------------------------
reg	[2:0]	feature_row_delay_0;
reg	[2:0]	feature_row_delay_1;
reg	[2:0]	feature_row_delay_2;
reg	[2:0]	feature_row_delay_3;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		feature_row_delay_0	<= 2'd0;
		feature_row_delay_1 <= 2'd0;
		feature_row_delay_2 <= 2'd0;
		feature_row_delay_3 <= 2'd0;
	end
	else begin
		feature_row_delay_0	<= feature_row_delay_1;
		feature_row_delay_1 <= feature_row_delay_2;
		feature_row_delay_2 <= feature_row_delay_3;
		feature_row_delay_3 <= feature_row;
	end
end
//-----------------------------------------------
		
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		clear	<=	0;
	else if(kernel_calc_fin_delay_0)
		clear	<=	1;
	else
		clear	<=	0;
end
		
assign	valid	=	kernel_calc_fin_delay_0 || kernel_calc_fin_delay_1;

/* pooling_layer_input_cache U_pooling_layer_input_cache_0(
//--input
	.clk				(clk),
	.rst_n				(rst_n),
	.kernel_calc_fin	(kernel_calc_fin),
	.data_in			(data_in),		
//--.output
	.data_out			(data_from_cache)
); */

pooling_layer_input_buffer U_pooling_layer_input_buffer_0(
//--input
	.clk				(clk),
	.rst_n				(rst_n),
	.kernel_calc_fin	(kernel_calc_fin),
	.data_in			(data_in[INPUT_SIZE*`DATA_WIDTH-1 -: KERNEL_SIZE*`DATA_WIDTH]),		
//--.output
	.data_out			(data_from_cache_0)
);


pooling_array U_pooling_array_0(
//--input
	.clk		(clk),
	.rst_n		(rst_n),
	.data_in	(data_from_cache_0),
	.clear		(clear),
	.kernel_calc_fin(kernel_calc_fin_delay_0),
	.feature_idx(feature_idx_delay_0),
	.feature_row(feature_row_delay_0),
//--output
	.data_out	(data_from_array_0)	
);



wire	[`DATA_WIDTH-1:0]	data_from_output_interface_0;

pooling_output_interface U_pooling_output_interface_0(
//--input
	.clk		(clk),
	.rst_n		(rst_n),
	.feature_idx(feature_idx_delay_0),
	.feature_row(feature_row_delay_0),
	.data_in	(data_from_array_0),
	.valid		(kernel_calc_fin_delay_0),
//--output
	.data_out	(data_from_output_interface_0)
);

`ifdef DEBUG

// shortreal data_from_cache_ob[OUTPUT_SIZE];
// always @(*) begin
	 // data_from_cache_ob[0]	=	$bitstoshortreal(data_from_cache[(OUTPUT_SIZE - 0)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
	 // data_from_cache_ob[1]	=	$bitstoshortreal(data_from_cache[(OUTPUT_SIZE - 1)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
	 // data_from_cache_ob[2]	=	$bitstoshortreal(data_from_cache[(OUTPUT_SIZE - 2)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
// end

// shortreal data_from_array_ob[OUTPUT_SIZE];
// always @(*) begin
	 // data_from_array_ob[0]	=	$bitstoshortreal(data_from_array[(OUTPUT_SIZE - 0)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
	 // data_from_array_ob[1]	=	$bitstoshortreal(data_from_array[(OUTPUT_SIZE - 1)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
	 // data_from_array_ob[2]	=	$bitstoshortreal(data_from_array[(OUTPUT_SIZE - 2)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
// end		 
	 
`endif



endmodule