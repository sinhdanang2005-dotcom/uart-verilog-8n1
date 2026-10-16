# UART 8-N-1 in Verilog

A UART transmitter and receiver implemented in Verilog as a personal RTL learning project. The design uses finite state machines (FSMs) to control transmission and reception, with a baud rate generator providing timing ticks.

## 1. Design Specifications

| Parameter | Value |
|-----------|-------|
| System clock | 50 MHz |
| Baud rate | 9600 |
| Data bits | 8 |
| Parity | None |
| Stop bits | 1 |
| Transmission order | LSB first |
| RX sampling | 16× oversampling |

Each UART frame contains one start bit, eight data bits, and one stop bit. The serial line remains high when idle.

## 2. Project Files

| File | Description |
|------|-------------|
| `baud_rate.v` | Generates timing ticks for the transmitter and receiver. |
| `UART_TX.v` | Transmits an 8-bit input as a serial UART frame. |
| `UART_RX.v` | Receives serial data and samples each data bit near its center using 16× timing ticks. |
| `UART.v` | Top-level module connecting the UART blocks. |
| `UART_tb.v` | Loopback testbench connecting the TX output directly to the RX input and checking the received byte. |

## 3. Simulation Setup

The design was simulated using Questa/ModelSim.

The testbench:
1. Generates a 50 MHz system clock.
2. Resets the baud rate generator.
3. Applies the test byte `8'b11001100` (`0xCC`) to the transmitter.
4. Connects the transmitter output to the receiver input.
5. Waits for one complete UART frame.
6. Compares the received byte with the transmitted byte and prints PASS or FAIL.

To run the testbench, compile the following files and select `UART_tb` as the simulation top:

- `baud_rate.v`
- `UART_TX.v`
- `UART_RX.v`
- `UART_tb.v`

In the Questa/ModelSim Transcript window, run:

```tcl
vsim work.UART_tb
add wave sim:/UART_tb/*
run -all
wave zoom full
```

## 4. Simulation Results

| Check | Result |
|-------|--------|
| Transmitted byte | `11001100` (`0xCC`) |
| Received byte | `11001100` (`0xCC`) |
| Data comparison | **PASS** |

The testbench printed:

```text
PASS: TX = 11001100, RX = 11001100
```

This simulation confirms successful loopback transmission and reception of the test byte `0xCC`. Additional data patterns and error conditions have not yet been verified by this testbench.

### Simulation Screenshots

![UART simulation screenshot 1](<Screenshot 2026-10-16 121145.png>)

![UART simulation screenshot 2](<Screenshot 2026-10-16 121156.png>)

## 5. Author

Thai Trung Sinh
