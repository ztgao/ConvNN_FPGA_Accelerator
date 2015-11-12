// version 1.0 -- setup
// Description:
// Consider that the weight set will not change in a specific network, so I try to put them in
// a ROM IP by Xilinx. In the test, the ROM is configured as a 32x4B rom and I will put two set
// weight.

module conv_weight_cache(
	//--input
	clk,
	rst_n,
	current_state,
	// a signal to indicate the send state, eg. stop, hold or change the rom_addr
	//--output
	o_weight
	
);

parameter	WIDTH				=	32;
parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

//parameter	WEIGHT_SET_NUM		=	2;

parameter	STAGE_INIT			=	3'd0;
parameter	STAGE_PRELOAD		=	3'd1;	
parameter	STAGE_SHIFT			=	3'd2;
parameter	STAGE_LOAD			=	3'd3;

input					clk;
input					rst_n;
input	[1:0]			weight;

output	[WIDTH-1:0]		o_weight;
reg		[WIDTH-1:0]		o_weight;

reg		[4:0]			rom_addr;	
reg		[2:0]			current_state;

wire	[WIDTH-1:0]		r_data;


always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		rom_addr	<=	5'b0 ;
	else if (current_state 	== 	STAGE_SHIFT)	// ?!
		rom_addr	<=	rom_addr + 1 ;
	else if (current_state	==	STAGE_LOAD)
		rom_addr	<=	5'b0 ;
	else
		rom_addr	<=	rom_addr;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		o_weight	<=	32'b0 ;
	else if (current_state 	== 	STAGE_SHIFT)
		o_weight	<=	r_data ;
	else
		o_weight	<=	32'b0;
end
	
rom_32x32 U_weight_rom_32x32 (
  .a	(rom_addr),      // input wire [4 : 0] a
  .spo	(r_data)  // output wire [31 : 0] spo
);

endmodule