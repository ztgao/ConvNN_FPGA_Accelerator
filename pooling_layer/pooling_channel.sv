//	version	1.0		--	12.12
//					--	setup
//	Description:

`include "../../global_define.v"
module pooling_channel #(
	parameter
	INPUT_SIZE		=	6,
	KERNEL_SIZE		=	2,	
	TOTAL_FEATURE	=	4)
(
//--input
	clk,
	rst_n,
	feature_idx,
	feature_row,
	data_in,
	input_valid,
//--output
	output_valid,
	data_out
);

`include "../../pooling_layer/pooling_param.v"

localparam	ROW_WIDTH		=	logb2(INPUT_SIZE);
localparam	FEATURE_WIDTH	=	logb2(TOTAL_FEATURE);

input		clk;
input		rst_n;
input		[FEATURE_WIDTH-1:0]	feature_idx;
input		[ROW_WIDTH-1:0]	feature_row;
input 		input_valid;

input		[KERNEL_SIZE*`DATA_WIDTH-1:0]	data_in;	
output	 	[`DATA_WIDTH-1:0]	data_out;

wire		[`DATA_WIDTH-1:0]	data_intfIn_ker;
wire		[`DATA_WIDTH-1:0]	data_ker_intfOut;		

wire		output_valid_ker;
output		output_valid;

reg			[ROW_WIDTH-1:0]	feature_idx_delay_0;
reg			[ROW_WIDTH-1:0]	feature_row_delay_0;


always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		feature_idx_delay_0	<=	0;
	else if(input_valid)
		feature_idx_delay_0	<=	feature_idx;
	else
		feature_idx_delay_0	<=	feature_idx_delay_0;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		feature_row_delay_0	<=	0;
	else if(input_valid)
		feature_row_delay_0	<=	feature_row;
	else
		feature_row_delay_0	<=	feature_row_delay_0;
end




//	----------------------------------------
/* pooling_input_interface #(
	.INPUT_SIZE			(INPUT_SIZE),
	.KERNEL_SIZE		(KERNEL_SIZE)
)
U_pooling_input_interface(
//--input
	.clk				(clk),
	.rst_n				(rst_n),
	.input_valid		(input_valid),
	.data_in			(data_in),	
//--.output
	.data_out			(data_intfIn_ker)
); */

//	-----------------------------------------
pooling_kernel #(
	.INPUT_SIZE			(INPUT_SIZE),
	.KERNEL_SIZE		(KERNEL_SIZE),		
	.TOTAL_FEATURE	    (TOTAL_FEATURE)
)
U_pooling_kernel(
//--input
	.clk		(clk),
	.rst_n		(rst_n),
//	.data_in	(data_intfIn_ker),
	.data_in	(data_in),
	
	.input_valid(input_valid),
	.feature_idx(feature_idx_delay_0),
	.feature_row(feature_row_delay_0),
//--output
	.output_valid(output_valid_ker),
	.data_out	 (data_ker_intfOut)	
);

//	-----------------------------------------
pooling_output_interface #(
	.INPUT_SIZE			(INPUT_SIZE),
	.KERNEL_SIZE		(KERNEL_SIZE),
	.TOTAL_FEATURE	    (TOTAL_FEATURE)
)
U_pooling_output_interface(
//--input
	.clk		(clk),
	.rst_n		(rst_n),
	.feature_idx(feature_idx_delay_0),
	.feature_row(feature_row_delay_0),
	.data_in	(data_ker_intfOut),
	.input_valid(output_valid_ker),
//--output
	.output_valid(output_valid),
	.data_out	(data_out)
);


endmodule




