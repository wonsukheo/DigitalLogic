module hex2mux4 (
	input[15:0] HEX_In,
	input Clock, Reset, Load,
	
	output[0:6] SEG,
	output[3:0] CAT
);
	logic[15:0] Reg_In;
	logic[3:0] dataOut;
	logic[1:0] SEL;
	logic[31:0] Mux_Clock;
	
	always @(posedge Load, negedge Reset)
		if (Reset == 0) Reg_In <= 0; 
		else Reg_In <= HEX_In;

four2one four2one_inst
(
	.D0(Reg_In[3:0]) ,	// input [(N-1):0] D0_sig
	.D1(Reg_In[7:4]) ,	// input [(N-1):0] D1_sig
	.D2(Reg_In[11:8]),	// input [(N-1):0] D2_sig
	.D3(Reg_In[15:12]),	// input [(N-1):0] D3_sig
	.A(SEL[0]) ,	// input  A_sig
	.B(SEL[1]) ,	// input  B_sig
	.Y(dataOut) 	// output [(N-1):0] Y_sig
);
		
FSM FSM_inst
(
	.clock(Mux_Clock[17]) ,	// input  clock_sig
	.reset(Reset) ,	// input  reset_sig
	.SEL(SEL) ,	// output [1:0] SEL_sig
	.CAT(CAT) 	// output [3:0] CAT_sig
);


hex2seven hex2seven_inst //ACT-HIGH
(
	.w(dataOut[3]) ,	// input  w_sig
	.x(dataOut[2]) ,	// input  x_sig
	.y(dataOut[1]) ,	// input  y_sig
	.z(dataOut[0]) ,	// input  z_sig
	.a(SEG[0]) ,	// output  a_sig
	.b(SEG[1]) ,	// output  b_sig
	.c(SEG[2]) ,	// output  c_sig
	.d(SEG[3]) ,	// output  d_sig
	.e(SEG[4]) ,	// output  e_sig
	.f(SEG[5]) ,	// output  f_sig
	.g(SEG[6]) 	// output  g_sig
);

ClockDivider #(32) ClockDivider_inst // 50Mhz 
(
	.CLK(Clock) ,
	.CLR(Reset) ,
	.Y(Mux_Clock)
);
endmodule
