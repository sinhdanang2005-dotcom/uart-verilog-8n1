module transmist (
input clk,tickTX, // clk:clock of system; tickTX: clock of baud rate generator
output reg out_TX, // out put of block TX
input wire [7:0] dataBits // assume the input data is 8 bits
);
localparam [1:0] IDLE  = 2'b00, // four state of UART transmit
                 START = 2'b01,
                 DATA  = 2'b10,
                 STOP  = 2'b11;
reg [1:0] state = IDLE; // state
reg [3:0] indexBits = 1;// index of the input data
always @(posedge clk)
	begin
		if(state == IDLE) // state IDLE
			begin
				if(tickTX) // when tickTX = 1 that mean clock of baudrate was counted of 5208
					begin
						state <= START; // go to the next state
						out_TX <= 1'b0; // start the transmit
					end
				else
					begin
						out_TX <= 1'b1; // if not remain state IDLE
					end	
			end
			
		if(state == START) // in the state start
			begin
				if(tickTX) // when tickTX = 1
					begin
						state <= DATA; // go to the next state
						out_TX <= dataBits[0]; // transfer the first least significant bit if transfer in state DATA it can delay 2 cycles, while we want 1 cycle tranfer 1 bit
					end
			end
			
		if(state == DATA) // state DATA
			begin
				if(tickTX) // when tickTX = 1
					begin
						if(indexBits == 8) // the condition for the next state
							begin
								state <= STOP; // next state
								out_TX <= 1'b1; // finish the transmit
								indexBits <= 4'b0001; // reset the indexbits for the new transfer
							end
						else // if not == 8
							begin
								out_TX <= dataBits[indexBits]; // transfer sequential bit for the index is [1] because [0] already sent at start state
								indexBits <= indexBits + 1; // increase the index for the next data
							end
					end
			end
			
		if(state == STOP) 
			begin
				if(tickTX)
					begin
						out_TX <= 1;
						state <= IDLE; // return to IDLE state
					end
			end
	end	
		
endmodule