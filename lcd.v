module lcd( clk,
rst_n,
lcd_en,
lcd_rw, //always "0" because always read
lcd_rs,
lcd_data,
lcd_on);//flag2);

input clk;
input rst_n;
output lcd_on;
output lcd_en;
output lcd_rw;
output lcd_rs;
output [7:0] lcd_data;
wire clk;
wire rst_n;
wire lcd_en;
wire lcd_rw;
reg [7:0] lcd_data;
reg lcd_rs;
reg [5:0] state;
reg [5:0] symbol;
reg [10:0] num;
reg [10:0] mun;
reg [10:0] ham;
reg [10:0] bite;
reg [10:0] bit;
reg [10:0] bi;
wire [127:0] row_1;
wire [127:0] row_2;
//wire [127:0] row_3;
//reg flag;

assign row_1 ="   ----(HELLO)--";
assign row_2 ="!HAPPY EVERYDAY!";
//assign row_3 ="           HELLO";

//--------------------------------------------------------------------вЂ”
//initialize
//first step is waitng more than 20 ms.
parameter TIME_20MS = 1000_000 ; //20000000/20=1000_000

parameter TIME_500HZ= 100_000 ; // 2 ms

//parameter TIME_sec= 100 ; // 1 s
reg [10:0] cnt_sec ;
reg [10:0] cnt_1sec ;
//use gray code
parameter IDLE= 8'h00 ;
parameter SET_FUNCTION= 8'h01 ;
parameter DISP_OFF= 8'h03 ;
parameter DISP_CLEAR= 8'h02 ;
parameter ENTRY_MODE= 8'h06 ;
parameter DISP_ON = 8'h07 ;
parameter ROW1 = 8'h05 ;
parameter ROW2 = 8'h04 ;
parameter CREATE = 8'h0C ;
parameter THIRD = 8'h0D ;
parameter SECOND = 8'h0F ;
parameter FIRST = 8'h0E ;
//parameter ROW3 = 8'h0C ;
//parameter DELAY1 = 8'h0C ;
//parameter DELAY2 = 8'h0D ;

