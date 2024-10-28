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

module ALU_Operation (
    output wire [3:0] ALUOperation,
    output wire NegA,
    output wire InvB,
    input wire [5:0] ALUOpr,
    input wire [1:0] OpcodeExtention
);

    // Intermediate wires for R_ROT operations
    wire [3:0] rot_operation = 
        (OpcodeExtention == 2'b00) ? `ALU_ROL :
        (OpcodeExtention == 2'b01) ? `ALU_SLL :
        (OpcodeExtention == 2'b10) ? `ALU_ROR :
        `ALU_SRL;

    // Intermediate wires for R_ARITH operations
    wire [3:0] arith_operation =
        (OpcodeExtention == 2'b00) ? `ALU_ADD :
        (OpcodeExtention == 2'b01) ? `ALU_ADD :
        (OpcodeExtention == 2'b10) ? `ALU_XOR :
        `ALU_AND;

    // Final ALU operation selection
    assign ALUOperation = 
        (ALUOpr[3:0] == `ALU_R_ROT) ? rot_operation :
        (ALUOpr[3:0] == `ALU_R_ARITH) ? arith_operation :
        ALUOpr[3:0];

    // NegA logic
    wire neg_a_from_opr = ALUOpr[5];
    wire neg_a_from_sub = (ALUOpr[3:0] == `ALU_R_ARITH & OpcodeExtention == 2'b01);
    assign NegA = neg_a_from_opr | neg_a_from_sub;

    // InvB logic
    wire inv_b_from_opr = ALUOpr[4];
    wire inv_b_from_andn = (ALUOpr[3:0] == `ALU_R_ARITH & OpcodeExtention == 2'b11);
    assign InvB = inv_b_from_opr | inv_b_from_andn;

endmodule