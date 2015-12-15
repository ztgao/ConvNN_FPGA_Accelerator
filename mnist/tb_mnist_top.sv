// version 1.0 -- setup
// Description:

`include "../../global_define.v"
`timescale 1ns/1ns
module tb_mnist_top;

parameter 	KERNEL_SIZE 	= 	3,
			ARRAY_SIZE		= 	6,
			TOTAL_WEIGHT 	= 	4;



logic 			clk;
logic 			rst_n;
logic 			enable;

bit 		[`DATA_WIDTH-1:0]		data_from_ext_rom;
bit			[`EXT_ADDR_WIDTH-1:0]	ext_rom_addr;


bit		[`DATA_WIDTH-1:0] 		pooling_output	[12];
bit		[12 * `DATA_WIDTH-1:0]		pooling_output_bus;



assign {pooling_output[0],
        pooling_output[1],
        pooling_output[2],
        pooling_output[3],
        pooling_output[4],
        pooling_output[5],
		pooling_output[6],
        pooling_output[7],
        pooling_output[8],
        pooling_output[9],
        pooling_output[10],
        pooling_output[11]} = pooling_output_bus;

always
	#5 	clk		=	~clk;
	
initial begin

	clk			=	0;
	rst_n		=	1;
	enable		=	0;
	#10
	rst_n		=	0;
	#10
	rst_n		=	1;
	#10
	enable		=	1;
	#10
	enable		=	0;
	
	// #400
	// idle		=	1;
	// #100
	// idle		=	0;
	#300000
	
	$stop;
end




mnist_top	U_mnist_top(
	.clk			(clk),
	.rst_n          (rst_n),
	.enable         (enable),
	.data_in        (data_from_ext_rom),
	.ext_rom_addr   (ext_rom_addr),
	.pooling_output (pooling_output_bus)
);


`ifdef	RTL_SIMULATION	
	rom_4kx32_sim U_rom_1 (
		.addr(ext_rom_addr),      // input wire [5 : 0] a
		.data_o(data_from_ext_rom)  // output wire [31 : 0] spo
	);

`else
	rom_4kx32 U_rom_1 (
		.a(ext_rom_addr),      // input wire [5 : 0] a
		.spo(data_from_ext_rom)  // output wire [31 : 0] spo
	);
`endif


shortreal		pooling_output_ob [12];
always @(*) begin
	pooling_output_ob[0]		=	$bitstoshortreal(pooling_output[0]);
	pooling_output_ob[1]		=	$bitstoshortreal(pooling_output[1]);
	pooling_output_ob[2]		=	$bitstoshortreal(pooling_output[2]);
	pooling_output_ob[3]		=	$bitstoshortreal(pooling_output[3]);
	pooling_output_ob[4]		=	$bitstoshortreal(pooling_output[4]);
	pooling_output_ob[5]		=	$bitstoshortreal(pooling_output[5]);
	pooling_output_ob[6]		=	$bitstoshortreal(pooling_output[6]);
	pooling_output_ob[7]		=	$bitstoshortreal(pooling_output[7]);
	pooling_output_ob[8]		=	$bitstoshortreal(pooling_output[8]);
	pooling_output_ob[9]		=	$bitstoshortreal(pooling_output[9]);
	pooling_output_ob[10]		=	$bitstoshortreal(pooling_output[10]);
	pooling_output_ob[11]		=	$bitstoshortreal(pooling_output[11]);	
end	


endmodule