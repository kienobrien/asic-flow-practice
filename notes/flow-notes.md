# ASIC Flow Notes

Update this file as you learn.

## 1. RTL
Describe what the hardware should do using synthesizable SystemVerilog.

## 2. Verification
Use a testbench to check functional behavior before synthesis.

Questions to answer:
- What cases did I test?
- What corner cases could still fail?
- Is the testbench self-checking?

## 3. Synthesis
Translate RTL into a gate-level representation.

Things to inspect:
- logic/cell count
- inferred structures
- warnings
- whether the synthesized logic matches the intended architecture

## 4. Timing constraints
Timing analysis needs clocks and path constraints. A purely combinational demo does not meaningfully exercise a clocked STA flow.

## 5. Physical design
Future topics:
- floorplanning
- placement
- clock-tree synthesis (CTS)
- routing
- static timing analysis (STA)
- design-rule checking (DRC)
- layout-vs-schematic (LVS)

## Interview rule
Only claim a step on a resume after you have actually done it and can explain what you did, what tool you used, and what you learned.
