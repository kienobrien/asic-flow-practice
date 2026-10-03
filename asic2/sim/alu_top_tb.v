// SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
// SPDX-License-Identifier: Apache-2.0
//
// Clocked testbench for alu_top with a scoreboard.
// New random inputs go in every cycle; the expected results wait in a small
// queue for the two-cycle latency, then get compared with what comes out.
// Run:  iverilog -g2012 -o alu_top_tb.vvp alu_top_tb.v ../rtl/adder8.v ../rtl/alu_core.v ../rtl/alu_top.v && vvp alu_top_tb.vvp

`timescale 1ns/1ps

module alu_top_tb;

  localparam LATENCY = 2;
  localparam CYCLES  = 20000;

  reg        clk = 1'b0;
  reg        rst_n = 1'b0;
  reg  [7:0] a = 0, b = 0;
  reg  [2:0] op = 0;
  wire [7:0] y;
  wire       carry, overflow, zero, negative;

  alu_top dut (
    .clk(clk), .rst_n(rst_n), .a(a), .b(b), .op(op),
    .y(y), .carry(carry), .overflow(overflow), .zero(zero), .negative(negative)
  );

  always #5 clk = ~clk;   // 10 ns period, 100 MHz

  // Reference model for one operation; returns {y, carry, overflow, zero, negative}.
  function [11:0] model(input [7:0] ma, input [7:0] mb, input [2:0] mop);
    reg [8:0] w; reg [7:0] r; reg c, v;
    begin
      c = 1'b0; v = 1'b0;
      case (mop)
        3'b000: begin w = ma + mb;        r = w[7:0]; c = w[8]; v = (ma[7] == mb[7]) && (r[7] != ma[7]); end
        3'b001: begin w = {1'b0, ma} + {1'b0, ~mb} + 9'd1; r = w[7:0]; c = w[8]; v = (ma[7] != mb[7]) && (r[7] != ma[7]); end
        3'b010: r = ma & mb;
        3'b011: r = ma | mb;
        3'b100: r = ma ^ mb;
        3'b101: r = ~ma;
        3'b110: r = ma << 1;
        default: r = ma >> 1;
      endcase
      model = {r, c, v, (r == 8'h00), r[7]};
    end
  endfunction

  // Scoreboard: each expected result waits in a shift register that is as long
  // as the DUT's latency, so it pops out on the same edge as the real result.
  reg [11:0] expected [0:LATENCY-1];
  reg        valid    [0:LATENCY-1];
  integer i, cycle, checked = 0, errors = 0;

  initial begin
    if ($test$plusargs("vcd")) begin
      $dumpfile("alu_top_tb.vcd");
      $dumpvars(0, alu_top_tb);
    end
    for (i = 0; i < LATENCY; i = i + 1) valid[i] = 1'b0;

    // Hold reset for two edges, then check the reset values.
    repeat (2) @(posedge clk);
    #1;
    if (y !== 8'h00 || zero !== 1'b1) begin
      $display("FAIL: reset values wrong (y=%h zero=%b)", y, zero);
      errors = errors + 1;
    end
    rst_n = 1'b1;

    for (cycle = 0; cycle < CYCLES; cycle = cycle + 1) begin
      // 1. Drive new inputs (the previous edge was 1 ns ago).
      a  = $random;
      b  = $random;
      op = (cycle < 8) ? cycle[2:0] : $random;   // every op appears early on

      // 2. Push what the model says these inputs should produce.
      for (i = LATENCY-1; i > 0; i = i - 1) begin
        expected[i] = expected[i-1];
        valid[i]    = valid[i-1];
      end
      expected[0] = model(a, b, op);
      valid[0]    = 1'b1;

      // 3. Let the clock tick, then compare the oldest expectation with the outputs.
      @(posedge clk);
      #1;
      if (valid[LATENCY-1]) begin
        checked = checked + 1;
        if ({y, carry, overflow, zero, negative} !== expected[LATENCY-1]) begin
          if (errors < 10)
            $display("FAIL cycle %0d: got %h expected %h", cycle,
                     {y, carry, overflow, zero, negative}, expected[LATENCY-1]);
          errors = errors + 1;
        end
      end

      if (cycle == 40 && $test$plusargs("vcd")) $dumpoff;
    end

    if (errors == 0) $display("PASS: %0d results checked against the scoreboard.", checked);
    else             $fatal(1, "FAIL: %0d of %0d results wrong.", errors, checked);
    $finish;
  end

endmodule
