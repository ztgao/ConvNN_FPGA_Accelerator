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



input					clk;
input					rst_n;
input					enable;

reg		[2:0]			current_state;

reg		[2:0]			next_state;

reg		[2:0]			last_state;

reg		[4:0]			read_index;
reg		[1:0]			shift_idx;



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

always @(current_state, read_index, shift_idx) begin
	case (current_state)	
		
		INIT: begin
				next_state	=	PRELOAD;
		end
		
		PRELOAD: begin
			if (preload_finish)
				next_state	=	SHIFT_ROW_0;
			else	
				next_state	=	PRELOAD;
		end
		
		SHIFT_ROW_0: begin
			if (shift_idx	== 	2'b10)
				next_state	=	SHIFT_ROW_1;
			else
				next_state	=	SHIFT_ROW_0;
		end
		
		SHIFT_ROW_1: begin
			if (shift_idx	== 	2'b10)
				next_state	=	SHIFT_ROW_2;
			else
				next_state	=	SHIFT_ROW_1;			
		end
		
		SHIFT_ROW_2: begin
			if (shift_idx	== 	2'b10)
				next_state	=	SHIFT_ROW_0;
			else
				next_state	=	SHIFT_ROW_2;				
		end	
		
		IDLE: begin
			if (!idle)
				next_state 	= 	SHIFT_ROW_0;
			else
				next_state 	=	IDLE;
		end
								
		default: begin
			next_state	=	INIT;
		end
	endcase
end

//	external_rom_addr		
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		external_rom_addr		<=	6'b0;
	end
	else begin
		case (current_state)
			
			INIT: begin
				external_rom_addr	<=	6'b0;
			end
			
			PRELOAD: begin
				external_rom_addr	=	external_rom_addr + 1'b1;
			end
			
			SHIFT_ROW_0: begin
//				if (shift_idx == 2'b10)
				if (shift_idx == 2'b10 || read_index == 5'b0111)
					external_rom_addr	<=	external_rom_addr + 1'b1;
				else
					external_rom_addr	<=	external_rom_addr;
			end
			
			SHIFT_ROW_1: begin
				external_rom_addr	<=	external_rom_addr + 1'b1;
			end
			
			SHIFT_ROW_2: begin
				external_rom_addr	<=	external_rom_addr + 1'b1;
			end	

			IDLE: begin
				external_rom_addr	<=	external_rom_addr;
			end
				
			default: begin
				external_rom_addr	<=	external_rom_addr;
			end
		endcase
	end
end	

//	bit index in each bank
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		read_index <=	5'b0;
	end
	else begin
		case (current_state)
			
			INIT: begin
				read_index	<=	5'b0;
			end
			
			PRELOAD: begin
				if (read_index == 5'd23)
					read_index	<=	5'b0;
				else
					read_index	<=	read_index + 1'b1;
			end
			
			SHIFT_ROW_0: begin
				if (shift_idx == 2'b10)
					read_index	<=	read_index + 1'b1;
				else if (read_index == 5'b0111)
					read_index	<=	5'b0;
				else
					read_index	<=	read_index;					
			end
			
			SHIFT_ROW_1: begin
				if (read_index == 5'b0111)
					read_index	<=	5'b0;
				else
					read_index	<=	read_index + 1'b1;
			end
			
			SHIFT_ROW_2: begin
				if (read_index == 5'b0111)
					read_index	<=	5'b0;
				else
					read_index	<=	read_index + 1'b1;
			end
			
			IDLE: begin
				read_index	<=	read_index;
			end
			
			default: begin
				read_index	<=	read_index;
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
			
			PRELOAD: begin
				shift_idx	<=	2'b0;
			end
			
			SHIFT_ROW_0: begin
				if (shift_idx == 2'b10)
					shift_idx	<=	2'b0;
				else
					shift_idx	<=	shift_idx + 2'b1;
			end
			
			SHIFT_ROW_1: begin
				if (shift_idx == 2'b10)
					shift_idx	<=	2'b0;
				else
					shift_idx	<=	shift_idx + 2'b1;
			end
			
			SHIFT_ROW_2: begin
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