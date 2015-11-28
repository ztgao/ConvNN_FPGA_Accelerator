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
//	version 2.0	--	2015.11.28
//				--	rewrite all the architecture, separate more bottom behaviors from 
//					the interface
//
// Description:
// A data cache for pixel floating point data between DDR3 and conv kernel, 
// functioning by a standard FSM
// The state transfer:
//	
//	|-- INIT --|-- PRELOAD --|-- SHIFT 0 1 2... --|-- BIAS --|-- LOAD --|
//
`include "../../global_define.v"
module conv_layer_input_interface(	
// --input
	input	clk,
	input	rst_n,
	input	enable,
	input	data_in,
	input	cmd,
	input	ack,
	
// --output
	output	current_state,
	output	data_out_port
);

`include "../conv_layer_param.v"

parameter	STATE_INIT			=	3'd0;
parameter	STATE_PRELOAD		=	3'd1;	
parameter	STATE_SHIFT			=	3'd2;
parameter	STATE_ROW_1			=	3'd3;
parameter	STATE_ROW_2			=	3'd4;
parameter	STATE_BIAS			=	3'd5;
parameter	STATE_LOAD			=	3'd6;
parameter	STATE_IDLE			=	3'd7;

parameter	ACK_IDLE			=	2'd0;
parameter	ACK_PRELOAD_FIN		=	2'd1;
parameter	ACK_SHIFT_FIN		=	2'd2;
parameter	ACK_LOAD_FIN		=	2'd3;

parameter	CMD_IDLE			=	2'd0;
parameter	CMD_PRELOAD			=	2'd1;
parameter	CMD_SHIFT			=	2'd2;
parameter	CMD_LOAD			=	2'd3;



wire					clk;
wire					rst_n;
wire					enable;

wire	[WIDTH-1:0]		data_in;
wire	[1:0]			cmd;


reg		[INPUT_SIZE*WIDTH-1:0]	data_out_port;

assign	data_out_port		=	data_out_port[INPUT_SIZE*WIDTH-1:(INPUT_SIZE-ARRAY_SIZE)*WIDTH];

output	[ADDR_WIDTH-1:0] 	rom_addr;
reg		[ADDR_WIDTH-1:0] 	rom_addr;

output	[2:0]				current_state;
reg		[2:0]				current_state;

reg		[2:0]				next_state;

reg		[2:0]				last_state;

reg		[4:0]				cell_idx;
reg		[1:0]				shift_idx;

reg		[1:0]				preload_cycle;

reg		[1:0]				ack; 

reg		[2:0]				array_idx;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		current_state	<=	STATE_INIT;
	end
	else begin
		if (enable)
			current_state	<=	next_state;
		else
			current_state	<= 	current_state;
	end
end

always @(next_state) begin
	if(next_state == STATE_IDLE) begin
		last_state	=	current_state;
	end
end


