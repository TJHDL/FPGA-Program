module comparator_8bit
(
input wire clk,
input wire start,
input wire rst,
input wire  ai,bi,
output reg [1:0] sout, //00:NA, 01:<, 10:=, 11:>
);

//internal reg declearation
reg [1:0] comp, comp_next;
reg [1:0] state, state_next;
reg [2:0] count, count_next;

// state declearation
localparam [1:0]
    IDLE    = 2'b00,
    OP      = 2'b01,
    DONE    = 2'b10;

//current state
always@(posedge clk)
if (rst)   begin
             state<=IDLE;
             count<=0;
             comp<=2'b0;
             sout<=2'b0;
             end
else     begin
             comp<=comp_next;
             state<=state_next;
             count<=count_next;
             end

//next state logic
always @ * 
begin

state_next =state;
comp_next = comp;
case (state)
   IDLE:    begin
                 if (start)  begin
                             state_next=OP;
                             count_next=0;
                             comp_next=2'b10;   // default set to equal
                             end
            end

    OP:       begin
                 if (ai>bi) comp_next= 2'b11;
                 else if (ai<bi)  comp_next =2'b01;  
                 // if equal , comp_next holds as formal value.
                   
                 if (count==7) begin
                              state_next=DONE;
                              end

                 else   count_next=count+1;  // state holds to OP.
               end

     DONE:     state_next= IDLE;

     default:  state_next =IDLE;
end

//OUTPUT LOGIC
always@* begin
                   if (state==DONE|| state==IDLE)  sout=comp;
                   else              sout=2'b0;
                   end

endmodule
