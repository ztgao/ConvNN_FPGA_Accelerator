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

// parameter	STAGE_INIT			=	3'd0;
// parameter	STAGE_PRELOAD		=	3'd1;	
// parameter	STAGE_SHIFT			=	3'd2;
// parameter	STAGE_LOAD			=	3'd3;

parameter	STAGE_INIT			=	3'd0;
parameter	STAGE_PRELOAD		=	3'd1;	
parameter	STAGE_ROW_0			=	3'd2;
parameter	STAGE_ROW_1			=	3'd3;
parameter	STAGE_ROW_2			=	3'd4;
parameter	STAGE_BIAS			=	3'd5;
parameter	STAGE_LOAD			=	3'd6;
parameter	STAGE_IDLE			=	3'd7;

input					clk;
input					rst_n;
input	[2:0]			current_state;

output	[WIDTH-1:0]		o_weight;
reg		[WIDTH-1:0]		o_weight;

reg		[5:0]			rom_addr;	


wire	[WIDTH-1:0]		r_data;


always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		rom_addr	<=	6'b0 ;
	else if (current_state 	== 	STAGE_ROW_0 || current_state == STAGE_ROW_1 || current_state == STAGE_ROW_2 || current_state == STAGE_BIAS)	// ?!
		rom_addr	<=	rom_addr + 1 ;
	else if (current_state	==	STAGE_LOAD || current_state == STAGE_PRELOAD)
		rom_addr	<=	6'b0 ;
	else
		rom_addr	<=	rom_addr;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		o_weight	<=	32'b0 ;
	else if (current_state 	== 	STAGE_ROW_0 || current_state == STAGE_ROW_1 || current_state == STAGE_ROW_2 || current_state == STAGE_BIAS)
		o_weight	<=	r_data ;
	else
		o_weight	<=	32'b0;
end
	
rom_weight_64x32 U_rom_weight_64x32  (
	.a		(rom_addr),      // input wire [4 : 0] a
	.spo	(r_data)  // output wire [31 : 0] spo
);

endmodule