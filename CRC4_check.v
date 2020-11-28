module CRC4_check(din,clk,rst,dout,wr,error);
input wire din, rst,clk, en;
output reg ready,crc_error;


//internal regs declearation
reg[1:0]state, state_next;
reg[2:0]cnt,cnt_next;
reg[4:0]bit, bit_next
reg[4:0] remainder, remainder_next;  //CRC4 中 被除数保持为5位，当最高位为1时进行异或，最后的余数若为0，则表示CRC校验正确，否则校验错误。



// parameters declearation
localparam [1:0]
    IDLE =2'b00,
    OP =2'b01,
    DONE =2'b10;
localparam [4:0] divisor=5'b10011;  //G(x)= x^4 + x^1 + x^0


//current state
always @(posedge clk) begin
  cnt<=cnt_next;
  if (cnt==3) begin state<=state_next, bit<=bit_next; remainder<= remainder_next; end  //仅在位数据的中间点数据采样及状态改变，其他时刻保持。
end


//next state logic
always@* begin
  case (state) 
  IDLE:  if(en) begin
            state_next= OP;
            cnt_next=0;
            bit_next =0;
            remainder_next=0;
        end
        else begin
            state_next= IDLE;
            cnt_next=0;
            bit_next =0;
            remainder_next=remainder;
        end
  OP: begin
      cnt_next = cnt+1;   
      if (bit==18) begin  state_next= DONE;   cnt_next = cnt; end          //18 是本例中CRC校验的总数据位数，需根据应用场景的不同改变
      else         begin  bit_next = bit+1; state_next=state; end

      if(remainder[3]==1) begin 
            remainder_next={remainder<<1，din}^divisor;                        //第四位为1，则移位后与多项式异或，否则移位
      else  remainder_next={remainder<<1，din};

  DONE:  begin
            state_next= IDLE;
            cnt_next=0;
            bit_next =0;
            remainder_next=remainder;
       end
  default: begin
            state_next= IDLE;
            bit_next =0;
            cnt_next=0;
            remainder_next=0;
       end


//output logic
always@* begin
  crc_error = (remainder ==0);
  if ((state==DONE|| state == IDLE)  ready=1;
  else ready =0; 
 
end
endmodule


