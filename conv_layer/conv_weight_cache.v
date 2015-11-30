// version 1.0 -- setup
// Description:
// Consider that the weight set will not change in a specific network, so I try to put them in
// a ROM IP by Xilinx. In the test, the ROM is configured as a 32x4B rom and I will put two set
// weight.
`include "../../global_define.v"
module conv_weight_cache(
	//--input
	clk,
	rst_n,
	current_state,
	// a signal to indicate the send state, eg. stop, hold or change the rom_addr
	//--output
	o_weight
	
);

parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

//parameter	WEIGHT_SET_NUM		=	2;

// parameter	STATE_INIT			=	3'd0;
// parameter	STATE_PRELOAD		=	3'd1;	
// parameter	STATE_SHIFT			=	3'd2;
// parameter	STATE_LOAD			=	3'd3;

parameter	STATE_INIT			=	3'd0;
parameter	STATE_PRELOAD		=	3'd1;	
parameter	STATE_SHIFT			=	3'd2;
parameter	STATE_BIAS			=	3'd5;
parameter	STATE_LOAD			=	3'd6;
parameter	STATE_IDLE			=	3'd7;

input					clk;
input					rst_n;
input	[2:0]			current_state;

output	[`DATA_WIDTH-1:0]		o_weight;
reg		[`DATA_WIDTH-1:0]		o_weight;

reg		[5:0]			rom_addr;	


wire	[`DATA_WIDTH-1:0]		r_data;


always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		rom_addr	<=	6'b0 ;
	else if (current_state 	== 	STATE_SHIFT || current_state == STATE_BIAS)	// ?!
		rom_addr	<=	rom_addr + 1 ;
	else if (current_state	==	STATE_LOAD || current_state == STATE_PRELOAD)
		rom_addr	<=	6'b0 ;
	else
		rom_addr	<=	rom_addr;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		o_weight	<=	32'b0 ;
	else if (current_state 	== 	STATE_SHIFT || current_state == STATE_BIAS)
		o_weight	<=	r_data ;
	else
		o_weight	<=	32'b0;
end

`ifdef	RTL_SIMULATION		
	rom_64x32_sim	U_rom_64x32_sim_0(
		.addr	(rom_addr),
		.data_o	(r_data)
	);
	
`else
	rom_weight_64x32 U_rom_weight_64x32  (
		.a		(rom_addr),      // input wire [4 : 0] a
		.spo	(r_data)  // output wire [31 : 0] spo
	);
`endif	

endmodule