module str(f,clk,hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7);//
output [6:0] hex0;
output [6:0] hex1;
output [6:0] hex2;
output [6:0] hex3;
output [6:0] hex4;
output [6:0] hex5;
output [6:0] hex6;
output [6:0] hex7;

output f;
reg f;

input clk;

reg [6:0] hex0;
reg [6:0] hex1;
reg [6:0] hex2;
reg [6:0] hex3;
reg [6:0] hex4;
reg [6:0] hex5;
reg [6:0] hex6;
reg [6:0] hex7;

integer k = 1;
integer h = 0;

always @ (posedge clk)
begin
if (k == 50000000)
begin
f<=~f;
k<=1;
end
else
begin
k<=k+1;
end
end

always @ (posedge f)
begin
h<=h+1;
case(h)
0:
begin
hex0<=7'b00001001;
hex1<=7'b01111111;
hex2<=7'b01111111;
hex3<=7'b01111111;
hex4<=7'b01111111;
hex5<=7'b01111111;
hex6<=7'b01111111;
hex7<=7'b01111111;
h<=h+1;
end
1:
begin
hex0<=7'b00000110;//E
hex1<=7'b00001001;//H
h<=h+1;
end
2:
begin
hex0<=7'b01000111;
hex1<=7'b00000110;
hex2<=7'b00001001;
h<=h+1;
end
3:
begin
hex0<=7'b01000111;
hex1<=7'b01000111;
hex2<=7'b00000110;
hex3<=7'b00001001;
h<=h+1;
end
4:
begin
hex0<=7'b01000000;
hex1<=7'b01000111;
hex2<=7'b01000111;
hex3<=7'b00000110;
hex4<=7'b00001001;
hex5<=7'b01111111;
hex6<=7'b01111111;
hex7<=7'b01111111;
h<=h+1;
end
5:
begin
hex0<=7'b01111111;
hex1<=7'b01000000;
hex2<=7'b01000111;
hex3<=7'b01000111;
hex4<=7'b00000110;
hex5<=7'b00001001;
h<=h+1;
end
6:
begin
hex0<=7'b01111111;
hex1<=7'b01111111;
hex2<=7'b01000000;
hex3<=7'b01000111;
hex4<=7'b01000111;
hex5<=7'b00000110;
hex6<=7'b00001001;
h<=h+1;
end
7:
begin
hex0<=7'b01111111;
hex1<=7'b01111111;
hex2<=7'b01111111;
hex3<=7'b01000000;
hex4<=7'b01000111;
hex5<=7'b01000111;
hex6<=7'b00000110;
hex7<=7'b00001001;
h<=h+1;
end
8:
begin
hex0<=7'b00001001;
hex1<=7'b01111111;
hex2<=7'b01111111;
hex3<=7'b01111111;
hex4<=7'b01000000;
hex5<=7'b01000111;
hex6<=7'b01000111;
hex7<=7'b00000110;
h<=h+1;
end
9:
begin
hex0<=7'b00000110;
hex1<=7'b00001001;
hex2<=7'b01111111;
hex3<=7'b01111111;
hex4<=7'b01111111;
hex5<=7'b01000000;
hex6<=7'b01000111;
hex7<=7'b01000111;
h<=h+1;
end
10:
begin
hex0<=7'b01000111;
hex1<=7'b00000110;
hex2<=7'b00001001;
hex3<=7'b01111111;
hex4<=7'b01111111;
hex5<=7'b01111111;
hex6<=7'b01000000;
hex7<=7'b01000111;
h<=h+1;
end
11:
begin
hex0<=7'b01000111;
hex1<=7'b01000111;
hex2<=7'b00000110;
hex3<=7'b00001001;
hex4<=7'b01111111;
hex5<=7'b01111111;
hex6<=7'b01111111;
hex7<=7'b01000000;
h<=4;
end

endcase
end
endmodule