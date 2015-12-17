// 	version 1.0 --	2015.12.16	
//				-- 	setup

module	pingpong_buffer(






);











ram_4kx32_sim U_ram_bank_0(
//--input
	.clk	(clk),
	.data_i	(data_i),
	.addr	(addr),
	.we		(we),
//--output  
	.data_o (data_o)
);

ram_4kx32_sim U_ram_bank_1(
//--input
	.clk	(clk),
	.data_i	(data_i),
	.addr	(addr),
	.we		(we),
//--output  
	.data_o (data_o)
);