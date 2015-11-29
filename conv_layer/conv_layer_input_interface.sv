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
// Description:
// A data cache for pixel floating point data between DDR3 and conv kernel, 
// functioning by a standard FSM
// The state transfer:
//	
//	|-- INIT --|-- PRELOAD --|-- SHIFT 0 1 2... --|-- BIAS --|-- LOAD --|
//

module conv_layer_input_interface(	
// --input
	clk,
	rst_n,
	enable,
	pixel_in,
	cmd,
	ack,
	
// --output
	current_state,
	rom_addr,
	out_kernel_port
);

parameter	WIDTH				=	32;
parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

parameter	ADDR_WIDTH			=	6;
parameter	ROM_DEPTH			=	64;

parameter	STATE_INIT			=	3'd0;
parameter	STATE_PRELOAD		=	3'd1;	
parameter	STATE_ROW_0			=	3'd2;
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
parameter	CMD_PRELOAD_START	=	2'd1;
parameter	CMD_SHIFT_START		=	2'd2;
parameter	CMD_LOAD_START		=	2'd3;

parameter	FLOAT32_ONE			=	32'h3F800000;


input					clk;
input					rst_n;
input					enable;

input	[WIDTH-1:0]		pixel_in;
input	[1:0]			cmd;


output	[ARRAY_SIZE*WIDTH-1:0]	out_kernel_port;
reg		[IMAGE_SIZE*WIDTH-1:0]	out_kernel_port_reg;

assign	out_kernel_port		=	out_kernel_port_reg[IMAGE_SIZE*WIDTH-1:(IMAGE_SIZE-ARRAY_SIZE)*WIDTH];

output	[ADDR_WIDTH-1:0] 	rom_addr;
reg		[ADDR_WIDTH-1:0] 	rom_addr;

output	[2:0]				current_state;
reg		[2:0]				current_state;

reg		[2:0]				next_state;

reg		[2:0]				last_state;

reg		[4:0]				read_index;
reg		[1:0]				shift_idx;

reg		[1:0]				preload_cycle;

// output	[2:0]				weight_set_counter;
// reg		[2:0]				weight_set_counter;

output	[1:0]				ack; 
reg		[1:0]				ack; 

// 	data cache bank
reg		[IMAGE_SIZE*WIDTH-1:0]		cache_array_0;	
reg		[IMAGE_SIZE*WIDTH-1:0]		cache_array_1;	
reg		[IMAGE_SIZE*WIDTH-1:0]		cache_array_2;	

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

// always @(next_state) begin
	// if(next_state == STATE_IDLE) 
		// last_state	=	current_state;
// end


