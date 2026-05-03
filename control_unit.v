module control_unit(
    input [6:0] opcode,

    output reg alu_src,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,   // ? NEW
    output reg mem_to_reg   // ? NEW
);

always @(*) begin
    case(opcode)

        // ================= R-TYPE =================
        7'b0110011: begin
            alu_src   = 0;
            reg_write = 1;
            mem_read  = 0;
            mem_write = 0;
            mem_to_reg= 0;
        end

        // ================= ADDI =================
        7'b0010011: begin
            alu_src   = 1;
            reg_write = 1;
            mem_read  = 0;
            mem_write = 0;
            mem_to_reg= 0;
        end

        // ================= LW =================
        7'b0000011: begin
            alu_src   = 1;
            reg_write = 1;
            mem_read  = 1;
            mem_write = 0;
            mem_to_reg= 1;   // ? LOAD FROM MEMORY
        end

        // ================= SW =================
        7'b0100011: begin
            alu_src   = 1;
            reg_write = 0;
            mem_read  = 0;
            mem_write = 1;   // ? STORE
            mem_to_reg= 0;
        end

        // ================= DEFAULT =================
        default: begin
            alu_src   = 0;
            reg_write = 0;
            mem_read  = 0;
            mem_write = 0;
            mem_to_reg= 0;
        end

    endcase
end

endmodule
