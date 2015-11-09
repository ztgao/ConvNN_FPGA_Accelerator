`timescale 1ns/1ns
module tb_floating_ip;

reg 			clk;
reg 	[31:0]	input_a;
reg 	[31:0]	input_b;

real	num_a;

wire	[31:0]	sum;
wire	[31:0]	product;

always
	#5 clk = ~clk;
	
initial begin
	clk 	=	0;
	input_a	=	0;
	input_b	=	0;
	num_a	=	3.14;
	
	#30
	input_a	=	32'h40200000;	//	100.0
	input_b	=	32'h42C80000;	//	2.5
	#30
	input_a	=	32'h44034000;	//	525.0
	input_b	=	32'h41B28007;	//	22.3125
	#30
	input_a	=	32'h40200000;	//	100.0
	input_b	=	32'h42C80000;	//	2.5
	#30
	input_a	=	32'h44034000;	//	525.0
	input_b	=	32'h41B28007;	//	22.3125
	#30
	input_a	=	32'h40200000;	//	100.0
	input_b	=	32'h42C80000;	//	2.5
	#30
	input_a	=	32'h44034000;	//	525.0
	input_b	=	32'h41B28007;	//	22.3125	
		
	
	
	#500
	$stop;
end

floating_adder U_floating_adder (
//  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(input_a),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_a_tlast(),              // input wire s_axis_a_tlast
  .s_axis_b_tvalid(),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(input_b),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(sum),    // output wire [31 : 0] m_axis_result_tdata
  .m_axis_result_tlast()    // output wire m_axis_result_tlast
);


floating_mult U_floating_mult (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(input_a),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(input_b),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(product)    // output wire [31 : 0] m_axis_result_tdata
);

endmodule
