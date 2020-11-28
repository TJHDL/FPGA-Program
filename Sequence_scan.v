module sequence_scan
(
input wire clk,
input wire rst,
input wire [1:0] XY,
output reg [1:0] Z
);

//internal reg declearation
reg [2:0] state, state_next;

// state declearation
localparam [2:0]
    IDLE    = 2'b000,
    S0      = 2'b001,
    S01     = 2'b010,
    S013    = 2'b011,
    S0132   = 2'b100,
    S02     = 2'B101,
    S023    = 2'B110,
    S0231   = 2'B111;

//current state
always@(posedge clk) begin
  if (rst)   state <=IDLE;
  else       state <=state_next;
end

//next state logic
always @ *
begin
case (state)
    IDLE:     begin
                  if (XY==2'b00) state_next=S0;
                  else state_next=IDLE;
              end
    S0:       begin
                  if (XY==2'b01) state_next= S01;
                  else if(XY==2'b10) state_next=S02;
                       else if(XY==2'b00) state_next=S0;
                            else state_next=IDLE;
              end
     S01:     begin
                  if (XY==2'b11) state_next= S013;
                  else if(XY==2'b00) state_next=S0;
                       else state_next=IDLE;
              end
     S013:    begin
                  if (XY==2'b10) state_next= S0132;
                  else if(XY==2'b00) state_next=S0;
                       else state_next=IDLE;
              end
     S0132:   begin
                  if (XY==2'b00) state_next= S0;
                  else state_next=IDLE;
              end
     S02:     begin
                  if (XY==2'b11) state_next= S023;
                  else if(XY==2'b00) state_next=S0;
                       else state_next=IDLE;
              end 
     S023:    begin
                  if (XY==2'b01) state_next= S0231;
                  else if(XY==2'b00) state_next=S0;
                       else state_next=IDLE;
              end
     S0231:   begin
                  if (XY==2'b00) state_next= S0;
                  else state_next=IDLE;
              end
     default:  state_next =IDLE;
end

//OUTPUT LOGIC
always@* begin
 if(state==S0132&& XY==2'b00) Z=2'b10;
 else if(state==S0231&& XY==2'b00) Z=2'b11;
 else Z=2'b00;
 end

endmodule
