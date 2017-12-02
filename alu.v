`timescale 1ns / 1ps
`include <head.h>

module ALU(input [`shamt] IR_E,
			  input [`F] A, B,
			  input [3:0] ALU_OP,
			  output[`F] C);
	 
	 wire[31:0] c0, c1;
	 wire[63:0] sra_srav_temp, sra_ans, srav_ans;  //sra_srav_temp:��ʱ�洢B��ֵ����32λΪ������չ, ������Ϊsra��srav����λ�����
	 
	 assign c0=A+B;	
	 assign c1=A-B; 
	 assign sra_srav_temp[63:32]={32{B[31]}};
	 assign sra_srav_temp[31:0]=B;
	 assign sra_ans=sra_srav_temp >> IR_E[`shamt];
	 assign srav_ans=sra_srav_temp >> A[4:0];
	 
	 assign C=(ALU_OP == 1)?c1:			//��
                 (ALU_OP == 2)?(A&B):		//��
                 (ALU_OP == 3)?(A|B):		//��
                 (ALU_OP == 4)?(A^B):		//���
                 (ALU_OP == 5)?~(A|B):		//���
                 (ALU_OP == 6)?32'b1:				//��1
                 (ALU_OP == 7)?32'b0:				//��0
                 (ALU_OP == 8)?(B << 16):	//���ظ�λ
                 (ALU_OP == 9)?(B << IR_E[`shamt]):			//sll
                 (ALU_OP == 10)?(B >> IR_E[`shamt]):		//srl
                 (ALU_OP == 11)?(B << A[4:0]):				//sllv
                 (ALU_OP == 12)?(B >> A[4:0]):				//srlv
                 (ALU_OP == 13)?(sra_ans[`F]):	//sra
                 (ALU_OP == 14)?(srav_ans[`F]):c0;		//��
				 
endmodule
