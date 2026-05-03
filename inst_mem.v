module inst_mem(
    input  [31:0] addr,
    output [31:0] instr
);

    reg [31:0] mem [0:31];
    integer i;

    initial begin
        // Fill with NOPs
        for (i = 0; i < 32; i = i + 1) begin
            mem[i] = 32'h00000013; // NOP
        end

        // ===== FORWARDING PROGRAM =====
        mem[0] = 32'h00500093; // ADDI x1, x0, 5
        mem[1] = 32'h00108133; // ADD  x2, x1, x1  (needs forwarding)
        mem[2] = 32'h00000013; // NOP
    end

    // Safe read
    assign instr = (addr[31:2] < 32) ? mem[addr[31:2]] : 32'h00000013;

endmodule