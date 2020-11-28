//4bit´®ĞĞÊäÈëººÃ÷±àÂë
module HammingCoding_4bit
(
input wire clk,
input wire start,
input wire rst,
input wire din,
output reg ready,
output reg  done,
output reg [6:0] dout
);

//internal reg declearation
reg [2:0] state, state_next;
reg  A0,A1,A2,A0_next,A1_next,A2_next;
reg [3:0] d_temp;

// state declearation
localparam [2:0]
    IDLE    = 2'b000,
    SBIT3      = 2'b001,
    SBIT4      = 2'b010,
    SBIT5      = 2'b011,
    SBIT6      = 2'b100,
    DONE    = 2'b101;

//current state
always@(posedge clk) begin
  if (rst) begin
             state<=IDLE;
             A0<=0;
             A1<=0;
             A2<=0;
           end
  else     begin
             state<=state_next;
             A0<=A0_next;
             A1<=A1_next;
             A2<=A2_next;
           end
end

//next state logic
always @ * 
begin
state_next =state;
A0_next = A0;
A1_next = A1;
A2_next = A2;
case (state)
   IDLE:    begin
                 if (start)  begin
                                  state_next=SBIT3;
                                  dout = 7'b0;
                             end
            end

    SBIT3:     begin
                 state_next=SBIT4;
                 A0_next = din;                                                   //(A3)
                 A1_next = din;                                                   //(A3), A2 holds as default value
                 d_temp = {d_temp[3:1],din};                            // d_temp[0]= din
             end
    SBIT4:     begin
                 state_next=SBIT5;
                 A0_next = A0^din;                                          // (A3^A4)
                 A2_next = din;                                                // (A4), A1 holds as bit3
                 d_temp ={d_temp[3:2],din,d_temp[0]};         //d_temp[1]= din
             end
    SBIT5:     begin
                 state_next=SBIT6;
                 A1_next = A1^din;                                          //(A3^A5)
                 A2_next = A2^din;                                          //(A4^A5), A0 holds as sbit4 value(A3^A4)
                 d_temp={d_temp[3], din, d_temp[1:0]};       //d_temp[2]= din
             end
    SBIT6:     begin
                 state_next=DONE;
                 A0_next = A0^din;                                       //(A3^A4^A5)
                 A1_next = A1^din;                                       //(A3^A5^A6)
                 A2_next = A2^din;                                      //(A4^A5^A6) 
                 d_temp={din, d_temp[2:0]};                       //d_temp[3]= din
             end

    DONE:    state_next= IDLE;

    default:  state_next =IDLE;
end

//OUTPUT LOGIC
always@* begin
                   ready=1'b0;
                   done=1'b0;
                   if (state==IDLE)  begin ready=1'b1; end
                   if (state==DONE)  begin  done=2'b1; dout={d_temp, A2,A1,A0}; end
                   end

endmodule
