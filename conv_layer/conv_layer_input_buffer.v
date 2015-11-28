// 	version 1.0 --	2015.11.27	
//				-- 	setup

`include "../../global_define.v"
`define		BUFFER_LOAD_COUNT_WIDTH		3;

module conv_layer_input_buffer(
// --input
	input			clk,
	input			rst_n,
	input			data_in,
	input			array_idx,
	input			cmd;
	
// --output
	output			ack,
	output			data_out_bus	
);

`include "../conv_layer_param.v"

//	--	data buffer bank
//	----	8 x 32	-----
//	|0 1 2 3 4 5 6 7 	|
//	3					|
//	|					|
//	---------------------

parameter	STATE_INIT					2'd0;
parameter	STATE_LOAD					2'd1;
//parameter	STATE_OUTPUT				2'd2;
parameter	STATE_IDLE					2'd3;

parameter	BUFFER_LOAD_COUNT_END	=	3'd7;	//	INPUT_SIZE	= 8

wire									clk;
wire									rst_n;
wire	[`DATA_WIDTH-1:0]				data_in;
wire	[1:0]							array_idx;

reg		[INPUT_SIZE*`DATA_WIDTH-1:0]	buffer_array_0;		//	8 x 32
reg		[INPUT_SIZE*`DATA_WIDTH-1:0]	buffer_array_1;		//	8 x 32
reg		[INPUT_SIZE*`DATA_WIDTH-1:0]	buffer_array_2;		//	8 x 32

reg		[INPUT_SIZE*`DATA_WIDTH-1:0]	data_out_bus;		//	8 x 32

reg		[`BUFFER_LOAD_COUNT_WIDTH-1:0]	buffer_load_count;	//	[2:0] (0-7)

reg		[2:0]							current_state;
reg		[2:0]							next_state;

wire									ack;

//	--	Buffer Array Index Decoder
always @(array_idx)	begin
	case (array_idx)
		2'd0:	data_out_bus	=	buffer_array_0;
		2'd1:	data_out_bus	=	buffer_array_1;
		2'd2:	data_out_bus	=	buffer_array_2;
		default:
				data_out_bus	=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
	endcase
end

//	--	Buffer State Transfer
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		current_state	<=	STATE_INIT;
	end
	else begin
//		if (enable)
			current_state	<=	next_state;
		// else
			// current_state	<= 	current_state;
	end
end

always @(current_state, buffer_load_count,cmd) begin
		case (current_state)	
		
			STATE_INIT: begin 
				if ( cmd == BUFFER_CMD_IDLE )
					next_state	=	STATE_IDLE;
				else
					next_state	=	STATE_INIT;
			end
														
	//  Caution: whenever add a new state which could go into IDLE, should add the exit for this state.		
			STATE_IDLE: begin
				if ( cmd == BUFFER_CMD_LOAD)
					next_state	=	STATE_LOAD;
				else if ( cmd == BUFFER_CMD_READ )
					next_state	=	STATE_IDLE;
				else
					next_state	=	STATE_IDLE;
			end
			
			STATE_LOAD: begin
				if ( cmd == BUFFER_CMD_READ ) begin
					next_state	=	STATE_IDLE;
				end
				else begin
					if ( buffer_load_count < BUFFER_LOAD_COUNT_END)	//	3'd7
						next_state	=	STATE_LOAD;
					else
						next_state	=	STATE_IDLE;
				end
			end
			
			default: begin
				next_state	=	current_state;
			end
		endcase
//	end
end

//	Buffer Last Array Load Control
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		buffer_load_count <= `BUFFER_LOAD_COUNT_WIDTH 'b0;
	end
	else begin
		case (current_state)
			
			STAGE_INIT: begin
				buffer_load_count <= `BUFFER_LOAD_COUNT_WIDTH 'b0;
			end
						
			STAGE_IDLE: 
				buffer_load_count	<=	buffer_load_count;	

			STAGE_LOAD: begin
				if (buffer_load_count == BUFFER_LOAD_COUNT_END)
					buffer_load_count	<=	`BUFFER_LOAD_COUNT_WIDTH 'b0;
				else
					buffer_load_count	<=	buffer_load_count + 1'b1;
			end				
			
			default: 
				buffer_load_count	<=	buffer_load_count;
				
		endcase
	end
end

assign 	ack = (buffer_load_count == BUFFER_LOAD_COUNT_END)? BUFFER_ACK_LOAD_FIN : 1'b0;

//	--	Buffer Array Operation
//	--	Buffer Array 0
always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		buffer_array_0	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
	else begin
		case ( current_state )
			
			STATE_INIT: 
				buffer_array_0	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
			
			STATE_IDLE:
				buffer_array_0	<=	buffer_array_0;
				
			STATE_LOAD:
				if(buffer_load_count == `BUFFER_LOAD_COUNT_WIDTH 'd0)
					buffer_array_0	<=	buffer_array_1;	
				else
					buffer_array_0	<=	buffer_array_0;
			
			default:
				buffer_array_0	<=	buffer_array_0;
				
		endcase
	end
end

//	--	Buffer Array 1
always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		buffer_array_1	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
	else begin
		case ( current_state )
			
			STATE_INIT: 
				buffer_array_1	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
			
			STATE_IDLE:
				buffer_array_1	<=	buffer_array_1;
				
			STATE_LOAD:
				if(buffer_load_count == `BUFFER_LOAD_COUNT_WIDTH 'd0)
					buffer_array_1	<=	buffer_array_2;	
				else
					buffer_array_1	<=	buffer_array_1;
			
			default:
				buffer_array_1	<=	buffer_array_1;
				
		endcase
	end
end

//	--	The Last Buffer Array
always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		buffer_array_2	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
	else begin
		case ( current_state )
			
			STATE_INIT: 
				buffer_array_2	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
			
			STATE_IDLE:
				buffer_array_2	<=	buffer_array_2;
				
			STATE_LOAD: begin
				if ( buffer_load_count < BUFFER_LOAD_COUNT_END) begin
					buffer_array_2[INPUT_SIZE*`DATA_WIDTH-1:`DATA_WIDTH] <=	buffer_array_2[(INPUT_SIZE-1)*`DATA_WIDTH-1:0];
					buffer_array_2[`DATA_WIDTH-1:0]	<=	data_in;
				end
				else
					buffer_array_2	<=	buffer_array_2;
			end
			
			default:
				buffer_array_0	<=	buffer_array_0;				
		endcase
	end
end
				
endmodule			

				
		
