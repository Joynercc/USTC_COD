`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/29 23:48:32
// Design Name: 
// Module Name: Mux_2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux_2(
    input [31 : 0] choose0 ,
    input [31 : 0] choose1 ,
    input mux ,
    output [31 : 0] result
    );
    
assign result = (mux == 1) ? choose1 : choose0 ;    
endmodule
