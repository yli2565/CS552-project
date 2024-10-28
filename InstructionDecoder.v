// System Instructions
`define HALT    5'b00000
`define NOP     5'b00001
`define SIIC    5'b00010
`define RTI     5'b00011

// Jump Instructions
`define J       5'b00100
`define JR      5'b00101
`define JAL     5'b00110
`define JALR    5'b00111

// Immediate Arithmetic/Logic Instructions
`define ADDI    5'b01000
`define SUBI    5'b01001
`define XORI    5'b01010
`define ANDNI   5'b01011

// Branch Instructions
`define BEQZ    5'b01100
`define BNEZ    5'b01101
`define BLTZ    5'b01110
`define BGEZ    5'b01111

// Memory Instructions
`define ST      5'b10000
`define LD      5'b10001
`define SLBI    5'b10010
`define STU     5'b10011

// Immediate Shift/Rotate Instructions
`define ROLI    5'b10100
`define SLLI    5'b10101
`define RORI    5'b10110
`define SRLI    5'b10111

// Load/Special Instructions
`define LBI     5'b11000
`define BTR     5'b11001

// Register Shift/Rotate Instructions (shared opcode)
`define ROL     5'b11010
`define SLL     5'b11010
`define ROR     5'b11010
`define SRL     5'b11010

// Register Arithmetic/Logic Instructions (shared opcode)
`define ADD     5'b11011
`define SUB     5'b11011
`define XOR     5'b11011
`define ANDN    5'b11011

// Compare Instructions
`define SEQ     5'b11100
`define SLT     5'b11101
`define SLE     5'b11110
`define SCO     5'b11111


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


module InstructionDecoder (
    output wire [1:0] MemRW,
    output wire ALUJmp,
    output wire SLBIshift8,
    output wire [3:0] BrchCtrl,
    output wire ImmSrc,
    output wire RegWrt,
    output wire [1:0] BSrc,
    output wire ZeroExt,
    output wire [5:0] ALUOpr,
    output wire [1:0] RegSrc,
    output wire [1:0] RegDst,
    output wire Halt,
    input wire [4:0] Opcode
);

    wire NegAProto;
    wire InvBProto;
    wire [3:0] ALUOperationProto;

    assign ALUOpr = {NegAProto, InvBProto, ALUOperationProto[3:0]};

    assign MemRW = 
        (Opcode === `ST | Opcode === `STU) ? 2'b01 :
        (Opcode === `LD) ? 2'b10 :
        2'b00;

    assign ALUJmp = (Opcode === `JR | Opcode === `JALR);

    assign SLBIshift8 = (Opcode === `SLBI);

    assign BrchCtrl = 
        (Opcode === `J | Opcode === `JAL) ? 4'b1000 :
        (Opcode === `BEQZ) ? 4'b0100 :
        (Opcode === `BNEZ) ? 4'b0101 :
        (Opcode === `BLTZ) ? 4'b0110 :
        (Opcode === `BGEZ) ? 4'b0111 :
        (Opcode === `SEQ) ? 4'b0000 :
        (Opcode === `SLT) ? 4'b0001 :
        (Opcode === `SLE) ? 4'b0010 :
        (Opcode === `SCO) ? 4'b0011 :
        4'b0000;

    assign ImmSrc = (Opcode === `J | Opcode === `JAL);

    assign RegWrt = 
        !(Opcode === `HALT | Opcode === `NOP | 
          Opcode === `J | Opcode === `JR | 
          Opcode === `BEQZ | Opcode === `BNEZ | 
          Opcode === `BLTZ | Opcode === `BGEZ | 
          Opcode === `ST);

    assign BSrc = 
        (Opcode === `JR | Opcode === `JALR | 
         Opcode === `SLBI | Opcode === `LBI) ? 2'b10 :
        (Opcode === `ADDI | Opcode === `SUBI | 
         Opcode === `XORI | Opcode === `ANDNI | 
         Opcode === `ST | Opcode === `LD | 
         Opcode === `STU | Opcode === `ROLI | 
         Opcode === `SLLI | Opcode === `RORI | 
         Opcode === `SRLI) ? 2'b01 :
        (Opcode === `BEQZ | Opcode === `BNEZ | 
         Opcode === `BLTZ | Opcode === `BGEZ) ? 2'b11 :
        2'b00;

    assign ZeroExt = (Opcode === `XORI | Opcode === `ANDNI | Opcode === `SLBI);

assign ALUOperationProto = 
    // Addition operations
    (Opcode === `JR | Opcode === `JALR | 
     Opcode === `ADDI | Opcode === `SUBI | 
     Opcode === `ST | Opcode === `LD | 
     Opcode === `STU) ? `ALU_ADD :
    
    // Bitwise operations
    (Opcode === `XORI) ? `ALU_XOR :
    (Opcode === `ANDNI) ? `ALU_AND :
    
    // Compare operations
    (Opcode === `BEQZ | Opcode === `BNEZ | 
     Opcode === `BLTZ | Opcode === `BGEZ | 
     Opcode === `SEQ | Opcode === `SLT | 
     Opcode === `SLE | Opcode === `SCO) ? `ALU_CMP :
    
    // OR operation (for SLBI)
    (Opcode === `SLBI) ? `ALU_OR :
    
    // Shift and rotate operations
    (Opcode === `ROLI) ? `ALU_ROL :
    (Opcode === `SLLI) ? `ALU_SLL :
    (Opcode === `RORI) ? `ALU_ROR :
    (Opcode === `SRLI) ? `ALU_SRL :
    
    // Special operations
    (Opcode === `LBI) ? `ALU_BYPASS :
    (Opcode === `BTR) ? `ALU_INV :
    
    // Not determined operations
    (Opcode === `ROL) ? `ALU_R_ROT :
    (Opcode === `ADD) ? `ALU_R_ARITH :
    
    // Default: No operation
    `ALU_NONE;

    assign RegSrc = 
        (Opcode === `JAL | Opcode === `JALR) ? 2'b00 :
        (Opcode === `LD) ? 2'b01 :
        (Opcode === `SEQ | Opcode === `SLT | 
         Opcode === `SLE | Opcode === `SCO) ? 2'b11 :
        2'b10;

    assign RegDst = 
        (Opcode === `ADDI | Opcode === `SUBI | 
         Opcode === `XORI | Opcode === `ANDNI | 
         Opcode === `LD | Opcode === `ROLI | 
         Opcode === `SLLI | Opcode === `RORI | 
         Opcode === `SRLI) ? 2'b00 :
        (Opcode === `SLBI | Opcode === `STU | 
         Opcode === `LBI) ? 2'b01 :
        (Opcode === `BTR | Opcode === `ROL | 
         Opcode === `ADD | Opcode === `SEQ | 
         Opcode === `SLT | Opcode === `SLE | 
         Opcode === `SCO) ? 2'b10 :
        (Opcode === `JAL | Opcode === `JALR) ? 2'b11 :
        2'bzz;

    assign NegAProto = 
        (Opcode === `SUBI | Opcode === `BEQZ | 
         Opcode === `BNEZ | Opcode === `BLTZ | 
         Opcode === `BGEZ | Opcode === `SEQ | 
         Opcode === `SLT | Opcode === `SLE);

    assign InvBProto = (Opcode === `ANDNI);

    assign Halt = (Opcode === `HALT) ? 1'b1 : 1'b0;

endmodule