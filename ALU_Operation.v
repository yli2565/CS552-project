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

module ALU_Operation (
    output reg [3:0] ALUOperation,
    output reg NegA,
    output reg InvB,
    input [5:0] ALUOpr,
    input [1:0] OpcodeExtention
);

    always @(*) begin
        NegA = ALUOpr[5];
        InvB = ALUOpr[4];

        case (ALUOpr[3:0])
            `ALU_R_ROT: begin
                case (OpcodeExtention)
                    2'b00 : ALUOperation = `ALU_ROL; //ROL
                    2'b01 : ALUOperation = `ALU_SLL; //SLL
                    2'b10 : ALUOperation = `ALU_ROR; //ROR
                    2'b11 : ALUOperation = `ALU_SRL; //SRL
                endcase
            end
            `ALU_R_ARITH: begin
                case (OpcodeExtention)
                    2'b00 : ALUOperation = `ALU_ADD; // ADD
                    2'b01 : begin // SUB
                        ALUOperation = `ALU_ADD;
                        NegA = 1'b1;
                    end
                    2'b10 : ALUOperation = `ALU_XOR; // XOR
                    2'b11 : begin // ANDN
                        ALUOperation = `ALU_AND; 
                        InvB = 1'b1;
                    end
                endcase
            end
            default: ALUOperation = ALUOpr;
        endcase
    end

endmodule