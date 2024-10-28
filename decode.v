/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`include "MUX_2x16.v"
`include "MUX_4x3.v"
`include "InstructionDecoder.v"
`include "regFile.v"
`default_nettype none
module decode (
    input wire clk, rst,
    input wire [15:0] Instr,
    input wire RegWrt,
    input wire [15:0] WrtData,
    output wire [15:0] Rs, Rt,
    output wire [15:0] I1_Imm, I2_Imm, J_Imm,
    output wire [1:0] MemRW,
    output wire ALUJmp, ImmSrc, ZeroExt,
    output wire [1:0] BSrc, RegSrc, RegDst,
    output wire [5:0] ALUOpr,
    output wire [3:0] BrchCtrl,
    output wire SLBIshift8,
    output wire Halt
);
    wire [4:0] Instr15_11 = Instr[15:11];
    wire [2:0] Instr10_8 = Instr[10:8];
    wire [2:0] Instr7_5 = Instr[7:5];
    wire [2:0] Instr4_2 = Instr[4:2];
    wire [2:0] WrtReg;

    InstructionDecoder InstructionDecoder_(.MemRW(MemRW), .ALUJmp(ALUJmp),
        .SLBIshift8(SLBIshift8), .BrchCtrl(BrchCtrl), .ImmSrc(ImmSrc),
        .RegWrt(RegWrt), .BSrc(BSrc), .ZeroExt(ZeroExt), .ALUOpr(ALUOpr),
        .RegSrc(RegSrc), .RegDst(RegDst), .Halt(Halt), .Opcode(Instr15_11));

    MUX_4x3 WrtRegMux(
        .out(WrtReg), .in0(Instr7_5), .in1(Instr10_8),
        .in2(Instr4_2), .in3(3'b111), .ctrl(RegDst)
    );

    regFile regFile_(.read1Data(Rs), .read2Data(Rt), .writeData(WrtData),
        .writeEn(RegWrt), .writeRegSel(WrtReg), .read1RegSel(Instr10_8),
        .read2RegSel(Instr7_5), .clk(clk), .rst(rst));

    assign I1_Imm = ZeroExt ? {8'b0, Instr[7:0]} : {{8{Instr[7]}}, Instr[7:0]};
    assign I2_Imm = ZeroExt ? {11'b0, Instr[4:0]} : {{11{Instr[4]}}, Instr[4:0]};
    assign J_Imm = {{5{Instr[10]}}, Instr[10:0]};
endmodule
`default_nettype wire
