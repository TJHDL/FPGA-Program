//整数n的模100运算
module mod_100_fast
(
input wire clk,
input wire start,
input wire rst,
input wire [15:0] n,
output reg ready,
output reg  done,
output reg [6:0] remain
);

//internal reg declearation
reg [1:0] state, state_next;
reg [15:0] temp, temp_next;


// state declearation
localparam [1:0]
    IDLE    = 2'b00,
    OP      = 2'b01,
    DONE    = 2'b10;

//current state
always@(posedge clk)
if (rst)   begin
             state<=IDLE;
             temp<=0;
             ready<=1;
             done<=0;
             out<=0;
             end
else     begin
             state<=state_next;
             temp<=temp_next;
             ready<=0;
             end

//next state logic
always @ * 
begin
state_next =state;
temp_next = temp;
case (state)
   IDLE:    begin
                 if (start)  begin
                                  state_next=OP;
                                  temp_next=n;
                             end
            end

    OP:       begin
                 if (temp<100)          state_next=DONE;
                 else if (temp<200) begin
                                        temp_next=temp-100;
                                        state_next=DONE;
                                    end
                 else if (temp300) begin
                                        temp_next=temp-200;
                                        state_next=DONE;
                                    end
                 else if (temp<400) begin
                                        temp_next=temp-300;
                                        state_next=DONE;
                                    end
                 else if (temp<500) begin
                                        temp_next=temp-400;
                                        state_next=DONE;
                                    end
                 else               begin
                                        temp_next=temp-500;
                                    end
               end

     DONE:    state_next= IDLE;

     default:  state_next =IDLE;
end

//OUTPUT LOGIC
always@* begin
                   ready=1'b0;
                   done=1'b0;
                   if (state==IDLE)  begin ready=1'b1; end
                   if (state==DONE)  begin  tick=2'b1; remain=temp; end
                   end

endmodule
