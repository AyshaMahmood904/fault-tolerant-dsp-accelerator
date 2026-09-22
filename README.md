# Fault-Tolerant DSP Accelerator Using Verilog HDL

## Overview

This project presents the design and verification of a fault-tolerant Digital Signal Processing (DSP) accelerator implemented using Verilog/SystemVerilog HDL.

The design is based on a 4-tap Finite Impulse Response (FIR) filter and uses Triple Modular Redundancy (TMR) to improve reliability against single-module faults.

The project also includes fault injection and an online fault detection mechanism to verify that the system can detect a faulty processing unit while maintaining the correct output.

## Key Features

- 4-tap FIR filter implementation
- Parallel multiply-and-accumulate (MAC) architecture
- Triple Modular Redundancy (TMR)
- Majority voting logic
- Fault injection mechanism
- Fault detection logic
- Automated functional verification
- Simulation using Icarus Verilog
- Waveform-based verification using EPWave

## Architecture

The system consists of three identical FIR accelerator modules operating in parallel.

```text
                    Input Sample
                         |
              +----------+----------+
              |          |          |
              v          v          v
           FIR0         FIR1       FIR2
              |          |          |
              |    Fault Injection
              |          |          |
              +----------+----------+
                         |
                  Majority Voter
                         |
                         v
                   Final Output

              Fault Detector
                    |
                    v
             Fault Detected
```
## FIR Accelerator

The FIR accelerator implements the following 4-tap filter:
```text
y[n] = x[n]H0 + x[n-1]H1 + x[n-2]H2 + x[n-3]H3
```
The filter coefficients used in the design are:
```text
H0 = 1
H1 = 2
H2 = 3
H3 = 4
```
The multiplication and addition operations are organized as parallel datapath operations.

## Triple Modular Redundancy

Three identical FIR accelerator instances are used:
```text
FIR0
FIR1
FIR2
```
Their outputs are compared using majority voting.

If one module produces an incorrect result while the other two produce the same correct result, the majority voter selects the correct value.

## Fault Injection

A fault injection mechanism was implemented to simulate a faulty processing module.

During fault injection:
```text
FIR0 → Faulty Output
FIR1 → Correct Output
FIR2 → Correct Output
```
The majority voter continues to produce the correct final output.

## Fault Detection

The design includes a fault detector that compares the outputs of the three redundant modules.

A fault is detected when the three module outputs are not identical.
```text
Faulty Module
      |
      v
Output Mismatch
      |
      v
Fault Detector
      |
      v
fault_detected = 1
```
## Verification

The design was verified using a SystemVerilog testbench.

The verification process includes:

-Reset verification
-Functional FIR output verification
-Multiple test cases
-TMR output verification
-Fault injection testing
-Fault detection verification
-Majority voting verification

The functional verification tests passed successfully, and the fault injection experiment demonstrated that the system maintained the correct output despite a fault in one redundant module.

## Simulation

Simulation was performed using:

-Verilog/SystemVerilog
-Icarus Verilog
-EPWave

Waveform screenshots and simulation results are available in the outputs directory.

## Project Structure
```text
DSP_Project/
│
├── design.sv
├── testbench.sv
│
└── outputs/
    ├── functional verification waveforms
    ├── TMR waveforms
    ├── fault injection results
    └── fault detection results
```
## Applications

Fault-tolerant digital architectures are relevant to systems where reliability is important, including:

-Safety-critical digital systems
-Aerospace and satellite electronics
-Industrial control systems
-Reliable DSP systems
-Embedded computing
-Semiconductor and ASIC/SoC design
-Future Improvements

## Possible extensions include:

-Parameterized FIR filter architecture
-Larger number of filter taps
-Automatic fault localization
-Synthesis and area analysis
-Power and timing analysis
-FPGA implementation
-Hardware-based fault injection
##Author
```text
Aysha Mahmood
B.Tech ECE Project
```
## Technologies:
-Verilog/SystemVerilog, Digital Design, DSP, TMR, RTL Verification
