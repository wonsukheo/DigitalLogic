module mux2toOne #(parameter N = 8) (
	input[N-1:0] A, B,
	input SEL,
	
	output logic[N-1:0] OUT
);

	assign OUT = SEL ? A : B;
	
endmodule
