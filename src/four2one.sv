module four2one #(parameter N = 4) (
    input  logic[N-1:0] D0, D1, D2, D3,
    input  logic A, B,
    output logic[N-1:0] Y
);
    always_comb begin
        case ({B, A})
            2'b00: Y = D0;     
            2'b01: Y = D1;     
            2'b10: Y = D2;     
            2'b11: Y = D3;           
        endcase
    end

endmodule
