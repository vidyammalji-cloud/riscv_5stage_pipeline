module regfile(
    input clk,
    input we,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] wd,
    output [31:0] rd1,
    output [31:0] rd2
);

reg [31:0] regs [0:31];
integer i;

// ================= INIT =================
initial begin
    for (i = 0; i < 32; i = i + 1)
        regs[i] = 0;
end

// ================= READ =================
assign rd1 = regs[rs1];
assign rd2 = regs[rs2];

// ================= WRITE =================
always @(posedge clk) begin
    if (we && rd != 0) begin
        regs[rd] <= wd;

        // ? DEBUG PRINT (VERY IMPORTANT)
        $display("WRITE: x%0d = %0d", rd, wd);
    end
end

endmodule