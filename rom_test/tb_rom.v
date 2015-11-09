`timescale 1ns/1ns

module tb_rom;

parameter	ADDR_WIDTH		=	6;
parameter	ROM_DEPTH		=	64;
parameter	DATA_WIDTH		=	32;

reg								clk;
reg			[ADDR_WIDTH-1:0]	addr;
wire		[DATA_WIDTH-1:0]	data;

always 
	#5	clk		=	~clk;

	
initial	begin
	clk		=	0;
	addr	=	6'b0;
	#10
	addr	=	addr	+	6'b1;
	#10
	addr	=	addr	+	6'b1;
	#10
	addr	=	addr	+	6'b1;
	#10
	addr	=	addr	+	6'b1;
	#10
	addr	=	addr	+	6'b1;
	#10
	addr	=	6'd25;	
	#50
	$stop;
	
end


rom_64x32 U_rom_1 (
  .a(addr),      // input wire [5 : 0] a
  .spo(data)  // output wire [31 : 0] spo
);

endmodule