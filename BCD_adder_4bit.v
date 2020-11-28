// 4-bit BCD full adder
module BCD_adder_4bit (A, B, C_IN, C_OUT, SUM);
  input [3:0] A;B
  input C_IN;
  output wire [3:0] SUM;
  output wire C_OUT
wire [3:0] sum1;
wire cout1, and1_out, and2_out;
wire dummy1;
wire [3:0] dummy2;
wire dummy3;

assign dummy2={0,C_OUT,C_OUT,0};

and and1(and1_out,sum1(3),sum1(2));
and and2(and2_out,sum1(3),sum1(1));
or or1(C_OUT,cout1,and1_out,and2_out);
adder_4bit adder1(.A(A), .B(B), .C_IN(C_IN), .C_OUT(cout1), .SUM(sum1));
adder_4bit adder2(.A(dummy2), .B(sum1), .C_IN(dummy1), .C_OUT(dummy3), .SUM(SUM));

endmodule