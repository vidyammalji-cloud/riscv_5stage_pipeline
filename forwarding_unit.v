module forwarding_unit(
    input [4:0] rs1_ex,
    input [4:0] rs2_ex,
    input [4:0] rd_mem,
    input [4:0] rd_wb,
    input reg_write_mem,
    input reg_write_wb,

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

always @(*) begin
    // ================= DEFAULT =================
    forwardA = 2'b00;
    forwardB = 2'b00;

    // ================= FORWARD A =================
    if (reg_write_mem && (rd_mem != 5'b00000) && (rd_mem == rs1_ex)) begin
        forwardA = 2'b10;   // EX/MEM (highest priority)
    end 
    else if (reg_write_wb && (rd_wb != 5'b00000) && 
            !(reg_write_mem && (rd_mem != 5'b00000) && (rd_mem == rs1_ex)) &&
            (rd_wb == rs1_ex)) begin
        forwardA = 2'b01;   // MEM/WB
    end

    // ================= FORWARD B =================
    if (reg_write_mem && (rd_mem != 5'b00000) && (rd_mem == rs2_ex)) begin
        forwardB = 2'b10;   // EX/MEM (highest priority)
    end 
    else if (reg_write_wb && (rd_wb != 5'b00000) && 
            !(reg_write_mem && (rd_mem != 5'b00000) && (rd_mem == rs2_ex)) &&
            (rd_wb == rs2_ex)) begin
        forwardB = 2'b01;   // MEM/WB
    end
end

endmodule