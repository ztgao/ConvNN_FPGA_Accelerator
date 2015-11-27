// 	version 1.0 --	2015.11.27	
//				-- 	setup

`include "../../global_define.v"

module conv_layer_input_buffer(
// --input
	input	clk,
	input	rst_n,
	input	data_in,
	input	buffer_array_idx;
	input	buffer_cmd;
	
// --output
	output	buffer_ack;
	output	data_out_bus	
);

`include "../conv_layer_param.v"

//	--	data buffer bank
//	----	8 x 32	-----
//	|0 1 2 3 4 5 6 7 8	|
//	3					|
//	|					|
//	---------------------

parameter	BUFFER_CMD_IDLE		2'd0;
parameter	BUFFER_CMD_LOAD		2'd1;
parameter	BUFFER_CMD_READ		2'd2;

parameter	BUFFER_ACK_LOAD_FIN

parameter	STATE_INIT			2'd0;
parameter	STATE_LOAD			2'd1;
//parameter	STATE_OUTPUT		2'd2;
parameter	STATE_IDLE			2'd3;

wire									clk;
wire									rst_n;
wire	[`DATA_WIDTH-1:0]				data_in;
wire	[1:0]							array_idx;

reg		[INPUT_SIZE*`DATA_WIDTH-1:0]	buffer_array_0;		//	8 x 32
reg		[INPUT_SIZE*`DATA_WIDTH-1:0]	buffer_array_1;		//	8 x 32
reg		[INPUT_SIZE*`DATA_WIDTH-1:0]	buffer_array_2;		//	8 x 32

