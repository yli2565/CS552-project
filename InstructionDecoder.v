module InstructionDecoder (
    output reg [1:0] MemRW,
    output reg ALUJmp,
    output reg SLBIshift8,
    output reg [3:0] BrchCtrl,
    output reg ImmSrc,
    output reg RegWrt,
    output reg [1:0] BSrc,
    output reg ZeroExt,
    output [5:0] ALUOpr,
    output reg [1:0] RegSrc,
    output reg [1:0] RegDst,
    output reg Halt,
    input wire [4:0] Opcode
);

    reg NegAProto;
    reg InvBProto;
    reg [3:0] ALUOperationProto;

    assign ALUOpr = {NegAProto, InvBProto, ALUOperationProto[3:0]};

    always @(*) begin
        // Default values (most common cases)
        MemRW = 2'b00;
        ALUJmp = 1'b0;
        SLBIshift8 = 1'b0;
        NegAProto = 1'b0;
        BrchCtrl = 4'b0000;
        ImmSrc = 1'b0;
        RegWrt = 1'b1;     // Most instructions write to register
        BSrc = 2'b00;      // Default to Rt
        ZeroExt = 1'b0;    // Default to sign extend
        ALUOperationProto = 4'b0000;  // Default to None
        RegSrc = 2'b10;    // Default to ALU output
        RegDst = 2'bzz;    // Default to Rd (bits 7:5)
        Halt = 1'b0;

        case(Opcode)
            5'b00000: begin // HALT
                RegWrt = 1'b0;
                Halt = 1'b1;
            end
            5'b00001: begin // NOP
                RegWrt = 1'b0;
            end
            5'b00100: begin // J
                RegWrt = 1'b0;
                ImmSrc = 1'b1;
                BrchCtrl = 4'b1000;
            end
            5'b00101: begin // JR
                RegWrt = 1'b0;
                BSrc = 2'b10;
                ALUOperationProto = 4'b0110;
                ALUJmp = 1'b1;
            end
            5'b00110: begin // JAL
                RegDst = 2'b11;
                ImmSrc = 1'b1;
                RegSrc = 2'b00;
                BrchCtrl = 4'b1000;
            end
            5'b00111: begin // JALR
                RegDst = 2'b11;
                BSrc = 2'b10;
                ALUOperationProto = 4'b0110;
                RegSrc = 2'b00;
                ALUJmp = 1'b1;
            end
            5'b01000: begin // ADDI
                RegDst = 2'b00;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0110;
                RegSrc = 2'b10;
            end
            5'b01001: begin // SUBI
                RegDst = 2'b00;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0110;
                NegAProto = 1'b1;
                RegSrc = 2'b10;
            end
            5'b01010: begin // XORI
                RegDst = 2'b00;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0101;
                ZeroExt = 1'b1;
                RegSrc = 2'b10;
            end
            5'b01011: begin // ANDNI
                RegDst = 2'b00;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0011;
                ZeroExt = 1'b1;
                InvBProto = 1'b1;
                RegSrc = 2'b10;
            end
            5'b01100: begin // BEQZ
                RegWrt = 1'b0;
                ImmSrc = 1'b0;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0111;
                NegAProto = 1'b1;
                BrchCtrl = 4'b0100;
            end
            5'b01101: begin // BNEZ
                RegWrt = 1'b0;
                ImmSrc = 1'b0;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0111;
                NegAProto = 1'b1;
                BrchCtrl = 4'b0101;
            end
            5'b01110: begin // BLTZ
                RegWrt = 1'b0;
                ImmSrc = 1'b0;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0111;
                NegAProto = 1'b1;
                BrchCtrl = 4'b0110;
            end
            5'b01111: begin // BGEZ
                RegWrt = 1'b0;
                ImmSrc = 1'b0;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0111;
                NegAProto = 1'b1;
                BrchCtrl = 4'b0111;
            end
            5'b10000: begin // ST
                RegWrt = 1'b0;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0110;
                MemRW = 2'b01;
            end
            5'b10001: begin // LD
                RegDst = 2'b00;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0110;
                MemRW = 2'b10;
                RegSrc = 2'b01;
            end
            5'b10010: begin // SLBI
                RegDst = 2'b01;
                BSrc = 2'b10;
                ALUOperationProto = 4'b0100;
                ZeroExt = 1'b1;
                SLBIshift8 = 1'b1;
                RegSrc = 2'b10;
            end
            5'b10011: begin // STU
                RegDst = 2'b01;
                BSrc = 2'b01;
                ALUOperationProto = 4'b0110;
                MemRW = 2'b01;
                RegSrc = 2'b10;
            end
            5'b10100: begin // ROLI
                RegDst = 2'b00;
                BSrc = 2'b01;
                ALUOperationProto = 4'b1000;
                RegSrc = 2'b10;
            end
            5'b10101: begin // SLLI
                RegDst = 2'b00;
                BSrc = 2'b01;
                ALUOperationProto = 4'b1001;
                RegSrc = 2'b10;
            end
            5'b10110: begin // RORI
                RegDst = 2'b00;
                BSrc = 2'b01;
                ALUOperationProto = 4'b1010;
                RegSrc = 2'b10;
            end
            5'b10111: begin // SRLI
                RegDst = 2'b00;
                BSrc = 2'b01;
                ALUOperationProto = 4'b1011;
                RegSrc = 2'b10;
            end
            5'b11000: begin // LBI
                RegDst = 2'b01;
                BSrc = 2'b10;
                ALUOperationProto = 4'b1101;
                RegSrc = 2'b10;
            end
            5'b11001: begin // BTR
                RegDst = 2'b10;
                ALUOperationProto = 4'b1100;
                RegSrc = 2'b10;
            end
            5'b11010: begin // ROL/SLL/ROR/SRL
                RegDst = 2'b10;
                ALUOperationProto = 4'b0001;
                RegSrc = 2'b10;
            end
            5'b11011: begin // ADD/SUB/XOR/ANDN
                RegDst = 2'b10;
                ALUOperationProto = 4'b0010;
                RegSrc = 2'b10;
            end
            5'b11100: begin // SEQ
                RegDst = 2'b10;
                ALUOperationProto = 4'b0111;
                NegAProto = 1'b1;
                RegSrc = 2'b11;
                BrchCtrl = 4'b0000;
            end
            5'b11101: begin // SLT
                RegDst = 2'b10;
                ALUOperationProto = 4'b0111;
                NegAProto = 1'b1;
                RegSrc = 2'b11;
                BrchCtrl = 4'b0001;
            end
            5'b11110: begin // SLE
                RegDst = 2'b10;
                ALUOperationProto = 4'b0111;
                NegAProto = 1'b1;
                RegSrc = 2'b11;
                BrchCtrl = 4'b0010;
            end
            5'b11111: begin // SCO
                RegDst = 2'b10;
                ALUOperationProto = 4'b0111;
                RegSrc = 2'b11;
                BrchCtrl = 4'b0011;
            end
        endcase
    end

endmodule