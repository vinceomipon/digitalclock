module clkdiv(
	input  logic			clk,
	input  logic			rst,
	input	 logic [1:0]	state,
	output logic [25:0]	counter,
	output logic 			tick_sec);
	
	localparam int MAX_COUNT = 50_000_000;
	
	always_ff @(posedge clk) begin
		if (rst || state == 2'b01 || state == 2'b10) begin
			counter <= 0;
			tick_sec <= 0;
		end else begin
			if (counter == (MAX_COUNT - 1)) begin		// converts the counter to specified frequency
				tick_sec <= 1;
				counter <= 0;
			end else begin
				tick_sec <= 0;
				counter <= counter + 1;
			end
		end
	end
	
endmodule