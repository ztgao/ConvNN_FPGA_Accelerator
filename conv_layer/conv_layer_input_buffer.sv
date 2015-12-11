// 	version 1.0 --	2015.11.29	
//				-- 	setup

`include "../../global_define.v"
module conv_layer_input_buffer
#(parameter	BUFFER_ROW			= 3,
			BUFFER_ROW_WIDTH	= 2,
			BUFFER_COL			= 8,
			BUFFER_COL_WIDTH	= 3)
(// --input
	clk,
	rst_n,
	data_in,
	col_index,
	row_index,	
	preload_cycle,
	current_state,
// --output
	data_out_bus
);

`include "../../conv_layer/conv_kernel_param.v"


input							clk;
input							rst_n;
input	[BUFFER_COL_WIDTH-1:0]	col_index;
input	[BUFFER_ROW_WIDTH-1:0]	row_index;		//	[1:0]
input	[`DATA_WIDTH-1:0]		data_in;
input	[BUFFER_ROW_WIDTH-1:0]	preload_cycle;
input	[2:0]					current_state;

output reg [BUFFER_COL*`DATA_WIDTH-1:0]	data_out_bus;

// 	data buffer bank
reg		[BUFFER_COL*`DATA_WIDTH-1:0]	buffer_array [0 : BUFFER_ROW-1];	


//	--	Buffer Array Index Decoder
always @(*)	begin
	case (row_index)
		row_index: data_out_bus	=	buffer_array[row_index];
		default:
			data_out_bus	=	{ BUFFER_COL {`DATA_WIDTH 'h0}};
	endcase
end

//	--	buffer bank 0 behavior
genvar	gv_rowIdx;

generate
	for (gv_rowIdx = 0; gv_rowIdx < BUFFER_ROW - 1; gv_rowIdx = gv_rowIdx + 1) 
	begin: bufGen
//	--	buffer bank behavior except the last row
		always @(posedge clk, negedge rst_n) begin: bufferRow
			if(!rst_n) 
				buffer_array[gv_rowIdx]	<=	{ BUFFER_COL {`DATA_WIDTH 'h0}};
			else begin
				case (current_state)
					
					STATE_IDLE: 
						buffer_array[gv_rowIdx]	<=	buffer_array[gv_rowIdx];				
														
					STATE_SHIFT: 
						buffer_array[gv_rowIdx]	<=	buffer_array[gv_rowIdx];		
							
					STATE_BIAS: 
						buffer_array[gv_rowIdx]	<=	buffer_array[gv_rowIdx];
					
					STATE_LOAD: 
						if (col_index == 'd0) 
							buffer_array[gv_rowIdx]	<=	buffer_array[gv_rowIdx+1];				
						else 
							buffer_array[gv_rowIdx]	<=	buffer_array[gv_rowIdx];
														
					default: 
						buffer_array[gv_rowIdx]	<=	buffer_array[gv_rowIdx];
				endcase
			end
		end	

	end
endgenerate

//	last buffer bank behavior
always @(posedge clk, negedge rst_n) begin: lastBufferRow
	if(!rst_n) 
		buffer_array[BUFFER_ROW-1]	<=	{ BUFFER_COL {`DATA_WIDTH 'h0}};
	else begin
		case (current_state)
			
			STATE_IDLE: 
				buffer_array[BUFFER_ROW-1]	<=	buffer_array[BUFFER_ROW-1];					
												
			STATE_SHIFT:   
				buffer_array[BUFFER_ROW-1]	<=	buffer_array[BUFFER_ROW-1];
						
			STATE_BIAS: 
				buffer_array[BUFFER_ROW-1]	<=	buffer_array[BUFFER_ROW-1];	
			
			STATE_LOAD: 
				case (col_index)
					col_index: 	buffer_array[BUFFER_ROW-1][(BUFFER_COL-col_index)*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					default:       
						buffer_array[BUFFER_ROW-1]	<=	buffer_array[BUFFER_ROW-1];
				endcase

			default: 
				buffer_array[BUFFER_ROW-1]	<=	buffer_array[BUFFER_ROW-1];
	
		endcase
	end
end

/*
//	--	buffer bank 0 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_array[0]	<=	{ BUFFER_COL {`DATA_WIDTH 'h0}};
	else begin
		case (current_state)
			
			STATE_IDLE: 
				buffer_array[0]	<=	buffer_array[0];				
												
			STATE_SHIFT: 
				buffer_array[0]	<=	buffer_array[0];		
					
			STATE_BIAS: 
				buffer_array[0]	<=	buffer_array[0];
			
			STATE_LOAD: 
				if (col_index == 0) 
					buffer_array[0]	<=	buffer_array[1];				
				else 
					buffer_array[0]	<=	buffer_array[0];
			
							
			default: 
				buffer_array[0]	<=	buffer_array[0];
		endcase
	end
end		

//	buffer bank 1 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_array[1]	<=	{ BUFFER_COL {`DATA_WIDTH 'h0}};
	else begin
		case (current_state)
								
			STATE_IDLE: 
				buffer_array[1]	<=	buffer_array[1];				
					
			STATE_SHIFT: 
				buffer_array[1]	<=	buffer_array[1];														

			STATE_BIAS: 
				buffer_array[1]	<=	buffer_array[1];				

			STATE_LOAD: 
				if (col_index == 0) 			
					buffer_array[1]	<=	buffer_array[2];				
				else 
					buffer_array[1]	<=	buffer_array[1];				
	
			default: 
				buffer_array[1]	<=	buffer_array[1];
	
		endcase
	end
end	

//	buffer bank 2 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_array[2]	<=	{ BUFFER_COL {`DATA_WIDTH 'h0}};
	else begin
		case (current_state)
			
			STATE_IDLE: 
				buffer_array[2]	<=	buffer_array[2];					
												
			STATE_SHIFT:   
				buffer_array[2]	<=	buffer_array[2];
						
			STATE_BIAS: 
				buffer_array[2]	<=	buffer_array[2];	
			
			STATE_LOAD: 
				case (col_index)
					col_index: 	buffer_array[2][(BUFFER_COL-col_index)*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					default:       
						buffer_array[2]	<=	buffer_array[2];
				endcase

			default: 
				buffer_array[2]	<=	buffer_array[2];
	
		endcase
	end
end */

`ifdef	DEBUG

//	--	just for observe

shortreal	buffer_array_ob[BUFFER_ROW][BUFFER_COL];

always @(*) begin
	for(int row = 0; row < BUFFER_ROW; row++)
		for (int col = 0; col < BUFFER_COL; col++) begin
			buffer_array_ob[row][col]=$bitstoshortreal(buffer_array[row][(BUFFER_COL-col)*`DATA_WIDTH-1 -:`DATA_WIDTH]);											
		end
end              

`endif

endmodule