// version 	1.0 -- 	setup
// version	1.1	--	add an extra cycle after "STAGE_ROW_2" for each output 
//					port to fix on 1.0 to caculate the bias.
// version	1.2 --  change the strategy of memory access and the data control
//					will be finished by higher hierarchy

// Description:
// A data cache for pixel floating point data between DDR3 and conv kernel, 
// functioning by a standard FSM
module conv_layer_input_interface(	
// --input
	clk,
	rst_n,
	enable,
	data_in,
	cmd,
	
// --output
	rom_addr,
	out_kernel_port,
	current_state
	
);

parameter	WIDTH				=	32;
parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

parameter	ADDR_WIDTH			=	6;
parameter	ROM_DEPTH			=	64;

parameter	STAGE_INIT			=	3'd0;
parameter	STAGE_PRELOAD		=	3'd1;	
parameter	STAGE_ROW_0			=	3'd2;
parameter	STAGE_ROW_1			=	3'd3;
parameter	STAGE_ROW_2			=	3'd4;
parameter	STAGE_BIAS			=	3'd5;
parameter	STAGE_LOAD			=	3'd6;
parameter	STAGE_STAGE_BIAS	=	3'd7;


input					clk;
input					rst_n;
input					enable;

input	[WIDTH-1:0]		pixel_in;


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

// 	data cache bank 0
reg		[WIDTH-1:0]		cache_array_0_0;	
reg		[WIDTH-1:0]		cache_array_0_1;	
reg		[WIDTH-1:0]		cache_array_0_2;	
reg		[WIDTH-1:0]		cache_array_0_3;	
reg		[WIDTH-1:0]		cache_array_0_4;	
reg		[WIDTH-1:0]		cache_array_0_5;	
reg		[WIDTH-1:0]		cache_array_0_6;
reg		[WIDTH-1:0]		cache_array_0_7;

// 	data cache bank 1
reg		[WIDTH-1:0]		cache_array_1_0;		
reg		[WIDTH-1:0]		cache_array_1_1;		
reg		[WIDTH-1:0]		cache_array_1_2;	
reg		[WIDTH-1:0]		cache_array_1_3;	
reg		[WIDTH-1:0]		cache_array_1_4;	
reg		[WIDTH-1:0]		cache_array_1_5;	
reg		[WIDTH-1:0]		cache_array_1_6;
reg		[WIDTH-1:0]		cache_array_1_7;

// 	data cache bank 2
reg		[WIDTH-1:0]		cache_array_2_0;		
reg		[WIDTH-1:0]		cache_array_2_1;		
reg		[WIDTH-1:0]		cache_array_2_2;	
reg		[WIDTH-1:0]		cache_array_2_3;	
reg		[WIDTH-1:0]		cache_array_2_4;	
reg		[WIDTH-1:0]		cache_array_2_5;	
reg		[WIDTH-1:0]		cache_array_2_6;
reg		[WIDTH-1:0]		cache_array_2_7;


always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		current_state	<=	INIT;
	end
	else begin
		if (enable)
			current_state	<=	next_state;
		else
			current_state	<= 	current_state;
	end
end