always @(current_state, read_index, shift_idx, preload_cycle,cmd) begin
		case (current_state)	
			
			STATE_INIT: begin 
				if ( cmd == CMD_PRELOAD_START )
					next_state	=	STATE_PRELOAD;
				else
					next_state	=	STATE_INIT;
			end
			
			STATE_PRELOAD: begin
				if ( cmd == CMD_SHIFT_START ) 
					next_state	=	STATE_ROW_0;
				else begin
					if ( preload_cycle < 2'b11)
						next_state	=	STATE_PRELOAD;
					else
						next_state	=	STATE_IDLE;
				end
			end
			
			STATE_ROW_0: 
				if (shift_idx	== 	2'b10)
					next_state	=	STATE_ROW_1;
				else
					next_state	=	STATE_ROW_0;
						
			STATE_ROW_1: 
				if (shift_idx	== 	2'b10)
					next_state	=	STATE_ROW_2;
				else
					next_state	=	STATE_ROW_1;							
		
			STATE_ROW_2: 
				if (shift_idx	== 	2'b10)
					next_state	=	STATE_BIAS;
				else
					next_state	=	STATE_ROW_2;				
			
			STATE_BIAS: 
				if ( cmd == CMD_LOAD_START )
					next_state 	= 	STATE_LOAD;
				else if (cmd == CMD_SHIFT_START )
					next_state 	=	STATE_ROW_0;
				else
					next_state	=	STATE_IDLE;
				
			STATE_LOAD: 
				if ( read_index == 5'd7 )
					next_state	=	STATE_IDLE;
				else if ( cmd == CMD_SHIFT_START )
					next_state	=	STATE_ROW_0;				 
				else
					next_state	=	STATE_LOAD;
					
	//  Caution: whenever add a new state which could go into IDLE, should add the exit for this state.		
			STATE_IDLE: 
				if ( cmd == CMD_SHIFT_START)
					next_state	=	STATE_ROW_0;
				else if ( cmd == CMD_LOAD_START )
					next_state	=	STATE_LOAD;
				else if ( cmd == CMD_PRELOAD_START)
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
						
			STATE_ROW_0: 
				ack		<=	ACK_IDLE;			
			
			STATE_ROW_1: 
				ack		<=	ACK_IDLE;			
			
			STATE_ROW_2: 
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
			
			STATE_ROW_0: 
				rom_addr	<=	rom_addr;
			
			STATE_ROW_1: 
				rom_addr	<=	rom_addr;
			
			STATE_ROW_2: 
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
			
			STATE_ROW_0: 
				read_index	<=	read_index;					
			
			STATE_ROW_1: 
				read_index	<=	read_index;
			
			STATE_ROW_2: 
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
			
			STATE_ROW_0: 
				if (shift_idx == 2'b10)
					shift_idx	<=	2'b0;
				else
					shift_idx	<=	shift_idx + 2'b1;
			
			STATE_ROW_1: 
				if (shift_idx == 2'b10)
					shift_idx	<=	2'b0;
				else
					shift_idx	<=	shift_idx + 2'b1;
			
			STATE_ROW_2: 
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


//	cache bank 0 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		cache_array_0	<=	{8{32'h0}};
	else begin
		case (current_state)
			
			STATE_INIT: 
				cache_array_0	<=	{8{32'h0}};			
			
			
			STATE_PRELOAD: 
				if (preload_cycle < 2'd3) begin				
					if (read_index == 5'd8) 
						cache_array_0	<=	cache_array_1;
					else 
						cache_array_0	<=	cache_array_0;
				end
			
			
			STATE_ROW_0: 
				cache_array_0	<=	cache_array_0;		
			
			
			STATE_ROW_1: 
				cache_array_0	<=	cache_array_0;				
			
			
			STATE_ROW_2: 
				cache_array_0	<=	cache_array_0;	
			
			
			STATE_BIAS: 
				cache_array_0	<=	cache_array_0;
			

			STATE_LOAD: 
				if (read_index == 5'b0) 
					cache_array_0	<=	cache_array_1;				
				else 
					cache_array_0	<=	cache_array_0;
			
			STATE_IDLE: 
				cache_array_0	<=	cache_array_0;			
						
			default: 
				cache_array_0	<=	cache_array_0;
		endcase
	end
end		

//	cache bank 1 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		cache_array_1	<=	{8{32'h0}};
	end
	else begin
		case (current_state)
			
			STATE_INIT: begin
				cache_array_1	<=	{8{32'h0}};			
			end	

			STATE_PRELOAD: begin
				if (preload_cycle < 2'd3) begin			
					if (read_index == 5'd8) begin			
						cache_array_1	<=	cache_array_2;
					end
					else begin
						cache_array_1	<=	cache_array_1;
					end
				end
			end			
			
			STATE_ROW_0: begin
				cache_array_1	<=	cache_array_1;		
			end				
						
			STATE_ROW_1: begin
				cache_array_1	<=	cache_array_1;	
			end
			
			STATE_ROW_2: begin
				cache_array_1	<=	cache_array_1;	
			end

			STATE_BIAS: begin
				cache_array_1	<=	cache_array_1;	
			end

			STATE_LOAD: begin
				if (read_index == 5'b0) begin			
					cache_array_1	<=	cache_array_2;
				end
				else begin
					cache_array_1	<=	cache_array_1;
				end
			end

			STATE_IDLE: begin
				cache_array_1	<=	cache_array_1;
			end			
		
			default: begin
				cache_array_1	<=	cache_array_1;
			end
		endcase
	end
end	

//	cache bank 2 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		cache_array_2	<=	{8{32'h0}};
	else begin
		case (current_state)
			
			STATE_INIT: 
				cache_array_2	<=	{8{32'h0}};			
			

			STATE_PRELOAD: 
				case (read_index)
					5'd0: 	cache_array_2[8*WIDTH-1:7*WIDTH]	<=	pixel_in;
					5'd1: 	cache_array_2[7*WIDTH-1:6*WIDTH]	<=	pixel_in;
					5'd2: 	cache_array_2[6*WIDTH-1:5*WIDTH]	<=	pixel_in;
					5'd3: 	cache_array_2[5*WIDTH-1:4*WIDTH]	<=	pixel_in;
					5'd4: 	cache_array_2[4*WIDTH-1:3*WIDTH]	<=	pixel_in;
					5'd5: 	cache_array_2[3*WIDTH-1:2*WIDTH]	<=	pixel_in;
					5'd6: 	cache_array_2[2*WIDTH-1:1*WIDTH]	<=	pixel_in;
					5'd7: 	cache_array_2[1*WIDTH-1:0]			<=	pixel_in;
					default:       
						cache_array_2	<=	cache_array_2;					
				endcase
						
			
			STATE_ROW_0:   
				cache_array_2	<=	cache_array_2;
						
			STATE_ROW_1:      
				cache_array_2	<=	cache_array_2;		
						
			STATE_ROW_2: 
				cache_array_2	<=	cache_array_2;		
			
			STATE_BIAS: 
				cache_array_2	<=	cache_array_2;	
			
			STATE_LOAD: 
				case (read_index)
					5'd0: 	cache_array_2[8*WIDTH-1:7*WIDTH]	<=	pixel_in;
					5'd1: 	cache_array_2[7*WIDTH-1:6*WIDTH]	<=	pixel_in;
					5'd2: 	cache_array_2[6*WIDTH-1:5*WIDTH]	<=	pixel_in;
					5'd3: 	cache_array_2[5*WIDTH-1:4*WIDTH]	<=	pixel_in;
					5'd4: 	cache_array_2[4*WIDTH-1:3*WIDTH]	<=	pixel_in;
					5'd5: 	cache_array_2[3*WIDTH-1:2*WIDTH]	<=	pixel_in;
					5'd6: 	cache_array_2[2*WIDTH-1:1*WIDTH]	<=	pixel_in;
					5'd7: 	cache_array_2[1*WIDTH-1:0]			<=	pixel_in;
					default:       
						cache_array_2	<=	cache_array_2;
				endcase

			STATE_IDLE: 
				cache_array_2	<=	cache_array_2;			
		
			default: 
				cache_array_2	<=	cache_array_2;
	
		endcase
	end
end

		

// output port behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		out_kernel_port_reg <=	{8{32'h0}};
	end
	else begin
		case (current_state)
			
			STATE_INIT: begin
				out_kernel_port_reg <=	{8{32'h0}};
			end
			
			STATE_PRELOAD: begin
				out_kernel_port_reg <=	{8{32'h0}};
			end
			
			STATE_ROW_0: begin
				if (shift_idx == 2'b00) begin
					out_kernel_port_reg	<=	cache_array_0;
																		
				end
				else begin
					out_kernel_port_reg[IMAGE_SIZE*WIDTH-1:WIDTH] <= out_kernel_port_reg[(IMAGE_SIZE-1)*WIDTH-1:0];
				end
			end
			
			STATE_ROW_1: begin
				if (shift_idx == 2'b00) begin
					out_kernel_port_reg	<=	cache_array_1;							
				end
				else begin
					out_kernel_port_reg[IMAGE_SIZE*WIDTH-1:WIDTH] <= out_kernel_port_reg[(IMAGE_SIZE-1)*WIDTH-1:0];
				end
			end
			
			STATE_ROW_2: begin
				if (shift_idx == 2'b00) begin
					out_kernel_port_reg	<=	cache_array_2;							
				end
				else begin
					out_kernel_port_reg[IMAGE_SIZE*WIDTH-1:WIDTH] <= out_kernel_port_reg[(IMAGE_SIZE-1)*WIDTH-1:0];
				end
			end	

			STATE_BIAS: begin
					out_kernel_port_reg	<=	{ 8 {FLOAT32_ONE}};
			end
											
			STATE_LOAD: begin
					out_kernel_port_reg <=	{8{32'h0}};
			end									

			STATE_IDLE: begin
					out_kernel_port_reg <=	{8{32'h0}};
																						
			end							
		
			default: begin
				out_kernel_port_reg	<=	out_kernel_port_reg;				
			end
		endcase
	end
end

endmodule

