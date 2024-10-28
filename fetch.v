/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`include "MUX_2x16.v"
`include "Adder16.v"
`include "memory2c.v"
`default_nettype none
module fetch (
    input wire clk, rst,
    input wire Halt,
    input wire ALUJmp,
    input wire BrchOrJmpSig,
    input wire [15:0] PCBasedAddr,
    input wire [15:0] RegBasedAddr,
    output wire [15:0] Instr,
    output wire [15:0] PCplus2
);
    reg [15:0] PC;
    wire [15:0] PCNext;
    wire [15:0] PCBasedBrchOrJmpTarget;

    MUX_2x16 BranchOrJmpMux(.out(PCBasedBrchOrJmpTarget), .in0(PCplus2), .in1(PCBasedAddr), .ctrl(BrchOrJmpSig));
    MUX_2x16 PCMux(.out(PCNext), .in0(PCBasedBrchOrJmpTarget), .in1(RegBasedAddr), .ctrl(ALUJmp));
    Adder16 PCAdder(.InputA(PC), .InputB(16'd2), .CarryIn(1'b0), .Sum(PCplus2), .CarryOut());

    always @(posedge clk or posedge rst) begin
        if (rst) PC <= 16'b0;
        else if (!Halt) PC <= PCNext;
    end

    memory2c Imem (.data_out(Instr), .data_in(16'b0), .addr(PC), .enable(~Halt), 
                   .wr(1'b0), .createdump(Halt), .clk(clk), .rst(rst));
endmodule
`default_nettype wire
