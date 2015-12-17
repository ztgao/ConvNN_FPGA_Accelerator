// 	version 1.0 --	2015.12.01	
//				-- 	setup

`include "../../global_define.v"

module	pooling_layer_top #(
	parameter
	INPUT_SIZE		=	6,
	KERNEL_SIZE		=	2,
	OUTPUT_SIZE		=	3,
	TOTAL_FEATURE	=	4)
(
//--input
	clk,
	rst_n,	
	input_valid,
	feature_idx,
	feature_row,
	data_in,	
//--output
	output_valid,
	feature_idx_o,
	feature_row_o,	
	data_out
);

`include "../../pooling_layer/pooling_param.v"

localparam	ROW_WIDTH		=	logb2(INPUT_SIZE);
localparam	FEATURE_WIDTH	=	logb2(TOTAL_FEATURE);

input	clk;
input	rst_n;
input	input_valid;

input	[FEATURE_WIDTH-1:0]	feature_idx;
input	[ROW_WIDTH-1:0]		feature_row;

input	[INPUT_SIZE*`DATA_WIDTH-1:0]	data_in;	//	6
output	[OUTPUT_SIZE*`DATA_WIDTH-1:0]	data_out;	//	3

output	output_valid;

output	[FEATURE_WIDTH-1:0]	feature_idx_o;
output	[ROW_WIDTH-1:0]		feature_row_o;

reg		[ROW_WIDTH-1:0]	feature_idx_delay_0;
reg		[ROW_WIDTH-1:0]	feature_row_delay_0;


assign	feature_idx_o	=	feature_idx_delay_0;
assign	feature_row_o	=	feature_row_delay_0;

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


genvar	gv_poolChIdx;	
generate
	for (gv_poolChIdx = 0; gv_poolChIdx < OUTPUT_SIZE; gv_poolChIdx=gv_poolChIdx+1)
	begin: genPoolCh
	//////////////////////////////////
		pooling_channel #(
			.INPUT_SIZE		(INPUT_SIZE),
			.KERNEL_SIZE	(KERNEL_SIZE),	
			.TOTAL_FEATURE	(TOTAL_FEATURE))
		U_pooling_channel (
		//--input
			.clk		(clk),
			.rst_n		(rst_n),
			.feature_idx(feature_idx),
			.feature_row(feature_row),
			.data_in	(data_in[(INPUT_SIZE-gv_poolChIdx*KERNEL_SIZE)*`DATA_WIDTH-1 -: KERNEL_SIZE*`DATA_WIDTH]),
			.input_valid(input_valid),
		//--output      
			.output_valid(output_valid),
			.data_out   (data_out[(OUTPUT_SIZE-gv_poolChIdx)*`DATA_WIDTH-1 -: `DATA_WIDTH])
		);
	//////////////////////////////////
	end
endgenerate


//	--	for simulation observation
//
//
`ifdef DEBUG

shortreal data_out_ob[OUTPUT_SIZE];
always @(*) begin
	for(int i = 0; i<OUTPUT_SIZE; i = i + 1)
		data_out_ob[i]	=	$bitstoshortreal(data_out[(OUTPUT_SIZE - i)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
end

shortreal data_in_ob[INPUT_SIZE];
always @(*) begin
	for(int i = 0; i<INPUT_SIZE; i = i + 1)
		data_in_ob[i]	=	$bitstoshortreal(data_in[(INPUT_SIZE - i)*`DATA_WIDTH-1 -: `DATA_WIDTH]);

end	

//	-- print --
 

/*
shortreal	poolMap[OUTPUT_SIZE][OUTPUT_SIZE][TOTAL_FEATURE];
always @(output_valid) begin
	if(output_valid && U_conv_layer_top_0.ext_rom_addr < 'd924)
		for (int i = 0; i < OUTPUT_SIZE; i = i + 1)
			poolMap[(feature_row_delay_0/2)][i][feature_idx_delay_0] = data_out_ob[i];
end

int fp_poolMap;	
int row;
int col;
int ch;

initial begin
	fp_poolMap = $fopen("poolMap.txt","w");
end

always @(U_conv_layer_top_0.ext_rom_addr)	begin
	if(U_conv_layer_top_0.ext_rom_addr == 'd924) begin
		for ( ch = 0; ch < TOTAL_FEATURE; ch++) begin
			for ( row = 0; row < OUTPUT_SIZE; row++) begin
				for( col = 0; col < OUTPUT_SIZE; col++) begin
					$fwrite(fp_poolMap,"%f\t",poolMap[row][col][ch]);
				end
//				$fwrite(fp_poolMap, "\n");
			end
			$fwrite(fp_poolMap, "\n");
		end
		$fclose(fp_poolMap);
	end			
end

//	----------	
 
	  */
`endif



endmodule