//--------------------------------------------------------------------вЂ”
//20ms
reg [19:0] cnt_20ms ;
always @(posedge clk or negedge rst_n)begin
if(rst_n==1'b0)begin
cnt_20ms<=0;
end
else if(cnt_20ms == TIME_20MS - 1)begin
cnt_20ms<=cnt_20ms;
end
else
cnt_20ms<=cnt_20ms + 1 ;
end
wire delay_done = (cnt_20ms==TIME_20MS-1)? 1'b1 : 1'b0 ;
//--------------------------------------------------------------------вЂ”
//500Hz
reg [19:0] cnt_500hz;
always @(posedge clk or negedge rst_n)begin
if(rst_n==1'b0)begin
cnt_500hz <= 0;
end
else if(delay_done==1)begin
if(cnt_500hz== TIME_500HZ - 1)
cnt_500hz<=0;
else
cnt_500hz<=cnt_500hz + 1 ;
end
else
cnt_500hz<=0;
end
assign lcd_on = 1'b1;
assign lcd_en = ((cnt_500hz<(TIME_500HZ)/2)/*&&(flag==0)*/)? 1'b1 : 1'b0;
assign write_flag = (cnt_500hz==TIME_500HZ - 1) ? 1'b1 : 1'b0 ;

//set_function ,display off, display clear ,entry mode set
//--------------------------------------------------------------------
assign lcd_rw = 0;
always @(posedge clk or negedge rst_n)begin
if(rst_n==1'b0)begin
lcd_rs <= 0 ; //whatever order or data 0: order 1:data
end
else if(write_flag == 1)begin
if((state==SET_FUNCTION)||(state==DISP_OFF)|| //if command(order) then
(state==DISP_CLEAR)||(state==ENTRY_MODE)||
(state==DISP_ON ) ||((num==0)&&(state==ROW1))||
((mun==0)&&(state==ROW2))||((bite==0)&&(state==CREATE)&&(symbol==FIRST))||
((bit==0)&&(state==CREATE)&&(symbol==SECOND))||((bi==0)&&(state==CREATE)&&(symbol==THIRD)))/*((ham==0)&&(state==ROW3))*/
begin
lcd_rs<=0;
end
else begin
lcd_rs<= 1;
end
end
else begin
lcd_rs<=lcd_rs;
end
end

always @(posedge clk or negedge rst_n)begin
if(rst_n==1'b0)begin
lcd_data<=0 ;
end
else if(write_flag)begin
case(state)

	IDLE: 
begin 
lcd_data <= 8'hxx;
state <= SET_FUNCTION;
end
	SET_FUNCTION:
begin 
lcd_data <= 8'h38; //2*16 5*8 8
state <= DISP_OFF;
end
	DISP_OFF: 
begin 
lcd_data <= 8'h08;
state <= DISP_CLEAR;
end	
	DISP_CLEAR: 
begin 
lcd_data <= 8'h01;
state <= ENTRY_MODE;
end	
	ENTRY_MODE: 
begin
lcd_data <= 8'h06;
state <= DISP_ON;
end
	DISP_ON : 
begin
lcd_data <= 8'h0c; //The display function is on, there is no cursor, and it does not flash
state <= CREATE;
symbol <= FIRST;
end
	CREATE:
	begin
	case(symbol)
		FIRST:
		begin
		case(bite)
		0:
		begin
		lcd_data <= 8'h40;
		state <= CREATE;
		symbol <= FIRST;
		bite <= bite+1;
		end
		1:
		begin
		lcd_data <= 8'h04;
		state <= CREATE;
		symbol <= FIRST;
		bite <= bite+1;
		end
		2:
		begin
		lcd_data <= 8'h02;
		state <= CREATE;
		symbol <= FIRST;
		bite <= bite+1;
		end
		3:
		begin
		lcd_data <= 8'h07;
		state <= CREATE;
		symbol <= FIRST;
		bite <= bite+1;
		end
		4:
		begin
		lcd_data <= 8'h0D;
		state <= CREATE;
		symbol <= FIRST;
		bite <= bite+1;
		end
		5:
		begin
		lcd_data <= 8'h1F;
		state <= CREATE;
		symbol <= FIRST;
		bite <= bite+1;
		end
		6:
		begin
		lcd_data <= 8'h17;
		state <= CREATE;
		symbol <= FIRST;
		bite <= bite+1;
		end
		7:
		begin
		lcd_data <= 8'h14;
		state <= CREATE;
		symbol <= FIRST;
		bite <= bite+1;
		end
	   8:
		begin
		lcd_data <= 8'h03;
		state <= CREATE;
		symbol <= SECOND;
		bi <= 0;
		end
		endcase
		end
		
		SECOND:
		begin
		case(bit)
		0:
		begin
		lcd_data <= 8'h48;//2 символ
		state <= CREATE;
		symbol <= SECOND;
		bit <= bit+1;
		end
		1:
		begin
		lcd_data <= 8'h02;
		state <= CREATE;
		symbol <= SECOND;
		bit <= bit+1;
		end
		2:
		begin
		lcd_data <= 8'h04;
		state <= CREATE;
		symbol <= SECOND;
		bit <= bit+1;
		end
		3:
		begin
		lcd_data <= 8'h1E;
		state <= CREATE;
		symbol <= SECOND;
		bit <= bit+1;
		end
		4:
		begin
		lcd_data <= 8'h1B;
		state <= CREATE;
		symbol <= SECOND;
		bit <= bit+1;
		end
		5:
		begin
		lcd_data <= 8'h1F;
		state <= CREATE;
		symbol <= SECOND;
		bit <= bit+1;
		end
		6:
		begin
		lcd_data <= 8'h1E;
		state <= CREATE;
		symbol <= SECOND;
		bit <= bit+1;
		end
		7:
		begin
		lcd_data <= 8'h02;
		state <= CREATE;
		symbol <= SECOND;
		bit <= bit+1;
		end
		8:
		begin
		lcd_data <= 8'h0C;
		state <= CREATE;
		symbol <= THIRD;
		bite<= 0;
		end
		endcase
		end
		
		THIRD:
		begin
		case(bi)
		0:
		begin
		lcd_data <= 8'h50;
		state <= CREATE;
		symbol <= THIRD;
		bi <= bi+1;
		end
		1:
		begin
		lcd_data <= 8'h00;
		state <= CREATE;
		symbol <= THIRD;
		bi <= bi+1;
		end
		2:
		begin
		lcd_data <= 8'h00;
		state <= CREATE;
		symbol <= THIRD;
		bi <= bi+1;
		end
		3:
		begin
		lcd_data <= 8'h00;
		state <= CREATE;
		symbol <= THIRD;
		bi <= bi+1;
		end
		4:
		begin
		lcd_data <= 8'h00;
		state <= CREATE;
		symbol <= THIRD;
		bi <= bi+1;
		end
		5:
		begin
		lcd_data <= 8'h10;
		state <= CREATE;
		symbol <= THIRD;
		bi <= bi+1;
		end
		6:
		begin
		lcd_data <= 8'h10;
		state <= CREATE;
		symbol <= THIRD;
		bi <= bi+1;
		end
		7:
		begin
		lcd_data <= 8'h10;
		state <= CREATE;
		symbol <= THIRD;
		bi <= bi+1;
		end
		8:
		begin
		lcd_data <= 8'h00;
		state <= ROW1;
		symbol <= FIRST;
		bit <= 0;
		end
		endcase
		end
	endcase
	end
	
	ROW1:
	begin
		case(num)
		0:
		begin
		lcd_data <= 8'h80; //00+80
		state <= ROW1;
		num <= num+1;
		end
		1:
		begin
		lcd_data <=8'h00; //00+80
		state <= ROW1;
		num <= num+1;
		end
		2:
		begin
		lcd_data <=8'h01; 
		state <= ROW1;
		num <= num+1;
		end
		3:
		begin
		lcd_data <= 8'h02; 
		state <= ROW1;
		num <= num+1;
		end
		4:
		begin
		lcd_data <= row_1 [103: 96]; 
		state <= ROW1;
		num <= num+1;
		end
		5:
		begin
		lcd_data <= row_1 [ 95: 88]; 
		state <= ROW1;
		num <= num+1;
		end
		6:
		begin
		lcd_data <= row_1 [ 87: 80]; 
		state <= ROW1;
		num <= num+1;
		end
		7:
		begin
		lcd_data <= row_1 [ 79: 72];
		state <= ROW1;
		num <= num+1;
		end
		8:
		begin
		lcd_data <= row_1 [ 71: 64];
		state <= ROW1;
		num <= num+1;
		end
		9:
		begin
		lcd_data <= row_1 [ 63: 56]; 
		state <= ROW1;
		num <= num+1;
		end
		10:
		begin
		lcd_data <= row_1 [ 55: 48]; 
		state <= ROW1;
		num <= num+1;
		end
		11:
		begin
		lcd_data <= row_1 [ 47: 40]; 
		state <= ROW1;
		num <= num+1;
		end
		12:
		begin
		lcd_data <= row_1 [ 39: 32]; 
		state <= ROW1;
		num <= num+1;
		end
		13:
		begin
		lcd_data <= row_1 [ 31: 24]; 
		state <= ROW1;
		num <= num+1;
		end
		14:
		begin
		lcd_data <= row_1 [ 23: 16]; 
		state <= ROW1;
		num <= num+1;
		end
		15:
		begin
		lcd_data <= row_1 [ 15: 8]; 
		state <= ROW1;
		num <= num+1;
		end
		16:
		begin
		lcd_data <= row_1 [ 7: 0]; 
		state <= ROW2;
		mun <= 0;
		ham <= 0;
		end
		endcase
	end
		
	ROW2:
	begin
		case(mun)
		0:
		begin
		lcd_data <= 8'hC0; 
		state <= ROW2;
		mun <= mun+1;
		end
		1:
		begin
		lcd_data <=row_2 [127:120]; 
		state <= ROW2;
		mun <= mun+1;
		end
		2:
		begin
		lcd_data <=row_2 [119:112]; 
		state <= ROW2;
		mun <= mun+1;
		end
		3:
		begin
		lcd_data <= row_2 [111:104]; 
		state <= ROW2;
		mun <= mun+1;
		end
		4:
		begin
		lcd_data <= row_2 [103: 96]; 
		state <= ROW2;
		mun <= mun+1;
		end
		5:
		begin
		lcd_data <= row_2 [ 95: 88]; 
		state <= ROW2;
		mun <= mun+1;
		end
		6:
		begin
		lcd_data <= row_2 [ 87: 80]; 
		state <= ROW2;
		mun <= mun+1;
		end
		7:
		begin
		lcd_data <= row_2 [ 79: 72];
		state <= ROW2;
		mun <= mun+1;
		end
		8:
		begin
		lcd_data <= row_2 [ 71: 64];
		state <= ROW2;
		mun <= mun+1;
		end
		9:
		begin
		lcd_data <= row_2 [ 63: 56]; 
		state <= ROW2;
		mun <= mun+1;
		end
		10:
		begin
		lcd_data <= row_2 [ 55: 48]; 
		state <= ROW2;
		mun <= mun+1;
		end
		11:
		begin
		lcd_data <= row_2 [ 47: 40]; 
		state <= ROW2;
		mun <= mun+1;
		end
		12:
		begin
		lcd_data <= row_2 [ 39: 32]; 
		state <= ROW2;
		mun <= mun+1;
		end
		13:
		begin
		lcd_data <= row_2 [ 31: 24]; 
		state <= ROW2;
		mun <= mun+1;
		end
		14:
		begin
		lcd_data <= row_2 [ 23: 16]; 
		state <= ROW2;
		mun <= mun+1;
		end
		15:
		begin
		lcd_data <= row_2 [ 15: 8]; 
		state <= ROW2;
		mun <= mun+1;
		end
		16:
		begin
		lcd_data <= row_2 [ 7: 0]; 
		state <= ROW1;
		num <= 0;
		ham <= 0;
		end
		endcase
	end
	/*	
	DELAY1:
		begin
		flag <= 1'b1;
		if (cnt_sec == TIME_sec - 1)
		begin
		cnt_sec <= 0;
		state <= ROW3;
		flag <= 1'b0;
		end
		else
		cnt_sec <= cnt_sec+1;
	   end*/
	/*		
	ROW3:
		begin
		case(ham)
		0:
		begin
		lcd_data <= 8'h80; 
		state <= ROW3;
		ham <= ham+1;
		end
		1:
		begin
		lcd_data <=row_3 [127:120]; 
		state <= ROW3;
		ham <= ham+1;
		end
		2:
		begin
		lcd_data <=row_3 [119:112]; 
		state <= ROW3;
		ham <= ham+1;
		end
		3:
		begin
		lcd_data <= row_3 [111:104]; 
		state <= ROW3;
		ham <= ham+1;
		end
		4:
		begin
		lcd_data <= row_3 [103: 96]; 
		state <= ROW3;
		ham <= ham+1;
		end
		5:
		begin
		lcd_data <= row_3 [ 95: 88]; 
		state <= ROW3;
		ham <= ham+1;
		end
		6:
		begin
		lcd_data <= row_3 [ 87: 80]; 
		state <= ROW3;
		ham <= ham+1;
		end
		7:
		begin
		lcd_data <= row_3 [ 79: 72];
		state <= ROW3;
		ham <= ham+1;
		end
		8:
		begin
		lcd_data <= row_3 [ 71: 64];
		state <= ROW3;
		ham <= ham+1;
		end
		9:
		begin
		lcd_data <= row_3 [ 63: 56]; 
		state <= ROW3;
		ham <= ham+1;
		end
		10:
		begin
		lcd_data <= row_3 [ 55: 48]; 
		state <= ROW3;
		ham <= ham+1;
		end
		11:
		begin
		lcd_data <= row_3 [ 47: 40]; 
		state <= ROW3;
		ham <= ham+1;
		end
		12:
		begin
		lcd_data <= row_3 [ 39: 32]; 
		state <= ROW3;
		ham <= ham+1;
		end
		13:
		begin
		lcd_data <= row_3 [ 31: 24]; 
		state <= ROW3;
		ham <= ham+1;
		end
		14:
		begin
		lcd_data <= row_3 [ 23: 16]; 
		state <= ROW3;
		ham <= ham+1;
		end
		15:
		begin
		lcd_data <= row_3 [ 15: 8]; 
		state <= ROW3;
		ham <= ham+1;
		end
		16:
		begin
		lcd_data <= row_3 [ 7: 0]; 
		state <= ROW2;
		mun <= 0;
		end
		endcase
		end
	*/
	/*
		DELAY2:
		begin
		flag <= 1'b1;
		if (cnt_1sec == TIME_sec - 1)
		begin
		cnt_1sec <= 0;
		state <= ROW1;
		flag <= 1'b0;
		end
		else
		cnt_sec <= cnt_1sec+1;
		end
	*/	
endcase
end
else
lcd_data<=lcd_data ;
end

endmodule