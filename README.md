# UART 8-N-1 in Verilog

A UART transmitter and receiver designed for a 50 MHz system clock and a 9600 baud rate. The receiver uses 16× oversampling to sample incoming data near the center of each bit.

## Files

- `UART.v` — connects the UART modules
- `UART_TX.v` — transmitter
- `UART_RX.v` — receiver
- `baud_rate.v` — generates timing ticks for TX and RX

## Author

Thai Trung Sinh
