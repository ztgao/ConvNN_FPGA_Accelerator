// 	version 1.0 --	2015.11.29	
//				-- 	setup

// parameter	INPUT_SIZE	=	6;
// parameter	KERNEL_SIZE	=	2;
// parameter	OUTPUT_SIZE	=	3;

// parameter	TOTAL_FEATURE	=	4;
// parameter	FEATURE_WIDTH	=	2;

// parameter	ROW_WIDTH		=	3;

function integer logb2;
    input integer n;
	begin
      n = n-1;
      for(logb2=0; n>0; logb2=logb2 + 1)
        n = n>>1;
    end
 endfunction