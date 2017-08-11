/*Name: test
Compiler: Quartus Prime Lite Edition 17.0.0
Coded by: Jianyu Chen
Place: Nanpin, China
Function: control the spi. it will read the second, minute and hour data. if the chip is not initialized
(the bit7 of second register is 1), it will change to initializing state to initialize the cihp
Time: 11th,Aug,2017 
*/

module test(input clk,
				input rst_n,
				output ce,//chip enable for ds1302
				inout io,
				output sclk,//clock for ds1302
				output[7:0] second,
				output[7:0] minute,
				output[7:0] hour
				);
				
reg[6:0] cnt;
reg rrst_spi;
reg[1:0] rdir;
reg[7:0] rsecond;
reg[7:0] rminute;
reg[7:0] rhour;
reg[7:0] rwr_addr;
reg[7:0] rwr_data;
reg init_flag;


wire[1:0] dir;  // 1 in dir[1] means output data, 1 in dir[0]means read data
wire finish;    // 1 means the chip is not initialized
wire rst_spi;
wire[7:0] rd;
wire[7:0] wr_addr;
wire[7:0] wr_data;

assign wr_addr=rwr_addr;
assign wr_data=rwr_data;
assign dir=rdir;
assign rst_spi=rrst_spi;
assign second=rsecond;
assign minute=rminute;
assign hour=rhour;

//address for registers
parameter second_read=8'h81,minute_read=8'h83,hour_read=8'h85,
				second_write=8'h80,minute_write=8'h82,hour_write=8'h84,
				wp_write=8'h8e;


always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		cnt<=7'd0;
		init_flag<=1'b0;
		rdir<=2'b0;
		rrst_spi<=1'b1;
	end
	else case(cnt)
	//judge whether the chip is initialized, if not. initialize it
	7'd0: begin
		if(init_flag)
			cnt<=7'd1;
		else
			cnt<=7'd7;
	end
	//write the address and data to spi module, change the spi module to write mode
	7'd1:begin
		rwr_addr<=wp_write;
		rwr_data<=8'h00;
		rdir<=2'b10;
		cnt<=cnt+7'd1;
	end
	
	//start the spi module
	7'd2:begin
		rrst_spi<=1'b0;
		cnt<=cnt+7'd1;
	end
	7'd3:begin
		rrst_spi<=1'b1;
		if(finish)
			cnt<=7'd4;
	end
	
	//write 0x00 to second register
	7'd4:begin
		rwr_addr<=second_write;
		rwr_data<=8'h00;
		rdir<=2'b10;
		cnt<=cnt+7'd1;
	end
	7'd5:begin
		rrst_spi<=1'b0;
		cnt<=cnt+7'd1;
	end
	
	7'd6:begin
		rrst_spi<=1'b1;
		init_flag<=1'd0;
		if(finish)     //wait for the finish of spi
			cnt<=7'd7;
	end
	
	//read second
	7'd7:begin 
		rwr_addr<=second_read;
		rdir<=2'b01;
		cnt<=cnt+7'd1;
	end
	
	7'd8:begin
		rrst_spi<=1'b0;
		cnt<=cnt+7'd1;
	end
	7'd9:begin
		rrst_spi<=1'b1;
		if(finish)begin
			cnt<=cnt+7'd1;
			rsecond<=rd;
			init_flag<=rd[7];  //judge whether the chip is initialized
		end
	end
	
	//read minute
	7'd10:begin 
		rwr_addr<=minute_read;
		rdir<=2'b01;
		cnt<=cnt+7'd1;
	end
	
	7'd11:begin
		rrst_spi<=1'b0;
		cnt<=cnt+7'd1;
	end
	7'd12:begin
		rrst_spi<=1'b1;
		if(finish)begin
			cnt<=cnt+7'd1;
			rminute<=rd;
		end
	end
	
	//read hour
	7'd13:begin 
		rwr_addr<=hour_read;
		rdir<=2'b01;
		cnt<=cnt+7'd1;
	end
	
	7'd14:begin
		rrst_spi<=1'b0;
		cnt<=cnt+7'd1;
	end
	7'd15:begin
		rrst_spi<=1'b1;
		if(finish)begin
			cnt<=7'd0;
			rhour<=rd;
		end
	end
	
	
	default:cnt=cnt+7'd1;
	endcase
end

spi u1(.wr_addr(wr_addr),
			.wr_data(wr_data),
			.dir(dir),
			.clk(clk),
			.rst_n(rst_spi),
			.rd(rd),
			.finish(finish),
			.io(io),
			.ce(ce),
			.sclk(sclk)
			);

endmodule 