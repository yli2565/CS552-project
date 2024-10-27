module BrchCnd (
    output reg BrchOrJmpSig,      // Branch/Jump taken signal
    output reg [15:0] CmpResult,  // Compare result for SEQ/SLT/SLE/SCO
    input wire [3:0] BrchCtrl,    // Branch control from decoder
    input wire SF,                // Sign flag from ALU
    input wire ZF,                // Zero flag from ALU
    input wire OF,                // Overflow flag from ALU
    input wire CF                 // Carry flag from ALU
);

    always @(*) begin
        // Default values
        BrchOrJmpSig = 1'b0;
        CmpResult = 16'bz;

        case(BrchCtrl)
            // SEQ
            4'b0000: begin
                CmpResult = {15'b0, ZF};
            end
            // SLT
            4'b0001: begin
                CmpResult = {15'b0, (SF ^ OF)};
            end
            // SLE
            4'b0010: begin
                CmpResult = {15'b0, (SF ^ OF) | ZF};
            end
            // SCO
            4'b0011: begin
                CmpResult = {15'b0, CF};
            end
            // BEQZ
            4'b0100: begin
                BrchOrJmpSig = ZF;
            end
            // BNEZ
            4'b0101: begin
                BrchOrJmpSig = ~ZF;
            end
            // BLTZ
            4'b0110: begin
                BrchOrJmpSig = SF ^ OF;
            end
            // BGEZ
            4'b0111: begin
                BrchOrJmpSig = ~(SF ^ OF);
            end
            // J/JAL
            4'b1000: begin
                BrchOrJmpSig = 1'b1;
            end
        endcase
    end

endmodule