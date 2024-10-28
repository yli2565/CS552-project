/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`include "MUX_4x16.v"
`include "ALU_Operation.v"
`include "ALU.v"
`default_nettype none
module execute (
    input wire [15:0] Rs, Rt,
    input wire [15:0] I1_Imm, I2_Imm,
    input wire [1:0] BSrc,
    input wire [5:0] ALUOpr,
    input wire [1:0] Instr1_0,
    input wire SLBIshift8,
    output wire [15:0] ALUOut,
    output wire SF, ZF, OF, CF
);
    wire [15:0] OprB;
    wire [3:0] ALUOperation;
    wire NegA, InvB;

    MUX_4x16 OprB_Mux(.out(OprB), .in0(Rt), .in1(I2_Imm), .in2(I1_Imm), .in3(16'b0), .ctrl(BSrc));

    ALU_Operation ALU_Operation_(.ALUOperation(ALUOperation), .NegA(NegA),
        .InvB(InvB), .ALUOpr(ALUOpr), .OpcodeExtention(Instr1_0));

    ALU ALU_(.ALUOut(ALUOut), .SF(SF), .ZF(ZF), .OF(OF), .CF(CF),
        .OprA(Rs), .OprB(OprB), .ALUOperation(ALUOperation),
        .SLBIshift8(SLBIshift8), .NegA(NegA), .InvB(InvB));
endmodule
`default_nettype wire
