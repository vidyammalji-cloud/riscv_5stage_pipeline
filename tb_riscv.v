`timescale 1ns/1ps
module tb_riscv;

reg clk;
reg reset;

wire [31:0] pc;
wire [31:0] instr;
wire [31:0] alu_out;   // ? ADD THIS

// DUT
riscv uut (
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .instr(instr),
    .alu_out(alu_out)   // ? CONNECT THIS
);

// Ciin]nitial begin
initial begin 
    clk = 0;
    reset = 1;
    #20;        // keep reset for 20 ns
    reset = 0;  // release reset
    #200;       // let it run
    $stop;
end

always #5 clk = ~clk;  // 10 ns clocklock

endmodule