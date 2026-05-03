module riscv(
    input clk,
    input reset,
    output [31:0] pc,
    output [31:0] instr,
    output [31:0] alu_out
);

// ================= IF =================
wire [31:0] pc_if, instr_if;
wire [31:0] pc_next;

wire stall;
wire pc_write, if_id_write;

assign pc_next = pc_if + 4;

pc_reg PC (
    .clk(clk),
    .reset(reset),
    .stall(stall),   // OK: stall freezes PC
    .pc_next(pc_next),
    .pc(pc_if)
);

inst_mem IM (
    .addr(pc_if),
    .instr(instr_if)
);

// ================= IF/ID =================
wire [31:0] pc_id, instr_id;

if_id IF_ID (
    .clk(clk),
    .reset(reset),
    .stall(~if_id_write),  // freeze when hazard
    .flush(1'b0),          // no flush needed
    .pc_in(pc_if),
    .instr_in(instr_if),
    .pc_out(pc_id),
    .instr_out(instr_id)
);

// ================= ID =================
wire [31:0] rs1_data, rs2_data, imm;
wire alu_src, reg_write, mem_read, mem_write, mem_to_reg;
wire [3:0] alu_ctrl;

control_unit CU (
    .opcode(instr_id[6:0]),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg)
);

alu_control ALUCTRL (
    .opcode(instr_id[6:0]),
    .funct3(instr_id[14:12]),
    .funct7(instr_id[31:25]),
    .alu_ctrl(alu_ctrl)
);

imm_gen IG (
    .instr(instr_id),
    .imm(imm)
);

// ================= REGISTER FILE =================
wire [31:0] write_back_data;
wire [31:0] alu_result_wb, mem_data_wb;
wire [4:0] rd_wb;
wire reg_write_wb, mem_to_reg_wb;

regfile RF (
    .clk(clk),
    .we(reg_write_wb),
    .rs1(instr_id[19:15]),
    .rs2(instr_id[24:20]),
    .rd(rd_wb),
    .wd(write_back_data),
    .rd1(rs1_data),
    .rd2(rs2_data)
);

// ================= ID/EX =================
wire [31:0] rs1_data_ex, rs2_data_ex, imm_ex;
wire alu_src_ex, reg_write_ex, mem_read_ex, mem_write_ex, mem_to_reg_ex;
wire [3:0] alu_ctrl_ex;
wire [4:0] rd_ex;
wire [4:0] rs1_ex, rs2_ex;

id_ex ID_EX (
    .clk(clk),
    .reset(reset),
    .flush(stall),   // insert bubble on hazard

    .rs1_data_in(rs1_data),
    .rs2_data_in(rs2_data),
    .imm_in(imm),
    .alu_src_in(alu_src),
    .alu_ctrl_in(alu_ctrl),
    .reg_write_in(reg_write),
    .mem_read_in(mem_read),
    .mem_write_in(mem_write),
    .mem_to_reg_in(mem_to_reg),
    .rd_in(instr_id[11:7]),
    .rs1_addr_in(instr_id[19:15]),
    .rs2_addr_in(instr_id[24:20]),

    .rs1_data_out(rs1_data_ex),
    .rs2_data_out(rs2_data_ex),
    .imm_out(imm_ex),
    .alu_src_out(alu_src_ex),
    .alu_ctrl_out(alu_ctrl_ex),
    .reg_write_out(reg_write_ex),
    .mem_read_out(mem_read_ex),
    .mem_write_out(mem_write_ex),
    .mem_to_reg_out(mem_to_reg_ex),
    .rd_out(rd_ex),

    .rs1_addr_out(rs1_ex),
    .rs2_addr_out(rs2_ex)
);

// ================= HAZARD =================
hazard_unit HU (
    .mem_read_ex(mem_read_ex),
    .rd_ex(rd_ex),
    .rs1_id(instr_id[19:15]),
    .rs2_id(instr_id[24:20]),
    .stall(stall),
    .pc_write(pc_write),
    .if_id_write(if_id_write)
);

// ================= EX/MEM SIGNALS =================
wire [31:0] alu_result_mem, write_data_mem;
wire [4:0] rd_mem;
wire reg_write_mem, mem_read_mem, mem_write_mem, mem_to_reg_mem;

// ================= FORWARDING =================
wire [1:0] forwardA, forwardB;

forwarding_unit FU (
    .rs1_ex(rs1_ex),
    .rs2_ex(rs2_ex),
    .rd_mem(rd_mem),
    .rd_wb(rd_wb),
    .reg_write_mem(reg_write_mem),
    .reg_write_wb(reg_write_wb),
    .forwardA(forwardA),
    .forwardB(forwardB)
);

// ================= EX =================
wire [31:0] alu_result;
wire [31:0] alu_in1, alu_in2_temp, alu_operand_B;

assign alu_in1 =
    (forwardA == 2'b10) ? alu_result_mem :
    (forwardA == 2'b01) ? write_back_data :
                          rs1_data_ex;

assign alu_in2_temp =
    (forwardB == 2'b10) ? alu_result_mem :
    (forwardB == 2'b01) ? write_back_data :
                          rs2_data_ex;

assign alu_operand_B = (alu_src_ex) ? imm_ex : alu_in2_temp;

alu ALU (
    .a(alu_in1),
    .b(alu_operand_B),
    .alu_ctrl(alu_ctrl_ex),
    .result(alu_result)
);

// ================= EX/MEM =================
ex_mem EX_MEM (
    .clk(clk),
    .reset(reset),
    .alu_result_in(alu_result),
    .write_data_in(alu_in2_temp),
    .rd_in(rd_ex),
    .reg_write_in(reg_write_ex),
    .mem_read_in(mem_read_ex),
    .mem_write_in(mem_write_ex),
    .mem_to_reg_in(mem_to_reg_ex),

    .alu_result_out(alu_result_mem),
    .write_data_out(write_data_mem),
    .rd_out(rd_mem),
    .reg_write_out(reg_write_mem),
    .mem_read_out(mem_read_mem),
    .mem_write_out(mem_write_mem),
    .mem_to_reg_out(mem_to_reg_mem)
);

// ================= DATA MEMORY =================
wire [31:0] mem_data;

data_mem DM (
    .clk(clk),
    .mem_read(mem_read_mem),
    .mem_write(mem_write_mem),
    .addr(alu_result_mem),
    .write_data(write_data_mem),
    .read_data(mem_data)
);

// ================= MEM/WB =================
mem_wb MEM_WB (
    .clk(clk),
    .reset(reset),
    .alu_result_in(alu_result_mem),
    .mem_data_in(mem_data),
    .rd_in(rd_mem),
    .reg_write_in(reg_write_mem),
    .mem_to_reg_in(mem_to_reg_mem),

    .alu_result_out(alu_result_wb),
    .mem_data_out(mem_data_wb),
    .rd_out(rd_wb),
    .reg_write_out(reg_write_wb),
    .mem_to_reg_out(mem_to_reg_wb)
);

// ================= WRITE BACK =================
assign write_back_data =
    (mem_to_reg_wb) ? mem_data_wb : alu_result_wb;

// ================= OUTPUT =================
assign pc      = pc_if;
assign instr   = instr_if;
assign alu_out = alu_result;

endmodule