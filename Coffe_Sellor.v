module coffe_seller
(
input wire clk,
input wire rst,
input wire [1:0] M_in,
input wire [3:0] sel_in,
input wire cancle, 
output reg inport,
output reg  return,
output reg tast_lamp,
output reg [1:0] change,
output reg  [3:0] out,
output reg change_en,
output reg out_en
);

//internal reg declearation
reg [2:0] state, state_next;

// state declearation
localparam [2:0]
    IDLE     = 2'b000,
    S5       = 2'b001,
    S10      = 2'b010,
    S15      = 2'b011,
    S20      = 2'b100,
    CANCLE   = 2'B101,
    SELECT   = 2'B110,
    OUT      = 2'B111;

//current state
always@(posedge clk)
if (rst)   state<=IDLE;
else state<=state_next;

//next state logic
always @ *
begin
state_next =state;
case (state)
   IDLE:      begin
                 if (m_in==2'b01) state_next=S5;
                 else if (m_in== 2'b10) state_next=S10;
              end
    S5:       begin
                 if (cancle) state_next= CANCLE;
                 else if(m_in==2'b01) state_next=S10;
                          else if(m_in==2'b10) state_next=S15;
              end
     S10:     begin
                  if (cancle) state_next= CANCLE;
                 else if(m_in==2'b01) state_next=S15;
                          else if(m_in==2'b10) state_next=S20;
              end
     S15:     begin
                   state_next =SELECT;
              end
     S20:     begin
                  state_next =SELECT;
              end
     SELECT:  begin
                   if (cancle) state_next =CANCLE;
                   else if (sel_in<>0) state_next = OUT;
              end
      OUT:      state_next =IDLE;
      default:  state_next =IDLE;
end

//OUTPUT LOGIC
always@* begin
tast_lamp=1'b0;
in_port=1'b1;
out_en=1'b0;
change_en=1'b0;
if (state==IDLE)  begin change=2'b0; out=4'b0; return=1'b0; end
if (state==S15)  change=2'b0;
if (state==S20)  change=2'b01;
if (state==SELECT) begin tast_lamp=1'b1; in_port=1'b0; out=sel_in;  end
if (state==CANCLE) return=1;
if (state==OUT) begin out_en=1'b1; change_en=1'b1;  end    
end

endmodule
