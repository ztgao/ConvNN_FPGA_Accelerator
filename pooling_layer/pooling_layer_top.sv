// 	version 1.0 --	2015.12.01	
//				-- 	setup

`include "../../global_define.v"

module	pooling_layer_top(
//--input
	clk,
	rst_n,	
	valid,
	feature_idx,
	feature_row,
	data_in,	
//--output
	data_out
);

`include "../../pooling_layer/pooling_param.v"

input	clk;
input	rst_n;
input	valid;

input	[1:0]	feature_idx;
input	[2:0]	feature_row;

input	[INPUT_SIZE*`DATA_WIDTH-1:0]	data_in;	//	6
output	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_out;	//	3

wire	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_from_cache;
wire	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_from_array;

wire	[`DATA_WIDTH-1:0]	data_from_cache_0;
wire	[`DATA_WIDTH-1:0]	data_from_array_0;
wire	[`DATA_WIDTH-1:0]	data_from_output_interface_0;


wire	valid;
wire	pooling_valid;

reg		[2:0]	block_idx;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		block_idx	<=	3'b0;
	else if(valid)
		block_idx	<=	feature_idx;
	else
		block_idx	<=	block_idx;
end


//---------------------------------------------
reg	[2:0]	feature_row_delay_0;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		feature_row_delay_0	<=	3'b0;
	else if(valid)
		feature_row_delay_0	<=	feature_row;
	else
		feature_row_delay_0	<=	feature_row_delay_0;
end

//-----------------------------------------------

pooling_input_interface U_pooling_input_interface_0(
//--input
	.clk				(clk),
	.rst_n				(rst_n),
	.valid	(valid),
	.data_in			(data_in[INPUT_SIZE*`DATA_WIDTH-1 -: KERNEL_SIZE*`DATA_WIDTH]),		
//--.output
	.data_out			(data_from_cache_0)
);


pooling_array U_pooling_array_0(
//--input
	.clk		(clk),
	.rst_n		(rst_n),
	.data_in	(data_from_cache_0),
	
	.kernel_calc_fin		(valid),
	.feature_idx(block_idx),
	.feature_row(feature_row_delay_0),
//--output
	.valid		(pooling_valid),
	.data_out	(data_from_array_0)	
);




pooling_output_interface U_pooling_output_interface_0(
//--input
	.clk		(clk),
	.rst_n		(rst_n),
	.feature_idx(block_idx),
	.feature_row(feature_row_delay_0),
	.data_in	(data_from_array_0),
	.valid		(pooling_valid),
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