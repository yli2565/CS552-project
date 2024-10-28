/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`include "MUX_4x16.v"
`default_nettype none
module wb (
    input wire [1:0] RegSrc,
    input wire [15:0] PCplus2,
    input wire [15:0] MemOut,
    input wire [15:0] ALUOut,
    input wire [15:0] CmpResult,
    output wire [15:0] WrtData
);
    MUX_4x16 WrtData_Mux(.out(WrtData), .in0(PCplus2), .in1(MemOut),
        .in2(ALUOut), .in3(CmpResult), .ctrl(RegSrc));
endmodule
`default_nettype wire
