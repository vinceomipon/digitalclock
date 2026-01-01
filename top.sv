module top (
    input  logic        CLOCK_50,
    input  logic [1:0]  KEY,
    output logic [9:0]  LEDR,
    output logic [6:0]  HEX0,
    output logic [6:0]  HEX1,
    output logic [6:0]  HEX2,
    output logic [6:0]  HEX3,
    output logic [6:0]  HEX4,
    output logic [6:0]  HEX5
);
	logic mode, mode_pressed, rst;
	assign rst = KEY[1];
	
	logic set_hours, set_minutes;
	logic [1:0] state;
	
	
	// Sample input on rising clk edge to handle metastability and synchronization
	// By converting a asynchronous signal to a synchronous one
	always_ff @(posedge CLOCK_50) begin
		mode <= ~KEY[0];
	end
	
	// Generates single cycle pulse when button is held down
	// to prevent racing between state transitions
	pos_edge_det ped(CLOCK_50, mode, mode_pressed);
	
	fsm fsm_dut(CLOCK_50, rst, mode_pressed, set_hours, set_minutes, state);
	
	
	always_comb begin
		LEDR[1:0] = state;
	end
	
endmodule
