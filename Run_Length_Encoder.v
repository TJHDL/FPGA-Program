module Run_Length_Encoder(din,clk,rst,dout,d_valid);
input wire[7:0] din; 
input wire rst,clk, start;
output reg d_valid;
output reg[15:0] dout;


//internal regs declearation
reg state, state_next;
reg[2:0]cnt, cnt_next;
reg[4:0]data, data_next


// parameters declearation
localparam
    IDLE       = 1'b0,
    COUNT  = 1'b1;

//current state
always @(posedge clk) begin
  if(rst)  begin
     cnt <= 0;
     state <=IDLE;
     data <= 0;
  end 
  else begin
     cnt <= cnt_next;
     state <= state_next;
     data <= data_next;
  end
end

//next state logic
always@* begin
  case (state) 
  IDLE:  begin
            state_next= COUNT;
            cnt_next= 0;
            data_next =0;
            d_valid = 0;
        end
  COUNT: begin
      data_next=din;
      state_next= state;
      if (cnt==0) begin                         //复位（rst）后的第一次计数
           cnt_next= cnt+1; 
           state_next= state;  
           d_valid = 0;
      end
      else                                               // 非第一次计数
           if (data==data_next) begin      //前后相等时
                if (cnt == 255) begin  //计数器溢出时
                     cnt_next = 1;
                     d_valid = 1;
                end
                else begin                           //计数器非溢出时
                     cnt_next = cnt+1;
                     d_valid = 0;
               end
           end
           else begin                             //前后不等时
               cnt_next = 1;
               d_valid = 1;
           end
       end
  end
  
  default: begin
            state_next= COUNT;
            cnt_next= 0;
            data_next =0;
             d_valid = 0;
       end

//output logic 
  always@* begin
      if ( d_valid==1) 
         dout={data, cnt}；
  end
endmodule


