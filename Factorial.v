module factorial
(
input wire clk,
input wire start,
input wire rst,
input wire [3:0] n,
output reg ready,
output reg  tick,
output reg [31:0] out,
);

//internal reg declearation
reg [1:0] state, state_next;
reg [3:0] i, i_next;
reg [31:0] fact, fact_next;

// state declearation
localparam [1:0]
    IDLE  =2'b00,
    OP      = 2'b01,
    DONE    = 2'b10;

//current state
always@(posedge clk)
if (rst)   begin
             state<=IDLE;
             i<=1;
             fact<=1;
             out<=32'b1;
             end
else     begin
             state<=state_next;
             i<=i_next;
             fact<=fact_next;
             end

//next state logic
always @ * 
begin
state_next =state;
i_next=i;
fact_next=fact;
case (state)
   IDLE:    begin
                 if (start)  begin
                                  state_next=OP;
                                   i_next=n;
                                   fact_next=1;
                                  end
                 end

    OP:       begin
                 if (i==1)   state_next=DONE;
                 else         begin
                                   fact_next=fact*i;
                                   i_next=i-1;
                                   end
                 end

     DONE:    state_next= IDLE;

     default:  state_next =IDLE;
end

//OUTPUT LOGIC
always@* begin
                   ready=1'b0;
                   tick=1'b0;
                   if (state==IDLE)  begin ready=1'b1; end
                   if (state==DONE)  begin  tick=2'b1; out=fact; end
                   end

endmodule
