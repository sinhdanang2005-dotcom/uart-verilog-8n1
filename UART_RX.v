module receive (
    input clk, tickRX,
    input wire RX_in,
    output reg [7:0] RX_out
);

    localparam [1:0] IDLE  = 2'b00,
                     START = 2'b01,
                     DATA  = 2'b10,
                     STOP  = 2'b11;

    reg [1:0] state = IDLE;
    reg [7:0] indexBits = 1;
	 reg [9:0] countTick = 0;

    always @(posedge clk)
    begin
        if (state == IDLE) 
        begin
          if(RX_in == 0) // if RX_in = 0 go to start state
				begin
					state <= START;
				end
        end

        if (state == START)
        begin
            if (tickRX)
					begin
						if (RX_in == 1 && countTick == 7) // can not If(RX_in==0 && countTick == 7 because countTick is equal to 7 due to the truth condition and can not go to else to achieve 23)
							begin									// check RX_in = 0? and in the middle of start?	
								state <= IDLE;
								countTick <= 0;
							end
						else if(countTick == 23) // from the middle of start to the end of start is 8 tick and from and of start go to middle of D0 is 8 tick 8+8+7=23 
							begin
								RX_out[0] <= RX_in; // take the LSB first
								state <= DATA; // go to data state
								countTick <= 0; // reset countTick
							end
						else
							begin
								countTick <= countTick + 1;
							end
					end
				end	
					
        if (state == DATA)
        begin
            if (tickRX)
            begin
					if(countTick == 15) // we need to take a data for 16 ticks and we have the bit from 1->7
						begin
							RX_out[indexBits] <= RX_in;
							indexBits <= indexBits + 1;
							countTick <= 0; // for each 15 ticks reset the countTick and repeat it 7 times
							if(indexBits == 7) // the condition for stop take the data
								begin
								indexBits <= 1; // reset the indexBits for the next use
								state <= STOP;
								end
						end
					else 
						begin
							countTick <= countTick + 1;
						end
            end
        end

        if (state == STOP)
        begin
            if (tickRX)
            begin
                if (RX_in == 1 && countTick == 15)
                begin
                    state <= IDLE;
						  countTick <= 0;
                end
					 else
						begin
							countTick <= countTick + 1;
						end
            end
    end
end
endmodule