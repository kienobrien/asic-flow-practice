module alu #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2:0]       op,
    output logic [WIDTH-1:0] y,
    output logic             zero
);

    always_comb begin
        unique case (op)
            3'b000: y = a + b;
            3'b001: y = a - b;
            3'b010: y = a & b;
            3'b011: y = a | b;
            3'b100: y = a ^ b;
            3'b101: y = a;
            3'b110: y = b;
            default: y = '0;
        endcase

        zero = (y == '0);
    end

endmodule
