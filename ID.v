`timescale 1ns / 1ps
`define F 31:0
`define I16 15:0
`define I26 25:0
`define rs 25:21
`define rt 20:16
`define rd 15:11

module IDandWB(input clk, reset,
	input [`F] IR_D, PC4_D,
	output [`F] IR_E, RS_E, RT_E, EXT_E, PC8_E, b_j_jr_tgt,
	output PC_sel,
	input[`F] IR_W, PC8_W, ALUOUT_W, DMOUT_W,
	output [`F] Wdata,
	input[2:0] Forward_RS_D, Forward_RT_D,
	input[`F] ALUOUT_M_out, PC8_M_out);
	//ID阶段变量声明
	wire[`F] Rdata1,Rdata2,EXTOUT;
	wire[2:0] AB_CMPOUT;
	wire[2:0] A0_CMPOUT;
	wire[1:0] b_j_jr_sel;
	wire EXT_sel;
	wire[`F] MF_RS_D_out;
	wire[`F] MF_RT_D_out;
	//WB阶段变量声明
	wire[1:0] Wreg_sel, Wdata_sel;
	wire[4:0] Wreg;
	wire GRF_WE;
	//ID阶段执行
MUX_FORWARD_D MF_RS_D(Rdata1, ALUOUT_M_out, Wdata, PC8_M_out, PC8_W, Forward_RS_D, MF_RS_D_out);//这里的PC8_W不用加后缀_out
MUX_FORWARD_D MF_RT_D(Rdata2, ALUOUT_M_out, Wdata, PC8_M_out, PC8_W, Forward_RT_D, MF_RT_D_out);//传进来的就是PC8_W
GRF _GRF(clk, reset, IR_D[`rs], IR_D[`rt], Wreg, Wdata, GRF_WE, Rdata1, Rdata2);
EXT _EXT(IR_D[`I16], EXT_sel, EXTOUT);
CMP _CMP_AB(MF_RS_D_out, MF_RT_D_out, AB_CMPOUT);
CMP _CMP_A0(MF_RS_D_out, 0, A0_CMPOUT);
NPC _NPC(PC4_D, IR_D[`I26], MF_RS_D_out, b_j_jr_sel, b_j_jr_tgt);
CTRL_D _CTRL_D(IR_D, AB_CMPOUT, A0_CMPOUT, EXT_sel, b_j_jr_sel, PC_sel);
ADDER _PC4plus4(PC4_D, PC8_E);
	assign IR_E=IR_D;
	assign EXT_E=EXTOUT;
	assign RS_E=Rdata1;
	assign RT_E=Rdata2;
	//WB阶段执行
	mux_Wreg _mux_Wreg(IR_W[`rt], IR_W[`rd], Wreg_sel, Wreg);
	mux_Wdata _mux_Wdata(ALUOUT_W, DMOUT_W, PC8_W, Wdata_sel, Wdata);
	CTRL_W _CTRL_W(IR_W, Wreg_sel, Wdata_sel, GRF_WE);
endmodule
