// 	version 1.0 --	2015.11.01	
//				-- 	setup
//
// 	version	1.1	--	2015.11.03
//				--	add an extra cycle after "STATE_ROW_2" for each output 
//					port to fix on 1.0 to caculate the bias.
// 
// 	version	1.2 --	2015.11.04
//				--  change the strategy of memory access and the data control
//					will be finished by upper hierarchy.
//
// 	version	1.3	--	2015.11.10
//				--	the state transfer process is not decided by the interface itself
//					it will interact with the upper hierarchy by command and ack signal.
//
// 	Description:
// 	A data buffer for pixel floating point data between DDR3 and conv kernel, 
// 	functioning by a standard FSM
// 	The state transfer:
//	
//	|-- INIT --|-- PRELOAD --|-- SHIFT --|-- BIAS --|-- LOAD --|
//

`include "../../global_define.v"
module conv_layer_input_interface 
#(parameter	KERNEL_SIZE 		= 	3,
			IMAGE_SIZE			=	8,
			ARRAY_SIZE			=	6,
			WEIGHT_ROM_DEPTH	=	64,
			TOTAL_WEIGHT		=	4)
(
// --input
	clk,
	rst_n,
	enable,
	data_in,
	cmd,	
// --output
	ack,
	ext_rom_addr,
	data_out,
	o_weight
);

`include "../../conv_layer/conv_kernel_param.v"

localparam	ARRAY_WIDTH			=	logb2(ARRAY_SIZE);
localparam	BUFFER_ROW_WIDTH	=	logb2(KERNEL_SIZE);
localparam	BUFFER_COL_WIDTH	=	logb2(IMAGE_SIZE);
localparam	WEIGHT_WIDTH		=   logb2(TOTAL_WEIGHT);
localparam	WEIGHT_ADDR_WIDTH	=	logb2(WEIGHT_ROM_DEPTH);



input							clk;
input							rst_n;
input							enable;
input	[`DATA_WIDTH-1:0]		data_in;
input	[1:0]					cmd;

output		[ARRAY_SIZE*`DATA_WIDTH-1:0]	data_out;
output reg	[`EXT_ADDR_WIDTH-1:0] 			ext_rom_addr;
output		[`DATA_WIDTH-1:0]				o_weight;
output reg	[1:0]							ack; 

reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	data_out_reg;

reg		[2:0]				current_state;
reg		[2:0]				next_state;

reg		[BUFFER_ROW_WIDTH-1:0]	shift_idx;
reg		[BUFFER_COL_WIDTH-1:0]	buffer_col_idx;
reg		[BUFFER_ROW_WIDTH-1:0]	buffer_row_idx;

