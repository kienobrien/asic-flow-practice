// Exhaustive verification independent of the lookahead equations.
`timescale 1ns/1ps
module adder8_exhaustive_tb;
  reg [7:0] a, b;
  reg cin;
  wire [7:0] sum;
  wire cout;
  reg [8:0] expected;
  integer ia, ib, ic, checked;
  adder8 dut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
  initial begin
    checked = 0;
    for (ic = 0; ic < 2; ic = ic + 1)
      for (ia = 0; ia < 256; ia = ia + 1)
        for (ib = 0; ib < 256; ib = ib + 1) begin
          a = ia[7:0]; b = ib[7:0]; cin = ic[0];
          expected = {1'b0, a} + {1'b0, b} + cin;
          #1;
          if ({cout, sum} !== expected)
            $fatal(1, "Adder mismatch a=%h b=%h cin=%b got=%h expected=%h",
                   a, b, cin, {cout, sum}, expected);
          checked = checked + 1;
        end
    $display("PASS: all %0d exhaustive adder vectors passed.", checked);
    $finish;
  end
endmodule
