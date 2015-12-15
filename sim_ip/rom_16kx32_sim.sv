// version 1.0 -- setup
// Description:

module	rom_16kx32_sim(
	addr,
	data_o
);

parameter 	WIDTH		=	32;
parameter	ADDR_WIDTH	=	14;
parameter	DEPTH		=	16384;

input		[ADDR_WIDTH-1:0]	addr;
output reg	[WIDTH-1:0]			data_o;

bit			[WIDTH-1:0]		memory		[0:DEPTH-1];

initial begin
	$readmemb("rom_16kx32.mif",memory);
end

always @(addr) begin
	data_o	=	memory[addr];
end

endmodule