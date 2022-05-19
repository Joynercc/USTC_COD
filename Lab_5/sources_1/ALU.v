`timescale 1ns / 1ps

module ALU (
//input rst ,
    input [31 : 0] ALU_a , ALU_b ,
    input   ALUop ,
    output reg Alu_zero ,
    output reg [31: 0] ALU_result
);

always@(*)  begin
//if(rst )        ALU_result = 32'b1 ;
    
    case(ALUop)
        1'b0 : ALU_result = ALU_a +  ALU_b;  
        1'b1 : ALU_result = ALU_a -  ALU_b;  
        default : begin
            ALU_result = 32'b0 ;
        end 
    endcase
    
    if(ALU_result == 0)
        Alu_zero = 1 ; 
    else 
        Alu_zero = 0 ; 

end
    
endmodule 