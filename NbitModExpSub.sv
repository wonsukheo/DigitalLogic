module NbitModExpSub #(parameter N=5) (
	input[N-1:0] EA, EB,
	
	output logic[N-2:0] shiftMod,
	output logic BorrowOut, UnderflowFlag
);

	logic[N-1:0] Mod, result_reg, resultTwoComp;
	
	// 1.RCS
	NbitRCS #(N) NbitRCS_inst 
	(
		.A(EA) ,	// input [(N-1):0] A_sig
		.B(EB) ,	// input [(N-1):0] B_sig
		.Sum(result_reg) ,	// output [(N-1):0] Sum_sig
		.Cout(BorrowOut) 	// output  Cout_sig
	);
	
	// 2.CASE (A < B): Borrow is used. borrowout0
	//   take 2's comp to get ||MOD||
	twoCompConverter #(N) twoCompConverter_inst
	(
		.A(result_reg) ,	// input [(N-1):0] A_sig
		.OUT(resultTwoComp) 	// output [(N-1):0] OUT_sig
	);
	
	// 3. MUX A-1, B-0
	twoToOneMUX #(N) twoToOneMUX_inst
	(
		.A(result_reg) ,	// input [(N-1):0] A_sig
		.B(resultTwoComp) ,	// input [(N-1):0] B_sig
		.Select(BorrowOut) ,	// input  Select_sig
		.Out(Mod) 	// output [(N-1):0] Out_sig
	);
	
	// 4. SHIFT_MAX = 10b mantissa + 1b hidden 1 = 11bits
	always_comb begin
		if (Mod >= 11) begin
			shiftMod = 4'd11;
			UnderflowFlag = 1'b1;
		end 
		else begin
			shiftMod = Mod;
			UnderflowFlag = 1'b0;
		end
	end
	
endmodule
