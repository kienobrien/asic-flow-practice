# ASIC Flow Practice

Personal learning repository for taking a small RTL design through early ASIC implementation steps.

> This is a **personal practice project**, not a Stone Arch Silicon project and not a taped-out chip.

## Current design
An 8-bit ALU supporting:
- ADD
- SUB
- AND
- OR
- XOR
- pass-through A
- pass-through B
- zero

## What this repo is for
The goal is to understand the handoff between:
1. RTL design
2. simulation / verification
3. synthesis
4. timing constraints
5. gate-level implementation
6. later physical-design work such as floorplanning, placement, CTS, routing, STA, and DRC

## Files
- `src/alu.sv` — synthesizable RTL
- `tb/tb_alu.sv` — self-checking testbench
- `constraints/alu.sdc` — timing-constraint scaffold for future sequential versions
- `scripts/synth.ys` — starter Yosys synthesis script
- `notes/flow-notes.md` — notes to update as I learn the ASIC flow

## Run the RTL testbench
```bash
mkdir -p build
iverilog -g2012 -o build/alu_tb src/alu.sv tb/tb_alu.sv
vvp build/alu_tb
```

## Run generic synthesis with Yosys
```bash
mkdir -p build
yosys -s scripts/synth.ys
```

## Important
Generic Yosys synthesis is **not** the same as a foundry-ready ASIC flow. Real physical design requires a PDK, standard-cell libraries, timing models, routing rules, and implementation tools.

## Next milestones
- add registered inputs/outputs so timing constraints are meaningful
- inspect synthesized netlist and cell statistics
- learn static timing analysis
- run a small design through an OpenROAD/OpenLane flow with a supported open PDK
- compare area/timing after RTL changes

## ASIC 101 with Isaac

Start with [our collaboration guide](CONTRIBUTING.md), [shared setup](notes/setup.md), and [session log](notes/session-log.md). Use the lesson/lab issue template and the pull request template to share work and explanations.

Course hub: [ASIC Flow Practice](https://github.com/kienobrien/asic-flow-practice). RTL exercises: [RTL Practice](https://github.com/kienobrien/rtl-practice).

Shared board: [ASIC 101 — Kien and Isaac](https://github.com/users/kienobrien/projects/1).

Course: [Stone Arch Silicon ASIC 101](https://stone-arch-silicon.github.io/ASIC_101/#page_5).

Current lab: [Carry-lookahead adder](https://github.com/kienobrien/asic-flow-practice/issues/2). Verified implementation: [Asic2 review PR](https://github.com/kienobrien/asic-flow-practice/pull/3).