reg		[INPUT_SIZE*`DATA_WIDTH-1:0]	data_out_bus;		//	8 x 32

reg		[BUFFER_LOAD_COUNT_WIDTH-1:0]	buffer_load_count;	//	[2:0] (0-7)

reg		[2:0]							current_state;
reg		[2:0]							next_state;

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
					next_state	=	STATE_OUTPUT;
				else
					next_state	=	STATE_INIT;
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
											
	//  Caution: whenever add a new state which could go into IDLE, should add the exit for this state.		
			STATE_IDLE: begin
				if ( cmd == BUFFER_CMD_LOAD)
					next_state	=	STATE_LOAD;
				else if ( cmd == BUFFER_CMD_READ )
					next_state	=	STATE_IDLE;
				else
					next_state	=	STATE_IDLE;
			end
			
			default: begin
				next_state	=	current_state;
			end
		endcase
//	end
end

//	--	Buffer Array Operation
always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		buffer_array_0	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
	else begin
		case ( buffer_cmd )
			
			BUFFER_CMD_INIT: 
				buffer_array_0	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
			
			BUFFER_CMD_LOAD:
				buffer_array_0	<=	
/*
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		buffer_array_0	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};	// 8 x 32'b0
	else begin
		case (buffer_cmd)
			
			:
				buffer_array_0	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};	// 8 x 32'b0
			
			STATE_PRELOAD:
				if (preload_cycle < 2'd3) begin
					if (read_index == 5'd8) begin
						buffer_array_0	<=	buffer_array_1;
					end
					else begin
						buffer_array_0	<=	buffer_array_0;
					end
				end
			
			STATE_ROW_0: begin
				buffer_array_0	<=	buffer_array_0;
			end
				
			STATE_ROW_1: begin
				buffer_array_0	<=	buffer_array_0;
			end
			
			STATE_ROW_2: begin
				buffer_array_0	<=	buffer_array_0;	
			end
			
			STATE_BIAS: begin
				buffer_array_0	<=	buffer_array_0;
			end

			STATE_LOAD: begin
				if (read_index == 5'b0) begin
					buffer_array_0	<=	buffer_array_1;
				end
				else begin
					buffer_array_0	<=	buffer_array_0;
				end
			end

			STATE_IDLE: begin
				buffer_array_0	<=	buffer_array_0;
			end			
						
			default: begin
				buffer_array_0	<=	buffer_array_0;
			end
		endcase
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		buffer_array_1	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};	// 8 x 32'b0
	else begin
		case (current_state)
			
			STATE_INIT:
				buffer_array_1	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};	// 8 x 32'b0
			
			STATE_PRELOAD:
				if (preload_cycle < 2'd3) begin
					if (read_index == 5'd8) begin
						buffer_array_1	<=	buffer_array_1;
					end
					else begin
						buffer_array_1	<=	buffer_array_2;
					end
				end
			
			STATE_ROW_0: begin
				buffer_array_1	<=	buffer_array_1;
			end
				
			STATE_ROW_1: begin
				buffer_array_1	<=	buffer_array_1;
			end
			
			STATE_ROW_2: begin
				buffer_array_1	<=	buffer_array_1;	
			end
			
			STATE_BIAS: begin
				buffer_array_1	<=	buffer_array_1;
			end

			STATE_LOAD: begin
				if (read_index == 5'b0) begin
					buffer_array_1	<=	buffer_array_2;
				end
				else begin
					buffer_array_1	<=	buffer_array_1;
				end
			end

			STATE_IDLE: begin
				buffer_array_1	<=	buffer_array_1;
			end			
						
			default: begin
				buffer_array_1	<=	buffer_array_1;
			end
		endcase
	end
end

//	cache bank 2 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		buffer_array_2	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};	// 8 x 32'b0
	end
	else begin
		case (current_state)
			
			STATE_INIT: begin
				buffer_array_2	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};	// 8 x 32'b0
			end

			STATE_PRELOAD: begin
				case (read_index)
					5'd0: 	cache_array_2_0	<=	pixel_in;
					5'd1: 	cache_array_2_1	<=	pixel_in;
					5'd2: 	cache_array_2_2	<=	pixel_in;
					5'd3: 	cache_array_2_3	<=	pixel_in;
					5'd4: 	cache_array_2_4	<=	pixel_in;
					5'd5: 	cache_array_2_5	<=	pixel_in;
					5'd6: 	cache_array_2_6	<=	pixel_in;
					5'd7: 	cache_array_2_7	<=	pixel_in;
					default: begin      
						buffer_array_2	<=	buffer_array_2;	// 8 x 32'b0
					end
				endcase
			end			
			
			STATE_ROW_0: begin  
				buffer_array_2	<=	buffer_array_2;	// 8 x 32'b0
			end
			
			STATE_ROW_1: begin     
				buffer_array_2	<=	buffer_array_2;	// 8 x 32'b0
		
			end
			
			STATE_ROW_2: begin
				buffer_array_2	<=	buffer_array_2;	// 8 x 32'b0
		
			end

			STATE_BIAS: begin
				buffer_array_2	<=	buffer_array_2;	// 8 x 32'b0
	
			end

			STATE_LOAD: begin
				case (read_index)
					5'd0: 	cache_array_2_0	<=	pixel_in;
					5'd1: 	cache_array_2_1	<=	pixel_in;
					5'd2: 	cache_array_2_2	<=	pixel_in;
					5'd3: 	cache_array_2_3	<=	pixel_in;
					5'd4: 	cache_array_2_4	<=	pixel_in;
					5'd5: 	cache_array_2_5	<=	pixel_in;
					5'd6: 	cache_array_2_6	<=	pixel_in;
					5'd7: 	cache_array_2_7	<=	pixel_in;
					default: begin      
						buffer_array_2	<=	buffer_array_2;	// 8 x 32'b0
					end
				endcase
			end

			STATE_IDLE: begin
				buffer_array_2	<=	buffer_array_2;	// 8 x 32'b0
			end			
		
			default: begin
				buffer_array_2	<=	buffer_array_2;	// 8 x 32'b0
			end
		endcase
	end
end

// output port behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		out_kernel_port_reg <=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
	end
	else begin
		case (current_state)
			
			STATE_INIT: begin
				out_kernel_port_reg <=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
			end
			
			STATE_PRELOAD: begin
				out_kernel_port_reg <=	{ INPUT_SIZE {`DATA_WIDTH 'h0}};
			end
			
			STATE_ROW_0: begin
				if (shift_idx == 2'b00) begin
					out_kernel_port_reg	<=	{ 	cache_array_0_0,
												cache_array_0_1,
												cache_array_0_2,
												cache_array_0_3,
												cache_array_0_4,
												cache_array_0_5,
												cache_array_0_6,
												cache_array_0_7									  
											};							
				end
				else begin
					out_kernel_port_reg[IMAGE_SIZE*WIDTH-1:WIDTH] <= out_kernel_port_reg[(IMAGE_SIZE-1)*WIDTH-1:0];
				end
			end
			
			STATE_ROW_1: begin
				if (shift_idx == 2'b00) begin
					out_kernel_port_reg	<=	{ 	cache_array_1_0,
												cache_array_1_1,
												cache_array_1_2,
												cache_array_1_3,
												cache_array_1_4,
												cache_array_1_5,
												cache_array_1_6,
												cache_array_1_7									  
											};							
				end
				else begin
					out_kernel_port_reg[IMAGE_SIZE*WIDTH-1:WIDTH] <= out_kernel_port_reg[(IMAGE_SIZE-1)*WIDTH-1:0];
				end
			end
			
			STATE_ROW_2: begin
				if (shift_idx == 2'b00) begin
					out_kernel_port_reg	<=	{ 	cache_array_2_0,
												cache_array_2_1,
												cache_array_2_2,
												cache_array_2_3,
												cache_array_2_4,
												cache_array_2_5,
												cache_array_2_6,
												cache_array_2_7									  
											};							
				end
				else begin
					out_kernel_port_reg[IMAGE_SIZE*WIDTH-1:WIDTH] <= out_kernel_port_reg[(IMAGE_SIZE-1)*WIDTH-1:0];
				end
			end	

			STATE_BIAS: begin
					out_kernel_port_reg	<=	{ 	FLOAT32_ONE,
												FLOAT32_ONE,
												FLOAT32_ONE,
												FLOAT32_ONE,
												FLOAT32_ONE,
												FLOAT32_ONE,
												FLOAT32_ONE,
												FLOAT32_ONE									  
											};
			end
											
			STATE_LOAD: begin
					out_kernel_port_reg	<=	{	32'b0,
												32'b0,
												32'b0,
												32'b0,
												32'b0,
												32'b0,
												32'b0,
												32'b0
											};
			end									

			STATE_IDLE: begin
					out_kernel_port_reg	<=	{	32'b0,
												32'b0,
												32'b0,
												32'b0,
												32'b0,
												32'b0,
												32'b0,
												32'b0
											};
																						
			end							
		
			default: begin
				out_kernel_port_reg	<=	out_kernel_port_reg;				
			end
		endcase
	end
end

*/

				
		
