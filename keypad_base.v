module keypad_base(
	input clk,
	input [3:0]row,
	output [3:0]col,
	output [3:0]value,
	output valid,
//debug
	output slow_clock,
	output sense,
	output valid_digit,
	output [3:0] inv_row
);

assign inv_row=~row;

//instantiation
clock_div #(.DIV(100000)) keypad_clock_divider(
	.clk(clk),
	.clk_out(slow_clock)
);

//instantiation
keypad_fsm keypad_fsm(
	.clk(slow_clock),
	.row(inv_row),
	.col(col),
	.sense(sense)
);

//instantiation
keypad_decoder #(.BASE(16)) keypad_key_decoder(
	.row(inv_row),
	.col(col),
	.value(value),
	.valid(valid_digit)
);

assign valid = valid_digit && sense;

endmodule
