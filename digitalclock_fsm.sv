module digitalclock_fsm(
	input	 logic		clk,
	input  logic		rst,
	input	 logic		mode,
	output logic set_hours,
	output logic set_minutes,
	output logic [1:0] state_enum);
	
	typedef enum logic [1:0] {S0, S1, S2} statetype;
	statetype state, next_state;
	
	// next-state logic
	always_comb begin
		case(state)
			S0:
				begin
					if (mode)
						next_state = S1;
					else
						next_state = S0;
				end
			S1:
				begin
					if (mode)
						next_state = S2;
					else
						next_state = S1;
				end
			S2:
				begin
					if (mode)
						next_state = S0;
					else
						next_state = S2;
				end
			default: next_state = S0;
		endcase
	end
	
	// current-state logic
	// active low reset
	always_ff @(posedge clk) begin
		if (~rst)
			state <= S0;
		else
			state <= next_state;
	end
	
	// Output logic
	assign set_hours 		= (next_state == S1);
	assign set_minutes 	= (next_state == S2);
	
	always_comb begin
		case(state)
			S0: state_enum = 2'b00;
			S1: state_enum = 2'b01;
			S2: state_enum = 2'b10;
			default: state_enum = 2'b00;
		endcase
	end
	
	
endmodule