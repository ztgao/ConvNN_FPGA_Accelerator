// version 1.0 -- setup
// Description:
// In the test, the input image is 8x8, and we suggest that we take 16 DWORDS in a single step,
// so we can calculate 12 convolution in this step.
// The conv_kernel is 3x3.

`include "../../global_define.v"
module conv_layer_top
#(parameter 
	KERNEL_SIZE 		= 	3,
	IMAGE_SIZE			= 	8,
	ARRAY_SIZE  		= 	6,	
	TOTAL_WEIGHT		= 	4,
	WEIGHT_ROM_DEPTH	=	64)			
(	
//--input
	clk,
	rst_n,
	data_in,	
	enable,	
//--output
	ext_rom_addr,
	valid,
	image_calc_fin,
	feature_idx,
	feature_row,
	feature_output
);

`include "../../conv_layer/conv_kernel_param.v"

localparam	WEIGHT_WIDTH		= 	logb2(TOTAL_WEIGHT);
localparam	ARRAY_WIDTH			=	logb2(ARRAY_SIZE);

input									clk;
input									rst_n;
input	[`DATA_WIDTH-1:0]				data_in;
input									enable;

output	[ARRAY_SIZE*`DATA_WIDTH-1:0]	feature_output;
wire	[ARRAY_SIZE*`DATA_WIDTH-1:0]	o_pixel_bus;
output	[`EXT_ADDR_WIDTH-1:0]			ext_rom_addr;

output									image_calc_fin;
output	[WEIGHT_WIDTH-1:0]				feature_idx;

output	[ARRAY_WIDTH-1:0]				feature_row;

wire	[`DATA_WIDTH-1:0]				i_weight;

output						valid;

wire	[1:0]				input_interface_cmd;
wire	[1:0]				input_interface_ack;

wire	[ARRAY_SIZE*`DATA_WIDTH-1:0]	feature;

assign	feature_output	=	(valid)? feature: {ARRAY_SIZE{`DATA_WIDTH 'b0}};


conv_layer_controller #(
	.KERNEL_SIZE 		(KERNEL_SIZE),
	.ARRAY_SIZE		    (ARRAY_SIZE),
	.TOTAL_WEIGHT 	    (TOTAL_WEIGHT)
)
U_conv_layer_controller_0(
//--input
	.clk					(clk),
	.rst_n					(rst_n),
	.enable					(enable),
	.input_interface_ack	(input_interface_ack),	
//--output
	.valid					(valid),
	.image_calc_fin			(image_calc_fin),
	.feature_idx			(feature_idx),
	.feature_row			(feature_row),
	.input_interface_cmd	(input_interface_cmd)
);


conv_layer_input_interface #(
	.KERNEL_SIZE 		(KERNEL_SIZE),
	.IMAGE_SIZE	        (IMAGE_SIZE),
	.ARRAY_SIZE	        (ARRAY_SIZE),
	.WEIGHT_ROM_DEPTH	(WEIGHT_ROM_DEPTH),
	.TOTAL_WEIGHT		(TOTAL_WEIGHT)
)
U_conv_layer_input_interface_0 (
// --input
	.clk			(clk),
	.rst_n			(rst_n),
	.enable			(enable),
	.data_in		(data_in),
	.cmd			(input_interface_cmd),
	.ack			(input_interface_ack),
// --output
	.ext_rom_addr	(ext_rom_addr),
	.data_out		(o_pixel_bus),
	.o_weight		(i_weight)	
);



conv_kernel_array  #(
	.ARRAY_SIZE		(ARRAY_SIZE)
)
U_conv_kernel_array_0 (
//--input
	.clk			(clk),
	.rst_n			(rst_n),
	.i_pixel_bus	(o_pixel_bus),
	.i_weight		(i_weight),
	.clear			(valid),	
//--output	
	.o_pixel_bus	(feature)	
);


`ifdef DEBUG
/////////////////////////////////////////////////////////////////////////////
// A type cast module for IEEE-754 to real. 
// When synthesize the project in Vivado, please turn off it.
//	--

shortreal	o_pixel_bus_ob [ARRAY_SIZE];
always @(*) begin
	for (int i = 0; i < ARRAY_SIZE; i++)
		o_pixel_bus_ob[i]	=	$bitstoshortreal(o_pixel_bus[(ARRAY_SIZE-i)*`DATA_WIDTH-1 -: `DATA_WIDTH]);
end

//	--
shortreal	i_weight_observe;
always @(i_weight) begin
	i_weight_observe =	$bitstoshortreal(i_weight);
end

//	--	
shortreal	feature_ob [ARRAY_SIZE];
always @(*) begin
	for (int i = 0; i < ARRAY_SIZE; i++)
		feature_ob[i]	=	$bitstoshortreal(feature_output[(ARRAY_SIZE-i)*`DATA_WIDTH-1 -: `DATA_WIDTH]);	
end

//	-- print --

shortreal	featMap[ARRAY_SIZE][ARRAY_SIZE][TOTAL_WEIGHT];
always @(valid) begin
	if(valid && ext_rom_addr < 'd785)
		for (int i = 0; i < ARRAY_SIZE; i = i + 1)
			featMap[feature_row][i][feature_idx] = feature_ob[i];
end

int fp_featMap;	
int row;
int col;
int ch;

initial begin
	fp_featMap = $fopen("featMap.txt","w");
end

always @(ext_rom_addr)	begin
	if(ext_rom_addr == 'd785) begin
		for ( ch = 0; ch < TOTAL_WEIGHT; ch++) begin
			for ( row = 0; row < ARRAY_SIZE; row++) begin
				for( col = 0; col < ARRAY_SIZE; col++) begin
					$fwrite(fp_featMap,"%f\t",featMap[row][col][ch]);
				end
//				$fwrite(fp_featMap, "\n");
			end
			$fwrite(fp_featMap, "\n");
		end
		$fclose(fp_featMap);
	end			
end

//	----------	

		
	
/////////////////////////////////////////////////////////////////////////////
`endif


endmodule
