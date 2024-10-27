/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
`include "single_reg.v"
`include "dmux3to8.v"
`include "mux8to3.v"
module regFile #(parameter WIDTH=16) (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [WIDTH-1:0] writeData;
   input        writeEn;

   output [WIDTH-1:0] read1Data;
   output [WIDTH-1:0] read2Data;
   output        err;

   wire [7:0] decodedWriteEn;

   wire [WIDTH-1:0] readDataArray [7:0];
   wire [7:0] errArray; 
   
   // Array instantiation of single_reg modules
   single_reg #(.WIDTH(WIDTH)) reg_array_0 (
      .readData(readDataArray[0]),
      .err(errArray[0]),
      .clk(clk),
      .rst(rst),
      .writeData(writeData),
      .writeEn(decodedWriteEn[0])
   );
   
   single_reg #(.WIDTH(WIDTH)) reg_array_1 (
      .readData(readDataArray[1]),
      .err(errArray[1]),
      .clk(clk),
      .rst(rst),
      .writeData(writeData),
      .writeEn(decodedWriteEn[1])
   );

   single_reg #(.WIDTH(WIDTH)) reg_array_2 (
      .readData(readDataArray[2]),
      .err(errArray[2]),
      .clk(clk),
      .rst(rst),
      .writeData(writeData),
      .writeEn(decodedWriteEn[2])
   );

   single_reg #(.WIDTH(WIDTH)) reg_array_3 (
      .readData(readDataArray[3]),
      .err(errArray[3]),
      .clk(clk),
      .rst(rst),
      .writeData(writeData),
      .writeEn(decodedWriteEn[3])
   );

   single_reg #(.WIDTH(WIDTH)) reg_array_4 (
      .readData(readDataArray[4]),
      .err(errArray[4]),
      .clk(clk),
      .rst(rst),
      .writeData(writeData),
      .writeEn(decodedWriteEn[4])
   );

   single_reg #(.WIDTH(WIDTH)) reg_array_5 (
      .readData(readDataArray[5]),
      .err(errArray[5]),
      .clk(clk),
      .rst(rst),
      .writeData(writeData),
      .writeEn(decodedWriteEn[5])
   );

   single_reg #(.WIDTH(WIDTH)) reg_array_6 (
      .readData(readDataArray[6]),
      .err(errArray[6]),
      .clk(clk),
      .rst(rst),
      .writeData(writeData),
      .writeEn(decodedWriteEn[6])
   );

   single_reg #(.WIDTH(WIDTH)) reg_array_7 (
      .readData(readDataArray[7]),
      .err(errArray[7]),
      .clk(clk),
      .rst(rst),
      .writeData(writeData),
      .writeEn(decodedWriteEn[7])
   );

   dmux3to8 dmux_0 (
      .select(writeRegSel),
      .enable(writeEn),
      .out(decodedWriteEn)
   );

   mux8to3 #(.WIDTH(WIDTH)) mux_1 (
      .in0(readDataArray[0]),
      .in1(readDataArray[1]),
      .in2(readDataArray[2]),
      .in3(readDataArray[3]),
      .in4(readDataArray[4]),
      .in5(readDataArray[5]),
      .in6(readDataArray[6]),
      .in7(readDataArray[7]),
      .select(read1RegSel),
      .enable(1'b1),
      .out(read1Data)
   );

   mux8to3 #(.WIDTH(WIDTH)) mux_2 (
      .in0(readDataArray[0]),
      .in1(readDataArray[1]),
      .in2(readDataArray[2]),
      .in3(readDataArray[3]),
      .in4(readDataArray[4]),
      .in5(readDataArray[5]),
      .in6(readDataArray[6]),
      .in7(readDataArray[7]),
      .select(read2RegSel),
      .enable(1'b1),
      .out(read2Data)
   );
   
   assign err = |errArray;

endmodule
