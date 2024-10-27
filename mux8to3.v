module mux8to3 #(parameter WIDTH = 16) (
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    input [WIDTH-1:0] in3,
    input [WIDTH-1:0] in4,
    input [WIDTH-1:0] in5,
    input [WIDTH-1:0] in6,
    input [WIDTH-1:0] in7,
    input [2:0] select,
    input enable,
    output reg [WIDTH-1:0] out
);
always @(*) begin
    case (enable)
        1'b0: out = 16'b0000000000000000;
        1'b1: begin
            case (select)
                3'b000: out = in0;
                3'b001: out = in1;
                3'b010: out = in2;
                3'b011: out = in3;
                3'b100: out = in4;
                3'b101: out = in5;
                3'b110: out = in6;
                3'b111: out = in7;
            endcase
        end
    endcase
end

endmodule