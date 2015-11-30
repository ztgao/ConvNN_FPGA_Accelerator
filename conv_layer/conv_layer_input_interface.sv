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
// 	A data cache for pixel floating point data between DDR3 and conv kernel, 
// 	functioning by a standard FSM
// 	The state transfer:
//	
//	|-- INIT --|-- PRELOAD --|-- SHIFT 0 1 2... --|-- BIAS --|-- LOAD --|
//

`include "../../global_define.v"
module conv_layer_input_interface(	
// --input
	clk,
	rst_n,
	enable,
	data_in,
	cmd,
	ack,
	
// --output
	current_state,
	rom_addr,
	out_kernel_port
);

parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

parameter	ROM_DEPTH			=	256;

parameter	STATE_INIT			=	3'd0;
parameter	STATE_PRELOAD		=	3'd1;	
parameter	STATE_SHIFT			=	3'd2;
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

parameter	FLOAT32_ONE			=	32'h3F800000;


input					clk;
input					rst_n;
input					enable;

input	[`DATA_WIDTH-1:0]		data_in;
input	[1:0]			cmd;


output	[ARRAY_SIZE*`DATA_WIDTH-1:0]	out_kernel_port;
reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	data_out_reg;

assign	out_kernel_port		=	data_out_reg[IMAGE_SIZE*`DATA_WIDTH-1:(IMAGE_SIZE-ARRAY_SIZE)*`DATA_WIDTH];

output	[`EXT_ADDR_WIDTH-1:0] 	rom_addr;
reg		[`EXT_ADDR_WIDTH-1:0] 	rom_addr;

output	[2:0]				current_state;
reg		[2:0]				current_state;

reg		[2:0]				next_state;

reg		[2:0]				last_state;

reg		[4:0]				read_index;
reg		[1:0]				shift_idx;
reg		[1:0]				row_idx;

reg		[1:0]				preload_cycle;


output	[1:0]				ack; 
reg		[1:0]				ack; 

wire	[IMAGE_SIZE*`DATA_WIDTH-1:0]	data_from_cache;

reg		[1:0]				cache_array_idx;


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

