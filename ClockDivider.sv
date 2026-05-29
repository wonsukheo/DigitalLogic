module ClockDivider #(parameter N=32) (
	input CLK, CLR,
	
	output logic[N-1:0] Y
);

	always_ff @(posedge CLK, negedge CLR)
		if (~CLR) Y <= 1'b0;
		else Y <= Y + 1'b1;

endmodule
