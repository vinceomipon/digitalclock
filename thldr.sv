module thldr(
	input		logic			clk,
	input		logic			rst,
	input		logic			tick_sec,
	input		logic			up,
	input		logic			down,
	input		logic [1:0] state,
	output	logic	[5:0] seconds,
	output	logic [5:0] minutes,
	output	logic	[4:0] hours);
	
	always_ff @(posedge clk) begin
		if (rst) begin
			seconds	<= 0;
			minutes	<= 0;
			hours		<= 0;
		end else if (state == 2'b01) begin
			if (up && hours < 23) begin
				hours <= hours + 1;
			end else if (down && hours > 0) begin
				hours <= hours - 1;
			end
		end else if (state == 2'b10) begin
			if (up && minutes < 59) begin
				minutes <= minutes + 1;
			end else if (down && minutes > 0) begin
				minutes <= minutes - 1;
			end
		end else if (tick_sec) begin
			if (seconds == 59) begin
				seconds <= 0;
				if (minutes == 59) begin
					minutes <= 0;
					if (hours == 23) begin
						hours <= 0;
					end else begin
						hours <= hours + 1;
					end
				end else begin
					minutes <= minutes + 1;
				end
			end else begin
				seconds <= seconds + 1;
			end
		end
	end
endmodule
	