module MUX_2x16(
    output reg [15:0] out,
    input [15:0] in0,
    input [15:0] in1,
    input ctrl
);

always @(*) begin
    case (ctrl)
        1'b0: out = in0;
        1'b1: out = in1;
        default: out = 16'bz;
    endcase
end

endmodule
