//比较交换模块
module comp
(
input wire[7:0] a,b,
input clk,
output reg[7:0] c,d
);
always (posedge clk) begin
   if (a>b) begin
               c<=a;
               d<=b; 
            end
   else     begin
               c<=b;
               d<=a;
            end
end
endmodule


// 3数排序模块
module sort3
(
input wire[7:0] a1,a2,a3,
output reg[7:0]  b1,b2,b3,
input clk
);
reg[7:0] temp1,temp2,temp3,temp4,temp5,temp6;
comp comp1(.a(a1),.b(a2),.c(temp1),.d(temp3),.clk(clk));
comp comp2(.a(temp3),.b(temp4),.c(temp5),.d(temp6),.clk(clk));
comp comp3(.a(temp2),.b(temp5),.c(b1),.d(b2),.clk(clk));
always@(posedge clk) begin
  temp2<=temp1;
  temp4<=a3;
  b3<=temp6;
end
endmodule


//中值滤波
module medium_filter3X3
(
input wire[7:0][2:0] a;
input wire[7:0][2:0] b;
input wire[7:0][2:0] c;
input wire clk;
output reg[7:0] d;
)
reg[7:0][12:1] temp;
sort3 sort_1(.a1(a[0]),.a2(a[1]),.a3(a[2]),.b1(temp[1]),.b2(temp[2],.b3(temp[3]),.clk(clk));
sort3 sort_2(.a1(b[0]),.a2(b[1]),.a3(b[2]),.b1(temp[4]),.b2(temp[5],.b3(temp[6]),.clk(clk));
sort3 sort_3(.a1(c[0]),.a2(c[1]),.a3(c[2]),.b1(temp[7]),.b2(temp[8],.b3(temp[9]),.clk(clk));
sort3 sort_4(.a1(temp[1]),.a2(temp[4]),.a3(temp[7]),.b1(temp[10]),.clk(clk));
sort3 sort_5(.a1(temp[2]),.a2(temp[5]),.a3(temp[8]),.b2(temp[11]),.clk(clk));
sort3 sort_6(.a1(temp[3]),.a2(temp[6]),.a3(temp[9]),.b3(temp[12]),.clk(clk));
sort3 sort_7(.a1(temp[10]),.a2(temp[11]),.a3(temp[12]),.b2(d),.clk(clk));

endmodule