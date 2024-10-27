module MUX_4x3(
    output reg [2:0] out,
    input [2:0] in0,
    input [2:0] in1,
    input [2:0] in2,
    input [2:0] in3,
    input [1:0] ctrl
);

always @(*) begin
    case (ctrl)
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        2'b11: out = in3;
        default: out = 3'bz;
    endcase
end

endmodule
