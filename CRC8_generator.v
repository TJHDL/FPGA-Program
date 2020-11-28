//CRC8校验码生成，CRC polynomial：P(x) = x^8+ x^5+ x^4+ x^0
module CRC8
(
input wire clk,
input wire start,
input wire rst,
input wire din,
output reg  done,
output reg [7:0] CRC
);

//internal reg declearation
reg [3:0] state, state_next;
reg [7:0] crc_reg, crc_next;

// state declearation
localparam [2:0]
    BIT0    =  4'b0000,
    BIT1   =  4'b0001,
    BIT2   =  4'b0010,
    BIT3   =  4'b0011,
    BIT4   =  4'b0100,
    BIT5    =  4'b0101,
    BIT6    =  4'b0110,
    BIT7    =  4'b0111,
    DONE =  4'b1000,
    IDLE   =   4'b1001;

//current state
always@(posedge clk) begin
  if (rst) begin
             state<=IDLE;
             crc_reg<=0;
             crc_next<=0;
           end
  else     begin
             state<=state_next;
             crc_reg<=crc_next;
           end
end

//next state logic
always @ * 
begin
  state_next =state;
  crc_next[0]=crc[7]^din;
  crc_next[1]=crc[0];
  crc_next[2]=crc[1];
  crc_next[3]=crc[2];
  crc_next[4]=crc[3]^din;
  crc_next[5]=crc[4]^din;
  crc_next[6]=crc[5];
  crc_next[7]=crc[6];

  case (state) 
     begin
      IDLE:    begin
                 if (start)  begin
                                  state_next=BIT0;
                                  crc_next= 8'b0;
                             end
            end
       BIT0:    state_next = BIT1;
       BIT1:    state_next = BIT1;
       BIT2:    state_next = BIT1;
       BIT3:    state_next = BIT1;
       BIT4:    state_next = BIT1;
       BIT5:    state_next = BIT1;
       BIT6:    state_next = BIT1;
       BIT7:    state_next = DONE;
       DONE:    state_next= IDLE;
       default:  state_next =IDLE;
     end
end

//OUTPUT LOGIC
always@* begin
                   ready=1'b0;
                   done=1'b0;
                   CRC=crc_reg;
                   if (state==DONE)  done=1'b1;
                 end
endmodule
