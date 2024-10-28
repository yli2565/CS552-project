`include "FullAdder.v"

module Adder16(
    input [15:0] InputA,
    input [15:0] InputB,
    input CarryIn,
    output [15:0] Sum,
    output CarryOut
);
    wire [16:0] Carry;
    assign Carry[0] = CarryIn;
    assign CarryOut = Carry[16];

    FullAdder Bit0(.A(InputA[0]), .B(InputB[0]), .Cin(Carry[0]), .Sum(Sum[0]), .Cout(Carry[1]));
    FullAdder Bit1(.A(InputA[1]), .B(InputB[1]), .Cin(Carry[1]), .Sum(Sum[1]), .Cout(Carry[2]));
    FullAdder Bit2(.A(InputA[2]), .B(InputB[2]), .Cin(Carry[2]), .Sum(Sum[2]), .Cout(Carry[3]));
    FullAdder Bit3(.A(InputA[3]), .B(InputB[3]), .Cin(Carry[3]), .Sum(Sum[3]), .Cout(Carry[4]));
    FullAdder Bit4(.A(InputA[4]), .B(InputB[4]), .Cin(Carry[4]), .Sum(Sum[4]), .Cout(Carry[5]));
    FullAdder Bit5(.A(InputA[5]), .B(InputB[5]), .Cin(Carry[5]), .Sum(Sum[5]), .Cout(Carry[6]));
    FullAdder Bit6(.A(InputA[6]), .B(InputB[6]), .Cin(Carry[6]), .Sum(Sum[6]), .Cout(Carry[7]));
    FullAdder Bit7(.A(InputA[7]), .B(InputB[7]), .Cin(Carry[7]), .Sum(Sum[7]), .Cout(Carry[8]));
    FullAdder Bit8(.A(InputA[8]), .B(InputB[8]), .Cin(Carry[8]), .Sum(Sum[8]), .Cout(Carry[9]));
    FullAdder Bit9(.A(InputA[9]), .B(InputB[9]), .Cin(Carry[9]), .Sum(Sum[9]), .Cout(Carry[10]));
    FullAdder Bit10(.A(InputA[10]), .B(InputB[10]), .Cin(Carry[10]), .Sum(Sum[10]), .Cout(Carry[11]));
    FullAdder Bit11(.A(InputA[11]), .B(InputB[11]), .Cin(Carry[11]), .Sum(Sum[11]), .Cout(Carry[12]));
    FullAdder Bit12(.A(InputA[12]), .B(InputB[12]), .Cin(Carry[12]), .Sum(Sum[12]), .Cout(Carry[13]));
    FullAdder Bit13(.A(InputA[13]), .B(InputB[13]), .Cin(Carry[13]), .Sum(Sum[13]), .Cout(Carry[14]));
    FullAdder Bit14(.A(InputA[14]), .B(InputB[14]), .Cin(Carry[14]), .Sum(Sum[14]), .Cout(Carry[15]));
    FullAdder Bit15(.A(InputA[15]), .B(InputB[15]), .Cin(Carry[15]), .Sum(Sum[15]), .Cout(Carry[16]));
endmodule