//probably need a timescale statement in each of the .v files btw



module alu_core (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire [2:0] op,

  output reg  [7:0] y,
  output reg        carry,
  output reg        overflow,
  output reg        zero,
  output reg        negative
);

  wire       sub;
  wire [7:0] b_arith;
  wire [7:0] arithmetic_result;
  wire       arithmetic_cout;

  assign sub     = (op == 3'b001);
  assign b_arith = b ^ {8{sub}};

  adder8 u_adder (
    .a    (a),
    .b    (b_arith),
    .cin  (sub),
    .sum  (arithmetic_result),
    .cout (arithmetic_cout)
  );

  always @* begin
    y        = 8'h00;
    carry    = 1'b0;
    overflow = 1'b0;

    case (op)
      3'b000: begin
        y        = arithmetic_result;
        carry    = arithmetic_cout;
        overflow = (~(a[7] ^ b[7])) & (y[7] ^ a[7]);
      end

      3'b001: begin
        y        = arithmetic_result;
        carry    = arithmetic_cout;
        overflow = (a[7] ^ b[7]) & (y[7] ^ a[7]);
      end

      3'b010: y = a & b;
      3'b011: y = a | b;
      3'b100: y = a ^ b;
      3'b101: y = ~a;
      3'b110: y = a << 1;
      3'b111: y = a >> 1;

      default: y = 8'h00;
    endcase

    zero     = (y == 8'h00);
    negative = y[7];
  end

endmodule