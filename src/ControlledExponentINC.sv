module ControlledExponentINC #(parameter N=5) (
	input Cin,
	input[N-2:0] shifted_IN,	//max_shifted = 11bits
	input[N-1:0] expBIG_IN,		
	
	output of_flag_OUT, uf_flag_OUT,
	output logic[N-1:0] exp_OUT
);
	logic[N-1:0] exp_TEMP;

assign exp_OUT = exp_TEMP;

	always_comb begin
		// CASE0: DEFAULT
		of_flag_OUT = 1'b0;
		uf_flag_OUT = 1'b0;
		
		// CASE1: 1x.xxx
		if (Cin) begin
			// CASE1.1: OVERFLOW, exp5'b11111 + 1
			if (expBIG_IN == 5'b11111) begin
				exp_TEMP = expBIG_IN;
				of_flag_OUT = 1'b1;
			end 
			// CASE1.2: exp5b + 1
			else begin exp_TEMP = expBIG_IN + 1;
				if (exp_TEMP == 5'b11111) of_flag_OUT = 1'b1;
			end
		end
		else begin
		// CASE2: VALID, mantissaAddSub == 0 
			if (shifted_IN == 12) begin
				exp_TEMP = 5'b00000;
			end 
			// CASE2.1: expBIG_IN + 1 DUE TO NORM SHIFT LOGIC
			else if (shifted_IN > expBIG_IN + 1) begin
				exp_TEMP = 5'b00000;
				uf_flag_OUT = 1'b1;
			end
			// CASE2.2: VALID
			else exp_TEMP = expBIG_IN + 1 - {1'b0, shifted_IN};
		end
		
	end
	
endmodule
