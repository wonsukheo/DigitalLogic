module NbitRCS #(parameter N = 8) (
	input[N-1:0] A, B,
	
	output[N-1:0] Sum,
	output Cout
);

	logic[N:0] Carry_wire;
	
	assign Carry_wire[0] = 1'b1;
	assign Cout = Carry_wire[N];
	
	generate
	genvar i;
		for(i=0; i<N; i++) begin: rcs_loop
			FullAdder FullAdder_inst
			(
				.A(A[i]) ,	// input  A_sig
				.B(~B[i]) ,	// input  B_sig
				.Cin(Carry_wire[i]) ,	// input  Cin_sig
				.Sum(Sum[i]) ,	// output  Sum_sig
				.Cout(Carry_wire[i+1]) 	// output  Cout_sig
			);
			end
	endgenerate
	
endmodule