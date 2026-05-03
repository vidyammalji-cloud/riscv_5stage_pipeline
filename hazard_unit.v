module hazard_unit (
    input  wire        mem_read_ex,   // EX stage: is it a load?
    input  wire [4:0]  rd_ex,         // destination register in EX
    input  wire [4:0]  rs1_id,        // source reg1 in ID
    input  wire [4:0]  rs2_id,        // source reg2 in ID

    output wire        stall,         // stall signal
    output wire        pc_write,      // control PC update
    output wire        if_id_write    // control IF/ID register
);

    // Detect load-use hazard (ignore x0)
    assign stall = mem_read_ex &&
                  (rd_ex != 5'd0) &&
                  ((rd_ex == rs1_id) || (rd_ex == rs2_id));

    // Control signals
    assign pc_write    = ~stall;  
    assign if_id_write = ~stall;  

endmodule