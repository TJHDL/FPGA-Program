module CRC4_check(din,clk,rst,dout,wr,error);
input wire din, rst,clk, en;
output reg ready,crc_error;


//internal regs declearation
reg[1:0]state, state_next;
reg[2:0]cnt,cnt_next;
reg[4:0]bit, bit_next
reg[4:0] remainder, remainder_next;  //CRC4 �� ����������Ϊ5λ�������λΪ1ʱ�����������������Ϊ0�����ʾCRCУ����ȷ������У�����



// parameters declearation
localparam [1:0]
    IDLE =2'b00,
    OP =2'b01,
    DONE =2'b10;
localparam [4:0] divisor=5'b10011;  //G(x)= x^4 + x^1 + x^0


//current state
always @(posedge clk) begin
  cnt<=cnt_next;
  if (cnt==3) begin state<=state_next, bit<=bit_next; remainder<= remainder_next; end  //����λ���ݵ��м�����ݲ�����״̬�ı䣬����ʱ�̱��֡�
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
      if (bit==18) begin  state_next= DONE;   cnt_next = cnt; end          //18 �Ǳ�����CRCУ���������λ���������Ӧ�ó����Ĳ�ͬ�ı�
      else         begin  bit_next = bit+1; state_next=state; end

      if(remainder[3]==1) begin 
            remainder_next={remainder<<1��din}^divisor;                        //����λΪ1������λ�������ʽ��򣬷�����λ
      else  remainder_next={remainder<<1��din};

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


