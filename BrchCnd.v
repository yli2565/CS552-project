module BrchCnd (
    output wire BrchOrJmpSig,     // Branch/Jump taken signal
    output wire [15:0] CmpResult, // Compare result for SEQ/SLT/SLE/SCO
    input wire [3:0] BrchCtrl,    // Branch control from decoder
    input wire SF,                // Sign flag from ALU
    input wire ZF,                // Zero flag from ALU
    input wire OF,                // Overflow flag from ALU
    input wire CF                 // Carry flag from ALU
);

    // Intermediate wires for individual condition results
    wire [15:0] seq_result = {15'b0, ZF};
    wire [15:0] slt_result = {15'b0, ~(SF ^ OF) & ~ZF};
    wire [15:0] sle_result = {15'b0, ~(SF ^ OF)};
    wire [15:0] sco_result = {15'b0, CF};

    // Branch condition results
    wire beqz_cond = ZF;
    wire bnez_cond = ~ZF;
    wire bltz_cond = ~(SF ^ OF) & ~ZF;
    wire bgez_cond = (SF ^ OF) | ZF;
    wire jump_cond = 1'b1;

    // Multiplexer for CmpResult
    assign CmpResult = 
        (BrchCtrl == 4'b0000) ? seq_result :
        (BrchCtrl == 4'b0001) ? slt_result :
        (BrchCtrl == 4'b0010) ? sle_result :
        (BrchCtrl == 4'b0011) ? sco_result :
        16'bz;

    // Multiplexer for BrchOrJmpSig
    assign BrchOrJmpSig = 
        (BrchCtrl == 4'b0100) ? beqz_cond :
        (BrchCtrl == 4'b0101) ? bnez_cond :
        (BrchCtrl == 4'b0110) ? bltz_cond :
        (BrchCtrl == 4'b0111) ? bgez_cond :
        (BrchCtrl == 4'b1000) ? jump_cond :
        1'b0;

endmodule