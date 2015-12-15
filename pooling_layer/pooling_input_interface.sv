//	version	1.0	--	setup
//	Description:

`include "../../global_define.v"

module	pooling_input_interface #(
	parameter
	INPUT_SIZE	=	6,
	KERNEL_SIZE	=	2)
(
//--input
	clk,
	rst_n,
	input_valid,
	data_in,
//--output
	data_out
);

`include "../../pooling_layer/pooling_param.v"

localparam	ROW_WIDTH 	= 	logb2(INPUT_SIZE);

input		clk;
input		rst_n;
input		input_valid;


input		[KERNEL_SIZE*`DATA_WIDTH-1:0]	data_in;	//	6
output 		[`DATA_WIDTH-1:0]	data_out;	//	3

reg			[`DATA_WIDTH-1:0]	buffer_0 [0:KERNEL_SIZE-1];		//	2[3] 32x2


genvar	gvBufIdx;
generate
	for(gvBufIdx = 0; gvBufIdx < KERNEL_SIZE-1; gvBufIdx = gvBufIdx + 1)
	begin: genBuf
	////////////////////////////////////////////
		always @(posedge clk, negedge rst_n) begin
			if(!rst_n) 
				buffer_0[gvBufIdx]	<=	`DATA_WIDTH 'h0;	
			else if (input_valid) 
				buffer_0[gvBufIdx]	<=	data_in[(KERNEL_SIZE-gvBufIdx)*`DATA_WIDTH-1 -: `DATA_WIDTH];
			else
				buffer_0[gvBufIdx]	<=	buffer_0[gvBufIdx+1];
		end
	////////////////////////////////////////////	
	end
endgenerate

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_0[KERNEL_SIZE-1]	<=	`DATA_WIDTH 'h0;	
	else if (input_valid) 
		buffer_0[KERNEL_SIZE-1]	<=	data_in[`DATA_WIDTH-1:0];
	else 
		buffer_0[KERNEL_SIZE-1]	<=  `DATA_WIDTH 'b0;
end


// always @(posedge clk, negedge rst_n) begin
	// if(!rst_n) begin
		// {buffer_0[0],buffer_0[1]}	<=	KERNEL_SIZE*`DATA_WIDTH 'h0;
	// end	
	// else if (input_valid) begin
		// {buffer_0[0],buffer_0[1]}	<=	data_in;
	// end
	// else begin
		// buffer_0[0]	<=	buffer_0[1];
		// buffer_0[1]	<=  `DATA_WIDTH 'b0;
	// end
// end

assign	data_out	=	buffer_0[0];

`ifdef DEBUG

shortreal buffer_0_ob[KERNEL_SIZE];
always @(*) begin
	for (int i = 0;i < KERNEL_SIZE; i = i + 1)
		buffer_0_ob[i] = $bitstoshortreal(buffer_0[i]);
end	 
	 
`endif

endmodule



	


