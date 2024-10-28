/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`include "MUX_2x16.v"
`include "MUX_4x16.v"
`include "MUX_4x3.v"
`include "memory2c.v"
`include "regFile.v"
`include "InstructionDecoder.v"
`include "BrchCnd.v"
`include "ALU_Operation.v"
`include "ALU.v"
`include "Adder16.v"

`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "wb.v"
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;

   output reg err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

    // Interconnect wires
    wire [15:0] Instr, PCplus2, Rs, Rt, ALUOut, MemOut, WrtData;
    wire [15:0] I1_Imm, I2_Imm, J_Imm;
    wire [15:0] CmpResult;
    wire [1:0] MemRW, BSrc, RegSrc, RegDst;
    wire [5:0] ALUOpr;
    wire [3:0] BrchCtrl;
    wire ALUJmp, ImmSrc, RegWrt, ZeroExt, SLBIshift8;
    wire SF, ZF, OF, CF, BrchOrJmpSig, Halt;

    // PCBased address calculation
    wire [15:0] PCDist = ImmSrc ? J_Imm : I1_Imm;
    wire [15:0] PCBasedAddr = PCplus2 + PCDist;

    // Module instantiations
    fetch fetch_ (
        .clk(clk), .rst(rst), .Halt(Halt), .ALUJmp(ALUJmp),
        .BrchOrJmpSig(BrchOrJmpSig), .PCBasedAddr(PCBasedAddr),
        .RegBasedAddr(ALUOut), .Instr(Instr), .PCplus2(PCplus2)
    );

    decode decode_ (
        .clk(clk), .rst(rst), .Instr(Instr), .RegWrt(RegWrt),
        .WrtData(WrtData), .Rs(Rs), .Rt(Rt),
        .I1_Imm(I1_Imm), .I2_Imm(I2_Imm), .J_Imm(J_Imm),
        .MemRW(MemRW), .ALUJmp(ALUJmp), .ImmSrc(ImmSrc),
        .ZeroExt(ZeroExt), .BSrc(BSrc), .RegSrc(RegSrc),
        .RegDst(RegDst), .ALUOpr(ALUOpr), .BrchCtrl(BrchCtrl),
        .SLBIshift8(SLBIshift8), .Halt(Halt)
    );

    execute execute_ (
        .Rs(Rs), .Rt(Rt), .I1_Imm(I1_Imm), .I2_Imm(I2_Imm),
        .BSrc(BSrc), .ALUOpr(ALUOpr), .Instr1_0(Instr[1:0]),
        .SLBIshift8(SLBIshift8), .ALUOut(ALUOut),
        .SF(SF), .ZF(ZF), .OF(OF), .CF(CF)
    );

    memory memory_ (
        .clk(clk), .rst(rst), .Halt(Halt), .MemRW(MemRW),
        .ALUOut(ALUOut), .Rt(Rt), .BrchCtrl(BrchCtrl),
        .SF(SF), .ZF(ZF), .OF(OF), .CF(CF),
        .MemOut(MemOut), .CmpResult(CmpResult),
        .BrchOrJmpSig(BrchOrJmpSig)
    );

    wb wb_ (
        .RegSrc(RegSrc), .PCplus2(PCplus2), .MemOut(MemOut),
        .ALUOut(ALUOut), .CmpResult(CmpResult), .WrtData(WrtData)
    );

    // Error handling (you can expand this based on your needs)
    always @(*) begin
        err = 1'b0;
    end
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
