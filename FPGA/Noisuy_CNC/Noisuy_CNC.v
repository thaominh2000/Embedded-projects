module Noisuy_CNC(clk,WR,LS,Nx,N,PulseX,DirX,flag_T,flag_full);
input clk,WR,LS;
input [7:0] N, Nx;
output reg PulseX,DirX;
output flag_T, flag_full;
reg clk1 = 1'b0;
reg flag_T = 1'b0;
reg flag_full = 1'b0;
reg pre_WR = 1'b0;
reg pre_clk1 = 1'b0;
reg [31:0]buffer = 32'h00000000;
reg [7:0]X = 7'h00;
reg [8:0]accX = 9'h000;
reg [9:0]timer = 10'h000;
reg [2:0]Nbuff = 3'h0;
always @(posedge clk) begin
	timer <= timer + 1'b1;
	pre_WR <= WR;
	pre_clk1 <= clk1;
	if (Nbuff < 4) begin
		flag_full <= 0;
	end
	else begin
		flag_full <= 1;
	end
	if (LS == 1) begin
		PulseX <= 0;
	end
	if ({pre_WR,WR} == 2'b01) begin
		if (flag_full == 0) begin
			case (Nbuff)
			3'h3: buffer[7:0] <= Nx;
			3'h2: buffer[15:8] <= Nx;
			3'h1: buffer[23:16] <= Nx;
			3'h0: buffer[31:24] <= Nx;
			endcase	
			Nbuff <= Nbuff + 1;
		end
	end
	if ((timer % 10'h032) == 0) begin
		clk1 <= !clk1;
		end
	if(timer == 10'h3e7) 
	begin
		flag_T = !flag_T;
		X <= buffer[30:24];
		buffer <= buffer << 8;
		if (Nbuff != 0) begin
			Nbuff <= Nbuff - 1;
		end
		timer <= 10'h000;
		accX <= N;
		DirX <= buffer[31];
	end
	case ({pre_clk1,clk1})
	2'b01: accX <= accX + X;	
	2'b11:
	begin
		if ((accX > N)&&(LS == 0))
			PulseX <= 1;
		else
			PulseX <= 0;
	end
	2'b10:
	begin
		PulseX <= 0;
		if (accX > N)
		accX <= accX - N;
	end
	endcase
end
endmodule
		