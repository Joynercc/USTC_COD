`timescale 1ns/1ps
module Mux_3 (
    input [31 : 0] choose00 , choose01 , choose10 ,choose11 ,
    input [1 : 0] mux ,
    output reg [31 : 0] result 
);

always@ (*) begin
    case (mux)
        2'b00 : result = choose00 ;
        2'b01 : result = choose01 ;
        2'b10 : result = choose10 ;
        2'b11 : result = choose11 ;
        default : result = 32'b0 ;
    endcase
end


endmodule //Mux_3