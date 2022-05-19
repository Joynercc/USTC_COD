`timescale 1ns / 1ps

module Sim( ) ;
reg clk , rst ;
reg [4 : 0] in ;
reg run ;
cpu_one_cycle cpu_1(.clk(clk), .rst(rst) ,.in(in) , .run(run) );

initial begin
    clk = 1;
    repeat (5000)
        #(2) clk = ~clk;
    $finish;
end

initial begin
rst = 1;
#2 rst = 1;
#2 rst = 0 ;
end

initial #4 in <= 5'b00010 ;

initial begin
 run = 1;
#500 run = 0;
end
endmodule