// SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
// SPDX-License-Identifier: Apache-2.0
//
// Registered wrapper around alu_core. Inputs are captured on one clock edge and
// the result is captured on the next, so every timing path is register to register.
// Latency: a result appears on the outputs two rising edges after its inputs.

`timescale 1ns/1ps

module alu_top (
  input  wire       clk,
  input  wire       rst_n,     // active-low, synchronous
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire [2:0] op,
  output reg  [7:0] y,
  output reg        carry,
  output reg        overflow,
  output reg        zero,
  output reg        negative
);

  reg  [7:0] a_q, b_q;
  reg  [2:0] op_q;

  wire [7:0] y_d;
  wire       carry_d, overflow_d, zero_d, negative_d;

  alu_core u_core (
    .a(a_q), .b(b_q), .op(op_q),
    .y(y_d), .carry(carry_d), .overflow(overflow_d), .zero(zero_d), .negative(negative_d)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      a_q      <= 8'h00;
      b_q      <= 8'h00;
      op_q     <= 3'b000;
      y        <= 8'h00;
      carry    <= 1'b0;
      overflow <= 1'b0;
      zero     <= 1'b1;
      negative <= 1'b0;
    end else begin
      a_q      <= a;
      b_q      <= b;
      op_q     <= op;
      y        <= y_d;
      carry    <= carry_d;
      overflow <= overflow_d;
      zero     <= zero_d;
      negative <= negative_d;
    end
  end

endmodule
