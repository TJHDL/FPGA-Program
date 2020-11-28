module clock     // //输入频率为10Mhz，经11分频后输出，以保证在传输波特率为115200bps时，每比特占用8个时钟周期。
(
input wire clk,         
input wire rst,
output reg clk_out
);

//internal reg declearation
reg [3:0] cnt;

always@(posedge clk,posedge rst) begin
if(rst) cnt<=0; 
else if (cnt==10) cnt<=0;
else cnt<=cnt+1;
end

alway@* begin
 if (cnt<=5) clk_out=1; 
 else clk_out=0;
end





module receiver
(
input wire clk,          //设经分频后的输入频率为10M/11 hz，以保证传输波特率为115200bps时，每比特占用8个时钟周期，数据采样在数据中间时刻，即第四个时钟周期。
input wire rst,
input wire din,
input wire crc_check, crc_done;
input wire [3:0 ]node_id,
output reg error, ready,
output reg [3:0] source_id,
output reg [7:0] dout
);

//internal reg declearation
reg [2:0] state, state_next;
reg [2:0] cnt, cnt_next;   //时钟计数
reg [4:0] bit, bit_next;   //数据位计数
reg crc_error, stop_error;

// state declearation
localparam [1:0]
    IDLE      = 2'b00,
    START     = 2'b01,
    RECEIVE   = 2'b10,
    STOP      = 2'b11;
    

//current state
always@(posedge clk,posedge rst) begin
  if (rst)   begin  state <=IDLE; cnt<=0; start_error<=0; stop_error<=0; crc_error<=0;    end
  else       begin  state <=state_next; cnt<=cnt_next;   end
end

//next state logic
always@ * begin
   case(state)
   IDLE:  begin 
             if (din==0)       begin  state_next = START; cnt_next=0;     end
             else              begin  state_next= state; cnt_next= cnt; end 
          end
   START: begin
             if(cnt==7)        begin  state_next= RECEIVE; cnt_next=0; end         //8个时钟周期后，起始位结束，进入接收状态
             else              begin  state_next= state; cnt_next= cnt+1; end
          end
   RECEIVE: begin
             cnt_next = cnt+1;
             state_next = state;
             if (bit==19)               begin  state_next= STOP; cnt_next = 0; bit_next = 0; end   
             esle if (cnt==3)           begin  receive_buf={receive_buf<<1, din}; end
                  else if ( cnt==7 )    begin  bit_next= bit+1; end                // starts at the begining of sending of each bit
          end
   STOP: begin
             if (cnt ==3)           begin  stop_bit = din; state_next= state; cnt_next = cnt+1; end
             else if (cnt==7)       begin  state_next= IDLE; cnt_next=0; end
             else                   begin  state_next= state; cnt_next = cnt+1; end
          end
end

//output logic
always@* begin
   crc_en = 0;
   if (state == IDLE) begin stop_error =0; crc_error = 0; end
   else if (state == RECEIVE) begin
        crc_en =1; ready=0;
        case (bit)
          3       : dest_id = receive_buf[3:0];
          7       : s_id = receive_buf[3:0];
          15      : data = receive_buf[7:0];
          default : begin dest_id = dest_id ; source_id = source_id;  data= data; end
        endcase
      end

   else if (state==STOP) begin 
           stop_error = ~stop_bit; 
           ready =1;
           crc_error = {crc_check&& crc_done};
           error= stop_error|| crc_error; 
           if (dest_id== node_id) begin
               source_id = s_id;
               dout = data;
           end
        end

end