// SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
// SPDX-License-Identifier: Apache-2.0
//
// First self-checking testbench: a handful of directed tests for adder8.
// Run:  iverilog -g2012 -o adder8_tb.vvp adder8_tb.v ../rtl/adder8.v && vvp adder8_tb.vvp

`timescale 1ns/1ps

module adder8_tb;

  reg  [7:0] a, b;
  reg        cin;
  wire [7:0] sum;
  wire       cout;

  integer errors = 0;

  adder8 dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

  // Apply one test, wait for the logic to settle, then compare with the expected answer.
  task check(input [7:0] ta, input [7:0] tb, input tcin, input [8:0] expected);
    begin
      a = ta; b = tb; cin = tcin;
      #5;
      if ({cout, sum} !== expected) begin
        $display("FAIL: %0d + %0d + %0d gave %0d, expected %0d", ta, tb, tcin, {cout, sum}, expected);
        errors = errors + 1;
      end else begin
        $display("ok:   %0d + %0d + %0d = %0d", ta, tb, tcin, {cout, sum});
      end
    end
  endtask

  initial begin
    if ($test$plusargs("vcd")) begin
      $dumpfile("adder8_tb.vcd");
      $dumpvars(0, adder8_tb);
    end

    check(8'd0,   8'd0,   1'b0, 9'd0);     // nothing at all
    check(8'd1,   8'd1,   1'b0, 9'd2);     // smallest carry
    check(8'd127, 8'd1,   1'b0, 9'd128);   // carry ripples through seven bits
    check(8'd255, 8'd1,   1'b0, 9'd256);   // carry ripples out the top
    check(8'd200, 8'd100, 1'b0, 9'd300);   // ordinary overflow of 8 bits
    check(8'd255, 8'd255, 1'b1, 9'd511);   // largest possible answer

    if (errors == 0) $display("PASS: all directed adder tests passed");
    else             $fatal(1, "FAIL: %0d test(s) failed", errors);
    $finish;
  end

endmodule
