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

   // Main Control signals
   // wire MemWrt;
   wire [1:0] MemRW;
   wire ALUJmp;
   wire ImmSrc;
   wire RegWrt;
   wire [1:0] BSrc;
   wire ZeroExt;
   wire [1:0] RegSrc;
   wire [1:0] RegDst;
   // ALU control signals
   wire [5:0] ALUOpr;
   wire [3:0] ALUOperation;
   wire SLBIshift8;
   wire NegA;
   wire InvB;
   // BrchCnd control signals
   wire [3:0] BrchCtrl;

   // extra halt signal
   wire Halt;

   // Data signals
   wire [15:0] Instr;

   // PC related
   reg [15:0] PC;
   wire [15:0] PCplus2;
   wire [15:0] PCDist;
   wire [15:0] PCBasedAddr;
   wire [15:0] PCBasedBrchOrJmpTarget;
   wire [15:0] RegBasedAddr;
   wire [15:0] PCNext;   

   // Branch related
   wire SF;
   wire ZF;
   wire OF;
   wire CF;
   wire BrchOrJmpSig; // branch switch
   wire [15:0] CmpResult; // Write to Rd

   // ALU related
   wire [15:0] Rs;
   wire [15:0] Rt;
   wire [15:0] Imm5;
   wire [15:0] Imm8;
   wire [15:0] OprB;
   wire cin;

   wire [15:0] ALUOut;
   // wire SF;
   // wire ZF;
   // wire OF;
   // wire CF;

   
   // Mem related
   wire [15:0] MemOut;

   // WB related
   wire [15:0] WrtData;
   wire [2:0] WrtReg;

   // IF stage
   assign RegBasedAddr = ALUOut;

   MUX_2x16 BranchOrJmpMux(.out(PCBasedBrchOrJmpTarget), .in0(PCplus2), .in1(PCBasedAddr), .ctrl(BrchOrJmpSig));

   MUX_2x16 PCMux(.out(PCNext), .in0(PCBasedBrchOrJmpTarget), .in1(RegBasedAddr), .ctrl(ALUJmp));

   assign PCplus2 = PC + 16'd2; // TODO: replace this

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         PC <= 16'b0;
      end
      else if (!Halt) begin
         PC <= PCNext;
      end
   end

   memory2c Imem (.data_out(Instr), .data_in(16'b0), .addr(PC), .enable(~Halt), .wr(1'b0), .createdump(Halt), .clk(clk), .rst(rst));

   // ID stage

   wire [4:0] Instr15_11 = Instr[15:11];
   wire [2:0] Instr10_8 = Instr[10:8];
   wire [2:0] Instr7_5 = Instr[7:5];
   wire [2:0] Instr4_2 = Instr[4:2];
   wire [4:0] Instr4_0 = Instr[4:0];
   wire [7:0] Instr7_0 = Instr[7:0];
   wire [10:0] Instr10_0 = Instr[10:0];
   wire [1:0] Instr1_0 = Instr[1:0];

   InstructionDecoder InstructionDecoder_(.MemRW(MemRW),.ALUJmp(ALUJmp),.SLBIshift8(SLBIshift8), .BrchCtrl(BrchCtrl), .ImmSrc(ImmSrc),.RegWrt(RegWrt),.BSrc(BSrc),.ZeroExt(ZeroExt),.ALUOpr(ALUOpr),.RegSrc(RegSrc),.RegDst(RegDst),.Halt(Halt),.Opcode(Instr15_11));

   // RegFile part
   regFile regFile_(.read1Data(Rs), .read2Data(Rt), .writeData(WrtData), .writeEn(RegWrt), .writeRegSel(WrtReg), .read1RegSel(Instr10_8), .read2RegSel(Instr7_5), .clk(clk), .rst(rst));

   MUX_4x3 WrtRegMux(.out(WrtReg), .in0(Instr7_5), .in1(Instr10_8), .in2(Instr4_2), .in3(3'b111), .ctrl(RegDst));

   // ImmGen part
   wire [15:0] I1_Imm;
   wire [15:0] I2_Imm;
   wire [15:0] J_Imm;
   // select signed extend or zero extend
   MUX_2x16 I1_Imm_Mux(.out(I1_Imm), .in0({{8{Instr7_0[7]}}, Instr7_0}), .in1({8'b0, Instr7_0}), .ctrl(ZeroExt));
   MUX_2x16 I2_Imm_Mux(.out(I2_Imm), .in0({{11{Instr4_0[4]}}, Instr4_0}), .in1({11'b0, Instr4_0}), .ctrl(ZeroExt));
   // J is always signed extend
   assign J_Imm={{5{Instr10_0[10]}}, Instr10_0};

   // EX stage

   wire [15:0] BrchDist;
   wire [15:0] JTypeDist;

   // calculate PCBasedAddr
   assign BrchDist = I1_Imm;
   assign JTypeDist = J_Imm;
   MUX_2x16 PCDist_Mux(.out(PCDist), .in0(BrchDist), .in1(JTypeDist), .ctrl(ImmSrc));

   assign PCBasedAddr = PCplus2 + PCDist;

   // OprB select
   assign Imm5=I2_Imm;
   assign Imm8=I1_Imm;

   MUX_4x16 OprB_Mux(.out(OprB), .in0(Rt), .in1(Imm5), .in2(Imm8), .in3(16'b0), .ctrl(BSrc));

   // ALU Control part
   ALU_Operation ALU_Operation_(.ALUOperation(ALUOperation), .NegA(NegA), .InvB(InvB), .ALUOpr(ALUOpr), .OpcodeExtention(Instr1_0));

   // ALU part   
   ALU ALU_(.ALUOut(ALUOut), .SF(SF), .ZF(ZF), .OF(OF), .CF(CF), .OprA(Rs), .OprB(OprB), .ALUOperation(ALUOperation), .SLBIshift8(SLBIshift8), .NegA(NegA), .InvB(InvB));

   // MEM stage

   // Branch Control part
   BrchCnd BrchCnd_(.BrchOrJmpSig(BrchOrJmpSig), .CmpResult(CmpResult), .BrchCtrl(BrchCtrl), .SF(SF), .ZF(ZF), .OF(OF), .CF(CF));

   // Main memory part
   memory2c Dmem (.data_out(MemOut), .data_in(Rt), .addr(ALUOut), .enable(~Halt & (MemRW[1]|MemRW[0])), .wr(MemRW[0]), .createdump(Halt), .clk(clk), .rst(rst));

   // WB stage
   MUX_4x16 WrtData_Mux(.out(WrtData), .in0(PCplus2), .in1(MemOut), .in2(ALUOut), .in3(CmpResult), .ctrl(RegSrc));

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
