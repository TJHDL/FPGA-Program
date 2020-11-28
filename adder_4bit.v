// 4-bit binary adder
module adder_4bit (A, B, C_IN, C_OUT, SUM);
  input [3:0] A;B
  input C_IN;
  output reg [3:0] SUM;
  output reg C_OUT
  always @ *
    {C_OUT,SUM} = A+B;
endmodule