module RYG_light
(
input wire clk,//0.1s clock
input wire rst,
output reg r,y,g,
);

//internal reg declearation
reg [1:0] state, state_next;
reg [4:0] cnt, cnt_next;

// state declearation
localparam [2:0]
    RED  = 2'b00,
    YELLOW  = 2'b01,
    GREEN  = 2'b11,
 
//current state
always@(posedge clk)
if (rst)   begin
           state<=RED;
           cnt<=20
           end
else begin
     state<=state_next;
     cnt<= cnt_next;
     end

//next state logic
always @ *
begin
state_next =state;
case (state)
    RED:    begin
                 if (cnt==0) begin state_next=YELLOW;cnt_next=30; end
                 else cnt_next=cnt-1;
           end
    YELLOW:    begin
                 if (cnt==0) begin state_next=GREEN;cnt_next=10; end
                 else cnt_next=cnt-1;
           end
    GREEN:    begin
                 if (cnt==0) begin state_next=RED;cnt_next=20; end
                 else cnt_next=cnt-1;
           end

    default:  begin state_next =RED;cnt_next=20; end
end

//OUTPUT LOGIC
always@* begin

if (state==RED)  begin r=2'b1; y=2'b0; g=2'b0;
                 end
if (state==YELLOW)  begin r=2'b0; y=2'b1; g=2'b0;
                 end
if (state==GREEN)  begin r=2'b0; y=2'b0; g=2'b1;
                 end
endmodule
