// 	version 1.0 --	2015.11.29	
//				-- 	setup

`include "../../global_define.v"
module conv_layer_input_buffer(
// --input
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

output reg [IMAGE_SIZE*`DATA_WIDTH-1:0]	data_out_bus;

// 	data buffer bank
reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	buffer_array_0;	
reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	buffer_array_1;	
reg		[IMAGE_SIZE*`DATA_WIDTH-1:0]	buffer_array_2;	

//	--	Buffer Array Index Decoder
always @(row_index, buffer_array_0, buffer_array_1, buffer_array_2)	begin
	case (row_index)
		0:	data_out_bus	=	buffer_array_0;
		1:	data_out_bus	=	buffer_array_1;
		2:	data_out_bus	=	buffer_array_2;
		default:
			data_out_bus	=	{ IMAGE_SIZE {`DATA_WIDTH 'h0}};
	endcase
end


//	--	buffer bank 0 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_array_0	<=	{ IMAGE_SIZE {`DATA_WIDTH 'h0}};
	else begin
		case (current_state)
			
			STATE_IDLE: 
				buffer_array_0	<=	buffer_array_0;				
						
			STATE_PRELOAD: 
				if (preload_cycle < BUFFER_ROW) begin				
					if (col_index == BUFFER_COL) 	//	actually larger than IMAGE_SIZE-1 to get an extra cycle
						buffer_array_0	<=	buffer_array_1;
					else 
						buffer_array_0	<=	buffer_array_0;
				end
				else
					buffer_array_0	<=	buffer_array_0;	
						
			STATE_SHIFT: 
				buffer_array_0	<=	buffer_array_0;		
					
			STATE_BIAS: 
				buffer_array_0	<=	buffer_array_0;
			
			STATE_LOAD: 
				if (col_index == 0) 
					buffer_array_0	<=	buffer_array_1;				
				else 
					buffer_array_0	<=	buffer_array_0;
			
							
			default: 
				buffer_array_0	<=	buffer_array_0;
		endcase
	end
end		

//	buffer bank 1 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_array_1	<=	{ IMAGE_SIZE {`DATA_WIDTH 'h0}};
	else begin
		case (current_state)
								
			STATE_IDLE: 
				buffer_array_1	<=	buffer_array_1;				

			STATE_PRELOAD: begin
				if (preload_cycle < BUFFER_ROW) begin			
					if (col_index == BUFFER_COL) 			
						buffer_array_1	<=	buffer_array_2;					
					else 
						buffer_array_1	<=	buffer_array_1;
					
				end
				else
					buffer_array_1	<=	buffer_array_1;	
			end			
			
			STATE_SHIFT: 
				buffer_array_1	<=	buffer_array_1;														

			STATE_BIAS: 
				buffer_array_1	<=	buffer_array_1;				

			STATE_LOAD: 
				if (col_index == 0) 			
					buffer_array_1	<=	buffer_array_2;				
				else 
					buffer_array_1	<=	buffer_array_1;				

					
		
			default: 
				buffer_array_1	<=	buffer_array_1;
	
		endcase
	end
end	

//	buffer bank 2 behavior
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		buffer_array_2	<=	{ IMAGE_SIZE {`DATA_WIDTH 'h0}};
	else begin
		case (current_state)
			
			STATE_IDLE: 
				buffer_array_2	<=	buffer_array_2;					
			
			STATE_PRELOAD: 
				case (col_index)
					0: 	buffer_array_2[8*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					1: 	buffer_array_2[7*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					2: 	buffer_array_2[6*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					3: 	buffer_array_2[5*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					4: 	buffer_array_2[4*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					5: 	buffer_array_2[3*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					6: 	buffer_array_2[2*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					7: 	buffer_array_2[1*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					default:       
						buffer_array_2	<=	buffer_array_2;					
				endcase
									
			STATE_SHIFT:   
				buffer_array_2	<=	buffer_array_2;
						
			STATE_BIAS: 
				buffer_array_2	<=	buffer_array_2;	
			
			STATE_LOAD: 
				case (col_index)
					0: 	buffer_array_2[8*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					1: 	buffer_array_2[7*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					2: 	buffer_array_2[6*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					3: 	buffer_array_2[5*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					4: 	buffer_array_2[4*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					5: 	buffer_array_2[3*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					6: 	buffer_array_2[2*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					7: 	buffer_array_2[1*`DATA_WIDTH-1 -: `DATA_WIDTH]	<=	data_in;
					default:       
						buffer_array_2	<=	buffer_array_2;
				endcase

			default: 
				buffer_array_2	<=	buffer_array_2;
	
		endcase
	end
end

`ifdef	DEBUG

//	--	just for observe

shortreal	buffer_array_ob_0[IMAGE_SIZE];
shortreal	buffer_array_ob_1[IMAGE_SIZE];
shortreal	buffer_array_ob_2[IMAGE_SIZE];

always @(*) begin
	buffer_array_ob_0[0]	=	$bitstoshortreal(buffer_array_0[8*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_0[1]	=	$bitstoshortreal(buffer_array_0[7*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_0[2]	=	$bitstoshortreal(buffer_array_0[6*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_0[3]	=	$bitstoshortreal(buffer_array_0[5*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_0[4]	=	$bitstoshortreal(buffer_array_0[4*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_0[5]	=	$bitstoshortreal(buffer_array_0[3*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_0[6]	=	$bitstoshortreal(buffer_array_0[2*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_0[7]	=	$bitstoshortreal(buffer_array_0[1*`DATA_WIDTH-1 -:`DATA_WIDTH]);
												
	buffer_array_ob_1[0]	=	$bitstoshortreal(buffer_array_1[8*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_1[1]	=	$bitstoshortreal(buffer_array_1[7*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_1[2]	=	$bitstoshortreal(buffer_array_1[6*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_1[3]	=	$bitstoshortreal(buffer_array_1[5*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_1[4]	=	$bitstoshortreal(buffer_array_1[4*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_1[5]	=	$bitstoshortreal(buffer_array_1[3*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_1[6]	=	$bitstoshortreal(buffer_array_1[2*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_1[7]	=	$bitstoshortreal(buffer_array_1[1*`DATA_WIDTH-1 -:`DATA_WIDTH]);
															
	buffer_array_ob_2[0]	=	$bitstoshortreal(buffer_array_2[8*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_2[1]	=	$bitstoshortreal(buffer_array_2[7*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_2[2]	=	$bitstoshortreal(buffer_array_2[6*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_2[3]	=	$bitstoshortreal(buffer_array_2[5*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_2[4]	=	$bitstoshortreal(buffer_array_2[4*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_2[5]	=	$bitstoshortreal(buffer_array_2[3*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_2[6]	=	$bitstoshortreal(buffer_array_2[2*`DATA_WIDTH-1 -:`DATA_WIDTH]);
	buffer_array_ob_2[7]	=	$bitstoshortreal(buffer_array_2[1*`DATA_WIDTH-1 -:`DATA_WIDTH]);
end              

`endif

endmodule