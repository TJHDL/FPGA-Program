module alarm
(
input wire clk,//0.1s clock
input wire rst,
input wire sensor,
input wire start;
input wire cancle;
output reg buzz,
);

//internal reg declearation
reg [1:0] state, state_next;
reg [5:0] cnt, cnt_next;

// state declearation
localparam [1:0]
    IDLE  = 2'b00,
    TEST  = 2'b01,
    START = 2'b10,
    ALARM  = 2'b11;
 
//current state
always@(posedge clk)
if (rst)   begin
           state<=IDLE;
           cnt<=0;
           end
else begin
     state<=state_next;
     cnt<= cnt_next;
     end

//next state logic
always @ *
begin
state_next =state;
cnt_next=cnt;
case (state)
    IDLE:     begin
                 if (start==1)      begin state_next=START;cnt_next=0; end
                 else if £¨test==1£©begin state_next= TEST;cnt_next=0; end
              end
    START:    begin
                 if (cancle==1) begin state_next=IDLE;cnt_next=0; end
                 else if(sensor==1) begin state_next=ALARM;cnt_next=0; end
                 else cnt_next=0;
              end
    ALARM:    begin
                 if (cancle==1) begin state_next=IDLE;cnt_next=0; end
                 else if(sensor==0) begin state_next=START;cnt_next=0; end
                 else if (cnt<=50) cnt_next=cnt+1;
              end
    TEST:     begin
                 if (cancle==1) begin state_next=IDLE;cnt_next=0; end
              end

    default:  begin state_next =IDLE;cnt_next=0; end
end

//OUTPUT LOGIC
always@* begin
    if (state==TEST||(state==ALARM && cnt>=50))  buzz=1;
    else buzz=0;
end
endmodule
