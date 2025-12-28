module top(
    input  logic       CLOCK_50,
    input  logic [1:0] KEY,
    output logic [9:0] LEDR,
	 output logic [6:0] HEX0,
	 output logic [6:0] HEX1,
	 output logic [6:0] HEX2,
	 output logic [6:0] HEX3,
	 output logic [6:0] HEX4,
	 output logic [6:0] HEX5
);

    localparam int MAX_COUNT = 50_000_000;

    logic [25:0] counter = 0;
    logic [5:0]  seconds = 0; // Renamed for clarity
	 logic [3:0]  tens = 0;
	 logic [3:0]  ones = 0;
    
    // Invert KEY[0] because buttons are usually active-low (0 when pressed)
    logic reset;
    assign reset = ~KEY[0]; 
    
	 // clock divider logic
    always_ff @(posedge CLOCK_50) begin
        if (reset) begin
				counter <= 0;
            seconds <= 0;
				tens <= 0;
        end else begin
            if (counter == (MAX_COUNT - 1)) begin
                counter <= 0;
                // logic for seconds
					 if (seconds == 6'b111100) begin
						seconds <= 0;							// if reached 60 seconds reset seconds counter
					 end else begin
						seconds <= seconds + 1;				// otherwise increment
					 end
            end else begin
                counter <= counter + 1;
            end
				
				tens <= seconds / 10;
				ones <= seconds % 10;
        end
    end
    
	 // output logic
    assign LEDR = seconds;
	 
	 sevenseg sg0(
		.num 		(ones),
		.display (HEX0)
		);
	
	 sevenseg sg1(
		.num 		(tens),
		.display (HEX1)
		);
	
	 
    
endmodule