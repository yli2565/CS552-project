`include "dff.v"
module single_reg #(parameter WIDTH = 16) (readData, err, clk, rst, writeData, writeEn);

    input        clk, rst;
    input [WIDTH-1:0] writeData;
    input        writeEn;

    output [WIDTH-1:0] readData;
    output        err;

    wire [WIDTH-1:0] writeData_;
    wire [WIDTH-1:0] delayedReadData;

    assign writeData_ = writeEn ? writeData : readData;
    assign readData = delayedReadData;
    // Array instantiation of D flip-flops
    dff dff_array[WIDTH-1:0] (
        .q(delayedReadData),
        .d(writeData_),
        .clk({WIDTH{clk}}),
        .rst({WIDTH{rst}})
    );
    
    assign err = (^readData === 1'bx) | (^writeData === 1'bx) | (writeEn === 1'bx) | (clk === 1'bx) | (rst === 1'bx);
    
endmodule