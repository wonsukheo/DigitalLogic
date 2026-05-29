module twoCompConverter #(parameter N=8) (
	input[N-1:0] A,
	output logic[N-1:0] OUT
);

	logic[N:0] Carry_wire;
	
	assign Carry_wire[0] = 1'b1;
	
	generate
	genvar i;
		for (i=0; i<N; i++) begin: fa_loop
			FullAdder FullAdder_inst
			(
				.A(~A[i]) ,	// input  A_sig
				.B(1'b0) ,	// input  B_sig
				.Cin(Carry_wire[i]) ,	// input  Cin_sig
				.Sum(OUT[i]) ,	// output  Sum_sig
				.Cout(Carry_wire[i+1]) 	// output  Cout_sig
			);
		end
	endgenerate

endmodule
