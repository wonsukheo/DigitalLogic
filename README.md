# DigitalLogic
DL2 FinalProject_25SP
# IEEE 754 Half-Precision Floating-Point Adder/Subtractor

An implementation of a 16-bit half-precision floating-point arithmetic unit built using SystemVerilog/Verilog, synthesized in Intel Quartus Prime, and deployed on a DE10-Lite FPGA board.

## Project Overview
This project implements a hardware-level arithmetic unit capable of performing both addition and subtraction on 16-bit floating-point numbers conforming to the IEEE 754 standard (1 sign bit, 5 exponent bits, and 10 mantissa bits). Inputs are delivered via a 4x4 matrix keypad, and the outputs are displayed in hexadecimal format on a seven-segment display module.

### Key Features
* **Full IEEE 754 Core:** Handles sign alignment, exponent comparison, mantissa normalization, and hidden-bit insertion.
* **Operation Control:** Toggles dynamically between Addition (`0`) and Subtraction (`1`) via hardware switch `SW0`.
* **Exception Flags:** Hardware-mapped indicators for real-time debugging:
  * `LEDR0`: Underflow detection (triggers if the exponent drops to `00000` after normalization).
  * `LEDR2`: Overflow detection (triggers if the exponent reaches `11111`, representing infinity).
* **Robust I/O Processing:** Features hardware debouncing for input switches and a custom Finite State Machine (FSM) to decode 4x4 keypad matrix scanning.

## System Architecture
The design is modularized into dedicated RTL blocks to optimize data path propagation delays and logic utilization:
* **`HalfPrecisionFPAddSub`**: The top-level arithmetic core driving the execution unit.
* **`MantissaNormalizerShifter` & `Barrel Shifters`**: Handles leading-zero detection, dynamic bit shifting, and final exponent adjustments.
* **`FSM` & `keypad_decoder`**: Drives the matrix scanning logic to capture asynchronous hex inputs safely.
* **`clock_div`**: Divides the high-frequency onboard clock down to stable operational frequencies required for debouncing and sequential logic.

## Hardware Demonstration

Click below to watch the full project demonstration (Google Drive Link): https://drive.google.com/file/d/1Ner-ok_hpGiTdJ8SQWl8-W1FJ9TPzsxc/view?usp=sharing

A list of verified test vectors running on physical hardware:
| Operand A (Hex) | Operand B (Hex) | Op | Expected Result (Hex) | Dec equivalent | Status |
|---|---|---|---|---|---|
| `0x4380` | `0x4520` | + | `0x4870` | 8.875 | Verified |
| `0x4380` | `0x4520` | - | `0xBD80` | -1.375 | Verified |
| `0x48C0` | `0x3880` | + | `0x4908` | 10.0625 | Verified |
| `0x7800` | `0x7800` | + | `0x7C00` | INFINITY (Overflow) | Verified |
| `0x0401` | `0x0400` | - | `0x0000` | UNDERFLOW | Verified |
