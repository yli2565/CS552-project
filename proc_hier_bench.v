/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
`default_nettype none
module proc_hier_bench();

   /* BEGIN DO NOT TOUCH */
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   // End of automatics
   

   wire [15:0] PC;
   wire [15:0] Inst;           /* This should be the 15 bits of the FF that
                                  stores instructions fetched from instruction memory
                               */
   wire        RegWrite;       /* Whether register file is being written to */
   wire [2:0]  WriteRegister;  /* What register is written */
   wire [15:0] WriteData;      /* Data */
   wire        MemWrite;       /* Similar as above but for memory */
   wire        MemRead;
   wire [15:0] MemAddress;
   wire [15:0] MemData;

   wire        Halt;         /* Halt executed and in Memory or writeback stage */
        
   integer     inst_count;
   integer     trace_file;
   integer     sim_log_file;
     

   proc_hier DUT();
   

   initial begin
      $display("Hello world...simulation starting");
      $display("See verilogsim.log and verilogsim.trace for output");
      inst_count = 0;
      trace_file = $fopen("verilogsim.trace");
      sim_log_file = $fopen("verilogsim.log");
      
   end

   always @ (posedge DUT.c0.clk) begin
      if (!DUT.c0.rst) begin
         if (Halt || RegWrite || MemWrite) begin
            inst_count = inst_count + 1;
         end
         $fdisplay(sim_log_file, "SIMLOG:: Cycle %d PC: %8x I: %8x R: %d %3d %8x M: %d %d %8x %8x",
                  DUT.c0.cycle_count,
                  PC,
                  Inst,
                  RegWrite,
                  WriteRegister,
                  WriteData,
                  MemRead,
                  MemWrite,
                  MemAddress,
                  MemData);
         if (RegWrite) begin
            if (MemWrite) begin
               // stu
               $fdisplay(trace_file,"INUM: %8d PC: 0x%04x REG: %d VALUE: 0x%04x ADDR: 0x%04x VALUE: 0x%04x",
                         (inst_count-1),
                        PC,
                        WriteRegister,
                        WriteData,
                        MemAddress,
                        MemData);
            end else if (MemRead) begin
               // ld
               $fdisplay(trace_file,"INUM: %8d PC: 0x%04x REG: %d VALUE: 0x%04x ADDR: 0x%04x",
                         (inst_count-1),
                        PC,
                        WriteRegister,
                        WriteData,
                        MemAddress);
            end else begin
               $fdisplay(trace_file,"INUM: %8d PC: 0x%04x REG: %d VALUE: 0x%04x",
                         (inst_count-1),
                        PC,
                        WriteRegister,
                        WriteData );
            end
         end else if (Halt) begin
            $fdisplay(sim_log_file, "SIMLOG:: Processor halted\n");
            $fdisplay(sim_log_file, "SIMLOG:: sim_cycles %d\n", DUT.c0.cycle_count);
            $fdisplay(sim_log_file, "SIMLOG:: inst_count %d\n", inst_count);
            $fdisplay(trace_file, "INUM: %8d PC: 0x%04x",
                      (inst_count-1),
                      PC );

            $fclose(trace_file);
            $fclose(sim_log_file);
            
            $finish;
         end else begin // if (RegWrite)
            if (MemWrite) begin
               // st
               $fdisplay(trace_file,"INUM: %8d PC: 0x%04x ADDR: 0x%04x VALUE: 0x%04x",
                         (inst_count-1),
                        PC,
                        MemAddress,
                        MemData);
            end else begin
               // conditional branch or NOP
               // Need better checking in pipelined testbench
               inst_count = inst_count + 1;
               $fdisplay(trace_file, "INUM: %8d PC: 0x%04x",
                         (inst_count-1),
                         PC );
            end
         end 
      end
      
   end

   /* END DO NOT TOUCH */

   /* Assign internal signals to top level wires
      The internal module names and signal names will vary depending
      on your naming convention and your design */

   // Edit the example below. You must change the signal
   // names on the right hand side
    
   assign PC = DUT.p0.PC;
   assign Inst = DUT.p0.Instr;
   
   assign RegWrite = DUT.p0.RegWrt;
   // Is register being written, one bit signal (1 means yes, 0 means no)
   
   assign WriteRegister = DUT.p0.regFile_.writeRegSel;
   // The name of the register being written to. (3 bit signal)

   assign WriteData = DUT.p0.regFile_.writeData;
   // Data being written to the register. (16 bits)
   
   assign MemRead =  DUT.p0.MemRW[1];
   // Is memory being read, one bit signal (1 means yes, 0 means no)
   
   assign MemWrite = DUT.p0.MemRW[0];
   // Is memory being written to (1 bit signal)
   
   assign MemAddress = DUT.p0.ALUOut;
   // Address to access memory with (for both reads and writes to memory, 16 bits)
   
   assign MemData = DUT.p0.Rt;
   // Data to be written to memory for memory writes (16 bits)
   
   assign Halt = DUT.p0.Dmem.createdump;
   // Is processor halted (1 bit signal)
   
   /* Add anything else you want here */
   wire [15:0] RegFileData [7:0];
   
   // assign RegFileData[0][0] = DUT.p0.regFile_.reg_array_0.dff_array[0].state;
   // assign RegFileData[0][1] = DUT.p0.regFile_.reg_array_0.dff_array[1].state;
   // assign RegFileData[0][2] = DUT.p0.regFile_.reg_array_0.dff_array[2].state;
   genvar i, j;
   generate
      for(i = 0; i < 16; i = i + 1) begin : connect_regs
         // Connect all bits of register i
         assign RegFileData[0][i] = DUT.p0.regFile_.reg_array_0.dff_array[i].state;
         assign RegFileData[1][i] = DUT.p0.regFile_.reg_array_1.dff_array[i].state;
         assign RegFileData[2][i] = DUT.p0.regFile_.reg_array_2.dff_array[i].state;
         assign RegFileData[3][i] = DUT.p0.regFile_.reg_array_3.dff_array[i].state;
         assign RegFileData[4][i] = DUT.p0.regFile_.reg_array_4.dff_array[i].state;
         assign RegFileData[5][i] = DUT.p0.regFile_.reg_array_5.dff_array[i].state;
         assign RegFileData[6][i] = DUT.p0.regFile_.reg_array_6.dff_array[i].state; 
         assign RegFileData[7][i] = DUT.p0.regFile_.reg_array_7.dff_array[i].state;
      end
   endgenerate
endmodule
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
