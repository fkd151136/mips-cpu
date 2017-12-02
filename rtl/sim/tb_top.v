`timescale 1ns / 1ps
module tb_top(

	      );
   reg resetn;
   reg clk;
   wire [7 :0] num_csn;
   wire [6 :0] num_a_g;
    initial
        begin
            clk = 1'b0;
	        resetn = 1'b0;
	        #700;
	        resetn = 1'b1;
        end
   always #5 clk=~clk;
   soc_lite_top soc_lite(
			 .resetn (resetn), 
			 .clk    (clk   ),
      
			 //------gpio-------
			 .num_csn(num_csn),
			 .num_a_g(num_a_g),
			 .led    (),
			 .switch () 
			 );
   
endmodule
