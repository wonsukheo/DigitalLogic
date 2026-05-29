module shiftReg #(parameter COUNT =4, WIDTH =4) (
	input trig, reset, dir, //left =0, right=1
	input[WIDTH-1:0] in,
	
	output reg[(WIDTH*COUNT)-1:0] out
);
	always @(posedge trig, negedge reset) begin
		if (~reset) 
			out <= 0;
		else begin
			if (dir)  begin //1=right
				out <= (out >> WIDTH);
				out[(COUNT*WIDTH)-1:((COUNT*WIDTH)-1)-WIDTH] <= in;
			end
			else begin //0=left
				out <= (out << WIDTH);
				out[WIDTH-1:0] <= in;
			end
		end
	
	end
endmodule
