module sevensegtb();
	logic			clk, reset;
	
	// input
	logic	[3:0]	num;
	
	// output, expected output
	logic [6:0] display, display_expected;
	
	// 32-bit long signals, stored in little endian order
	// vectornum indicates # of test vectors applied
	// errors indicate # of errors found.
	logic [31:0] vectornum, errors;
	
	// 4-bit input + 7-bit output = 11-bit testvector
	logic [10:0] testvectors[10000:0];
	
	// instantiate dut
	sevenseg dut(num, display);
	
	// initialize clock
	always 
		begin 
			clk = 1; #5; clk = 0; #5;
		end
	
	// load vectors, pulse reset
	initial
		begin
			$readmemb("ssg.txt", testvectors);
			vectornum = 0; errors = 0;
			
			reset = 1; #27;
			reset = 0;
		end
	
	// apply testvectors on posedge clk
	always @(posedge clk)
		begin
			#1; {num, display_expected} = testvectors[vectornum];
		end
	
	always @(negedge clk)
		if (~reset) begin
			// check if output from DUT == expected output
			if (display !== display_expected) begin
				$display("Error: inputs = %b", num);
				$display("Outputs = %b (%b expected)", display, display_expected);
				errors = errors + 1;
			end
			
			// increment count of vectors
			vectornum = vectornum + 1;
			
			// check if finished reading from testvector file
			if (testvectors[vectornum] == 11'bx) begin
				$display("%d tests completed with %d errors", vectornum, errors);
				
				// stop simulation
			end
		end
				
	
		
	
endmodule