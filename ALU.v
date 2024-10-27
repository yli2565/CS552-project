// Basic Operations
`define ALU_NONE    4'b0000    // No operation
`define ALU_R_ROT   4'b0001    // Not determined rotate operation
`define ALU_R_ARITH 4'b0010    // Not determined arithmetic operation
`define ALU_ADD     4'b0110    // Addition
`define ALU_XOR     4'b0101    // XOR operation
`define ALU_AND     4'b0011    // AND operation
`define ALU_OR      4'b0100    // OR operation

// Compare Operations
`define ALU_CMP     4'b0111    // Compare operation
`define ALU_CMP_0_A 4'b0111    // Compare 0 minus A
`define ALU_CMP_B_A 4'b0111    // Compare B minus A

// Shift/Rotate Operations
`define ALU_ROL     4'b1000    // Rotate left
`define ALU_SLL     4'b1001    // Shift left logical
`define ALU_ROR     4'b1010    // Rotate right
`define ALU_SRL     4'b1011    // Shift right logical

// Special Operations
`define ALU_BYPASS  4'b1101    // Bypass Immediate (B)
`define ALU_INV     4'b1100    // Bit inversion

module ALU (
    output wire [15:0] ALUOut,
    output wire SF,
    output wire ZF,
    output wire OF,
    output wire CF,
    input wire [15:0] OprA,
    input wire [15:0] OprB,
    input wire [3:0] ALUOperation,
    input wire SLBIshift8,
    input wire NegA,
    input wire InvB
);

    // Input preprocessing
    wire [15:0] A;
    wire [15:0] B;
    assign A = NegA ? (~OprA + 1) : SLBIshift8 ? (OprA << 8) : OprA;
    assign B = InvB ? ~OprB : OprB;

    // Operation results
    wire [15:0] add_result = A + B;
    wire [15:0] xor_result = A ^ B;
    wire [15:0] and_result = A & B;
    wire [15:0] or_result = A | B;
    wire [15:0] rol_result = A << B | A >> (16 - B);
    wire [15:0] sll_result = A << B;
    wire [15:0] ror_result = A >> 1 | A << (16 - B);
    wire [15:0] srl_result = A >> B;
    wire [15:0] inv_result = {A[0],A[1],A[2],A[3],A[4],A[5],A[6],A[7],A[8],A[9],A[10],A[11],A[12],A[13],A[14],A[15]};

    // Main ALU output multiplexer
    assign ALUOut = 
        (ALUOperation === `ALU_ADD)    ? add_result :
        (ALUOperation === `ALU_XOR)    ? xor_result :
        (ALUOperation === `ALU_AND)    ? and_result :
        (ALUOperation === `ALU_OR)     ? or_result :
        (ALUOperation === `ALU_ROL)    ? rol_result :
        (ALUOperation === `ALU_SLL)    ? sll_result :
        (ALUOperation === `ALU_ROR)    ? ror_result :
        (ALUOperation === `ALU_SRL)    ? srl_result :
        (ALUOperation === `ALU_BYPASS) ? B :
        (ALUOperation === `ALU_INV)    ? inv_result :
        (ALUOperation === `ALU_CMP)    ? 16'bz :
        16'bz;

    // Flag calculations
    wire [15:0] flag_result = (ALUOperation === `ALU_CMP) ? add_result : ALUOut;
    
    assign SF = (ALUOperation === `ALU_NONE) ? 1'bz : flag_result[15];
    assign ZF = (ALUOperation === `ALU_NONE) ? 1'bz : (flag_result === 16'b0);
    assign OF = (ALUOperation === `ALU_NONE) ? 1'bz : (A[15] & B[15] & ~flag_result[15]) | (~A[15] & ~B[15] & flag_result[15]);
    assign CF = (ALUOperation === `ALU_NONE) ? 1'bz : A[15] ^ B[15];

endmodule