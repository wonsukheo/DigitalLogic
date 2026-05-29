module twoToOneMUX #(parameter N=8) (
	input[N-1:0] A, B,
	input Select, 
	output logic[N-1:0] Out
);

assign Out = Select ? A : B;

endmodule
