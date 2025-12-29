module fsmtb();
	// inputs
	logic			clk, reset, mode;
	
	// outputs
	logic			set_hours, set_minutes;
	
	// declare state machine and state variables

	// create clock
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	// Instantiate dut
	digitalclock_fsm fsm_dut(clk, reset, mode, set_hours, set_minutes);
	
	// generate input signals
	initial
		begin
			clk = 0;
			reset = 0; 	// active-low reset
			mode = 0;
			
			#12;
			reset = 1; // turn off reset
			
			// S0 to S1
			@(posedge clk);
			mode = 1;
			@(posedge clk);
			mode = 0;
			
			// S1 to S2
			@(posedge clk);
			mode = 1;
			@(posedge clk);
			mode = 0;
			
			// S2 to S0
			@(posedge clk);
			mode = 1;
			@(posedge clk);
			mode = 0;
			
			#20 $finish;
		end
		
		// Monitor
		 initial begin
			  $monitor("t=%0t | mode=%b | set_hours=%b | set_minutes=%b",
							$time, mode, set_hours, set_minutes);
		 end
	
endmodule