always @(current_state, read_index, shift_idx, preload_cycle,cmd) begin
		case (current_state)	
			
			STATE_INIT: begin 
				if ( cmd == CMD_PRELOAD )
					next_state	=	STATE_PRELOAD;
				else
					next_state	=	STATE_INIT;
			end
			
			STATE_PRELOAD: begin
				if ( cmd == CMD_SHIFT ) 
					next_state	=	STATE_SHIFT;
				else begin
					if ( preload_cycle < 2'b11)
						next_state	=	STATE_PRELOAD;
					else
						next_state	=	STATE_IDLE;
				end
			end
			
			STATE_SHIFT: 
				if (shift_idx	== 	2'b10 && row_idx == 2'b10)
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
				if ( read_index == 5'd7 )
					next_state	=	STATE_IDLE;
				else if ( cmd == CMD_SHIFT )
					next_state	=	STATE_SHIFT;				 
				else
					next_state	=	STATE_LOAD;
					
	//  Caution: whenever add a new state which could go into IDLE, should add the exit for this state.		
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
//	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		preload_cycle		<=	2'b0;
	else if (current_state == STATE_PRELOAD) begin
		if (read_index == 5'd7)
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
	if(!rst_n) 
		ack		<=	ACK_IDLE;
		
	else begin
		case (current_state)
			
			STATE_INIT: 
				ack	<=	ACK_IDLE;
						
			STATE_PRELOAD: 
				if ( preload_cycle == 2'b11)
					ack	<=	ACK_PRELOAD_FIN;
				else
					ack	<=	ACK_IDLE;
						
			STATE_SHIFT: 
				ack		<=	ACK_IDLE;			
			
			STATE_BIAS: 
				ack		<=	ACK_SHIFT_FIN;
			
			STATE_LOAD: 
				if (read_index == 5'd7 )			
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
		
//	rom_addr		
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		rom_addr		<=	6'b0;
	else begin
		case (current_state)
			
			STATE_INIT: 
				rom_addr	<=	6'b0;
			
			STATE_PRELOAD: 
				if (read_index < 5'd8)
					rom_addr	<=	rom_addr + 1'b1;
				else
					rom_addr	<=	rom_addr;
			
			STATE_SHIFT: 
				rom_addr	<=	rom_addr;
			
			STATE_BIAS: 
				rom_addr	<=	rom_addr;
			
			STATE_LOAD: 
				rom_addr	<=	rom_addr + 1'b1;
				
			STATE_IDLE: 
				rom_addr	<=	rom_addr;	
				
			default: 
				rom_addr	<=	rom_addr;
				
		endcase
	end
end		
			
//	bit index in each bank
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		read_index <=	5'b0;
	else begin
		case (current_state)
			
			STATE_INIT: 
				read_index	<=	5'b0;
			
			STATE_PRELOAD: 
				if (read_index == 5'd8)
					read_index	<=	5'b0;
				else
					read_index	<=	read_index + 1'b1;
			
			STATE_SHIFT: 
				read_index	<=	read_index;					
						
			STATE_BIAS: 
				read_index	<=	read_index;
			
			STATE_LOAD: 
				if (read_index == 5'd7)
					read_index	<=	5'b0;
				else
					read_index	<=	read_index + 1'b1;
			
			STATE_IDLE: 
				read_index	<=	read_index;			
			
			default: 
				read_index	<=	read_index;
		endcase
	end
end

//	shift index in each cycle is 3 
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		shift_idx			<=	2'b0;
	else begin
		case (current_state)
			
			STATE_INIT: 
				shift_idx	<=	2'b0;
			
			STATE_PRELOAD: 
				shift_idx	<=	2'b0;
			
			STATE_SHIFT: 
				if (shift_idx == 2'b10)
					shift_idx	<=	2'b0;
				else
					shift_idx	<=	shift_idx + 2'b1;
			
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
	if(!rst_n) 
		data_out_reg <=	{8{32'h0}};
	else begin
		case (current_state)
			
			STATE_INIT: 
				data_out_reg <=	{8{32'h0}};
					
			STATE_PRELOAD: 
				data_out_reg <=	{8{32'h0}};
				
			STATE_SHIFT: 
				if (shift_idx == 2'b00) 
					data_out_reg	<=	data_from_cache;																		
				else 
					data_out_reg[IMAGE_SIZE*`DATA_WIDTH-1:`DATA_WIDTH] <= data_out_reg[(IMAGE_SIZE-1)*`DATA_WIDTH-1:0];
			
			STATE_BIAS: 
				data_out_reg	<=	{ 8 {FLOAT32_ONE}};
														
			STATE_LOAD: 
				data_out_reg <=	{8{32'h0}};
												
			STATE_IDLE: 
				data_out_reg <=	{8{32'h0}};
																															
			default: 
				data_out_reg	<=	data_out_reg;				
		endcase
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		cache_array_idx <=	2'd0;
	else begin
		case (current_state)
			
			STATE_INIT: 
				cache_array_idx <=	2'd0;
						
			STATE_PRELOAD: 
				cache_array_idx <=	2'd0;
						
			STATE_SHIFT: 
				if( shift_idx == 2'd2 )
					cache_array_idx	<=	cache_array_idx + 1'd1;	
				else
					cache_array_idx	<=	cache_array_idx;					
				
			STATE_BIAS: 
				cache_array_idx <=	2'd0;
														
			STATE_LOAD: 
				cache_array_idx <=	2'd0;												

			STATE_IDLE: 
				cache_array_idx <=	cache_array_idx;
				
			default: 
				cache_array_idx <=	cache_array_idx;				
			
		endcase
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		row_idx <=	2'd0;
	else begin
		case (current_state)
			
			STATE_INIT: 
				row_idx <=	2'd0;
						
			STATE_PRELOAD: 
				row_idx <=	2'd0;
						
			STATE_SHIFT: 			
				if( shift_idx == 2'd2 )
					row_idx	<=	row_idx + 1'd1;	
				else
					row_idx	<=	row_idx;
									
			STATE_BIAS: 
				row_idx <=	2'd0;
														
			STATE_LOAD: 
				row_idx <=	2'd0;												

			STATE_IDLE: 
				row_idx <=	row_idx;
				
			default: 
				row_idx <=	row_idx;				
			
		endcase
	end
end

conv_layer_input_cache U_conv_layer_input_cache_0(
// --input
	.clk			(clk),
	.rst_n			(rst_n),
	.data_in		(data_in),
	.read_index		(read_index),
	.preload_cycle	(preload_cycle),
	.current_state	(current_state),
	.array_idx		(cache_array_idx),
// --output
	.data_out_bus	(data_from_cache)

);


`ifdef	DEBUG
//	--	Observe the interface state
always	@(current_state, preload_cycle) begin
	case (current_state)
			
			STATE_INIT: begin
				$display("[ %10t ]: Interface initializing.",$time);
			end
			
			STATE_PRELOAD: begin
				if(preload_cycle == 2'd0)
					$display("[ %10t ]: Now the cache will drop all the previous data and refresh to new data.",$time);	
				else
					$display("[ %10t ]: Complete loading array [ %2d ].",$time, preload_cycle - 1);
			end
			
			STATE_SHIFT: 
				$display("[ %10t ]: Begin to load one data from one row of the cache and shift the convolution window.",$time);
									
			STATE_BIAS: 
				$display("[ %10t ]: Add the bias value.",$time);
														
			STATE_LOAD: 
				$display("[ %10t ]: Now the cache will load one row of new data from external mem.",$time);												

			STATE_IDLE: 
				$display("[ %10t ]: Cache Idle.",$time);
				
			default: 
				$display("[ %10t ]: Cache Abnormal.",$time);				
			
	endcase
end

`endif

endmodule

