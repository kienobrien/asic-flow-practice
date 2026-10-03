# Shared lab setup

## Verified on Kien's computer, 2026-10-03
- Windows Git 2.55.0; Ubuntu 24.04 in WSL.
- Icarus Verilog 12.0 and Yosys 0.33 installed from Ubuntu's package repository.
- Counter, priority encoder, and ALU simulations passed. Generic ALU synthesis completed (246 generic cells).
- Counter testbench input transitions moved to the falling edge to avoid a race with the rising-edge DUT.
- Icarus warns about constant selects in always_comb and ignored unique-case semantics. Existing examples ran; these checks are not complete verification.
- Full physical design, PDK installation, and course-specific tool compatibility have not been verified.

## Isaac's setup
Accept the invitations for IsaacBlommelUMN in both repositories. Clone using your own account:
```bash
git clone https://github.com/kienobrien/rtl-practice.git
git clone https://github.com/kienobrien/asic-flow-practice.git
```
On Ubuntu 24.04 (native or WSL), the verified starter tools can be installed with:
```bash
sudo apt-get update
sudo apt-get install -y iverilog yosys
iverilog -V
yosys -V
```
Run the commands in each README from that repository's root. Save your tool versions and results in a session entry. If you use another OS or toolchain, record it and compare results.

## Course requirements checked
Course: https://stone-arch-silicon.github.io/ASIC_101/#page_5

Pages 2–8 use Vivado, Git, an 8-bit ALU, exactly one custom adder architecture, exhaustive simulation, and an FPGA target for synthesis and implementation. A physical FPGA board is not required for this project. Kien's installed Vivado 2025.2 and selected xc7a12ticsg325-1L part were used for the repaired Asic2 project; its exhaustive ALU test passed in XSim. Future verification and physical-design tracks introduce additional tools; they have not all been installed.

Isaac's machine still needs its own setup verification. See the shared board and Asic2 PR for current work.

## Git workflow
```bash
git switch main
git pull --ff-only
git switch -c yourname/lab-01
# edit, simulate, and record notes
git add src tb notes
git commit -m "Complete lab 01 and record results"
git push -u origin yourname/lab-01
```
Open a PR on GitHub and ask the other person to review. Add other changed files explicitly when needed. GitHub authentication for pushing is separate from the public clone step.
