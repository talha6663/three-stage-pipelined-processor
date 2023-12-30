# Project Title
Three-Stage Pipelined Processor with CSR Support

# Overview
This project implements a three-stage pipelined processor with CSR (Control and Status Register) support. The processor is designed to execute instructions in a pipeline fashion, improving throughput and overall performance.

# Repository Structure
alu.sv: Implements the arithmetic logic unit (ALU).

Branch_comp.sv: Implements the branch comparison unit.

controller.sv: Implements the control unit.

data_mem.sv: Implements the data memory.

imm_gen.sv: Implements the immediate generator.

inst_decode.sv: Implements the instruction decoder.

inst_mem.sv: Implements the instruction memory.

PC.sv: Implements the program counter.

Processor.sv: Top-level module of the processor.

reg_file.sv: Implements the register file.

tb_processor.sv: Testbench for the processor.

compile_sim.bat: (Optional) Batch script to automate compilation and simulation.

## System Diagram ##
![System Diagram](/system%20diagram/systemdiagram.png)


# Additional considerations:

Simulation files: 

Place simulation-related files like memory initialization files (inst.mem, d_m.mem, rf.mem, rf_out.mem) and waveform dumps (processor.vcd) in a separate directory within work/ or tests/ to keep them organized.

Continuous integration: 

Consider using a continuous integration (CI) system to automate testing and deployment.

Visual representation:

repository_root/

├── work

│   ├── alu.sv

│   ├── Branch_comp.sv

│   ├── controller.sv

│   ├── data_mem.sv

│   ├── imm_gen.sv

│   ├── inst_decode.sv

│   ├── inst_mem.sv

│   ├── PC.sv

│   ├── Processor.sv

│   ├── reg_file.sv

│   ├── tb_processor.sv

└── README.md 

# Getting Started
Follow these steps to run and test the processor:

Clone the repository:

git clone https://github.com/talha6663/three-stage-pipelined-processor.git

# Design Diagram
For a detailed visual representation of the processor's design, refer to the Design Diagram.


# Code Explanation
The processor is divided into three stages: IF (Instruction Fetch), ID (Instruction Decode), and EX (Execution). Additionally, CSR (Control and Status Register) support is provided for managing system control.

#IF (Instruction Fetch):

Fetches instructions from memory.
Updates the program counter.

#ID (Instruction Decode):

Decodes the fetched instruction.
Reads operands from registers.

#EX (Execution):

Executes the operation based on the decoded instruction.
Manages CSR operations.

# Running

To ensure the correctness of the processor, run the provided test cases:

.\compile_sim.bat

THANKS!!!