always @(current_state, cell_idx, shift_idx, preload_cycle,cmd) begin
		case (current_state)	
			
			STATE_INIT: begin 
				if ( cmd == CMD_PRELOAD )
					next_state	=	STATE_PRELOAD;
				else
					next_state	=	STATE_INIT;
			end
			
			STATE_PRELOAD: begin
				if ( cmd == CMD_SHIFT ) begin
					next_state	=	STATE_SHIFT;
				end
				else begin
					if ( preload_cycle < KERNEL_SIZE)
						next_state	=	STATE_PRELOAD;
					else
						next_state	=	STATE_IDLE;
				end
			end
			
			STATE_SHIFT: begin
				if (array_idx	==	KERNEL_SIZE - 1) begin
					if (shift_idx	== 	SHIFT_CYCLE - 1)
						next_state	=	STATE_BIAS;
					else
						next_state	=	STATE_SHIFT;
				end
				else
					next_state	=	STATE_SHIFT;
			end
				
			
			STATE_BIAS: begin
				if ( cmd == CMD_LOAD )
					next_state 	= 	STATE_LOAD;
				else if (cmd == CMD_SHIFT )
					next_state 	=	STATE_SHIFT;
				else
					next_state	=	STATE_IDLE;
			end
			
			STATE_LOAD: begin
				if ( cell_idx == 5'd7 )
					next_state	=	STATE_IDLE;
				else if ( cmd == CMD_SHIFT )
					next_state	=	STATE_SHIFT;				 
				else
					next_state	=	STATE_LOAD;
			end
	//  Caution: whenever add a new state which could go into IDLE, should add the exit for this state.		
			STATE_IDLE: begin
				if ( cmd == CMD_SHIFT)
					next_state	=	STATE_SHIFT;
				else if ( cmd == CMD_LOAD )
					next_state	=	STATE_LOAD;
				else if ( cmd == CMD_PRELOAD)
					next_state	=	STATE_PRELOAD;
				else
					next_state	=	STATE_IDLE;
			end
			
			default: begin
				next_state	=	current_state;
			end
		endcase
//	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		preload_cycle		<=	2'b0;
	else if (current_state == STATE_PRELOAD) begin
		if (cell_idx == 5'd7)
			preload_cycle	<=	preload_cycle + 1'b1;
		else
			preload_cycle	<=	preload_cycle;
	end
	else if (preload_cycle	==	2'b11)
		preload_cycle	<=	2'b0;
	else
		preload_cycle 	<=	preload_cycle;
end

//	-- ack
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		ack		<=	ACK_IDLE;
	end
	else begin
		case (current_state)
			
			STATE_INIT: begin
				ack	<=	ACK_IDLE;
			end
			
			STATE_PRELOAD: begin
				if ( preload_cycle == KERNEL_SIZE)
					ack	<=	ACK_PRELOAD_FIN;
				else
					ack	<=	ACK_IDLE;
			end
			
			STATE_SHIFT: begin
				ack		<=	ACK_IDLE;
			end
			
			STATE_BIAS: begin
				ack		<=	ACK_SHIFT_FIN;
			end
			
			STATE_LOAD: begin
				if (cell_idx == 5'd7 )			
					ack		<=	ACK_LOAD_FIN;
				else
					ack		<=	ACK_IDLE;
			end
			
			STATE_IDLE: 
				ack		<=	ACK_IDLE;
				
			default: begin
				ack		<=	ACK_IDLE;
			end
		endcase
	end
end	
		
//	rom_addr		
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		rom_addr		<=	8'b0;
	end
	else begin
		case (current_state)
			
			STATE_INIT: begin
				rom_addr	<=	8'b0;
			end
			
			STATE_PRELOAD: begin
				if (cell_idx < 5'd8)
					rom_addr	<=	rom_addr + 1'b1;
				else
					rom_addr	<=	rom_addr;
			end
			
			STATE_SHIFT: begin
				rom_addr	<=	rom_addr;
			end

			STATE_BIAS: begin
				rom_addr	<=	rom_addr;
			end
			
			STATE_LOAD: begin
				rom_addr	<=	rom_addr + 1'b1;
			end
				
			STATE_IDLE: begin
				rom_addr	<=	rom_addr;
			end	
				
			default: begin
				rom_addr	<=	rom_addr;
			end			
		endcase
	end
end		
			
//	bit index in each bank
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		cell_idx <=	5'b0;
	end
	else begin
		case (current_state)
			
			STATE_INIT: begin
				cell_idx	<=	5'b0;
			end
			
			STATE_PRELOAD: begin
				// if (cell_idx == 5'd7)
					// cell_idx	<=	5'b0;
				// else
					// cell_idx	<=	cell_idx + 1'b1;
			end
			
			STATE_SHIFT: begin
				cell_idx	<=	cell_idx;					
			end
			
			
			STATE_BIAS: begin
				cell_idx	<=	cell_idx;
			end
			
			STATE_LOAD: begin
				if (cell_idx == 5'd7)
					cell_idx	<=	5'b0;
				else
					cell_idx	<=	cell_idx + 1'b1;
			end
			
			STATE_IDLE: begin
				cell_idx	<=	cell_idx;
			end			
			
			default: begin
				cell_idx	<=	cell_idx;
			end
		endcase
	end
end

//	shift index in each cycle is 3 
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		shift_idx			<=	2'b0;
	end
	else begin
		case (current_state)
			
			STATE_INIT: 
				shift_idx	<=	2'b0;
			
			STATE_PRELOAD:
				shift_idx	<=	2'b0;
			
			STATE_SHIFT: begin
				if (shift_idx == KERNEL_SIZE - 1)
					shift_idx	<=	2'b0;
				else
					shift_idx	<=	shift_idx + 2'b1;
			end			

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
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		data_out_port <=	{ INPUT_SIZE {`DATA_WIDTH 'h0} };
	end
	else begin
		case (current_state)
			
			STATE_INIT: 
				data_out_port	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0} };
			
			
			STATE_PRELOAD: 
				data_out_port	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0} };
					
			STATE_SHIFT: begin
				if (shift_idx == 2'b00) 					
					data_out_port	<=	data_from_buffer;						
				else 
					data_out_port[INPUT_SIZE*WIDTH-1:WIDTH] <= data_out_port[(INPUT_SIZE-1)*WIDTH-1:0];
			end			

			STATE_BIAS: 
				data_out_port	<=	{ INPUT_SIZE {`FLOAT32_ONE}	};			
											
			STATE_LOAD: 
				data_out_port	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0} };									

			STATE_IDLE: 
				data_out_port	<=	{ INPUT_SIZE {`DATA_WIDTH 'h0} };																													
		
			default: begin
				data_out_port	<=	data_out_port;				
			end
		endcase
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		array_idx <=	2'b0;
	end
	else begin
		case (current_state)
			
			STATE_INIT: 
				array_idx	<=	2'b0;
			
			
			STATE_PRELOAD: 
				array_idx	<=	2'b0;
					
			STATE_SHIFT: begin
				if (shift_idx == 2'b00)					
					array_idx	<=	array_idx + 1'b1;
				else if (array_idx == KERNEL_SIZE)
					array_idx	<=	2'b0;			
				else
					array_idx 	<= array_idx;
			end			

			STATE_BIAS: 
				array_idx	<=	2'b0;			
											
			STATE_LOAD: 
				array_idx	<=	2'b0;									

			STATE_IDLE: 
				array_idx	<=	2'b0;																													
		
			default: begin
				array_idx	<=	array_idx;				
			end
		endcase
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		buffer_cmd <=	BUFFER_CMD_IDLE;
	end
	else begin
		case (current_state)
			
			STATE_INIT: 
				buffer_cmd	<=	BUFFER_CMD_IDLE;
			
			
			STATE_PRELOAD:
				if (preload_cycle == KERNEL_SIZE) 
					buffer_cmd	<=	BUFFER_CMD_IDLE;
				else begin
					if (ack == BUFFER_ACK_LOAD_FIN)
						buffer_cmd	<=	BUFFER_CMD_LOAD;
					else
						buffer_cmd	<=	BUFFER_CMD_IDLE;
				end
					
			STATE_SHIFT: 
				buffer_cmd 	<= 	BUFFER_CMD_IDLE;			

			STATE_BIAS: 
				buffer_cmd	<=	BUFFER_CMD_IDLE;			
											
			STATE_LOAD: 
				if(buffer_ack == BUFFER_ACK_LOAD_FIN)
					buffer_cmd	<=	BUFFER_CMD_IDLE;
				else
					buffer_cmd	<=	BUFFER_CMD_LOAD;

			STATE_IDLE: 
				buffer_cmd	<=	BUFFER_CMD_IDLE;																													
		
			default: begin
				buffer_cmd	<=	buffer_cmd;				
			end
		endcase
	end
end






conv_layer_input_buffer	U_conv_layer_input_buffer_0(
// --input
	.clk				(clk),
	.rst_n				(rst_n),
	.data_in,           (data_in),
	.array_idx,  		(array_idx),
	.cmd;        		(buffer_cmd),
	                     
// --output
	.ack,        		(buffer_ack),
	.data_out_bus		(data_from_buffer),
);


endmodule

