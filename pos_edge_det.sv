// Simple edge detector module
module pos_edge_det(
    input logic clk,
    input logic signal,
    output logic edge_detected
);
    logic signal_prev;
    
    always_ff @(posedge clk) begin
		signal_prev <= signal;
    end
    
    assign edge_detected = signal & ~signal_prev; // detect a rising edge
endmodule