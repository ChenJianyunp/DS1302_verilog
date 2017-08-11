module decoder(input clk,
					input rst_n,
					input [3:0]number,
					output [7:0]num_out
					);
					
parameter num0=8'b1100_0000,num1=8'b1111_1001,num2=8'b1010_0100,
				num3=8'b1011_0000,num4=8'b1001_1001,num5=8'b1001_0010,
				num6=8'b1000_0010,num7=8'b1111_1000,num8=8'b1000_0000,
				num9=8'b1001_0000;

reg [7:0]num_buf;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
		num_buf<=8'd0;
	end
	else
	case(number)
		4'd0:num_buf<=num0;
		4'd1:num_buf<=num1;
		4'd2:num_buf<=num2;
		4'd3:num_buf<=num3;
		4'd4:num_buf<=num4;
		4'd5:num_buf<=num5;
		4'd6:num_buf<=num6;
		4'd7:num_buf<=num7;
		4'd8:num_buf<=num8;
		4'd9:num_buf<=num9;
	endcase
end
assign num_out=num_buf;
endmodule