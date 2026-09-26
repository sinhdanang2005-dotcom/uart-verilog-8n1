module UART(
input clk, tickRX,tickTX,rst,
input wire [7:0] dataBits, 
output wire [7:0] RX_out,
output wire tick_TX, tick_RX, TX_out,
input wire RX_in
); // declare the input and output pins for each module

baud_rate #(.ClockSystem(50000000),.BAUD(9600),.bits(13)) createBaud (.clk(clk),.rst(rst),.tick_TX(tick_TX),.tick_RX(tick_RX)); //call baud_rate module
transmist tx1 (.clk(clk), .out_TX(TX_out), .dataBits(dataBits), .tickTX(tick_TX)); // call TX module
receive rx1 (.clk(clk), .RX_out(RX_out), .RX_in(RX_in), .tickRX(tick_RX));// call RX module

endmodule