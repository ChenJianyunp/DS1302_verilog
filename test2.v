module test2(input clk,
				input rst_n,
				output rst_chip;
				output[7:0] wr_addr,
				//output[7:0] wr_data,
				output[1:0] dir,
				input[7:0] rd,
				output[7:0] second,
				output[7:0] minute,
				output[7:0] hour);
				
reg[12:0] cnt;
reg start_flag;
reg[3:0] state;
reg[7:0] rsecond;
reg[7:0] rminute;
reg[7:0] rhour;
reg rrst_chip;

assign rst_chip=rrst_chip;
assign second=rsecond;
assign minute=rminute;
assign hour=rhour;

parameter addr_second=8'h81,addr_minute=8'h83,addr_hour=8'h85;

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		cnt<=13'd0;
		start_flag<=1'b0;
	end
	else if(cnt==13'd76923)begin
		cnt<=13'd0;
		start_flag<=1'b0;
	end
	else
		cnt<=cnt+1;
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		state<=4'd0;
		rrst_chip<=1'b1;
	end
	case(state)
	4'd0:begin
		if(start_flag)begin
			state<=state+4'd1;
			start_flag<=1'd0;
		end
	end
	
	4'd1:begin
		wr_addr<=wr_second;
		state<=state+4'd1;
	end
	
	4'd2:begin
		rrst_chip=1'b0;
		state<=state+4'd1;
	end
	
	4'd3:begin
		rrst_chip=1'b1;
		if()
	end
	
	4
end