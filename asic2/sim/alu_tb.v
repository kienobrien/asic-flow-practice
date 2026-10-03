// SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
// SPDX-License-Identifier: Apache-2.0
//
// Exhaustive testbench for alu_core: every a, every b, every op (256 x 256 x 8).
// Run:  iverilog -g2012 -o alu_tb.vvp alu_tb.v ../rtl/adder8.v ../rtl/alu_core.v && vvp alu_tb.vvp
// Add +vcd to dump the first few hundred vectors to alu_tb.vcd.

`timescale 1ns/1ps

module alu_tb;

  reg  [7:0] a, b;
  reg  [2:0] op;
  wire [7:0] y;
  wire       carry, overflow, zero, negative;

  // expected values from the reference model
  reg  [7:0] exp_y;
  reg        exp_carry, exp_overflow, exp_zero, exp_negative;
  reg  [8:0] wide;

  integer ia, ib, iop;
  integer errors  = 0;
  integer vectors = 0;

  alu_core dut (
    .a(a), .b(b), .op(op),
    .y(y), .carry(carry), .overflow(overflow), .zero(zero), .negative(negative)
  );

  // Reference model: written independently of the RTL, using plain operators.
  task model;
    begin
      exp_carry    = 1'b0;
      exp_overflow = 1'b0;
      case (op)
        3'b000: begin
          wide         = {1'b0, a} + {1'b0, b};
          exp_y        = wide[7:0];
          exp_carry    = wide[8];
          exp_overflow = ($signed(a) + $signed(b) > 127) || ($signed(a) + $signed(b) < -128);
        end
        3'b001: begin
          wide         = {1'b0, a} + {1'b0, ~b} + 9'd1;
          exp_y        = wide[7:0];
          exp_carry    = wide[8];
          exp_overflow = ($signed(a) - $signed(b) > 127) || ($signed(a) - $signed(b) < -128);
        end
        3'b010:  exp_y = a & b;
        3'b011:  exp_y = a | b;
        3'b100:  exp_y = a ^ b;
        3'b101:  exp_y = ~a;
        3'b110:  exp_y = a << 1;
        default: exp_y = a >> 1;
      endcase
      exp_zero     = (exp_y == 8'h00);
      exp_negative = exp_y[7];
    end
  endtask

  task check;
    begin
      model;
      #1;
      vectors = vectors + 1;
      if ({y, carry, overflow, zero, negative} !==
          {exp_y, exp_carry, exp_overflow, exp_zero, exp_negative}) begin
        if (errors < 10)
          $display("FAIL op=%b a=%h b=%h | got y=%h c=%b v=%b z=%b n=%b | expected y=%h c=%b v=%b z=%b n=%b",
                   op, a, b, y, carry, overflow, zero, negative,
                   exp_y, exp_carry, exp_overflow, exp_zero, exp_negative);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    if ($test$plusargs("vcd")) begin
      $dumpfile("alu_tb.vcd");
      $dumpvars(0, alu_tb);
    end

    // A few recognizable vectors first, so the start of the waveform is readable.
    a = 8'h01; b = 8'h01; op = 3'b000; check;   // 1 + 1
    a = 8'h7F; b = 8'h01; op = 3'b000; check;   // 127 + 1 overflows signed range
    a = 8'h00; b = 8'h01; op = 3'b001; check;   // 0 - 1 borrows
    a = 8'hAA; b = 8'h55; op = 3'b100; check;   // XOR of alternating bits
    a = 8'h81; b = 8'h00; op = 3'b110; check;   // shift left drops the top bit
    a = 8'h81; b = 8'h00; op = 3'b111; check;   // shift right drops the bottom bit

    if ($test$plusargs("vcd")) $dumpoff;          // keep the waveform file small

    for (iop = 0; iop < 8; iop = iop + 1)
      for (ia = 0; ia < 256; ia = ia + 1)
        for (ib = 0; ib < 256; ib = ib + 1) begin
          op = iop[2:0]; a = ia[7:0]; b = ib[7:0];
          check;
        end

    if (errors == 0) $display("PASS: all %0d exhaustive ALU vectors passed.", vectors - 6);
    else             $fatal(1, "FAIL: %0d of %0d vectors failed.", errors, vectors);
    $finish;
  end

endmodule
