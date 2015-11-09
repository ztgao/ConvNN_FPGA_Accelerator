// version 1.0 -- setup
// Description:
// Consider that the weight set will not change in a specific network, so I try to put them in
// a ROM IP by Xilinx. In the test, the ROM is configured as a 32x4B rom and I will put two set
// weight.

module weight_cache(
	//--input
	clk,
	rst_n,
	// a signal to indicate the send state, eg. stop, hold or change the rom_addr
	
	//--output
	o_weight
	
);

parameter	WIDTH				=	32;
parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

parameter	WEIGHT_SET_NUM		=	2;


input					clk;
input					rst_n;

output	[WIDTH-1:0]		o_weight;
reg		[WIDTH-1:0]		o_weight;

reg		[4:0]			rom_addr;	

wire	[WIDTH-1:0]		r_data;


always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		rom_addr	<=	5'b0;
	end
	else begin
		

rom_32x32 U_weight_rom_32x32 (
  .a	(rom_addr),      // input wire [4 : 0] a
  .spo	(r_data)  // output wire [31 : 0] spo
);