module baud_rate #(
	parameter ClockSystem = 50000000, // I set an exmple to calculate the period
	parameter BAUD = 9600,
	parameter bits = 13
)(
	input rst,
	input clk, // for the external clock like FPGA
	output reg tick_TX,tick_RX
);
	reg [bits-1:0] counter_TX;
	reg [bits-1:0] counter_RX;
always @(posedge clk)
	begin
		if(rst)begin //assign the initial value
		tick_TX <= 0;
		tick_RX <= 0;
		counter_TX <=0;
		counter_RX <= 0;
			end
		else begin
		if(counter_TX == ClockSystem/BAUD - 1)begin // the counter count from 0 so that to count exactly 5208 we would count from 0 to 5207
			counter_TX <= 0; // reset counter
			tick_TX <= 1; // Announce done the count
			end
		else begin
			counter_TX <= counter_TX + 1; // continue to count to 5208
			tick_TX <= 0; // announce not done
			end
		if(counter_RX == ClockSystem/(BAUD*16) - 1)
			begin
				counter_RX <= 0;
				tick_RX <= 1;
			end
		else
			begin
				counter_RX <= counter_RX + 1;
				tick_RX <= 0;
			end
	end
	end
endmodule
		