// ALU Operations
`define ALU_NONE    4'b0000
`define ALU_R_ROT   4'b0001
`define ALU_R_ARITH 4'b0010
`define ALU_ADD     4'b0110
`define ALU_XOR     4'b0101
`define ALU_AND     4'b0011
`define ALU_OR      4'b0100

// Compare Operations
`define ALU_CMP 4'b0111      // Compare
`define ALU_CMP_0_A 4'b0111  // Compare 0-A
`define ALU_CMP_B_A 4'b0111  // Compare B-A

// Shift/Rotate Operations
`define ALU_ROL     4'b1000  // Rotate Left
`define ALU_SLL     4'b1001  // Shift Left Logical
`define ALU_ROR     4'b1010  // Rotate Right
`define ALU_SRL     4'b1011  // Shift Right Logical (zero extended)

// Special Operations
`define ALU_BYPASS  4'b1101  // Bypass (pass through)
`define ALU_INV     4'b1100  // Invert

module ALU (
    output reg [15:0] ALUOut,
    output reg SF,
    output reg ZF,
    output reg OF,
    output reg CF,
    input [15:0] OprA,
    input [15:0] OprB,
    input [3:0] ALUOperation,
    input SLBIshift8,
    input NegA,
    input InvB
);

    wire [15:0] A;
    wire [15:0] B;

    assign A = NegA ? (~OprA + 1) : SLBIshift8 ? (OprA << 8) : OprA;
    assign b = InvB ? ~OprB : OprB;

    always @(*) begin
        ALUOut = 16'bz;
        SF = 1'b0;
        ZF = 1'b0;
        OF = 1'b0;
        CF = 1'b0;
        case (ALUOperation)
            `ALU_NONE: begin
                ALUOut = 16'bz;
            end
            `ALU_ADD: begin
                ALUOut = A + B;
            end
            `ALU_XOR: begin
                ALUOut = A ^ B;
            end
            `ALU_AND: begin
                ALUOut = A & B;
            end
            `ALU_OR: begin
                ALUOut = A | B;
            end
            `ALU_CMP: begin
                ALUOut = A + B;
            end
            `ALU_ROL: begin
                ALUOut = A << B | A >> (16 - B);
            end
            `ALU_SLL: begin
                ALUOut = A << B;
            end
            `ALU_ROR: begin
                ALUOut = A >> 1 | A << (16 - B);
            end
            `ALU_SRL: begin
                ALUOut = A >> B;
            end
            `ALU_BYPASS: begin
                ALUOut = A;
            end
            `ALU_INV: begin
                ALUOut = ~A;
            end
        endcase
        case (ALUOperation)
            `ALU_CMP: begin
                SF = ALUOut[15];
                ZF = ALUOut == 16'b0;
                OF = (A[15] & B[15] & ~ALUOut[15]) | (~A[15] & ~B[15] & ALUOut[15]);
                CF = A[15] ^ B[15];
                ALUOut = 16'bz; // Don't care about ALUOut
            end
            default: begin
                SF = ALUOut[15];
                ZF = ALUOut == 16'b0;
                OF = (A[15] & B[15] & ~ALUOut[15]) | (~A[15] & ~B[15] & ALUOut[15]);
                CF = A[15] ^ B[15];
            end
        endcase
    end
endmodule