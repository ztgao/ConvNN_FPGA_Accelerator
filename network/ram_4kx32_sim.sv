// version 1.0 -- setup
// Description:

module	ram_4kx32_sim(
//--input
	clk,
	data_i,
	addr,
	we,
//--output
	data_o
);

parameter	DEPTH		=	4096;
parameter	ADDR_WIDTH	=	12;
parameter	WIDTH		=	32;

input	clk;
input	[WIDTH-1:0]			data_i;
input	[ADDR_WIDTH-1:0]	addr;
input						we;

output	logic [WIDTH-1:0]			data_o;

logic	[WIDTH-1:0]	mem	[0:DEPTH-1];
shortreal	mem_ob	[4096];


always @(posedge clk) begin
	if(we) begin
		mem[addr]	<=	data_i;
		mem_ob[addr] = $bitstoshortreal(data_i);
	end
end

always @(posedge clk) begin
	data_o	=	mem[addr];
end


endmodule


