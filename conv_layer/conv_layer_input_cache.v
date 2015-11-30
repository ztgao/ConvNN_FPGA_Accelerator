// 	version 1.0 --	2015.11.29	
//				-- 	setup

`include "../../global_define.v"
module conv_layer_input_cache(
// --input
	clk,
	rst_n,
	data_in,
	read_index,
	preload_cycle,
	current_state,
	array_idx,
// --output
	data_out_bus

);

parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

parameter	ADDR_WIDTH			=	8;
parameter	ROM_DEPTH			=	256;

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
input	[`DATA_WIDTH-1:0]				data_in;
input	[4:0]					read_index;
input	[1:0]					preload_cycle;
input	[2:0]					current_state;
input	[1:0]					array_idx;

output reg [IMAGE_SIZE*`DATA_WIDTH-1:0]	data_out_bus;



// 	data cache bank
reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	cache_array_0;	
reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	cache_array_1;	
reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	cache_array_2;	


//	--	Buffer Array Index Decoder
always @(array_idx, cache_array_0, cache_array_1, cache_array_2)	begin
	case (array_idx)
		2'd0:	data_out_bus	=	cache_array_0;
		2'd1:	data_out_bus	=	cache_array_1;
		2'd2:	data_out_bus	=	cache_array_2;
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
	if(!rst_n) 
		cache_array_1	<=	{8{32'h0}};
	else begin
		case (current_state)
			
			STATE_INIT: 
				cache_array_1	<=	{8{32'h0}};			
				

			STATE_PRELOAD: begin
				if (preload_cycle < 2'd3) begin			
					if (read_index == 5'd8) 			
						cache_array_1	<=	cache_array_2;					
					else 
						cache_array_1	<=	cache_array_1;
					
				end
			end			
			
			STATE_ROW_0: 
				cache_array_1	<=	cache_array_1;														

			STATE_BIAS: 
				cache_array_1	<=	cache_array_1;				

			STATE_LOAD: 
				if (read_index == 5'b0) 			
					cache_array_1	<=	cache_array_2;				
				else 
					cache_array_1	<=	cache_array_1;				

			STATE_IDLE: 
				cache_array_1	<=	cache_array_1;						
		
			default: 
				cache_array_1	<=	cache_array_1;
	
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
					5'd0: 	cache_array_2[8*`DATA_WIDTH-1:7*`DATA_WIDTH]	<=	data_in;
					5'd1: 	cache_array_2[7*`DATA_WIDTH-1:6*`DATA_WIDTH]	<=	data_in;
					5'd2: 	cache_array_2[6*`DATA_WIDTH-1:5*`DATA_WIDTH]	<=	data_in;
					5'd3: 	cache_array_2[5*`DATA_WIDTH-1:4*`DATA_WIDTH]	<=	data_in;
					5'd4: 	cache_array_2[4*`DATA_WIDTH-1:3*`DATA_WIDTH]	<=	data_in;
					5'd5: 	cache_array_2[3*`DATA_WIDTH-1:2*`DATA_WIDTH]	<=	data_in;
					5'd6: 	cache_array_2[2*`DATA_WIDTH-1:1*`DATA_WIDTH]	<=	data_in;
					5'd7: 	cache_array_2[1*`DATA_WIDTH-1:0]			<=	data_in;
					default:       
						cache_array_2	<=	cache_array_2;					
				endcase
						
			
			STATE_ROW_0:   
				cache_array_2	<=	cache_array_2;
						
			STATE_BIAS: 
				cache_array_2	<=	cache_array_2;	
			
			STATE_LOAD: 
				case (read_index)
					5'd0: 	cache_array_2[8*`DATA_WIDTH-1:7*`DATA_WIDTH]	<=	data_in;
					5'd1: 	cache_array_2[7*`DATA_WIDTH-1:6*`DATA_WIDTH]	<=	data_in;
					5'd2: 	cache_array_2[6*`DATA_WIDTH-1:5*`DATA_WIDTH]	<=	data_in;
					5'd3: 	cache_array_2[5*`DATA_WIDTH-1:4*`DATA_WIDTH]	<=	data_in;
					5'd4: 	cache_array_2[4*`DATA_WIDTH-1:3*`DATA_WIDTH]	<=	data_in;
					5'd5: 	cache_array_2[3*`DATA_WIDTH-1:2*`DATA_WIDTH]	<=	data_in;
					5'd6: 	cache_array_2[2*`DATA_WIDTH-1:1*`DATA_WIDTH]	<=	data_in;
					5'd7: 	cache_array_2[1*`DATA_WIDTH-1:0]			<=	data_in;
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

//	--	just for observe
wire	[`DATA_WIDTH-1:0]		cache_array_0_0	=	cache_array_0[8*`DATA_WIDTH-1:7*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_0_1	=	cache_array_0[7*`DATA_WIDTH-1:6*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_0_2	=	cache_array_0[6*`DATA_WIDTH-1:5*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_0_3	=	cache_array_0[5*`DATA_WIDTH-1:4*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_0_4	=	cache_array_0[4*`DATA_WIDTH-1:3*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_0_5	=	cache_array_0[3*`DATA_WIDTH-1:2*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_0_6	=	cache_array_0[2*`DATA_WIDTH-1:1*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_0_7	=	cache_array_0[1*`DATA_WIDTH-1:0];

wire	[`DATA_WIDTH-1:0]		cache_array_1_0	=	cache_array_1[8*`DATA_WIDTH-1:7*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_1_1	=	cache_array_1[7*`DATA_WIDTH-1:6*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_1_2	=	cache_array_1[6*`DATA_WIDTH-1:5*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_1_3	=	cache_array_1[5*`DATA_WIDTH-1:4*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_1_4	=	cache_array_1[4*`DATA_WIDTH-1:3*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_1_5	=	cache_array_1[3*`DATA_WIDTH-1:2*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_1_6	=	cache_array_1[2*`DATA_WIDTH-1:1*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_1_7	=	cache_array_1[1*`DATA_WIDTH-1:0];

wire	[`DATA_WIDTH-1:0]		cache_array_2_0	=	cache_array_2[8*`DATA_WIDTH-1:7*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_2_1	=	cache_array_2[7*`DATA_WIDTH-1:6*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_2_2	=	cache_array_2[6*`DATA_WIDTH-1:5*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_2_3	=	cache_array_2[5*`DATA_WIDTH-1:4*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_2_4	=	cache_array_2[4*`DATA_WIDTH-1:3*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_2_5	=	cache_array_2[3*`DATA_WIDTH-1:2*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_2_6	=	cache_array_2[2*`DATA_WIDTH-1:1*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]		cache_array_2_7	=	cache_array_2[1*`DATA_WIDTH-1:0];

endmodule