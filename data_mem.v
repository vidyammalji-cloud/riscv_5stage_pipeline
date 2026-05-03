module data_mem(
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
);

reg [31:0] memory [0:255];
integer i;

// ? Initialize memory (VERY IMPORTANT for LW test)
initial begin
    for (i = 0; i < 256; i = i + 1) begin
        memory[i] = 32'd0;
    end

    memory[0] = 32'd10;  // value that LW will load
end

// Write
always @(posedge clk) begin
    if (mem_write)
        memory[addr[9:2]] <= write_data;
end

// Read
always @(*) begin
    if (mem_read)
        read_data = memory[addr[9:2]];
    else
        read_data = 0;
end

endmodule