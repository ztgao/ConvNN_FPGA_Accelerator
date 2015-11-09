// version 1.0 -- setup
module conv_kernel(
	clk,
	rst_n,
	i_pixel,
	i_weight,
	o_pixel
);

parameter	WIDTH	=	32;


input					clk;
input					rst_n;
input	[WIDTH-1:0]		i_pixel;
input	[WIDTH-1:0]		i_weight;

output	[WIDTH-1:0]		o_pixel;

reg		[WIDTH-1:0]		o_pixel;
//reg		[WIDTH-1:0]		o_pixel_reg;

reg		[WIDTH-1:0]		mult_a;
reg		[WIDTH-1:0]		mult_b;
wire	[WIDTH-1:0]		product;

reg		[WIDTH-1:0]		add_a;
reg		[WIDTH-1:0]		add_b;
wire	[WIDTH-1:0]		sum;

always @(posedge clk, negedge rst_n)	begin
	if(!rst_n) begin
		mult_a		<=	32'b0;
		mult_b		<=	32'b0;
	end
	else begin
		mult_a		<=	i_pixel;
		mult_b		<=	i_weight;
	end
end

always @(posedge clk, negedge rst_n)	begin
	if(!rst_n) begin
		add_a		<=	32'b0;
		add_b		<=	32'b0;
	end
	else begin
		add_a		<=	product;
		add_b		<=	sum;
	end
end

always @(posedge clk, negedge rst_n)	begin
	if(!rst_n) begin
		o_pixel		<=	32'b0;
//		o_pixel_reg	<=	32'b0;
	end
	else begin
		o_pixel		<=	sum;
//		o_pixel_reg	<=	sum;
	end
end

floating_adder U_floating_adder (
//  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(add_a),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_a_tlast(),              // input wire s_axis_a_tlast
  .s_axis_b_tvalid(),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(add_b),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(sum),    // output wire [31 : 0] m_axis_result_tdata
  .m_axis_result_tlast()    // output wire m_axis_result_tlast
);


floating_mult U_floating_mult (
//  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(mult_a),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(mult_b),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(product)    // output wire [31 : 0] m_axis_result_tdata
);

endmodule