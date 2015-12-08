//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"

module	pooling_input_interface(
//--input
	clk,
	rst_n,
	input_valid,
	block_idx,
	data_in,
//--output
	data_out
);

`include "../../pooling_layer/pooling_param.v"

input	clk;
input	rst_n;
input	input_valid;

input	[2:0]	block_idx;




input		[KERNEL_SIZE*`DATA_WIDTH-1:0]	data_in;	//	6
output 		[`DATA_WIDTH-1:0]	data_out;	//	3

reg			[`DATA_WIDTH-1:0]	buffer_0 [0:KERNEL_SIZE-1];		//	2[3] 32x2

// reg			[`DATA_WIDTH-1:0]	buffer_0 [0:KERNEL_SIZE*KERNEL_SIZE-1];
// reg			[`DATA_WIDTH-1:0]	buffer_1 [0:KERNEL_SIZE*KERNEL_SIZE-1];
// reg			[`DATA_WIDTH-1:0]	buffer_2 [0:KERNEL_SIZE*KERNEL_SIZE-1];
// reg			[`DATA_WIDTH-1:0]	buffer_3 [0:KERNEL_SIZE*KERNEL_SIZE-1];


//reg			[3:0]


// always @(posedge clk, negedge rst_n) begin
	// if(!rst_n) begin
		// {buffer_0[0],buffer_0[1],buffer_0[2],buffer_0[3]}	<=	KERNEL_SIZE*KERNEL_SIZE*`DATA_WIDTH 'h0;
	// end	
	// else if (input_valid) begin
		// {buffer_0[0],buffer_0[1]}	<=	data_in;
	// end
	// else begin
		// buffer_0[0]	<=	buffer_0[1];
		// buffer_0[1]	<=  `DATA_WIDTH 'b0;
	// end
// end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		{buffer_0[0],buffer_0[1]}	<=	KERNEL_SIZE*`DATA_WIDTH 'h0;
	end	
	else if (input_valid) begin
		{buffer_0[0],buffer_0[1]}	<=	data_in;
	end
	else begin
		buffer_0[0]	<=	buffer_0[1];
		buffer_0[1]	<=  `DATA_WIDTH 'b0;
	end
end

assign	data_out	=	buffer_0[0];


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
shortreal buffer_0_ob[KERNEL_SIZE];
always @(*) begin
	 buffer_0_ob[0]=	$bitstoshortreal(buffer_0[0]);
	 buffer_0_ob[1] =	$bitstoshortreal(buffer_0[1]);
	 // buffer_0_in_ob[2] =	$bitstoshortreal(buffer_0[1][(KERNEL_SIZE-0)*`DATA_WIDTH-1:(KERNEL_SIZE-1)*`DATA_WIDTH]);
	 // buffer_0_in_ob[3] =	$bitstoshortreal(buffer_0[1][(KERNEL_SIZE-1)*`DATA_WIDTH-1:(KERNEL_SIZE-2)*`DATA_WIDTH]);
     // buffer_0_in_ob[4] =	$bitstoshortreal(buffer_0[2][(KERNEL_SIZE-0)*`DATA_WIDTH-1:(KERNEL_SIZE-1)*`DATA_WIDTH]);
	 // buffer_0_in_ob[5] =	$bitstoshortreal(buffer_0[2][(KERNEL_SIZE-1)*`DATA_WIDTH-1:(KERNEL_SIZE-2)*`DATA_WIDTH]);
end	 
	 
`endif

endmodule



	


