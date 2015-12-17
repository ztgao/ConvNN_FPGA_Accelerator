`timescale 1ns/1ns
module tb_ram;

parameter	RAM_DEPTH = 4096;

bit				clk;
bit		[11:0]	addr;
bit		[31:0]	data_i;
bit				we;
bit		[31:0]	data_o;

always
	#5	clk = ~clk;
	
initial begin
	clk		=	0;
	addr	=	'd0;
	data_i	=	'd0;
	we		=	0;

	#10
	//for (int i = 0; i < RAM_DEPTH;i++) begin
	we		=	1;
	addr	=	'd5;
	data_i	=	'd233;
	
	#10
	we		=	0;
	#25
	addr	=	'd7;
	
	#100
	$stop;
end
	
// ram_3kx32 U_ram_3kx32 (
  // .a(addr),      // input wire [11 : 0] a
  // .d(data_i),      // input wire [31 : 0] d
  // .clk(clk),  // input wire clk
  // .we(we),    // input wire we
  // .spo(data_o)  // output wire [31 : 0] spo
// );

ram_4kx32_sim U_ram_4kx32_sim_0(
//--input
	.clk	(clk),
	.data_i	(data_i),
	.addr	(addr),
	.we		(we),
//--output  
	.data_o (data_o)
);



endmodule