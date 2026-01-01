module clkdiv_tb();

	// generate ports for dut
	logic clk;
	logic rst;
	logic [1:0] state;
	logic [25:0] counter;
	logic tick_sec;
	
	// instantiate dut
	clkdiv dut(clk, rst, state, counter, tick_sec);
	
	// generate 50MHz clock
	always #10 clk = ~clk;
	
	// tracks # of pos clk edges occur
	int clk_count;
	
	initial begin
		// initial conditions
		clk			= 0;
		rst			= 1;
		state			= 2'b00;
		clk_count	= 0;
		
		// deassert reset
		#100;
		rst = 0;
		
		// for every positive clock edge, increment clk_count
		while (tick_sec == 0) begin
			@(posedge clk);
			clk_count++;
		end
		
		if (clk_count == 50000000)
			$display("PASS: tick_sec after %0d clocks", clk_count);
		else
			$display("FAIL: tick_sec after %0d clocks", clk_count);
		
		
		$finish;
	end

endmodule