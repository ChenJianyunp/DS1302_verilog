module clkdiv(
					clk50,
					rst_n,
					clkout);
					
input clk50;
input rst_n;
output clkout;

reg clkout;
reg[15:0] cnt;

always@(posedge clk50 or negedge rst_n)
begin
	if(!rst_n)
		begin
			clkout<=1'b0;
			cnt<=16'b0;
		end
	else if(cnt==16'd500)
		begin
			clkout<=~clkout;
			cnt<=16'd0;
		end
	else
		cnt<=cnt+16'd1;
end
endmodule