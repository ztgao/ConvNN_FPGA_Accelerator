// 	global marco definition
//	version 1.0	--	setup


//	--	Compiler Option
`define		RTL_SIMULATION
`define		DEBUG


//	--	Global Parameters

`define		FLOAT32_ONE			32'h3F800000
`define		FLOAT32_NEG_INF		32'hFF7FFFFF		//	infinite negative value (used in pipeline comparator)

`define		DATA_WIDTH			32		//	calculation and storage referring to IEEE-754 single floating point (32 bit)
`define		EXT_ADDR_WIDTH		12		//	1 MB
`define		EXT_RAM_DEPTH		4096	//	5x28x28

//`define		

