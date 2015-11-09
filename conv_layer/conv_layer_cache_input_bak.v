// version 	1.0 -- 	setup
// version	1.1	--	add an extra cycle after "STAGE_ROW_2" for each output 
//					port to fix on 1.0 to caculate the bias.

// Description:
// A data cache for pixel floating point data between DDR3 and conv kernel, 
// functioning by a standard FSM
module conv_layer_pixel_cache_input(	
// --input
	clk,
	rst_n,
	enable,
	pixel_in,
//	idle,
	
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

parameter	INIT				=	3'd0;
parameter	PREPARE_LOAD		=	3'd1;	
parameter	STAGE_ROW_0			=	3'd2;
parameter	STAGE_ROW_1			=	3'd3;
parameter	STAGE_ROW_2			=	3'd4;
parameter	IDLE				=	3'd7;


input					clk;
input					rst_n;
input					enable;
//input					idle;

input	[WIDTH-1:0]		pixel_in;


output	[ARRAY_SIZE*WIDTH-1:0]	out_kernel_port;
reg		[IMAGE_SIZE*WIDTH-1:0]	out_kernel_port_reg;

assign	out_kernel_port	=	out_kernel_port_reg[IMAGE_SIZE*WIDTH-1:(IMAGE_SIZE-ARRAY_SIZE)*WIDTH];

output	[ADDR_WIDTH-1:0] 	rom_addr;
reg		[ADDR_WIDTH-1:0] 	rom_addr;

output	[2:0]				current_state;
reg		[2:0]				current_state;

reg		[2:0]				next_state;

reg		[2:0]				last_state;

reg		[4:0]				bank_idx;
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

// always @(idle) begin
	// if(idle) begin
		// last_state	=	current_state;
	// end
// end

// change the state
always @(current_state, bank_idx, shift_idx) begin
	// if (idle) begin
		// next_state	= IDLE;
	// end
	// else begin
		case (current_state)	
			
			INIT: begin
					next_state	=	PREPARE_LOAD;
			end
			
			PREPARE_LOAD: begin
				if (bank_idx == 5'd23)
					next_state	=	STAGE_ROW_0;
				else	
					next_state	=	PREPARE_LOAD;
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
					next_state	=	IDLE;
				else
					next_state	=	STAGE_ROW_2;				
			end
			
			IDLE: begin
//				if (!idle)
					next_state 	= 	STAGE_ROW_0;
//				else
//					next_state 	=	IDLE;
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
			
			PREPARE_LOAD: begin
				rom_addr	=	rom_addr + 1'b1;
			end
			
			STAGE_ROW_0: begin
//				if (shift_idx == 2'b10)
				if (shift_idx == 2'b10 || bank_idx == 5'b0111)
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

			IDLE: begin
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
		bank_idx <=	5'b0;
	end
	else begin
		case (current_state)
			
			INIT: begin
				bank_idx	<=	5'b0;
			end
			
			PREPARE_LOAD: begin
				if (bank_idx == 5'd23)
					bank_idx	<=	5'b0;
				else
					bank_idx	<=	bank_idx + 1'b1;
			end
			
			STAGE_ROW_0: begin
				if (shift_idx == 2'b10)
					bank_idx	<=	bank_idx + 1'b1;
				else if (bank_idx == 5'b0111)
					bank_idx	<=	5'b0;
				else
					bank_idx	<=	bank_idx;					
			end
			
			STAGE_ROW_1: begin
				if (bank_idx == 5'b0111)
					bank_idx	<=	5'b0;
				else
					bank_idx	<=	bank_idx + 1'b1;
			end
			
			STAGE_ROW_2: begin
				if (bank_idx == 5'b0111)
					bank_idx	<=	5'b0;
				else
					bank_idx	<=	bank_idx + 1'b1;
			end
			
			IDLE: begin
				bank_idx	<=	bank_idx;
			end
			
			default: begin
				bank_idx	<=	bank_idx;
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
			
			PREPARE_LOAD: begin
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

			IDLE: begin
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
			
			PREPARE_LOAD: begin
///				if (bank_idx == 5'd24) begin
				
        			case (bank_idx)
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
			
			IDLE: begin
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

			PREPARE_LOAD: begin
				case (bank_idx)
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

			IDLE: begin
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

			PREPARE_LOAD: begin
				case (bank_idx)
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
				if (shift_idx == 2'b10 || bank_idx == 5'b0111) begin				
					case (bank_idx)
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
				case (bank_idx)
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
				case (bank_idx)
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

			IDLE: begin
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
			
			PREPARE_LOAD: begin
				if (bank_idx == 5'd23) 
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

			IDLE: begin
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

/* always @() begin
	case (current_state)
	
		INIT: begin
			out_kernel_port_reg	<=	256'b0;
		end
		
		LOAD: begin
			out_kernel_port_reg	<=	{ cache_array_1_0,
									cache_array_1_1,
			                      cache_array_1_2,
			                      cache_array_1_3,
			                      cache_array_1_4,
			                      cache_array_1_5,
			                      cache_array_1_6,
			                      cache_array_1_7									  
								};							
		end
		
		BIT_SHIFT_BANK_0: begin
			out_kernel_port_reg[IMAGE_SIZE*WIDTH-1:WIDTH] <= out_kernel_port_reg[(IMAGE_SIZE-1)*WIDTH-1:0];
		end
		
		BANK_SHIFT: begin
			out_kernel_port_reg	<=	{ cache_array_1_0,
								  cache_array_1_1,
			                      cache_array_1_2,
			                      cache_array_1_3,
			                      cache_array_1_4,
			                      cache_array_1_5,
			                      cache_array_1_6,
			                      cache_array_1_7									  									  
								};
		end
		
		BIT_SHIFT_BANK_1: begin
			out_kernel_port_reg[IMAGE_SIZE*WIDTH-1:WIDTH] <= out_kernel_port_reg[(IMAGE_SIZE-1)*WIDTH-1:0];			
		end			
	
		default: begin
			out_kernel_port_reg	<=	out_kernel_port_reg;				
		end
	endcase
end */

endmodule