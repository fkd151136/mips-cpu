`timescale 1ns / 1ps
`define F 31:0

module IF(input clk1, clk2,reset,PC_en,PC_sel,int_PC_sel, ERET_PC_sel,
			 input [`F] b_j_jr_tgt, EPC,
			 output[`F] IR_D,PC4_D);
	 
	 wire[`F] NPC, pc, im_pc;
	 mux_PC _mux_PC(PC4_D, b_j_jr_tgt, EPC, ERET_PC_sel, int_PC_sel, PC_sel, NPC);
	 PC _PC(clk1, reset, PC_en, int_PC_sel, ERET_PC_sel, NPC, pc);
	 ADDER _PCplus4(pc, PC4_D);
	 assign im_pc=pc-32'h0000_3000;

	 //cpt_1227_1006 _IM(clk2, 1'b0, im_pc[12:2], 32'b0, IR_D);			//calculator 3-0λ��ȥ7-4λ
	 //cpt_1229_1905 _IM(clk2, 1'b0, im_pc[12:2], 32'b0, IR_D);			//calculator(���������Ż�) 3-0λ��ȥ7-4λ
	 //cpt_1230_1201 _IM(clk2, 1'b0, im_pc[12:2], 32'b0, IR_D);			//calculator(���������Ż�) 7-4λ��ȥ3-0λ
	 //counter_1227_1040 _IM(clk2, 1'b0, im_pc[12:2], 32'b0, IR_D);		//counter
	 //counter_1229_1846 _IM(clk2, 1'b0, im_pc[12:2], 32'b0, IR_D);		//counter(���������Ż�)
	 //urat_1226_2355 _IM(clk2, 1'b0, im_pc[12:2], 32'b0, IR_D);		//ʵ��uart����
	 //uart_1229_0133 _IM(clk2, 1'b0, im_pc[12:2], 32'b0, IR_D);		//ʵ��uart����(���������Ż�)
	 p8_up_1_1503 _IM(clk2, 1'b0, im_pc[12:2], 32'b0, IR_D);          //���ϲ��Ե�һ��
	 //p8_up_2_1533 _IM(clk2, 1'b0, im_pc[12:2], 32'b0, IR_D);          //���ϲ��Եڶ���
endmodule
