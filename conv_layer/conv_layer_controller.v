//	version	1.0	--	setup
//	Description:

module conv_layer_controller(
	
	//--input
	clk,
	rst_n,
	enable,
	
	//--output
	input_interface_cmd,
	kernel_array_cmd,
	output_inteface_cmd,
);

parameter	WIDTH				=	32;
parameter	KERNEL_SIZE			=	3;	//3x3
parameter	IMAGE_SIZE			=	8;
parameter	ARRAY_SIZE			=	6;

parameter	ADDR_WIDTH			=	6;
parameter	ROM_DEPTH			=	64;

parameter	INIT				=	3'd0;
parameter	PRELOAD				=	3'd1;	
parameter	SHIFT_ROW_0			=	3'd2;
parameter	SHIFT_ROW_1			=	3'd3;
parameter	SHIFT_ROW_2			=	3'd4;
parameter	BIAS				=	3'd5;
parameter	LOAD				=	3'd6;
parameter	IDLE				=	3'd7;

parameter	ACK_IDLE			=	2'd0;
parameter	ACK_PRELOAD_FIN		=	2'd1;
parameter	ACK_SHIFT_FIN		=	2'd2;
parameter	ACK_LOAD_FIN		=	2'd3;

parameter	CMD_IDLE			=	2'd0;
parameter	CMD_PRELOAD_START	=	2'd1;
parameter	CMD_SHIFT_START		=	2'd2;
parameter	CMD_LOAD_START		=	2'd3;

input					clk;
input					rst_n;
input					enable;

reg		[1:0]			input_interface_cmd;
wire	[1:0]			input_interface_ack;

reg		[1:0]			weight_num;


//	--	
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
		input_interface_cmd	<=	2'd0; // CMD_IDLE
	else if ( enable )
		input_interface_cmd	<=	CMD_PRELOAD_START;
	else if ( input_interface_ack == ACK_PRELOAD_FIN )
		input_interface_cmd	<=	CMD_SHIFT_START;
	else if ( input_interface_ack == ACK_SHIFT_FIN )
		if ( weight_num == TOTAL_WEIGHT )
			input_interface_cmd	<=	CMD_LOAD_START;
		else
			input_interface_cmd	<=	CMD_SHIFT_START;
	else
		input_interface_cmd	<=	CMD_IDLE;
end

//	--	
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 	
		weight_num	<=	2'd0;
	else if ()
		weight_num	<=	weight_num	+ 1'd1;
	else
		weight_num	<=	weight_num;
end
		