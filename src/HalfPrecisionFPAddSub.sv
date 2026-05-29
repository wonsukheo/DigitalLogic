module HalfPrecisionFPAddSub (
	input[15:0] inA, inB,
	input addSub, reset, clock,
	
	output logic uf_flag_OUT, of_flag_OUT,
	output logic[15:0] outR
);	
	//register												
	logic signA, signB, signR, signFinal, uf_flag_OUT1, uf_flag_OUT2;
							//2^x bit = able to express mantissa bit
	logic[4:0] expA, expB, expBIG, exponentFinal;
	
	logic[9:0] mantissaA, mantissaB, mantissaNormOUT;
	logic[10:0] mantAhidden, mantBhidden;
	logic[11:0] mantissaAddSub;
	
	logic borrowOut_wire;					//wire
	logic[3:0] expMOD;
	logic[3:0] leading0_cnt;
	logic[10:0] mantissaBig, mantissaSmall, mantissaSmallShifted;		
	
	assign {signA, expA, mantissaA} = inA;
	assign {signB, expB, mantissaB} = inB;	
	assign mantAhidden = {1'b1, mantissaA};
	assign mantBhidden = {1'b1, mantissaB};

// STEP1. MOD EXPONENT SUBTRACTOR
NbitModExpSub #(5) ModExponentSub_inst
(
	.EA(expA) ,
	.EB(expB) ,
	
	.shiftMod(expMOD) ,				// output [N-2:0] MOD
	.BorrowOut(borrowOut_wire)	, 	// [3:0]BorrowOut (0)- EA < EB, (1)- EA > EB
	.UnderflowFlag(uf_flag_OUT1)	// uf_Flag
);	

//////////////////////////////
// STEP2. MANTISSA MUX
twoToOneMUX #(11) mux_mantissa_small
(
	.A(mantAhidden) ,				// Select(1) - A, Select(0) - B
	.B(mantBhidden) ,	
	.Select(~borrowOut_wire) ,	// borrowOut(0)- EA < EB
	
	.Out(mantissaSmall) 	
);

Barrell8bRShift #(11) mux_mantissa_shift
(
	.A(mantissaSmall) ,	
	.B(expMOD) ,			// input 4bit SHIFT COUNT
	
	.OUT(mantissaSmallShifted) 	
);

twoToOneMUX #(11) mux_mantissa_big
(
	.A(mantAhidden) ,					// Select(1) - A, Select(0) - B
	.B(mantBhidden) ,	
	.Select(borrowOut_wire) ,		// borrowOut(0)- EA < EB
	
	.Out(mantissaBig)
);
/////////////////////////////
//STEP3. EXP MUX
twoToOneMUX #(5) Exponent_MUX
(
	.A(expA) ,							// Select(1) - A, Select(0) - B
	.B(expB) ,	
	.Select(borrowOut_wire) ,		// borrowOut(0)- EA < EB
	
	.Out(expBIG) 	
);
/////////////////////////////
//STEP4. ALU
	always_ff @(posedge clock, negedge reset) begin
		if (~reset) mantissaAddSub <= 12'd0;
		else begin	// addSub- SW0 input, operands are positive
						//big number - small number
			if (addSub == 1'b1) begin mantissaAddSub <= {1'b0, mantissaBig} - {1'b0, mantissaSmallShifted};	end
			
			else begin mantissaAddSub <= {1'b0, mantissaBig} + {1'b0, mantissaSmallShifted}; end
		end
	end
	
// STEP5. MANTISSA 10BITS + EXP SHIFT FINAL
MantissaNormalizerShifter #(12) MantissaNormalizerShifter_inst
(
	.IN(mantissaAddSub) ,	// input 12bits
	
	.shift_cnt(leading0_cnt) ,	// output 4bit shifted_cnt
	.OUTs(mantissaNormOUT) 
);

// STEP6. CONTROLLED EXPONENT INCREMENTER && OVERFLOW
ControlledExponentINC ControlledExponentINC_inst
(
	.Cin(mantissaAddSub[11]) ,		// INPUT COUT 
	.shifted_IN(leading0_cnt) ,	// MANTISSA SHIFTED
	.expBIG_IN(expBIG) ,	
	
	.of_flag_OUT(of_flag_OUT) ,	// output  of_flag_OUT_sig
	.uf_flag_OUT(uf_flag_OUT2) ,	// output  uf_flag_OUT_sig
	.exp_OUT(exponentFinal) 	
);

/////////////////////////////
// STEP7. SIGN BIT 

twoToOneMUX #(1) Signbit_MUX
(
	.A(signA) ,						// Select(1) - A, Select(0) - B
	.B(signB) ,	
	.Select(borrowOut_wire) ,	// borrowOut(0)- EA < EB
	
	.Out(signR) 			// FOLLOW BIG NUMBER (expo + mantissa)
);

assign uf_flag_OUT = (uf_flag_OUT2 | uf_flag_OUT1);
//invert sign iff substracting bigger number
assign signFinal = signR ^ (addSub & ~borrowOut_wire);
assign outR = {signFinal, exponentFinal, mantissaNormOUT};

endmodule
