`timescale 1ns/1ps
module IF_ID (
    input clk , 
    input rst ,
    input IF_ID_stall ,
    input en ,
    input [31 : 0] PC_IF ,
    input [31 : 0] Instruction_IF ,
    output reg [31 : 0] PC_ID , 
    output reg [31 : 0] Instruction_ID 
);

always @(posedge clk or posedge rst) begin
    if (rst == 1 || en == 1) begin
        PC_ID <= 32'b0 ;
        Instruction_ID <= 32'b0 ;
    end
    else if(IF_ID_stall == 1)   begin
    end
    else begin
        PC_ID <= PC_IF ;
        Instruction_ID <= Instruction_IF ;
    end
    
end
//assign IF_ID_stall = 0;
endmodule //IF_ID