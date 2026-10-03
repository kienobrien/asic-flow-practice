#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build
for top in adder8_tb adder8_exhaustive_tb alu_tb alu_top_tb; do
  iverilog -g2012 -s "$top" -o "build/$top.vvp" \
    rtl/adder8.v rtl/alu_core.v rtl/alu_top.v "sim/$top.v"
  vvp "build/$top.vvp"
done
