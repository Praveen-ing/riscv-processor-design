# RISC-V Processor Design (Sequential & Pipelined)

This project implements a **64-bit RISC-V processor** in Verilog with both **sequential single-cycle** and **5-stage pipelined architectures**. It was developed as part of the IPA project at IIIT Hyderabad to understand modern processor design concepts, pipelining, hazard detection, and control logic implementation.

---

## 🚀 **Features**

✅ Implements RISC-V RV64I base instructions  
✅ Sequential single-cycle processor implementation  
✅ 5-stage pipelined processor with:
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)

✅ Modules for:
- ALU and ALU Control
- Control Unit
- Instruction Memory
- Data Memory
- Register File
- Immediate Generator
- Forwarding Unit
- Hazard Detection Unit
- Pipeline Registers

✅ Supports:
- Data hazards (Forwarding, Stall)
- Control hazards (Branch flushing)
- Testcases including Fibonacci computation

---

## 📁 **File Structure**

├── alu.v
├── alu_control.v
├── control.v
├── data_memory.v
├── instruction_memory.v
├── immediate_generator.v
├── register_file.v
├── new_pc.v
├── forwarding_unit.v
├── hazard_detection_unit.v
├── pipeline_registers.v
├── sequential_wrapper.v
├── pipelined_wrapper.v
├── testbenches/
│   ├── alu_tb.v
│   └── ...
├── Final Report.pdf
└── README.md

---

## ⚙️ **Modules Overview**

| Module | Description |
|--------|-------------|
| `alu.v` | Performs 64-bit arithmetic and logical operations. |
| `alu_control.v` | Generates control signals for ALU based on instruction funct fields. |
| `control.v` | Decodes instruction opcodes and generates control signals. |
| `data_memory.v` | Implements data memory for load and store operations. |
| `instruction_memory.v` | Stores program instructions and outputs based on PC. |
| `immediate_generator.v` | Extracts and sign-extends immediate values from instructions. |
| `register_file.v` | 32 registers (x0 to x31), with two read ports and one write port. |
| `new_pc.v` | Calculates next PC based on branch decisions. |
| `forwarding_unit.v` | Handles data hazards by forwarding ALU results to dependent instructions. |
| `hazard_detection_unit.v` | Detects load-use and control hazards; stalls or flushes pipeline accordingly. |
| `pipeline_registers.v` | Implements IF/ID, ID/EX, EX/MEM, MEM/WB pipeline registers. |
| `sequential_wrapper.v` | Top-level module for sequential processor. |
| `pipelined_wrapper.v` | Top-level module for pipelined processor. |

---

I individually implemented the following core modules:

- **ALU (Arithmetic Logic Unit)**: 64-bit addition, subtraction, AND, OR with overflow detection.  
- **ALU Control Unit**: Generates control signals based on instruction funct fields.  
- **Data Memory Module**: Handles load and store operations.  
- **Forwarding Unit**: Resolves data hazards in the pipelined architecture.  
- **Sequential Processor Wrapper**: Integrates all sequential modules.  
- **Pipelined Processor Wrapper**: Integrates all pipelined modules.  
- **Testbenches**: Developed for verifying ALU, forwarding unit, and overall pipeline functionality.

*(Other modules such as instruction memory, control unit, and immediate generator were collaboratively reviewed.)*

---

## 🖥️ **Simulation**

Run testbenches using your preferred Verilog simulator:

```bash
# Example using Icarus Verilog
iverilog -o alu_tb alu.v alu_tb.v
vvp alu_tb
gtkwave alu_tb.vcd

---
📷 Sample Outputs
1. ALU Operation (Addition)

2. Pipeline Execution

3. Hazard Detection Unit

(Add your GTKWave screenshots in an images/ folder for clarity.)

📚 Final Report
See Final Report.pdf for detailed explanation of:

Architecture and module designs

Pipelining implementation

Hazard detection logic

Sample testcases

📝 License
This project is licensed under the MIT License.

✉️ Contact
Created by Nethavath Praveen, IIIT Hyderabad.
Email | LinkedIn | GitHub
