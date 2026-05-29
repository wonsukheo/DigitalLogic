module keypad_input #( parameter DIGITS = 4) // Depends: keypad_base(clock_div,keypad_fsm,keypad_decoder), shift_reg
( 
	input clk,
	input reset,
	input [3:0] row,
	
	output [3:0] col,
	output [(DIGITS*4)-1:0] out,
	//debug
	output[3:0] value,
	output trig
);

//internal signal
	logic trig_prev;
   logic trig_pulse; // Only high for 1 clock cycle
	
// EDGE DETECT
    always_ff @(posedge clk) begin
        trig_prev <= trig;
    end

    assign trig_pulse = trig && ~trig_prev;

keypad_base keypad_base(
	.clk(clk),
	.row(row),
	.col(col),
	.value(value),
	.valid(trig)
);

shiftReg #(.COUNT(DIGITS)) shift_reg(
	.trig(trig_pulse),
	.in(value),
	.out(out),
	.reset(reset)
);

endmodule
