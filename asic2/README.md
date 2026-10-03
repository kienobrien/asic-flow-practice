# Asic2 — carry-lookahead ALU

Course: https://stone-arch-silicon.github.io/ASIC_101/#page_5

Implemented the course's 8-bit block carry-lookahead design: two 4-bit `cla4` blocks form `adder8`. Carry equations expand within each block; the upper block receives the lower block's carry. No arithmetic `+` operator or vendor adder IP is used in the adder.

The existing `alu_core` is preserved. ADD uses `a + b` through `adder8`; SUB uses `a + ~b + 1` through the same hardware. For subtraction, carry means no borrow. `alu_top` now registers inputs and outputs with synchronous active-low reset, as specified on course page 3.

## Original Vivado project

Updated `C:/Users/kieno/Asic2/Asic2.xpr` in place. Sources were registered in Vivado, synthesis top set to `alu_top`, simulation top set to `alu_tb`, and the page 8 educational 100 MHz constraint was added. Reopen the project in an existing Vivado window to reload its project metadata.

Target part remains `xc7a12ticsg325-1L`. The timing assumptions are educational, not board-specific pin assignments.

## Verification, 2026-10-03

- Icarus Verilog 12.0: all 131,072 combinations of adder inputs passed.
- Icarus Verilog 12.0: all 524,288 ALU combinations passed, including all four flags.
- Icarus Verilog 12.0: 19,999 pipelined results passed the course scoreboard.
- Vivado XSim 2025.2: all 524,288 exhaustive ALU vectors passed in the original project.
- Synthesis, place-and-route, power, and FPGA performance comparisons have not been run for this CLA project.

Run locally in Ubuntu / WSL from this folder:

```bash
bash run-tests.sh
```

The course testbenches compare against an independent arithmetic model. Failure paths use `$fatal` so failures return a nonzero status. The exhaustive adder test is an additional check covering both carry-in values.

Reports contain simulation logs. VCD files contain the initial directed ALU examples and early pipelined cycles. Vivado's waveform database is also saved in the original project's simulation directory.

## Next session with Isaac

Explain propagate (`p = a ^ b`) and generate (`g = a & b`), trace `FF + 01`, and review ADD versus SUB flags. Inspect the waveforms from page 7 before moving to the synthesis and implementation tasks on page 8. Record measured timing and utilization rather than assuming the CLA is faster on an FPGA.

## Attribution

`adder8.v`, `alu_top.v`, and the three course testbenches are adapted from Stone Arch Silicon's Apache-2.0 reference sources in https://github.com/Stone-Arch-Silicon/ASIC_101/tree/main/files/alu. Their attribution headers are retained. `alu_core.v` is copied from Kien's existing project. The original project metadata and empty wrapper were backed up before replacement.
