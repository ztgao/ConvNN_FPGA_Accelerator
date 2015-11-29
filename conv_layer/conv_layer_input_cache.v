// 	version 1.0 --	2015.11.29	
//				-- 	setup

module conv_layer_input_cache(
// --input
	clk,
	rst_n,
	pixel_in,
	read_index,
	preload_cycle,
	current_state,
	array_idx,
// --output
	data_out_bus

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

input							clk;
input							rst_n;
input	[WIDTH-1:0]				pixel_in;
input	[4:0]					read_index;
input	[1:0]					preload_cycle;
input	[1:0]					array_idx;

output	[IMAGE_SIZE*WIDTH-1:0]	data_out_bus;



// 	data cache bank
reg		[IMAGE_SIZE*WIDTH-1:0]	cache_array_0;	
reg		[IMAGE_SIZE*WIDTH-1:0]	cache_array_1;	
reg		[IMAGE_SIZE*WIDTH-1:0]	cache_array_2;	


//	--	Buffer Array Index Decoder
always @(array_idx)	begin
	case (array_idx)
		2'd0:	data_out_bus	=	buffer_array_0;
		2'd1:	data_out_bus	=	buffer_array_1;
		2'd2:	data_out_bus	=	buffer_array_2;
		default:
				data_out_bus	=	{ 8 {32 'h0}};
	endcase
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

		
/* 
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
end */

endmodule