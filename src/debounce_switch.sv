module debounce_switch (
	input switch_in, clock,
	
	output logic switch_out
);

	parameter DELAY = 500000;
	int count = 0;
	logic state1, state2;
	
	always_ff @(posedge clock) begin
		state1 <= switch_in;
		state2 <= state1;
	end
	
	always_ff @(posedge clock) begin
		//key pressed
		if (state2 != switch_out) begin
			if (count < DELAY) count <= count + 1;
			else begin switch_out <= state2; count <= 0; end
		end 
		//key press holding
		else count <= 0; 
	end
	
endmodule