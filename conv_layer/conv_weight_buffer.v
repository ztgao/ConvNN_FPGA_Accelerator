// version 1.0 -- setup
// Description:
// Consider the weight set will not change in a specific network, so I try to put them in
// a ROM IP by Xilinx. In the test, the ROM is configured as a 32x4B rom and I will put two set
// weight.
`include "../../global_define.v"
module conv_weight_buffer
#(parameter	WEIGHT_ROM_DEPTH	= 	64,
			TOTAL_WEIGHT		=	4)
(//--input
	clk,
	rst_n,
	current_state,
	// a signal to indicate the send state, eg. stop, hold or change the rom_addr
	//--output
	o_weight
	
);

`include "../../conv_layer/conv_kernel_param.v"

localparam	WEIGHT_ADDR_WIDTH	=	logb2(WEIGHT_ROM_DEPTH);
localparam	WEIGHT_WIDTH		=	logb2(TOTAL_WEIGHT);

input					clk;
input					rst_n;
input	[2:0]			current_state;

output	[`DATA_WIDTH-1:0]		o_weight;
reg		[`DATA_WIDTH-1:0]		o_weight;

reg		[WEIGHT_ADDR_WIDTH-1:0]		rom_addr;	


wire	[`DATA_WIDTH-1:0]		r_data;


always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		rom_addr	<=	0 ;
	else if (current_state 	== 	STATE_SHIFT || current_state == STATE_BIAS)	// ?!
		rom_addr	<=	rom_addr + 1'b1 ;
	else if (current_state	==	STATE_LOAD || current_state == STATE_PRELOAD)
		rom_addr	<=	0 ;
	else
		rom_addr	<=	rom_addr;
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		o_weight	<=	`DATA_WIDTH 'b0 ;
	else if (current_state 	== 	STATE_SHIFT || current_state == STATE_BIAS)
		o_weight	<=	r_data ;
	else
		o_weight	<=	`DATA_WIDTH 'b0 ;
end

`ifdef	RTL_SIMULATION		
	// rom_64x32_sim	U_rom_64x32_sim_0(
		// .addr	(rom_addr),
		// .data_o	(r_data)
	// );
	rom_1kx32_sim	U_rom_1kx32_sim_0(
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