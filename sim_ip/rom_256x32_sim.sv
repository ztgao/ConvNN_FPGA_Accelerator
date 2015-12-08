// version 1.0 -- setup
// Description:

module	rom_256x32_sim(
	addr,
	data_o
);

parameter 	WIDTH		=	32;
parameter	ADDR_WIDTH	=	8;
parameter	DEPTH		=	256;

input		[ADDR_WIDTH-1:0]	addr;
output reg	[WIDTH-1:0]			data_o;

bit		[WIDTH-1:0]		memory		[0:DEPTH-1];

initial begin
	$readmemb("rom_256x32_fw.mif",memory);
end

always @(addr) begin
	data_o	=	memory[addr];
end

endmodule