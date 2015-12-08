// 	version 1.0 --	2015.12.01	
//				-- 	setup

`include "../../global_define.v"

module	pooling_output_interface(
//--input
	clk,
	rst_n,
	feature_idx,
	feature_row,
	data_in,
	input_valid,
//--output
	data_out
);

`include "../../pooling_layer/pooling_param.v"


input		clk;
input		rst_n;
input	[1:0]	feature_idx;
input	[2:0]	feature_row;
input 		input_valid;

input		[`DATA_WIDTH-1:0]	data_in;	
output reg 	[`DATA_WIDTH-1:0]	data_out;

reg		[`DATA_WIDTH-1:0]	buffer [0:TOTAL_FEATURE-1];

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		buffer[0]	<=	`DATA_WIDTH 'b0;
		buffer[1]	<=	`DATA_WIDTH 'b0;
		buffer[2]	<=	`DATA_WIDTH 'b0;
		buffer[3]	<=	`DATA_WIDTH 'b0;
	end
	else if (input_valid) begin
		case(feature_row)
			3'd1, 3'd3, 3'd5: begin
				case (feature_idx)
					2'd0:	buffer[0]	<=	data_in;
					2'd1:	buffer[1]	<=	data_in;
					2'd2:	buffer[2]	<=	data_in;
					2'd3:	buffer[3]	<=	data_in;
				endcase
			end
				
			default: begin
				buffer[0]	<= buffer[0];
				buffer[1]	<= buffer[1];
				buffer[2]	<= buffer[2];
				buffer[3]	<= buffer[3];
			end			
		endcase	
	end
	else begin
		buffer[0]	<= buffer[0];
		buffer[1]	<= buffer[1];
		buffer[2]	<= buffer[2];
		buffer[3]	<= buffer[3];	
	end
end

reg	input_valid_delay_0;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		input_valid_delay_0 <= 0;
	else
		input_valid_delay_0	<= input_valid;
end


always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		data_out	<=	`DATA_WIDTH 'b0;
	else if (input_valid_delay_0) begin
		case(feature_row)
			3'd1, 3'd3, 3'd5: begin
				case(feature_idx)
					2'd0: data_out	<=	buffer[0];
					2'd1: data_out	<=	buffer[1];
					2'd2: data_out	<=	buffer[2];
					2'd3: data_out	<=	buffer[3];
				endcase
			end
			
			default:
				data_out	<=	data_out;
			
		endcase
	end
end

			

`ifdef DEBUG

shortreal buffer_ob[TOTAL_FEATURE];
always @(*) begin
	 buffer_ob[0]	=	$bitstoshortreal(buffer[0]);
	 buffer_ob[1]	=	$bitstoshortreal(buffer[1]);
	 buffer_ob[2]	=	$bitstoshortreal(buffer[2]);
	 buffer_ob[3]	=	$bitstoshortreal(buffer[3]);
end

shortreal data_out_ob;
always @(*) begin
	 data_out_ob	=	$bitstoshortreal(data_out);
end
	 	 
`endif


endmodule


