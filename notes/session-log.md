# Session log

## 2026-10-03 — Shared course workspace setup
Participants: Kien; Isaac's GitHub account: IsaacBlommelUMN.
Course: ASIC 101; Isaac has access, setup instructions pending.

- Added lab/PR templates, collaboration guidance, AI working instructions, and generated-file ignores.
- Sent invitations to both repositories; Isaac must accept.
- Installed Icarus Verilog 12.0 and Yosys 0.33 in Kien's Ubuntu 24.04 WSL environment.
- Priority encoder and ALU testbenches passed; Yosys generic synthesis completed with 246 cells.
- Counter initially reported 4 instead of 5. Inputs changed at the DUT's sampling edge; moving them to falling edges fixed the race. Corrected counter test passed.
- Next: accept invitations, verify Isaac's environment, and choose the first actual course lesson.

## Template for the next session
Date:
Participants / driver / reviewer:
Lesson and issue link:
Goal:
Commands and tool versions:
Expected versus actual results:
What each person learned:
Failed approaches and fixes:
PR / commit / evidence links:
Open questions:
Next step:

## 2026-10-03 — Asic2 carry-lookahead repair
- Read actual course pages 2, 3, 5, 7, and 8.
- Added the missing two-block CLA adder and completed the empty registered wrapper in Kien's existing Vivado project. Preserved alu_core.
- Configured design top alu_top and simulation top alu_tb, and added the course's educational 100 MHz timing constraints.
- All 131,072 adder inputs and 524,288 ALU inputs passed under Icarus; the clocked scoreboard checked 19,999 results. Vivado XSim also passed all 524,288 ALU vectors.
- Vivado RTL elaboration confirmed alu_top -> alu_core -> adder8 -> two cla4 blocks with no elaboration warnings or errors.
- Shared source and checks in PR #3; GitHub Actions simulation passed.
- Created the shared board and granted IsaacBlommelUMN Write access. The lab is in Review.
- Next: Isaac reviews equations, flags, and waveforms with Kien; accept any remaining repository invitation. Synthesis and implementation metrics remain unmeasured.
