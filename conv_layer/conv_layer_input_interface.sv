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
module conv_layer_input_interface(	
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
reg		[BUFFER_COL_WIDTH-1:0]	buffer_col_index;
reg		[BUFFER_ROW_WIDTH-1:0]	buffer_row_index;
reg		[BUFFER_ROW_WIDTH-1:0]	preload_cycle;

wire	[IMAGE_SIZE*`DATA_WIDTH-1:0]	data_from_buffer;


wire	shift_end;
wire	row_end;	

//	todo list
//	1. abstract the signal




always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		current_state	<=	STATE_INIT;
	else begin
		if (enable)
			current_state	<=	next_state;
		else
			current_state	<= 	current_state;
	end
end

always @(current_state, buffer_col_index, shift_idx, preload_cycle,cmd) begin
	case (current_state)	
		
		STATE_INIT: begin 
			if ( cmd == CMD_PRELOAD )
				next_state	=	STATE_PRELOAD;
			else
				next_state	=	STATE_INIT;
		end
		
		STATE_PRELOAD: 
			if ( cmd == CMD_SHIFT ) 
				next_state	=	STATE_SHIFT;
			else begin
				if ( preload_cycle == BUFFER_ROW - 1 && buffer_col_index == BUFFER_COL - 1)
					next_state	=	STATE_IDLE;
				else
					next_state	=	STATE_PRELOAD;				
			end
		
		STATE_SHIFT: 
			if (shift_idx	== 	KERNEL_SIZE - 1  && buffer_row_index == BUFFER_ROW - 1)
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
			if ( buffer_col_index == BUFFER_COL - 1 )
				next_state	=	STATE_IDLE;
			else if ( cmd == CMD_SHIFT )
				next_state	=	STATE_SHIFT;				 
			else
				next_state	=	STATE_LOAD;
				
//  Caution: whenever add a new state which could run into IDLE, 
//			 you should add a specific exit for this state.		
		STATE_IDLE: 
			if ( cmd == CMD_SHIFT)
				next_state	=	STATE_SHIFT;
			else if ( cmd == CMD_LOAD )
				next_state	=	STATE_LOAD;
			else if ( cmd == CMD_PRELOAD)
				next_state	=	STATE_PRELOAD;
			else
				next_state	=	STATE_IDLE;
		
		default: 
			next_state	=	current_state;
	endcase
end

// always @(posedge clk, negedge rst_n) begin
	// if(!rst_n)
		// preload_cycle		<=	0;
		
	// else if (current_state == STATE_PRELOAD) 
		// if (buffer_col_index == BUFFER_COL - 1)			//	finish one row
			// if (preload_cycle	==	BUFFER_ROW - 1)
				// preload_cycle	<=	2'b0;
			// else		
				// preload_cycle	<=	preload_cycle + 1'b1;
		// else
			// preload_cycle	<=	preload_cycle;		
	// else
		// preload_cycle 	<=	preload_cycle;
// end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		preload_cycle		<=	0;	
	else begin
		case (current_state)
		
			STATE_INIT: 
				preload_cycle	<=	0;
						
			STATE_PRELOAD: 
				if (buffer_col_index == BUFFER_COL - 1)	
					if ( preload_cycle == BUFFER_ROW - 1)
						preload_cycle	<=	preload_cycle;
					else
						preload_cycle	<=	preload_cycle + 1'b1;
				else
					preload_cycle	<=	preload_cycle;
						
			STATE_SHIFT: 
				preload_cycle	<=	0;			
			
			STATE_BIAS: 
				preload_cycle	<=	0;
			
			STATE_LOAD: 
				preload_cycle	<=	0;
			
			STATE_IDLE: 
				preload_cycle	<=	0;
				
			default: 
				preload_cycle	<=	preload_cycle;
	
		endcase
	end
end	



//	-- ack
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		ack		<=	ACK_IDLE;
		
	else begin
		case (current_state)
			
			STATE_INIT: 
				ack	<=	ACK_IDLE;
						
			STATE_PRELOAD: 
				if (buffer_col_index == BUFFER_COL - 1)	
					if ( preload_cycle == BUFFER_ROW - 1)
						ack	<=	ACK_PRELOAD_FIN;
					else
						ack	<=	ACK_IDLE;
				else
					ack	<=	ACK_IDLE;
						
			STATE_SHIFT: 
				ack		<=	ACK_IDLE;			
			
			STATE_BIAS: 
				ack		<=	ACK_SHIFT_FIN;
			
			STATE_LOAD: 
				if (buffer_col_index == BUFFER_COL - 1 )			
					ack		<=	ACK_LOAD_FIN;
				else
					ack		<=	ACK_IDLE;
			
			STATE_IDLE: 
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
			
			STATE_INIT: 
				ext_rom_addr	<=	0;
			
			STATE_PRELOAD: 
				if (buffer_col_index < BUFFER_COL)
					ext_rom_addr	<=	ext_rom_addr + 1'b1;
				else
					ext_rom_addr	<=	ext_rom_addr;
			
			STATE_SHIFT: 
				ext_rom_addr	<=	ext_rom_addr;
			
			STATE_BIAS: 
				ext_rom_addr	<=	ext_rom_addr;
			
			STATE_LOAD: 
				ext_rom_addr	<=	ext_rom_addr + 1'b1;
				
			STATE_IDLE: 
				ext_rom_addr	<=	ext_rom_addr;	
				
			default: 
				ext_rom_addr	<=	ext_rom_addr;
				
		endcase
	end
end		
			
//	bit index in each bank
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_col_index <= 0;
	else begin
		case (current_state)
			
			STATE_INIT: 
				buffer_col_index	<=	0;
			
			STATE_PRELOAD: 
				if (buffer_col_index == BUFFER_COL - 1 && preload_cycle == BUFFER_ROW - 1)
					buffer_col_index	<=	0;
				else if (buffer_col_index == BUFFER_COL)
					buffer_col_index	<=	0;
				else
					buffer_col_index	<=	buffer_col_index + 1'b1;
			
			STATE_SHIFT, STATE_BIAS, STATE_IDLE: 
				buffer_col_index	<=	buffer_col_index;					
						
						
			STATE_LOAD: 
				if (buffer_col_index == BUFFER_COL - 1)
					buffer_col_index	<=	0;
				else
					buffer_col_index	<=	buffer_col_index + 1'b1;

			default: 
				buffer_col_index	<=	buffer_col_index;
		endcase
	end
end

//	shift index in each cycle is 3 
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		shift_idx			<=	0;
	else begin
		case (current_state)
			
			STATE_INIT: 
				shift_idx	<=	0;
			
			STATE_PRELOAD: 
				shift_idx	<=	0;
			
			STATE_SHIFT: 
				if (shift_idx == BUFFER_ROW - 1)
					shift_idx	<=	0;
				else
					shift_idx	<=	shift_idx + 1'b1;
			
			STATE_BIAS: 
				shift_idx	<=	shift_idx;

			STATE_LOAD: 
				shift_idx	<=	shift_idx;
			
			STATE_IDLE: 
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
			
			STATE_INIT: 
				data_out_reg 	<=	{IMAGE_SIZE {`DATA_WIDTH 'h0}};
					
			STATE_PRELOAD: 
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
												
			STATE_IDLE: 
				data_out_reg 	<=	{IMAGE_SIZE {`DATA_WIDTH 'h0}};
																															
			default: 
				data_out_reg	<=	data_out_reg;				
		endcase
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_row_index <=	0;
	else begin
		case (current_state)
			
			STATE_INIT: 
				buffer_row_index <=	0;
						
			STATE_PRELOAD: 
				buffer_row_index <=	0;
						
			STATE_SHIFT: 
				if( shift_idx == BUFFER_ROW - 1 )
					buffer_row_index	<=	buffer_row_index + 1'd1;	
				else
					buffer_row_index	<=	buffer_row_index;					
				
			STATE_BIAS: 
				buffer_row_index <=	0;
														
			STATE_LOAD: 
				buffer_row_index <=	0;												

			STATE_IDLE: 
				buffer_row_index <=	buffer_row_index;
				
			default: 
				buffer_row_index <=	buffer_row_index;				
			
		endcase
	end
end

conv_layer_input_buffer U_conv_layer_input_buffer_0(
// --input
	.clk			(clk),
	.rst_n			(rst_n),
	.data_in		(data_in),
	.col_index		(buffer_col_index),
	.row_index		(buffer_row_index),
	.preload_cycle	(preload_cycle),
	.current_state	(current_state),
// --output
	.data_out_bus	(data_from_buffer)
);

conv_weight_buffer U_conv_weight_buffer_0(	
//--input
	.clk			(clk),
	.rst_n			(rst_n),
	.current_state	(current_state),	
//--output
	.o_weight		(o_weight)	
);


`ifdef	DEBUG
//	--	Observe the interface state
always	@(current_state, preload_cycle) begin
	case (current_state)
			
			STATE_INIT: begin
				$display("[%8t ]: Interface initializing.",$time);
			end
			
			STATE_PRELOAD: begin
				if(preload_cycle == 2'd0)
					$display("[%8t ]: Now the buffer will drop all the previous data and refresh to new data.",$time);	
				else
					$display("[%8t ]: Complete loading array [ %2d ].",$time, preload_cycle - 1);
			end
			
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
