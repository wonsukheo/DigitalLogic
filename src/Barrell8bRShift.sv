module Barrell8bRShift #(parameter N = 10)(
	input[N-1:0] A,
	input[3:0] B,			// adjusted for DL2 TERM PROJECT, not parameterized
	
	output logic[N-1:0] OUT
);

	logic[N-1:0] A_Shift0, A_Shift1, A_Shift2, A_Shift3;

	assign OUT = A_Shift0;

	
	//B[3] mux A_Shift3
	generate
		genvar i;
		for (i = N-1; i >= 0; i--) begin: shift8
			if (i >= N-8) begin
				mux2toOne mux2toOne_inst
				(
					.A(1'b0) ,	// input [(N-1):0] A_sig
					.B(A[i]) ,	// input [(N-1):0] B_sig
					.SEL(B[3]) ,	// input  SEL_sig
					.OUT(A_Shift3[i]) 	// output [(N-1):0] OUT_sig
				);
			end
			else begin
			mux2toOne mux2toOne_inst
				(
					.A(A[i+8]) ,	// input [(N-1):0] A_sig
					.B(A[i]) ,	// input [(N-1):0] B_sig
					.SEL(B[3]) ,	// input  SEL_sig
					.OUT(A_Shift3[i]) 	// output [(N-1):0] OUT_sig
				);
			end
		end
	endgenerate
	
	//B[2] mux A_Shift2
	generate
		for (i = N-1; i >= 0; i--) begin: shift4
			if (i >= N-4) begin
				mux2toOne mux2toOne_inst
				(
					.A(1'b0) ,	// input [(N-1):0] A_sig
					.B(A_Shift3[i]) ,	// input [(N-1):0] B_sig
					.SEL(B[2]) ,	// input  SEL_sig
					.OUT(A_Shift2[i]) 	// output [(N-1):0] OUT_sig
				);
			end
			else begin
			mux2toOne mux2toOne_inst
				(
					.A(A_Shift3[i+4]) ,	// input [(N-1):0] A_sig
					.B(A_Shift3[i]) ,	// input [(N-1):0] B_sig
					.SEL(B[2]) ,	// input  SEL_sig
					.OUT(A_Shift2[i]) 	// output [(N-1):0] OUT_sig
				);
			end
		end
	endgenerate

	//B[1] mux A_Shift1
	generate
		
		for (i = N-1; i >= 0; i--) begin: shift2
			if (i >= N-2) begin
				mux2toOne mux2toOne_inst
				(
					.A(1'b0) ,	// input [(N-1):0] A_sig
					.B(A_Shift2[i]) ,	// input [(N-1):0] B_sig
					.SEL(B[1]) ,	// input  SEL_sig
					.OUT(A_Shift1[i]) 	// output [(N-1):0] OUT_sig
				);
			end
			else begin
			mux2toOne mux2toOne_inst
				(
					.A(A_Shift2[i+2]) ,	// input [(N-1):0] A_sig
					.B(A_Shift2[i]) ,	// input [(N-1):0] B_sig
					.SEL(B[1]) ,	// input  SEL_sig
					.OUT(A_Shift1[i]) 	// output [(N-1):0] OUT_sig
				);
			end
		end
	endgenerate

//B[0] mux A_Shift1
	generate
		
		for (i = N-1; i >= 0; i--) begin: shift1
			if (i >= N-1) begin
				mux2toOne mux2toOne_inst
				(
					.A(1'b0) ,	// input [(N-1):0] A_sig
					.B(A_Shift1[i]) ,	// input [(N-1):0] B_sig
					.SEL(B[0]) ,	// input  SEL_sig
					.OUT(A_Shift0[i]) 	// output [(N-1):0] OUT_sig
				);
			end
			else begin
			mux2toOne mux2toOne_inst
				(
					.A(A_Shift1[i+1]) ,	// input [(N-1):0] A_sig
					.B(A_Shift1[i]) ,	// input [(N-1):0] B_sig
					.SEL(B[0]) ,	// input  SEL_sig
					.OUT(A_Shift0[i]) 	// output [(N-1):0] OUT_sig
				);
			end
		end
	endgenerate
	
endmodule
