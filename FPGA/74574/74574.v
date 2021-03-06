module 74574(data_in,clk,reset,data_out);
input [3:0]data_in;
input clk, reset;
output [3:0]data_out;
reg [3:0]data_out;
	always @(posedge clk or posedge clk) begin
		if (reset) begin
			data_out <= 4'h0;
		end
		else begin
			data_out <= data_in;
		end
	end
	endmodule			