always @(current_state, read_index, shift_idx, cmd) begin
	// if (STAGE_BIAS) begin
		// next_state	= STAGE_BIAS;
	// end
	// else begin
		case (current_state)	
			
			INIT: begin
					next_state	=	STAGE_PRELOAD;
			end
			
			STAGE_PRELOAD: begin
				if ( )
					next_state	=	STAGE_ROW_0;
				else	
					next_state	=	STAGE_PRELOAD;
			end
			
			STAGE_ROW_0: begin
				if (shift_idx	== 	2'b10)
					next_state	=	STAGE_ROW_1;
				else
					next_state	=	STAGE_ROW_0;
			end
			
			STAGE_ROW_1: begin
				if (shift_idx	== 	2'b10)
					next_state	=	STAGE_ROW_2;
				else
					next_state	=	STAGE_ROW_1;			
			end
			
/* 			STAGE_ROW_2: begin
				if (shift_idx	== 	2'b10)
					next_state	=	STAGE_ROW_0;
				else
					next_state	=	STAGE_ROW_2;				
			end */
			
			STAGE_ROW_2: begin
				if (shift_idx	== 	2'b10)
					next_state	=	STAGE_BIAS;
				else
					next_state	=	STAGE_ROW_2;				
			end
			
			STAGE_BIAS: begin
//				if (!STAGE_BIAS)
					next_state 	= 	STAGE_ROW_0;
//				else
//					next_state 	=	STAGE_BIAS;
			end
									
			default: begin
				next_state	=	INIT;
			end
		endcase
//	end
end

//	rom_addr		
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		rom_addr		<=	6'b0;
	end
	else begin
		case (current_state)
			
			INIT: begin
				rom_addr	<=	6'b0;
			end
			
			STAGE_PRELOAD: begin
				rom_addr	=	rom_addr + 1'b1;
			end
			
			STAGE_ROW_0: begin
//				if (shift_idx == 2'b10)
				if (shift_idx == 2'b10 || read_index == 5'b0111)
					rom_addr	<=	rom_addr + 1'b1;
				else
					rom_addr	<=	rom_addr;
			end
			
			STAGE_ROW_1: begin
				rom_addr	<=	rom_addr + 1'b1;
			end
			
			STAGE_ROW_2: begin
				rom_addr	<=	rom_addr + 1'b1;
			end	

			STAGE_BIAS: begin
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
		read_index <=	5'b0;
	end
	else begin
		case (current_state)
			
			INIT: begin
				read_index	<=	5'b0;
			end
			
			STAGE_PRELOAD: begin
				if (read_index == 5'd23)
					read_index	<=	5'b0;
				else
					read_index	<=	read_index + 1'b1;
			end
			
			STAGE_ROW_0: begin
				if (shift_idx == 2'b10)
					read_index	<=	read_index + 1'b1;
				else if (read_index == 5'b0111)
					read_index	<=	5'b0;
				else
					read_index	<=	read_index;					
			end
			
			STAGE_ROW_1: begin
				if (read_index == 5'b0111)
					read_index	<=	5'b0;
				else
					read_index	<=	read_index + 1'b1;
			end
			
			STAGE_ROW_2: begin
				if (read_index == 5'b0111)
					read_index	<=	5'b0;
				else
					read_index	<=	read_index + 1'b1;
			end
			
			STAGE_BIAS: begin
				read_index	<=	read_index;
			end
			
			default: begin
				read_index	<=	read_index;
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
			
			INIT: begin
				shift_idx	<=	2'b0;
			end
			
			STAGE_PRELOAD: begin
				shift_idx	<=	2'b0;
			end
			
			STAGE_ROW_0: begin
				if (shift_idx == 2'b10)
					shift_idx	<=	2'b0;
				else
					shift_idx	<=	shift_idx + 2'b1;
			end
			
			STAGE_ROW_1: begin
				if (shift_idx == 2'b10)
					shift_idx	<=	2'b0;
				else
					shift_idx	<=	shift_idx + 2'b1;
			end
			
			STAGE_ROW_2: begin
				if (shift_idx == 2'b10)
					shift_idx	<=	2'b0;
				else
					shift_idx	<=	shift_idx + 2'b1;
			end

			STAGE_BIAS: begin
				shift_idx	<=	shift_idx;
			end			
		
			default:
				shift_idx	<=	shift_idx;
		endcase
	end
end


//	cache bank 0 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		cache_array_0_0	<=	32'h0;
        cache_array_0_1 <=	32'h0;
        cache_array_0_2 <=	32'h0;
        cache_array_0_3 <=	32'h0;
        cache_array_0_4 <=	32'h0;
        cache_array_0_5 <=	32'h0;
        cache_array_0_6 <=	32'h0;
        cache_array_0_7 <=	32'h0;
	end
	else begin
		case (current_state)
			
			INIT: begin
				cache_array_0_0	<=	32'h0;
				cache_array_0_1 <=	32'h0;
				cache_array_0_2 <=	32'h0;
				cache_array_0_3 <=	32'h0;
				cache_array_0_4 <=	32'h0;
				cache_array_0_5 <=	32'h0;
				cache_array_0_6 <=	32'h0;
				cache_array_0_7 <=	32'h0;				
			end
			
			STAGE_PRELOAD: begin
///				if (read_index == 5'd24) begin
				
        			case (read_index)
        				5'd0: 	cache_array_0_0	<=	pixel_in;
        				5'd1: 	cache_array_0_1	<=	pixel_in;
        				5'd2: 	cache_array_0_2	<=	pixel_in;
        				5'd3: 	cache_array_0_3	<=	pixel_in;
        				5'd4: 	cache_array_0_4	<=	pixel_in;
        				5'd5: 	cache_array_0_5	<=	pixel_in;
        				5'd6: 	cache_array_0_6	<=	pixel_in;
        				5'd7: 	cache_array_0_7	<=	pixel_in;
        				default: begin      
        						cache_array_0_0	<=	cache_array_0_0;
        						cache_array_0_1 <=	cache_array_0_1;
        						cache_array_0_2 <=	cache_array_0_2;
        						cache_array_0_3 <=	cache_array_0_3;
        						cache_array_0_4 <=	cache_array_0_4;
        						cache_array_0_5 <=	cache_array_0_5;	
        						cache_array_0_6 <=	cache_array_0_6;
        						cache_array_0_7 <=	cache_array_0_7;
        				end
        			endcase	
//				end		
			end
			
			STAGE_ROW_0: begin
				if (shift_idx == 2'b10) begin
					cache_array_0_0	<=	cache_array_1_0;
					cache_array_0_1 <=	cache_array_1_1;
					cache_array_0_2 <=	cache_array_1_2;
					cache_array_0_3 <=	cache_array_1_3;
					cache_array_0_4 <=	cache_array_1_4;
					cache_array_0_5 <=	cache_array_1_5;
					cache_array_0_6 <=	cache_array_1_6;
					cache_array_0_7 <=	cache_array_1_7;
				end 
				else begin
					cache_array_0_0	<=	cache_array_0_0;
					cache_array_0_1 <=	cache_array_0_1;
					cache_array_0_2 <=	cache_array_0_2;
					cache_array_0_3 <=	cache_array_0_3;
					cache_array_0_4 <=	cache_array_0_4;
					cache_array_0_5 <=	cache_array_0_5;
					cache_array_0_6 <=	cache_array_0_6;
					cache_array_0_7 <=	cache_array_0_7;
				end				
			end
			
			STAGE_ROW_1: begin
				cache_array_0_0	<=	cache_array_0_0;
				cache_array_0_1 <=	cache_array_0_1;
				cache_array_0_2 <=	cache_array_0_2;
				cache_array_0_3 <=	cache_array_0_3;
				cache_array_0_4 <=	cache_array_0_4;
				cache_array_0_5 <=	cache_array_0_5;
				cache_array_0_6 <=	cache_array_0_6;
				cache_array_0_7 <=	cache_array_0_7;				
			end
			
			STAGE_ROW_2: begin
				cache_array_0_0	<=	cache_array_0_0;
				cache_array_0_1 <=	cache_array_0_1;
				cache_array_0_2 <=	cache_array_0_2;
				cache_array_0_3 <=	cache_array_0_3;
				cache_array_0_4 <=	cache_array_0_4;
				cache_array_0_5 <=	cache_array_0_5;
				cache_array_0_6 <=	cache_array_0_6;
				cache_array_0_7 <=	cache_array_0_7;	
			end
			
			STAGE_BIAS: begin
				cache_array_0_0	<=	cache_array_0_0;
				cache_array_0_1 <=	cache_array_0_1;
				cache_array_0_2 <=	cache_array_0_2;
				cache_array_0_3 <=	cache_array_0_3;
				cache_array_0_4 <=	cache_array_0_4;
				cache_array_0_5 <=	cache_array_0_5;
				cache_array_0_6 <=	cache_array_0_6;
				cache_array_0_7 <=	cache_array_0_7;
			end	
						
			default: begin
				cache_array_0_0	<=	cache_array_0_0;
				cache_array_0_1 <=	cache_array_0_1;
				cache_array_0_2 <=	cache_array_0_2;
				cache_array_0_3 <=	cache_array_0_3;
				cache_array_0_4 <=	cache_array_0_4;
				cache_array_0_5 <=	cache_array_0_5;
				cache_array_0_6 <=	cache_array_0_6;
				cache_array_0_7 <=	cache_array_0_7;
			end
		endcase
	end
end		

//	cache bank 1 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		cache_array_1_0	<=	32'h0;
        cache_array_1_1 <=	32'h0;
        cache_array_1_2 <=	32'h0;
        cache_array_1_3 <=	32'h0;
        cache_array_1_4 <=	32'h0;
        cache_array_1_5 <=	32'h0;
        cache_array_1_6 <=	32'h0;
        cache_array_1_7 <=	32'h0;
	end
	else begin
		case (current_state)
			
			INIT: begin
				cache_array_1_0	<=	32'h0;
				cache_array_1_1 <=	32'h0;
				cache_array_1_2 <=	32'h0;
				cache_array_1_3 <=	32'h0;
				cache_array_1_4 <=	32'h0;
				cache_array_1_5 <=	32'h0;
				cache_array_1_6 <=	32'h0;
				cache_array_1_7 <=	32'h0;				
			end	

			STAGE_PRELOAD: begin
				case (read_index)
					5'd8: 	cache_array_1_0	<=	pixel_in;
					5'd9: 	cache_array_1_1	<=	pixel_in;
					5'd10: 	cache_array_1_2	<=	pixel_in;
					5'd11: 	cache_array_1_3	<=	pixel_in;
					5'd12: 	cache_array_1_4	<=	pixel_in;
					5'd13: 	cache_array_1_5	<=	pixel_in;
					5'd14: 	cache_array_1_6	<=	pixel_in;
					5'd15: 	cache_array_1_7	<=	pixel_in;
					default: begin      
							cache_array_1_0	<=	cache_array_1_0;
							cache_array_1_1 <=	cache_array_1_1;
							cache_array_1_2 <=	cache_array_1_2;
							cache_array_1_3 <=	cache_array_1_3;
							cache_array_1_4 <=	cache_array_1_4;
							cache_array_1_5 <=	cache_array_1_5;	
							cache_array_1_6 <=	cache_array_1_6;
							cache_array_1_7 <=	cache_array_1_7;
					end
				endcase
			end			
			
			STAGE_ROW_0: begin
				if (shift_idx == 2'b10) begin
					cache_array_1_0	<=	cache_array_2_0;
					cache_array_1_1 <=	cache_array_2_1;
					cache_array_1_2 <=	cache_array_2_2;
					cache_array_1_3 <=	cache_array_2_3;
					cache_array_1_4 <=	cache_array_2_4;
					cache_array_1_5 <=	cache_array_2_5;
					cache_array_1_6 <=	cache_array_2_6;
					cache_array_1_7 <=	cache_array_2_7;
				end 
				else begin
					cache_array_1_0	<=	cache_array_1_0;
					cache_array_1_1 <=	cache_array_1_1;
					cache_array_1_2 <=	cache_array_1_2;
					cache_array_1_3 <=	cache_array_1_3;
					cache_array_1_4 <=	cache_array_1_4;
					cache_array_1_5 <=	cache_array_1_5;
					cache_array_1_6 <=	cache_array_1_6;
					cache_array_1_7 <=	cache_array_1_7;
				end				
			end				
			
			
			STAGE_ROW_1: begin
				cache_array_1_0	<=	cache_array_1_0;
				cache_array_1_1 <=	cache_array_1_1;
				cache_array_1_2 <=	cache_array_1_2;
				cache_array_1_3 <=	cache_array_1_3;
				cache_array_1_4 <=	cache_array_1_4;
				cache_array_1_5 <=	cache_array_1_5;
				cache_array_1_6 <=	cache_array_1_6;
				cache_array_1_7 <=	cache_array_1_7;	
			end
			
			STAGE_ROW_2: begin
				cache_array_1_0	<=	cache_array_1_0;
				cache_array_1_1 <=	cache_array_1_1;
				cache_array_1_2 <=	cache_array_1_2;
				cache_array_1_3 <=	cache_array_1_3;
				cache_array_1_4 <=	cache_array_1_4;
				cache_array_1_5 <=	cache_array_1_5;
				cache_array_1_6 <=	cache_array_1_6;
				cache_array_1_7 <=	cache_array_1_7;	
			end

			STAGE_BIAS: begin
				cache_array_1_0	<=	cache_array_1_0;
				cache_array_1_1 <=	cache_array_1_1;
				cache_array_1_2 <=	cache_array_1_2;
				cache_array_1_3 <=	cache_array_1_3;
				cache_array_1_4 <=	cache_array_1_4;
				cache_array_1_5 <=	cache_array_1_5;
				cache_array_1_6 <=	cache_array_1_6;
				cache_array_1_7 <=	cache_array_1_7;	
			end				
		
			default: begin
				cache_array_1_0	<=	cache_array_1_0;
				cache_array_1_1 <=	cache_array_1_1;
				cache_array_1_2 <=	cache_array_1_2;
				cache_array_1_3 <=	cache_array_1_3;
				cache_array_1_4 <=	cache_array_1_4;
				cache_array_1_5 <=	cache_array_1_5;
				cache_array_1_6 <=	cache_array_1_6;
				cache_array_1_7 <=	cache_array_1_7;
			end
		endcase
	end
end	

//	cache bank 2 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		cache_array_2_0	<=	32'h0;
        cache_array_2_1 <=	32'h0;
        cache_array_2_2 <=	32'h0;
        cache_array_2_3 <=	32'h0;
        cache_array_2_4 <=	32'h0;
        cache_array_2_5 <=	32'h0;
        cache_array_2_6 <=	32'h0;
        cache_array_2_7 <=	32'h0;
	end
	else begin
		case (current_state)
			
			INIT: begin
				cache_array_2_0	<=	32'h0;
				cache_array_2_1 <=	32'h0;
				cache_array_2_2 <=	32'h0;
				cache_array_2_3 <=	32'h0;
				cache_array_2_4 <=	32'h0;
				cache_array_2_5 <=	32'h0;
				cache_array_2_6 <=	32'h0;
				cache_array_2_7 <=	32'h0;				
			end

			STAGE_PRELOAD: begin
				case (read_index)
					5'd16: 	cache_array_2_0	<=	pixel_in;
					5'd17: 	cache_array_2_1	<=	pixel_in;
					5'd18: 	cache_array_2_2	<=	pixel_in;
					5'd19: 	cache_array_2_3	<=	pixel_in;
					5'd20: 	cache_array_2_4	<=	pixel_in;
					5'd21: 	cache_array_2_5	<=	pixel_in;
					5'd22: 	cache_array_2_6	<=	pixel_in;
					5'd23: 	cache_array_2_7	<=	pixel_in;
					default: begin      
							cache_array_2_0	<=	cache_array_2_0;
							cache_array_2_1 <=	cache_array_2_1;
							cache_array_2_2 <=	cache_array_2_2;
							cache_array_2_3 <=	cache_array_2_3;
							cache_array_2_4 <=	cache_array_2_4;
							cache_array_2_5 <=	cache_array_2_5;	
							cache_array_2_6 <=	cache_array_2_6;
							cache_array_2_7 <=	cache_array_2_7;
					end
				endcase
			end			
			
			STAGE_ROW_0: begin
//				if (shift_idx == 2'b10 ) begin
				if (shift_idx == 2'b10 || read_index == 5'b0111) begin				
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
							cache_array_2_0	<=	cache_array_2_0;
							cache_array_2_1 <=	cache_array_2_1;
							cache_array_2_2 <=	cache_array_2_2;
							cache_array_2_3 <=	cache_array_2_3;
							cache_array_2_4 <=	cache_array_2_4;
							cache_array_2_5 <=	cache_array_2_5;	
							cache_array_2_6 <=	cache_array_2_6;
							cache_array_2_7 <=	cache_array_2_7;
						end
					endcase
				end
			end
			
			STAGE_ROW_1: begin
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
							cache_array_2_0	<=	cache_array_2_0;
							cache_array_2_1 <=	cache_array_2_1;
							cache_array_2_2 <=	cache_array_2_2;
							cache_array_2_3 <=	cache_array_2_3;
							cache_array_2_4 <=	cache_array_2_4;
							cache_array_2_5 <=	cache_array_2_5;	
							cache_array_2_6 <=	cache_array_2_6;
							cache_array_2_7 <=	cache_array_2_7;
					end
				endcase			
			end
			
			STAGE_ROW_2: begin
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
							cache_array_2_0	<=	cache_array_2_0;
							cache_array_2_1 <=	cache_array_2_1;
							cache_array_2_2 <=	cache_array_2_2;
							cache_array_2_3 <=	cache_array_2_3;
							cache_array_2_4 <=	cache_array_2_4;
							cache_array_2_5 <=	cache_array_2_5;	
							cache_array_2_6 <=	cache_array_2_6;
							cache_array_2_7 <=	cache_array_2_7;
					end
				endcase			
			end

			STAGE_BIAS: begin
				cache_array_2_0	<=	cache_array_2_0;
				cache_array_2_1 <=	cache_array_2_1;
				cache_array_2_2 <=	cache_array_2_2;
				cache_array_2_3 <=	cache_array_2_3;
				cache_array_2_4 <=	cache_array_2_4;
				cache_array_2_5 <=	cache_array_2_5;
				cache_array_2_6 <=	cache_array_2_6;
				cache_array_2_7 <=	cache_array_2_7;	
			end				
		
			default: begin
				cache_array_2_0	<=	cache_array_2_0;
				cache_array_2_1 <=	cache_array_2_1;
				cache_array_2_2 <=	cache_array_2_2;
				cache_array_2_3 <=	cache_array_2_3;
				cache_array_2_4 <=	cache_array_2_4;
				cache_array_2_5 <=	cache_array_2_5;
				cache_array_2_6 <=	cache_array_2_6;
				cache_array_2_7 <=	cache_array_2_7;
			end
		endcase
	end
end

		

// output port behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		out_kernel_port_reg <=	256'b0;
	end
	else begin
		case (current_state)
			
			INIT: begin
				out_kernel_port_reg	<=	256'b0;
			end
			
			STAGE_PRELOAD: begin
				if (read_index == 5'd23) 
					out_kernel_port_reg	<=	{ 	cache_array_0_0,
												cache_array_0_1,
												cache_array_0_2,
												cache_array_0_3,
												cache_array_0_4,
												cache_array_0_5,
												cache_array_0_6,
												cache_array_0_7									  
											};	
				else
					out_kernel_port_reg	<=	256'b0;
			end
			
			STAGE_ROW_0: begin
				if (shift_idx == 2'b10) begin
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
			
			STAGE_ROW_1: begin
				if (shift_idx == 2'b10) begin
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
			
			STAGE_ROW_1: begin
				if (shift_idx == 2'b10) begin
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

			STAGE_ROW_2: begin
				if (shift_idx == 2'b10) begin
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

			STAGE_BIAS: begin
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
		
			default: begin
				out_kernel_port_reg	<=	out_kernel_port_reg;				
			end
		endcase
	end
end

endmodule