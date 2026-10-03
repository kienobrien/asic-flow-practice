`timescale 1ns/1ps

module alu_tb;

  reg  [7:0] a;
  reg  [7:0] b;
  reg  [2:0] op;

  wire [7:0] y;
  wire       carry;
  wire       overflow;
  wire       zero;
  wire       negative;

  reg  [7:0] exp_y;
  reg        exp_carry;
  reg        exp_overflow;
  reg        exp_zero;
  reg        exp_negative;
  reg  [8:0] tmp;

  integer ia;
  integer ib;
  integer iop;
  integer errors;

  alu_core dut (
    .a        (a),
    .b        (b),
    .op       (op),
    .y        (y),
    .carry    (carry),
    .overflow (overflow),
    .zero     (zero),
    .negative (negative)
  );

  task check_current;
    begin
      exp_y        = 8'h00;
      exp_carry    = 1'b0;
      exp_overflow = 1'b0;
      tmp          = 9'h000;

      case (op)
        3'b000: begin
          tmp          = {1'b0, a} + {1'b0, b};
          exp_y        = tmp[7:0];
          exp_carry    = tmp[8];
          exp_overflow = (~(a[7] ^ b[7])) & (exp_y[7] ^ a[7]);
        end

        3'b001: begin
          tmp          = {1'b0, a} + {1'b0, (~b)} + 9'd1;
          exp_y        = tmp[7:0];
          exp_carry    = tmp[8];
          exp_overflow = (a[7] ^ b[7]) & (exp_y[7] ^ a[7]);
        end

        3'b010: exp_y = a & b;
        3'b011: exp_y = a | b;
        3'b100: exp_y = a ^ b;
        3'b101: exp_y = ~a;
        3'b110: exp_y = a << 1;
        3'b111: exp_y = a >> 1;
      endcase

      exp_zero     = (exp_y == 8'h00);
      exp_negative = exp_y[7];

      #1;

      if (
        (y        !== exp_y)        ||
        (carry    !== exp_carry)    ||
        (overflow !== exp_overflow) ||
        (zero     !== exp_zero)     ||
        (negative !== exp_negative)
      ) begin

        if (errors < 20) begin
          $display(
            "FAIL op=%b a=%h b=%h | y=%h c=%b v=%b z=%b n=%b | expected y=%h c=%b v=%b z=%b n=%b",
            op, a, b,
            y, carry, overflow, zero, negative,
            exp_y, exp_carry, exp_overflow, exp_zero, exp_negative
          );
        end

        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    a      = 8'h00;
    b      = 8'h00;
    op     = 3'b000;

    // A few recognizable vectors appear at the beginning of the waveform.
    a = 8'h01; b = 8'h01; op = 3'b000; check_current;
    a = 8'h7F; b = 8'h01; op = 3'b000; check_current;
    a = 8'h00; b = 8'h01; op = 3'b001; check_current;
    a = 8'hAA; b = 8'h55; op = 3'b100; check_current;
    a = 8'h81; b = 8'h00; op = 3'b110; check_current;
    a = 8'h81; b = 8'h00; op = 3'b111; check_current;

    // Exhaustive verification.
    for (iop = 0; iop < 8; iop = iop + 1) begin
      for (ia = 0; ia < 256; ia = ia + 1) begin
        for (ib = 0; ib < 256; ib = ib + 1) begin
          op = iop[2:0];
          a  = ia[7:0];
          b  = ib[7:0];
          check_current;
        end
      end
    end

    if (errors == 0)
      $display("PASS: all 524288 exhaustive ALU vectors passed.");
    else
      $display("FAIL: %0d vectors failed.", errors);

    $finish;
  end

endmodule