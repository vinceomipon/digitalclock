module top (
    input  logic        CLOCK_50,
    input  logic [3:0]  KEY,
    output logic [9:0]  LEDR,
    output logic [6:0]  HEX0,
    output logic [6:0]  HEX1,
    output logic [6:0]  HEX2,
    output logic [6:0]  HEX3,
    output logic [6:0]  HEX4,
    output logic [6:0]  HEX5
);


    logic [25:0]	counter	= 0;
    logic [5:0]	seconds	= 0; // Renamed for clarity
	 logic [5:0]	minutes	= 0;
	 logic [4:0]	hours 	= 0;

    // Invert KEY[0] because buttons are usually active-low (0 when pressed)
	 logic [1:0] state_enum;
    logic reset, tick_sec, mode, mode_pressed, up, up_pressed, down, down_pressed;
    assign reset = ~KEY[0];
	 
	 // Sample input on rising clk edge to handle metastability and synchronization
	 always_ff @(posedge CLOCK_50) begin
		mode <= ~KEY[1];
		up <= ~KEY[3];
		down <= ~KEY[2];
	 end
	 
	 // generates single cycle pulse to prevent state transition racing
	 pos_edge_det pedm(CLOCK_50, mode, mode_pressed);
	 pos_edge_det pedu(CLOCK_50, up, up_pressed);
	 pos_edge_det pedd(CLOCK_50, down, down_pressed);
	 
	 digitalclock_fsm fsm(CLOCK_50, reset, mode_pressed, state_enum);
	 
	 clkdiv	cd1(CLOCK_50, reset, state_enum, counter, tick_sec);
	 thldr	tr1(CLOCK_50, reset, tick_sec, up_pressed, down_pressed, state_enum, seconds, minutes, hours);
	 
	 // Logic for spliting each time unit into tens and ones place
	 logic [3:0] sec_ones, sec_tens, min_ones, min_tens, hr_ones, hr_tens;
	 
	 always_comb begin
		sec_ones = seconds % 10;
		sec_tens = seconds / 10;
		
		min_ones = minutes % 10;
		min_tens = minutes / 10;
		
		hr_ones = hours % 10;
		hr_tens = hours / 10;
	 end
	 

    

    // output logic
    assign LEDR[1:0] = state_enum;

    sevenseg sg0 (
        .num     (sec_ones),
        .display (HEX0)
    );

    sevenseg sg1 (
        .num     (sec_tens),
        .display (HEX1)
    );
	 
	 sevenseg sg2 (
        .num     (min_ones),
        .display (HEX2)
    );
	 
	 sevenseg sg3 (
        .num     (min_tens),
        .display (HEX3)
    );
	 
	 sevenseg sg4 (
        .num     (hr_ones),
        .display (HEX4)
    );
	 
	 sevenseg sg5 (
        .num     (hr_tens),
        .display (HEX5)
    );

endmodule
