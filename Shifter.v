module Shifter (
    input [15:0] dataIn,
    input [3:0] shiftAmount,
    input [1:0] operation,
    output [15:0] dataOut
);

    wire [15:0] stage0;
    wire [15:0] stage1;
    wire [15:0] stage2;
    wire [15:0] stage3;

    assign stage0 = 
        (operation == 2'b00) ? (shiftAmount[3] ? {dataIn[7:0], dataIn[15:8]} : dataIn) :
        (operation == 2'b01) ? (shiftAmount[3] ? {dataIn[7:0], 8'b0} : dataIn) :
        (operation == 2'b10) ? (shiftAmount[3] ? {dataIn[15:8], dataIn[7:0]} : dataIn) :
                              (shiftAmount[3] ? {8'b0, dataIn[15:8]} : dataIn);

    assign stage1 = 
        (operation == 2'b00) ? (shiftAmount[2] ? {stage0[11:0], stage0[15:12]} : stage0) :
        (operation == 2'b01) ? (shiftAmount[2] ? {stage0[11:0], 4'b0} : stage0) :
        (operation == 2'b10) ? (shiftAmount[2] ? {stage0[3:0], stage0[15:4]} : stage0) :
                              (shiftAmount[2] ? {4'b0, stage0[15:4]} : stage0);

    assign stage2 = 
        (operation == 2'b00) ? (shiftAmount[1] ? {stage1[13:0], stage1[15:14]} : stage1) :
        (operation == 2'b01) ? (shiftAmount[1] ? {stage1[13:0], 2'b0} : stage1) :
        (operation == 2'b10) ? (shiftAmount[1] ? {stage1[1:0], stage1[15:2]} : stage1) :
                              (shiftAmount[1] ? {2'b0, stage1[15:2]} : stage1);

    assign stage3 = 
        (operation == 2'b00) ? (shiftAmount[0] ? {stage2[14:0], stage2[15]} : stage2) :
        (operation == 2'b01) ? (shiftAmount[0] ? {stage2[14:0], 1'b0} : stage2) :
        (operation == 2'b10) ? (shiftAmount[0] ? {stage2[0], stage2[15:1]} : stage2) :
                              (shiftAmount[0] ? {1'b0, stage2[15:1]} : stage2);

    assign dataOut = stage3;

endmodule