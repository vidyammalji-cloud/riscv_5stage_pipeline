Got it — here is your **clean, final README** in a **pure copy-paste format** (no extra blocks, no formatting issues). Just paste this directly into GitHub `README.md`.

---

# 🧠 5-Stage Pipelined RISC-V Processor (Verilog)

5-stage pipelined RISC-V processor in Verilog with hazard detection (stall/flush) and data forwarding, fully simulated and verified in Xilinx Vivado.

---

## 📌 Overview

This project implements a **32-bit RISC-V 5-stage pipelined processor** in Verilog.
It demonstrates fundamental computer architecture concepts including:

* Instruction pipelining
* Data forwarding
* Hazard detection
* Load-use hazard handling (stall + bubble insertion)

---

## 📊 Pipeline Architecture

```
        ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐
Instr → │ IF │→│ ID │→│ EX │→│ MEM│→│ WB │
        └────┘ └────┘ └────┘ └────┘ └────┘
```

---

## 🔹 Stage Description

| Stage | Description                         |
| ----- | ----------------------------------- |
| IF    | Fetch instruction from memory       |
| ID    | Decode instruction & read registers |
| EX    | Execute ALU operations              |
| MEM   | Access data memory                  |
| WB    | Write result back to register file  |

---

## ⚙️ Features

### ✅ Instruction Support

* ADDI
* ADD
* LW
* NOP

---

### ✅ Forwarding Unit

* Resolves data hazards without stalling
* Forwards data from:

  * EX/MEM stage
  * MEM/WB stage

---

### ✅ Hazard Detection Unit

* Detects **load-use hazards**
* Generates:

  * `stall`
  * pipeline freeze signals (`pc_write`, `if_id_write`)

---

### ✅ Stall Mechanism

When a load hazard occurs:

* `stall = 1`
* PC is frozen
* IF/ID register is frozen
* Control signals in ID/EX are cleared → **bubble inserted**

---

## 🧪 Test Cases & Waveforms

---

## 🔹 1. ADD Instruction (With Forwarding)

### 📖 Code

```assembly
ADDI x1, x0, 5
ADDI x2, x0, 7
ADD  x3, x1, x2
```

### 🔍 Observation

* Forwarding resolves dependency
* No stall occurs
* `forwardA = 2'b10`
* `forwardB = 2'b10`

### ✅ Expected Result

```
x1 = 5
x2 = 7
x3 = 12
```

### 📸 Waveform

<img width="1398" height="776" alt="add_instruction" src="https://github.com/user-attachments/assets/6b91f7fb-87d5-41cd-a5d6-2aa180cd45fb" />

---

## 🔹 2. Load-Use Hazard (Pipeline Stall)

### 📖 Code

```assembly
LW   x1, 0(x0)
ADD  x2, x1, x1
```

### 🔍 Observation

* `mem_read = 1` indicates load instruction
* Dependency detected between LW and ADD
* `stall = 1` for one cycle
* Pipeline is stalled and bubble is inserted

### 📸 Waveform

<img width="1184" height="638" alt="load_hazard" src="https://github.com/user-attachments/assets/b5c7e9d5-d683-44f0-be5d-11822df03bfb" />

---

## 🔹 3. Forwarding (No Stall)

### 📖 Code

```assembly
ADDI x1, x0, 5
ADD  x2, x1, x1
```

### 🔍 Observation

* Data forwarded from EX stage
* `forwardA = 2'b10`, `forwardB = 2'b10`
* `stall = 0`
* No pipeline delay

### ✅ Expected Result

```
x2 = 10
```

### 📸 Waveform

<img width="1411" height="713" alt="forwarding" src="https://github.com/user-attachments/assets/654ed54f-b605-4448-918c-491fe46f16d2" />

---

## 🧩 Modules

| Module              | Description         |
| ------------------- | ------------------- |
| `riscv.v`           | Top-level processor |
| `inst_mem.v`        | Instruction memory  |
| `data_mem.v`        | Data memory         |
| `regfile.v`         | Register file       |
| `alu.v`             | ALU                 |
| `control_unit.v`    | Control unit        |
| `alu_control.v`     | ALU control         |
| `if_id.v`           | Pipeline register   |
| `id_ex.v`           | Pipeline register   |
| `ex_mem.v`          | Pipeline register   |
| `mem_wb.v`          | Pipeline register   |
| `forwarding_unit.v` | Forwarding logic    |
| `hazard_unit.v`     | Hazard detection    |

---

## 🚀 How to Run

1. Open project in **Xilinx Vivado**
2. Run simulation using:

   ```
   tb_riscv.v
   ```
3. Add the following signals:

   ```
   clk
   pc
   instr
   forwardA
   forwardB
   stall
   alu_result
   ```
4. Observe:

   * Forwarding behavior
   * Load hazard stall
   * ALU outputs

---

## 🌟 Project Highlights

* Fully working 5-stage pipeline
* Handles real pipeline hazards
* Uses forwarding for performance optimization
* Verified using waveform simulation
* Modular and clean Verilog design

---

## 🧠 Key Learnings

* Pipeline improves performance via parallel execution
* Forwarding eliminates most data hazards
* Load-use hazards require stalling
* Waveform debugging is essential in hardware design

---

## 📌 Conclusion

This project successfully demonstrates:

* ✔️ 5-stage pipelined architecture
* ✔️ Data forwarding implementation
* ✔️ Load-use hazard detection and stall handling
* ✔️ Correct execution verified through simulation

---

