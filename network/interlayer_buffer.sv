// 	version 1.0 --	2015.12.16
//				-- 	setup

`include "../../global_define.v"

module	interlayer_buffer #(
	parameter	
	BUFFER_DEPTH	=	4096,
	INPUT_SIZE		=	12,
	TOTAL_FEATURE	=	20
	)
(
//--input
	clk,
	rst_n,
	data_i,
	valid_i,
	feature_row,
	feature_idx,
//	rd,
//	addr_rd,
//	wr,
	
//--output
	data_o
);

`include "../../network/network_param.v"

parameter	STATE_WR_READY	=	2'd0;
parameter	STATE_WR		=	2'd1;
parameter	STATE_RD_READY	=	2'd2;
parameter	STATE_RD		=	2'd3;

parameter	ROW_WIDTH		=	logb2(24);


parameter	ADDR_WIDTH		=	logb2(BUFFER_DEPTH);
parameter	ADDR_CH_BIAS	=	INPUT_SIZE * INPUT_SIZE;
parameter	ADDR_ROW_BIAS	=	INPUT_SIZE;

localparam	FEATURE_WIDTH	=	logb2(TOTAL_FEATURE);


input		clk;
input		rst_n;
input		valid_i;
input		[INPUT_SIZE * `DATA_WIDTH-1:0]	data_i;

input		[FEATURE_WIDTH-1:0]	feature_idx;
input		[ROW_WIDTH-1:0]		feature_row;

output		[`DATA_WIDTH-1:0]	data_o;

reg			[ADDR_WIDTH-1:0]	addr_wr;
reg			[ADDR_WIDTH-1:0]	addr_ch_bias;
reg			[ADDR_WIDTH-1:0]	addr_col;
reg			[ADDR_WIDTH-1:0]	addr_row_bias;
reg			[ADDR_WIDTH-1:0]	addr_row;

reg			[1:0]				cState;
reg			[1:0]				nState;

wire		lastFeature;
wire		lastCol;
wire		lastRow;


assign		lastFeature	=	(feature_idx == TOTAL_FEATURE - 1);
assign		lastCol		=	(addr_col == INPUT_SIZE - 1);
assign		lastRow		=	(feature_row == 2 * INPUT_SIZE - 1);

reg			we;

reg			[`DATA_WIDTH-1:0]	data_wr;

always @(*) begin
	case (addr_col)
		addr_col:
			data_wr	=	data_i[(INPUT_SIZE - addr_col) * `DATA_WIDTH-1 -: `DATA_WIDTH];
		default:
			data_wr	=	data_wr;
	endcase
end



always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		cState	<=	STATE_WR_READY;
	else
		cState	<=	nState;
end

always @(*) begin
	case (cState)
		
		STATE_WR_READY: 
			if(valid_i)
				nState	=	STATE_WR;
			else
				nState	=	STATE_WR_READY;
		
		STATE_WR:
			if (lastCol)
				nState	=	STATE_WR_READY;
			else
				nState	=	STATE_WR;
						
		default:
			nState	=	cState;
			
	endcase
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		addr_wr	<=	'd0;
	else
		case (cState)
			
			STATE_WR_READY:
				if(valid_i)
					addr_wr	<=	addr_col + addr_row_bias + addr_ch_bias;
				else
					addr_wr	<=	'd0;
					
			STATE_WR:
				if(lastCol)
					addr_wr	<=	'd0;
				else
					addr_wr	<=	addr_wr + 'd1; 
		
			STATE_RD_READY:
				addr_wr	<=	'd0;
			
			STATE_RD:
				addr_wr	<=	'd0;
				
			default:
				addr_wr	<=	addr_wr;
				
		endcase		
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		addr_col	<=	'd0;
	else
		case (cState)
			
			STATE_WR_READY:
				addr_col	<=	'd0;
			
			STATE_WR:
				if (lastCol)
					addr_col	<=	'd0; 
				else
					addr_col	<=	addr_col + 'd1;	
		
			STATE_RD_READY:
				addr_col	<=	'd0;
			
			STATE_RD:
				addr_col	<=	'd0;
				
			default:
				addr_col	<=	addr_col;
				
		endcase		
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		addr_ch_bias	<=	'd0;
	else
		case (cState)
			
			STATE_WR_READY:
				if (valid_i && feature_idx == 'd0)
					addr_ch_bias	<=	'd0;
				else
					addr_ch_bias	<=	addr_ch_bias;
			
			STATE_WR:
				if(lastCol)
					if(lastFeature)
						addr_ch_bias	<=	'd0;
					else
						addr_ch_bias	<=	addr_ch_bias + ADDR_CH_BIAS;
				else
					addr_ch_bias	<=	addr_ch_bias;
					
		
			STATE_RD_READY:
				addr_ch_bias	<=	addr_ch_bias;
			
			STATE_RD:
				addr_ch_bias	<=	addr_ch_bias;
			default:
				addr_ch_bias	<=	addr_ch_bias;
				
		endcase		
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		addr_row_bias	<=	'd0;
	else
		case (cState)
			
			STATE_WR_READY:
					addr_row_bias	<=	addr_row_bias;
			
			STATE_WR:
				if(lastCol && lastFeature)
					if(lastRow)
						addr_row_bias	<=	'd0;
					else
						addr_row_bias	<=	addr_row_bias + ADDR_ROW_BIAS;
				else
					addr_row_bias	<=	addr_row_bias;
					
		
			STATE_RD_READY:
				addr_row_bias	<=	addr_row_bias;
			
			STATE_RD:
				addr_row_bias	<=	addr_row_bias;
			
			default:
				addr_row_bias	<=	addr_row_bias;
				
		endcase		
end

/* always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 

	else
		case (cState)
			
			STATE_WR_READY:
			
			STATE_WR:
						
			STATE_RD_READY:
			
			STATE_RD:
			
			default:
				
		endcase		
end */

always @(*) begin
	we 	=	(cState == STATE_WR);
end


`ifdef DEBUG

shortreal data_wr_ob;
always @(*) begin
	data_wr_ob	=	$bitstoshortreal(data_wr[`DATA_WIDTH-1:0]);
end

`endif
	

 ram_4kx32_sim U_ram_4kx32_sim_0(
//--input
	.clk	(clk),
	.data_i	(data_wr),
	.addr	(addr_wr),
	.we		(we),
//--output  
	.data_o (data_o)
);

/*
ram_4kx32_sim U_ram_4kx32_sim_1(
//--input
	.clk	(clk),
	.data_i	(data_i),
	.addr	(addr),
	.we		(we),
//--output  
	.data_o (data_o)
); */


endmodule