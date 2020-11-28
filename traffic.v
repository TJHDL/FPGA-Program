module traffic
(
input wire clk,//1s clock
input wire rst,
output reg r1,r2,y1,y2,g1,g2,
output reg  led_en,
output reg  [5:0] led_data,

);

//internal reg declearation
reg [1:0] state, state_next;
reg [5:0] cnt, cnt_next;

// state declearation
localparam [1:0]
    S0  = 2'b00,
    S1  = 2'b01,
    S2  = 2'b11,
    S3  = 2'b10,
 
//current state
always@(posedge clk)
if (rst)   begin
           state<=S1;
           cnt<=3
           end
else begin
     state<=state_next;
     cnt<= cnt_next;
     end

//next state logic
always @ *
begin
state_next =state;
cnt_next=cnt-1;
case (state)
    S0:    begin
                 if (cnt==0) begin state_next=S1;cnt_next=3; end
           end
    S1:    begin
                 if (cnt==0) begin state_next=S2;cnt_next=40; end
           end
    S2:    begin
                 if (cnt==0) begin state_next=S3;cnt_next=3; end
           end
    S3:    begin
                 if (cnt==0) begin state_next=S0;cnt_next=30; end
           end
    default:  begin state_next =S1;cnt_next=3; end
end

//OUTPUT LOGIC
always@* begin
led_en=1'b0;
led_data=cnt;
r1=1'b0;r2=1'b0;
y1=1'b0;y2=1'b0;
g1=1'b0;g2=1'b0;
if (state==S0)  begin r1=2'b1; g2=1'b1;
                if (cnt<10) led_en=1;                    
                end
if (state==S1)  begin y1=2'b1; y2=1'b1; end
if (state==S2)  begin g1=2'b1; r2=1'b1;
                if (cnt<10) led_en=1;                    
                end
if (state==S3)  begin y1=2'b1; y2=1'b1; end  
end

endmodule
