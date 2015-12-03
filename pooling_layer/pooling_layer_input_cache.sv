//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"

module	pooling_layer_input_cache(
//--input
	clk,
	rst_n,
	kernel_calc_fin,
	data_in,
//--output
	data_out
);

`include "../../pooling_layer/pooling_param.v"

input	clk;
input	rst_n;
input	kernel_calc_fin;

input	[INPUT_SIZE*`DATA_WIDTH-1:0]	data_in;	//	6
output	[OUTPUT_SIZE*`DATA_WIDTH-1-1:0]	data_out;	//	3

reg		[KERNEL_SIZE*`DATA_WIDTH-1:0]	cache_array [0:OUTPUT_SIZE-1];		//	2[3]

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		cache_array[0]	<=	`DATA_WIDTH 'h0;
		cache_array[1]	<= 	`DATA_WIDTH 'h0;
	    cache_array[2]	<=  `DATA_WIDTH 'h0;
	end	
	else if (kernel_calc_fin) begin
		cache_array[0]	<=	data_in[INPUT_SIZE*`DATA_WIDTH-1 -: KERNEL_SIZE*`DATA_WIDTH];
		cache_array[1]	<=	data_in[(INPUT_SIZE-1*KERNEL_SIZE)*`DATA_WIDTH-1 -: KERNEL_SIZE*`DATA_WIDTH];
		cache_array[2]	<=	data_in[(INPUT_SIZE-2*KERNEL_SIZE)*`DATA_WIDTH-1 -: KERNEL_SIZE*`DATA_WIDTH];
	end
	else begin
		cache_array[0]	<=	cache_array[0];
		cache_array[1]	<=  cache_array[1];
		cache_array[2]	<=  cache_array[2];	
	end
end

assign	data_out	=	{cache_array[0],cache_array[1],cache_array[2]};

`ifdef DEBUG

/* shortreal data_in_ob [INPUT_SIZE];
always @(data_in) begin
	data_in_ob[0]	=	$bitstoshortreal(data_in[(INPUT_SIZE-0)*`DATA_WIDTH-1:(INPUT_SIZE-1)*`DATA_WIDTH]);
	data_in_ob[1]	=	$bitstoshortreal(data_in[(INPUT_SIZE-1)*`DATA_WIDTH-1:(INPUT_SIZE-2)*`DATA_WIDTH]);
	data_in_ob[2]	=	$bitstoshortreal(data_in[(INPUT_SIZE-2)*`DATA_WIDTH-1:(INPUT_SIZE-3)*`DATA_WIDTH]);
	data_in_ob[3]	=	$bitstoshortreal(data_in[(INPUT_SIZE-3)*`DATA_WIDTH-1:(INPUT_SIZE-4)*`DATA_WIDTH]);
	data_in_ob[4]	=	$bitstoshortreal(data_in[(INPUT_SIZE-4)*`DATA_WIDTH-1:(INPUT_SIZE-5)*`DATA_WIDTH]);
	data_in_ob[5]	=	$bitstoshortreal(data_in[(INPUT_SIZE-5)*`DATA_WIDTH-1:(INPUT_SIZE-6)*`DATA_WIDTH]);	
end	
 */
shortreal cache_in_ob[INPUT_SIZE];
always @(*) begin
	 cache_in_ob[0]	=	$bitstoshortreal(cache_array[0][(KERNEL_SIZE-0)*`DATA_WIDTH-1:(KERNEL_SIZE-1)*`DATA_WIDTH]);
	 cache_in_ob[1] =	$bitstoshortreal(cache_array[0][(KERNEL_SIZE-1)*`DATA_WIDTH-1:(KERNEL_SIZE-2)*`DATA_WIDTH]);
	 cache_in_ob[2] =	$bitstoshortreal(cache_array[1][(KERNEL_SIZE-0)*`DATA_WIDTH-1:(KERNEL_SIZE-1)*`DATA_WIDTH]);
	 cache_in_ob[3] =	$bitstoshortreal(cache_array[1][(KERNEL_SIZE-1)*`DATA_WIDTH-1:(KERNEL_SIZE-2)*`DATA_WIDTH]);
     cache_in_ob[4] =	$bitstoshortreal(cache_array[2][(KERNEL_SIZE-0)*`DATA_WIDTH-1:(KERNEL_SIZE-1)*`DATA_WIDTH]);
	 cache_in_ob[5] =	$bitstoshortreal(cache_array[2][(KERNEL_SIZE-1)*`DATA_WIDTH-1:(KERNEL_SIZE-2)*`DATA_WIDTH]);
end	 
	 
`endif

endmodule



	


