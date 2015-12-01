// 	version 1.0 --	2015.11.29	
//				-- 	setup

`include "../../global_define.v"
module conv_layer_input_cache(
// --input
	clk,
	rst_n,
	data_in,
	col_index,
	preload_cycle,
	current_state,
	row_index,
// --output
	data_out_bus

);

`include "../../conv_layer/conv_kernel_param.v"


input							clk;
input							rst_n;
input	[`DATA_WIDTH-1:0]				data_in;
input	[4:0]					col_index;
input	[1:0]					preload_cycle;
input	[2:0]					current_state;
input	[1:0]					row_index;

output reg [IMAGE_SIZE*`DATA_WIDTH-1:0]	data_out_bus;

// 	data cache bank
reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	cache_array_0;	
reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	cache_array_1;	
reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	cache_array_2;	

//	--	Buffer Array Index Decoder
always @(row_index, cache_array_0, cache_array_1, cache_array_2)	begin
	case (row_index)
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
					if (col_index == 5'd8) 
						cache_array_0	<=	cache_array_1;
					else 
						cache_array_0	<=	cache_array_0;
				end
						
			STATE_SHIFT: 
				cache_array_0	<=	cache_array_0;		
					
			STATE_BIAS: 
				cache_array_0	<=	cache_array_0;
			
			STATE_LOAD: 
				if (col_index == 5'b0) 
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
					if (col_index == 5'd8) 			
						cache_array_1	<=	cache_array_2;					
					else 
						cache_array_1	<=	cache_array_1;
					
				end
			end			
			
			STATE_SHIFT: 
				cache_array_1	<=	cache_array_1;														

			STATE_BIAS: 
				cache_array_1	<=	cache_array_1;				

			STATE_LOAD: 
				if (col_index == 5'b0) 			
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
				case (col_index)
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
									
			STATE_SHIFT:   
				cache_array_2	<=	cache_array_2;
						
			STATE_BIAS: 
				cache_array_2	<=	cache_array_2;	
			
			STATE_LOAD: 
				case (col_index)
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

`ifdef	DEBUG

//	--	just for observe
wire	[`DATA_WIDTH-1:0]	cache_array_0_0	=	cache_array_0[8*`DATA_WIDTH-1:7*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_0_1	=	cache_array_0[7*`DATA_WIDTH-1:6*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_0_2	=	cache_array_0[6*`DATA_WIDTH-1:5*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_0_3	=	cache_array_0[5*`DATA_WIDTH-1:4*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_0_4	=	cache_array_0[4*`DATA_WIDTH-1:3*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_0_5	=	cache_array_0[3*`DATA_WIDTH-1:2*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_0_6	=	cache_array_0[2*`DATA_WIDTH-1:1*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_0_7	=	cache_array_0[1*`DATA_WIDTH-1:0];

wire	[`DATA_WIDTH-1:0]	cache_array_1_0	=	cache_array_1[8*`DATA_WIDTH-1:7*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_1_1	=	cache_array_1[7*`DATA_WIDTH-1:6*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_1_2	=	cache_array_1[6*`DATA_WIDTH-1:5*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_1_3	=	cache_array_1[5*`DATA_WIDTH-1:4*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_1_4	=	cache_array_1[4*`DATA_WIDTH-1:3*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_1_5	=	cache_array_1[3*`DATA_WIDTH-1:2*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_1_6	=	cache_array_1[2*`DATA_WIDTH-1:1*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_1_7	=	cache_array_1[1*`DATA_WIDTH-1:0];

wire	[`DATA_WIDTH-1:0]	cache_array_2_0	=	cache_array_2[8*`DATA_WIDTH-1:7*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_2_1	=	cache_array_2[7*`DATA_WIDTH-1:6*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_2_2	=	cache_array_2[6*`DATA_WIDTH-1:5*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_2_3	=	cache_array_2[5*`DATA_WIDTH-1:4*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_2_4	=	cache_array_2[4*`DATA_WIDTH-1:3*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_2_5	=	cache_array_2[3*`DATA_WIDTH-1:2*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_2_6	=	cache_array_2[2*`DATA_WIDTH-1:1*`DATA_WIDTH];
wire	[`DATA_WIDTH-1:0]	cache_array_2_7	=	cache_array_2[1*`DATA_WIDTH-1:0];

`endif

endmodule