/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`include "memory2c.v"
`include "BrchCnd.v"
`default_nettype none
module memory (
    input wire clk, rst,
    input wire Halt,
    input wire [1:0] MemRW,
    input wire [15:0] ALUOut,
    input wire [15:0] Rt,
    input wire [3:0] BrchCtrl,
    input wire SF, ZF, OF, CF,
    output wire [15:0] MemOut,
    output wire [15:0] CmpResult,
    output wire BrchOrJmpSig
);
    BrchCnd BrchCnd_(.BrchOrJmpSig(BrchOrJmpSig), .CmpResult(CmpResult),
        .BrchCtrl(BrchCtrl), .SF(SF), .ZF(ZF), .OF(OF), .CF(CF));

    memory2c Dmem (.data_out(MemOut), .data_in(Rt), .addr(ALUOut),
        .enable(~Halt & (MemRW[1]|MemRW[0])), .wr(MemRW[0]),
        .createdump(Halt), .clk(clk), .rst(rst));
endmodule

`default_nettype wire
