/*Name: spi
Compiler: Quartus Prime Lite Edition 17.0.0
Coded by: Jianyu Chen
Place: Nanpin, China
Function: write data to the ds1302 or read data from ds1302. 
After getting a low pulse on rst_n port. First it will send the 
address of register to the ds1302.In the write mode, it will write
the data in wr_data port. In the read mode, it will output the read data to rd port.
After reading or writing, the finish port will be set to high.

To use this module to read: first, writing the address to wr_addr port. Give a low 
pulse on rst_n. After reading a high signal on finish port, read data on rd port. 
To use this module to write: first, writing the address to wr_addr port and data to wr_data port.
Give a low pulse on rst_n. After reading a high signal on finish port, sending is finished.

Time: 11th,Aug,2017 
*/

module spi(output ce, //enable the ds1302
				output sclk,//clock for ds1302
				inout io,  //input and output data
				input clk,	// clock for this module
				input[7:0] wr_addr,
				input[7:0] wr_data,
				input[1:0] dir,  // 1 in dir[1] means output data, 1 in dir[0]means read data
				input rst_n,
				output[7:0] rd,
				output finish
				);

reg rio;
reg[5:0] cnt;
reg rsclk;
reg rce;
reg io_dir; //1: io is in output
reg rfinish;
reg[7:0] rrd;
wire data_in;

assign sclk=rsclk;
assign ce=rce;
assign finish=rfinish;
assign rd=rrd;
assign io=io_dir?rio:1'bz;
assign data_in=io;
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)begin
		cnt<=6'd0;
		rio<=1'b0;
		rsclk<=1'b0;
		rce<=1'b0;
		rfinish<=1'd0;
	end
	else case(cnt)
	
	//in this state machine(cnt), 1 to 17 is to send the address,
	//18 to 33 is to send the data, 34 to 49 is to read the data
	//idle state
	6'd0:begin
		rce<=1'b0;
		rio<=1'b0;
		rsclk<=1'b0;
		io_dir<=1'b1;
		if(dir && ~rfinish)begin
			cnt<=cnt+6'd1;
		end
	end
	
	//pull down the clock signal and write address to io port in falling edge
	6'd1,6'd3,6'd5,6'd7,6'd9,6'd11,6'd13,6'd15:begin
		rce<=1'b1;
		rio<=wr_addr[(cnt>>1)];
		rsclk<=1'b0;
		cnt<=cnt+6'd1;
	end
	
	//pull up the clock signal
	6'd2, 6'd4, 6'd6, 6'd8, 6'd10, 6'd12, 6'd14, 6'd16, 6'd18, 6'd20, 6'd22, 6'd24, 6'd26, 6'd28, 6'd30, 6'd32:begin
		cnt<=cnt+6'd1;
		rsclk<=1'b1;
	end
	
	//judge to state 18 (in writing mode) or to 34 (in reading mode) 
	6'd17:begin
		rsclk<=1'b0;
		if(dir[1])begin
			io_dir<=1'b1;
			rio<=wr_data[7];
			cnt<=6'd18;
		end
		else begin
			io_dir<=1'b0;
			cnt<=6'd34;
		end
	end
	
	//pull down the clock signal and writing data on falling edge
	6'd19,6'd21,6'd23,6'd25,6'd27,6'd29,6'd31:begin
		rce<=1'b1;
		rio<=wr_data[(cnt>>1)-9];
		rsclk<=1'b0;
		cnt<=cnt+6'd1;
	end
	
	//change to idle state
	6'd33,6'd49:begin
		rfinish<=1'd1;
		cnt<=6'd50;
		rio<=1'b0;
		rsclk<=1'b0;
	end
	//read the data on rising edge
	6'd34,6'd36,6'd38,6'd40,6'd42,6'd44,6'd46,6'd48:begin
		rsclk<=1'b1;
		cnt<=cnt+6'd1;
		rrd[(cnt>>1)-17]<=io;
	end
	//pull down the clock signal
	6'd35,6'd37,6'd39,6'd41,6'd43,6'd45,6'd47:begin
		rsclk<=1'b0;
		cnt<=cnt+6'd1;
	end
	default: cnt<=6'd0;

	endcase
end

endmodule 