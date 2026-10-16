`timescale 1ns/1ps

module UART_tb();
localparam T = 20; // T = 20ns => f= 50MHz
localparam n = 8; // width of data
//declare ports
reg clock = 0;
reg reset = 0;
reg[n-1:0] data_bits = 8'b11001100;
wire tick_TX,tick_RX, out_TX;
wire [n-1:0] checkRX;

//connect with each block
baud_rate #(
	 .ClockSystem(50000000),
    .BAUD(9600),
    .bits(13)
) u_baud_rate(
	.rst(reset),
	.clk(clock),
	.tick_TX(tick_TX),
	.tick_RX(tick_RX)
);

transmist TX(
	.clk(clock),
	.tickTX(tick_TX),
	.out_TX(out_TX),
	.dataBits(data_bits)
);

receive RX(
	.clk(clock),
	.tickRX(tick_RX),
	.RX_out(checkRX),
	.RX_in(out_TX)
);

//clock driver
always
	begin
		clock = 1'b1;
		#(T/2);
		clock = 1'b0;
		#(T/2);
	end
	
initial // reset for a short period 
		begin
			reset = 1'b1;
			#(T/2 + 20);
			reset = 1'b0;
		end

//test process of UART
initial
	begin
		@(negedge reset); // wait for reset inactive
		@(negedge out_TX);   // wait for TX start bit

    #(10 * 5208 * T);    // wait 1 start + 8 data + 1 stop

    if (checkRX !== data_bits)
		begin
        $display("FAIL: TX = %b, RX = %b", data_bits, checkRX);
		end
    else
		begin
        $display("PASS: TX = %b, RX = %b", data_bits, checkRX);
		end
    $stop;	
	end
	
endmodule	