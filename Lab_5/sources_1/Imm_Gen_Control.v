`timescale 1ns / 1ps

module Imm_Gen_Control (      
    input [31 : 0] Instruction,
    //input Imm_Gen_en,
    output reg [31 : 0] ImmGen
);

  always @(*) begin
            case(Instruction[6 : 0])
            //addi
                7'b0010011 : 
                    ImmGen = { { 20{Instruction[31]} } , Instruction[31 : 20]};
            //jal
                7'b1101111 :
                    ImmGen = { { 12{Instruction[31]} } , Instruction[31] , 
                        Instruction[19 : 12] , Instruction[20] , Instruction[30 : 21] } ;            
            //beq 
                7'b1100011 :
                    ImmGen = { { 20{Instruction[31]} } , Instruction[31] , 
                        Instruction[7] , Instruction[30 : 25] , Instruction[11 : 8]};
            //lw
                7'b0000011 :
                    ImmGen = { { 20{Instruction[31]} } , Instruction[31 : 20]} ;

            //sw
                7'b0100011 :
                    ImmGen = { { 20{Instruction[31]} } , Instruction[31 : 25] , Instruction[11 : 7]} ;

                default : 
                    ImmGen = 32'b0;
        endcase
  end
endmodule //Imm_Gen