wire	[IMAGE_SIZE*`DATA_WIDTH-1:0]	data_from_buffer;


wire	lastShift;
wire	lastRow;
wire	lastCol;

assign	lastShift	=	(shift_idx == KERNEL_SIZE - 1);
assign	lastRow		=	(buffer_row_idx == KERNEL_SIZE - 1);
assign	lastCol		=	(buffer_col_idx	== IMAGE_SIZE - 1);

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		current_state	<=	STATE_IDLE;
	else begin
		if (enable)
			current_state	<=	next_state;
		else
			current_state	<= 	STATE_IDLE;
	end
end

always @(current_state, buffer_col_idx, shift_idx, cmd) begin
	case (current_state)	
		
//  Caution: whenever add a new state which could run into IDLE, 
//			 you should add a specific exit for this state.	
		STATE_IDLE: 
			if ( cmd == CMD_SHIFT)
				next_state	=	STATE_SHIFT;
			else if ( cmd == CMD_LOAD )
				next_state	=	STATE_LOAD;
			else
				next_state	=	STATE_IDLE;
				
		STATE_SHIFT: 
			if ( lastShift  && lastRow )
				next_state	=	STATE_BIAS;
			else
				next_state	=	STATE_SHIFT;			
		
		STATE_BIAS: 
			if ( cmd == CMD_LOAD )
				next_state 	= 	STATE_LOAD;
			else if (cmd == CMD_SHIFT )
				next_state 	=	STATE_SHIFT;
			else
				next_state	=	STATE_IDLE;
			
		STATE_LOAD: 
			if ( lastCol )
				next_state	=	STATE_IDLE;
			else if ( cmd == CMD_SHIFT )
				next_state	=	STATE_SHIFT;				 
			else
				next_state	=	STATE_LOAD;
		
		default: 
			next_state	=	current_state;
	endcase
end


//	-- ack
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		ack		<=	ACK_IDLE;
		
	else begin
		case (current_state)
			
			STATE_IDLE: 
				ack		<=	ACK_IDLE;
												
			STATE_SHIFT: 
				ack		<=	ACK_IDLE;			
			
			STATE_BIAS: 
				ack		<=	ACK_SHIFT_FIN;
			
			STATE_LOAD: 
				if ( lastCol )
					ack		<=	ACK_LOAD_FIN;
				else
					ack		<=	ACK_IDLE;
			
			default: 
				ack		<=	ACK_IDLE;
	
		endcase
	end
end	
		
//	ext_rom_addr		
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		ext_rom_addr		<=	0;
	else begin
		case (current_state)
			
			STATE_IDLE: 
				ext_rom_addr	<=	ext_rom_addr;
			
			STATE_SHIFT: 
				ext_rom_addr	<=	ext_rom_addr;
			
			STATE_BIAS: 
				ext_rom_addr	<=	ext_rom_addr;
			
			STATE_LOAD: 
				ext_rom_addr	<=	ext_rom_addr + 1'b1;
				
	
				
			default: 
				ext_rom_addr	<=	ext_rom_addr;
				
		endcase
	end
end		
			
//	bit index in each bank
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_col_idx <= 0;
	else begin
		case (current_state)
			
			STATE_IDLE: 
				buffer_col_idx	<=	0;

			STATE_SHIFT, STATE_BIAS: 
				buffer_col_idx	<=	buffer_col_idx;					
												
			STATE_LOAD: 
				if (lastCol)					
					buffer_col_idx	<=	0;
				else
					buffer_col_idx	<=	buffer_col_idx + 1'b1;

			default: 
				buffer_col_idx	<=	buffer_col_idx;
		endcase
	end
end

//	shift index in each cycle is 3 
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		shift_idx			<=	0;
	else begin
		case (current_state)
			
			STATE_IDLE: 
				shift_idx	<=	0;
			
			STATE_SHIFT: 
				if (lastShift)
					shift_idx	<=	0;
				else
					shift_idx	<=	shift_idx + 1'b1;
			
			STATE_BIAS: 
				shift_idx	<=	shift_idx;

			STATE_LOAD: 
				shift_idx	<=	shift_idx;
			
			
			default:
				shift_idx	<=	shift_idx;
		endcase
	end
end
		

// output port behavior

assign	data_out = data_out_reg[IMAGE_SIZE*`DATA_WIDTH-1:(IMAGE_SIZE-ARRAY_SIZE)*`DATA_WIDTH];

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		data_out_reg <=	{IMAGE_SIZE {`DATA_WIDTH 'h0}};
	else begin
		case (current_state)
			
			STATE_IDLE: 
				data_out_reg 	<=	{IMAGE_SIZE {`DATA_WIDTH 'h0}};

			STATE_SHIFT: 
				if (shift_idx == 0) 
					data_out_reg	<=	data_from_buffer;																		
				else 
					data_out_reg[IMAGE_SIZE*`DATA_WIDTH-1:`DATA_WIDTH] <= data_out_reg[(IMAGE_SIZE-1)*`DATA_WIDTH-1:0];
			
			STATE_BIAS: 
				data_out_reg	<=	{IMAGE_SIZE {`FLOAT32_ONE}};
														
			STATE_LOAD: 
				data_out_reg 	<=	{IMAGE_SIZE {`DATA_WIDTH 'h0}};
																																											
			default: 
				data_out_reg	<=	data_out_reg;				
		endcase
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_row_idx <=	0;
	else begin
		case (current_state)
			
			STATE_IDLE: 
				buffer_row_idx <=	0;
						
			STATE_SHIFT: 
				if ( lastShift )
					buffer_row_idx	<=	buffer_row_idx + 1'd1;	
				else
					buffer_row_idx	<=	buffer_row_idx;					
				
			STATE_BIAS: 
				buffer_row_idx <=	0;
														
			STATE_LOAD: 
				buffer_row_idx <=	0;												
				
			default: 
				buffer_row_idx <=	buffer_row_idx;				
			
		endcase
	end
end

conv_layer_input_buffer #(
	.BUFFER_ROW			(KERNEL_SIZE),	
	.BUFFER_COL			(IMAGE_SIZE)
)
U_conv_layer_input_buffer_0(
// --input
	.clk			(clk),
	.rst_n			(rst_n),
	.data_in		(data_in),
	.col_index		(buffer_col_idx),
	.row_index		(buffer_row_idx),
	.current_state	(current_state),
// --output
	.data_out_bus	(data_from_buffer)
);

conv_weight_buffer #(
	.WEIGHT_ROM_DEPTH	(WEIGHT_ROM_DEPTH),
	.TOTAL_WEIGHT		(TOTAL_WEIGHT)
)
U_conv_weight_buffer_0(	
//--input
	.clk			(clk),
	.rst_n			(rst_n),
	.current_state	(current_state),	
//--output
	.o_weight		(o_weight)	
);


`ifdef	DEBUG
//	--	Observe the interface state
always	@(current_state) begin
	case (current_state)
			
			// STATE_INIT: 
				// $display("[%8t ]: Interface initializing.",$time);
									
			STATE_SHIFT: 
				$display("[%8t ]: Begin to load one data from one row of the buffer and shift the convolution window.",$time);
									
			STATE_BIAS: 
				$display("[%8t ]: Add the bias value.",$time);
														
			STATE_LOAD: 
				$display("[%8t ]: Now the buffer will load one row of new data from external mem.",$time);												

			STATE_IDLE: 
				$display("[%8t ]: Cache Idle.",$time);
				
			default: 
				$display("[%8t ]: Cache Abnormal.",$time);				
			
	endcase
end

`endif

endmodule
