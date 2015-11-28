

//	--	General Convolutional Layer Parammeters

parameter	KERNEL_SIZE			=	3;	//3x3
parameter	INPUT_SIZE			=	8;
parameter	STRDIE				=	1;

parameter	ARRAY_SIZE			=	INPUT_SIZE - KERNEL_SIZE + 1;
//parameter	BUFFER_BANK
parameter	SHIFT_CYCLE			=	2'd3;

// parameter	INIT				=	3'd0;
// parameter	PRELOAD				=	3'd1;	
// parameter	SHIFT_ROW_0			=	3'd2;
// parameter	SHIFT_ROW_1			=	3'd3;
// parameter	SHIFT_ROW_2			=	3'd4;
// parameter	BIAS				=	3'd5;
// parameter	LOAD				=	3'd6;
// parameter	IDLE				=	3'd7;

//	--	Command and Acknowledge Signal

parameter	ACK_IDLE			=	2'd0;
parameter	ACK_PRELOAD_FIN		=	2'd1;
parameter	ACK_SHIFT_FIN		=	2'd2;
parameter	ACK_LOAD_FIN		=	2'd3;

parameter	CMD_IDLE			=	2'd0;
parameter	CMD_PRELOAD_START	=	2'd1;
parameter	CMD_SHIFT_START		=	2'd2;
parameter	CMD_LOAD_START		=	2'd3;

//	--	Condition and Stage in FSM

parameter	TOTAL_WEIGHT		=	4;
//parameter	TOTAL_		=	ARRAY_SIZE;

// parameter	STAGE_INIT			=	3'd0;
// parameter	STAGE_PRELOAD		=	3'd1;	
// parameter	STAGE_SHIFT			=	3'd2;
// parameter	STAGE_LOAD			=	3'd3;
//parameter	STAGE_IDLE			=	3'd7;

//	--	Buffer Parammeters

parameter	BUFFER_CMD_IDLE		=	2'd0;
parameter	BUFFER_CMD_LOAD		=	2'd1;
parameter	BUFFER_CMD_READ		=	2'd2;

parameter	BUFFER_ACK_LOAD_FIN	=	1'd1;