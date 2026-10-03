`timescale 1ns / 1ps




module alu_top (
  input  wire       clk,
  input  wire       rst_n,
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire [2:0] op,

  output reg  [7:0] y,
  output reg        carry,
  output reg        overflow,
  output reg        zero,
  output reg        negative
);

  reg [7:0] a_q;
  reg [7:0] b_q;
  reg [2:0] op_q;

  wire [7:0] y_comb;
  wire       carry_comb;
  wire       overflow_comb;
  wire       zero_comb;
  wire       negative_comb;

  alu_core u_core (
    .a        (a_q),
    .b        (b_q),
    .op       (op_q),
    .y        (y_comb),
    .carry    (carry_comb),
    .overflow (overflow_comb),
    .zero     (zero_comb),
    .negative (negative_comb)
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
    end
    else begin
      a_q      <= a;
      b_q      <= b;
      op_q     <= op;

      y        <= y_comb;
      carry    <= carry_comb;
      overflow <= overflow_comb;
      zero     <= zero_comb;
      negative <= negative_comb;
    end
  end

endmodule