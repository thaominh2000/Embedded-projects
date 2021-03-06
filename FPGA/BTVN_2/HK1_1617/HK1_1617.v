module HK1_1617(clk, enca, D); 
input clk, enca;
output [15:0] D;
reg [15:0] D = 16'h00;
reg [15:0] dem =16'h00;
reg [15:0] temp = 15'h00;
reg pre_enca = 0;
always @(posedge clk) begin
pre_enca<=enca;
dem<=dem+1;
if(dem==10000)begin
D<=temp;
temp<=0;
dem<=0;
end
if({pre_enca,enca}==2'b01) begin
temp<=temp+1;
end
end
endmodule
