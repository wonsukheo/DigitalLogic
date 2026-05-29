module HalfFloatAddSub (
	input inA, inB, inR, Clock, Reset, AddSub,	//AddSub SW0
	input[3:0] rows,
	
	output uf_flag_Out, of_flag_Out,
	output[0:6] SEGs,
	output[3:0] CATs, cols
);
	logic inA_prev, inB_prev, inR_prev;
	logic inA_rise, inB_rise, inR_rise;
	logic inA_debounced, inB_debounced, inR_debounced, AddSub_debounced;
	
	logic show_R;
	logic[15:0] input_ff, regA, regB, regR, displayR;
	wire[31:0] ClockLadder;

// 1. EXPECT 16'h KEYPAD INPUTS. DEBOUNCE+ EDGE DETECT
keypad_input keypad_input_16h
(
	.clk(Clock) ,	// input  clk_sig
	.reset(Reset) ,	// input  reset_sig
	.row(rows) ,	// input [3:0] row_sig
	
	.col(cols) ,	// output [3:0] col_sig
	.out(input_ff), 	// output [((DIGITS*4)-1):0] out_sig
	.value(),
	.trig()
);

// 2. DEBOUNCE BUTTON (NOT SWITCH)
debounce_switch inA_deb
(
	.switch_in(inA) ,	// input  switch_in_sig
	.clock(Clock) ,	// input  clock_sig
	.switch_out(inA_debounced) 	// output  switch_out_sig
);

debounce_switch inB_deb
(
	.switch_in(inB) ,	// input  switch_in_sig
	.clock(Clock) ,	// input  clock_sig
	.switch_out(inB_debounced) 	// output  switch_out_sig
);

debounce_switch inR_deb
(
	.switch_in(inR) ,	// input  switch_in_sig
	.clock(Clock) ,	// input  clock_sig
	.switch_out(inR_debounced) 	// output  switch_out_sig
);

debounce_switch AddSub_deb
(
	.switch_in(AddSub) ,	// input  switch_in_sig
	.clock(Clock) ,	// input  clock_sig
	.switch_out(AddSub_debounced) 	// output  switch_out_sig
);

// 2.1 EDGE DETECT
always_ff @(posedge Clock) begin
	inA_prev <= inA_debounced;
	inB_prev <= inB_debounced;
	inR_prev <= inR_debounced;
end

// 2.2 (0 -> 1) 
assign inA_rise = inA_debounced && ~inA_prev;
assign inB_rise = inB_debounced && ~inB_prev;
assign inR_rise = inR_debounced && ~inR_prev;

// 3. SAVE DATA IN REG 
always_ff @(posedge Clock, negedge Reset) begin
	if (~Reset) begin regA <= 16'b0; regB <= 16'b0; displayR <= 16'b0; end
	else begin
		if (inA_rise) begin regA <= input_ff; displayR <= input_ff; end
		else if (inB_rise) begin regB <= input_ff; displayR <= input_ff; end
		else if (inR_rise) displayR <= regR;
	end
end


// 4. FLOAT ADD/SUB
HalfPrecisionFPAddSub HalfPrecisionFPAddSub_inst
(
	.inA(regA) ,	// input [15:0] inA_sig
	.inB(regB) ,	// input [15:0] inB_sig
	.addSub(AddSub_debounced) ,	// input  addSub_sig
	.reset(Reset) ,	// input  reset_sig
	.clock(Clock) ,	// input  clock_sig
	
	.uf_flag_OUT(uf_flag_Out) ,	// output  uf_flag_OUT_sig
	.of_flag_OUT(of_flag_Out) ,	// output  of_flag_OUT_sig
	.outR(regR) 	// output [15:0] outR_sig
);

// 5. DISPLAY 
ClockDivider #(32) ClockDivider_inst
(
	.CLK(Clock) ,	// input  CLK_sig
	.CLR(Reset) ,	// input  CLR_sig
	.Y(ClockLadder) 	// output [(N-1):0] Y_sig
);

hex2mux4 hex2mux4_inst
(
	.HEX_In(displayR) ,	// input [15:0] HEX_In_sig
	.Clock(Clock) ,	// input  Clock_sig
	.Reset(Reset) ,	// input  Reset_sig
	.Load(ClockLadder[22]) ,	// input  Load_sig
	.SEG(SEGs) ,	// output [0:6] SEG_sig
	.CAT(CATs) 	// output [3:0] CAT_sig
);

endmodule