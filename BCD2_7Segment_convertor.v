module BCD_2_SEG7 (BCD, SEG7);
  input [3:0] BCD;
  output reg [1:7] SEG7;
  always @(BCD)
    case (BCD) //abcdefg
      0:      leds = 7¡¯b1111110;
      1:      leds = 7¡¯b0110000;
      2:      leds = 7¡¯b1101101;
      3:      leds = 7¡¯b1111001;
      4:      leds = 7¡¯b0110011;
      5:      leds = 7¡¯b1011011;
      6:      leds = 7¡¯b1011111;
      7:      leds = 7¡¯b1110000;
      8:      leds = 7¡¯b1111111;
      9:      leds = 7¡¯b1111011;
     default: leds = 7¡¯b1001111;  //"E"
   endcase
endmodule

module BCD_2_SEG7 (BCD, a,b,c,d,e,f,g);
  input [3:0] BCD;
  output a,b,c,d,e,f,g;
  reg [6:0] leds;
  always @(BCD) begin
    case (BCD) //abcdefg
      0:      leds = 7¡¯b1111110;
      1:      leds = 7¡¯b0110000;
      2:      leds = 7¡¯b1101101;
      3:      leds = 7¡¯b1111001;
      4:      leds = 7¡¯b0110011;
      5:      leds = 7¡¯b1011011;
      6:      leds = 7¡¯b1011111;
      7:      leds = 7¡¯b1110000;
      8:      leds = 7¡¯b1111111;
      9:      leds = 7¡¯b1111011;
     default: leds = 7¡¯b1001111;  //"E"
   end
   assign {a,b,c,d,e,f,g}=leds;
   endcase
endmodule