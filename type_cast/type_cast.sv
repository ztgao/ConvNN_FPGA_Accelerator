// version 1.0 -- setup
// Description:

program type_cast;

parameter	WIDTH	=	32;
parameter	DEPTH	=	64;

bit		[WIDTH-1:0]		float32_list[DEPTH];
shortreal				real_list[DEPTH];

int						fp_r_real;
int						fp_w_float32;
int						r_idx;
int 					w_idx;
int 					a;

initial begin
	fp_r_real		=	$fopen("./real_list.txt","r");
	fp_w_float32	=	$fopen("./float32_list.txt","w");
	
	r_idx			=	0;
	w_idx			=	0;
	
	while(!$feof(fp_r_real)) begin
		a = $fscanf(fp_r_real,"%f\n",real_list[r_idx]);		
		float32_list[r_idx] =	$shortrealtobits(real_list[r_idx]);
		r_idx++;
	end
	
	for(w_idx=0; w_idx < r_idx; w_idx++) begin
		$fdisplay(fp_w_float32,"%b",float32_list[w_idx]);
	end
	
	$fclose(fp_r_real);
	$fclose(fp_w_float32);
	
	$stop;

end
	
endprogram
	
	