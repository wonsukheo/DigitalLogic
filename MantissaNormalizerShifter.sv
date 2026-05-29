module MantissaNormalizerShifter #(parameter N = 12) (
	input[N-1:0] IN,
	
	output logic[3:0] shift_cnt,	// max_shift 11, 4bits
	output logic[N-3:0] OUTs		// 10bits
);
	logic[N-1:0] INshifted;

// 1. COUNT LEADING 0's
	always_comb begin
        shift_cnt = 4'd0;
		  
        // Loop from MSB down to 0
		for (int i = N-1; i >= 0; i--) begin
			if (IN[i] == 1'b1) break;

			else shift_cnt = shift_cnt + 1'b1;

		end
    end

// 2. SHIFT MANTISSA
Barrell8bLShift #(N) LShift12b_inst	//not fully parameterized
(
	.A(IN) ,				//N-1:0 INPUT
	.B(shift_cnt) ,	// input 3bit shift_cnt
	
	.OUT(INshifted) 	//N-1:0 OUTPUT
);

// 3. 1x.xxx, CarryOut (1)	
//    IF (carryout) RIGHT SHIFT >> 1;
//		else shfited[10:1], [11] is hidden bit
	assign OUTs = IN[N-1] ? IN[10:1] : INshifted[10:1];

	endmodule