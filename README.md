# 2-D Integral Image Hardware Block Design

## Description

This project implements a hardware block for computing the 2-D integral image from an input grayscale image of size M×N, using VHDL. The system is designed based on the FSMD (Finite State Machine with Datapath) architecture and implemented using the Vivado Design Suite.

## System Architecture

- **Datapath**: Performs summation and interacts with memory for read/write operations.
- **Controller**: Controls the computation process row by row and column by column.
- **Memory (Mock RAM)**: Stores both original and computed integral image data.
- **Top-level Module**: Interfaces with CPU, memory, and manages overall operation.

## Specifications

- Input: Image, up to 256×256 in size.
- Data width: 32-bit.
- Clock: 100 MHz (10 ns period).
- After implemtation: use phase shift: 3 ns delay added to the controller clock to avoid glitches.
- Resource usage: Less than 1% of available LUTs and FFs.

## Simulation & Results

- Functional simulation and post-implementation timing simulation were performed.
- Tested with multiple image sizes:
  - 5×5 → 250 clock cycles
  - 8×8 → 587 clock cycles
  - 256×256 → 526,747 clock cycles
- The output was accurate, and timing was met after applying clock phase adjustment.

## Tools Used

- **Vivado Design Suite** (Xilinx)
- **ModelSim / Vivado Simulator**
- Language: **VHDL**

## Authors

- Nguyễn Tiến Dũng – 22022113  
- Vũ Anh Tuấn – 22022114  
- University of Engineering and Technology – VNU

