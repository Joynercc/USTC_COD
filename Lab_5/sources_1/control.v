`timescale 1ns / 1ps

module Control(
    input [6 : 0] opcode,
    output reg ALUop,
    output reg [1 : 0] MemtoReg, 
    output reg Jal ,
    output reg ALUSrc ,
    output reg Branch ,
    output reg MemWrite , 
    output reg RegWrite ,
    output reg MemRead 

);

always @(*) begin
    case(opcode)
    //addi
        7'b0010011 : begin
            Jal = 0;
            Branch = 0;
            MemtoReg = 2'b00;
            ALUop = 0;
            MemWrite = 0;
            ALUSrc = 1;
            RegWrite = 1;
            MemRead = 0 ;
            
        end 

    //ADD 
        7'b0110011 : begin
                Jal = 0;
                Branch = 0;
                MemtoReg = 2'b00;
                ALUop = 0;
                MemWrite = 0;        
                ALUSrc = 0;
            MemRead = 0 ;
                RegWrite = 1;
        end

    //Jal
        7'b1101111 : begin
            Jal = 1;
            Branch = 0;
            MemtoReg = 2'b10;
            ALUop = 0;
            MemWrite = 0;           
            MemRead = 0 ;
            ALUSrc = 0;
            RegWrite = 0;           
        end
    
    //Beq 
        7'b1100011 : begin
                Jal = 0;
                Branch = 1;
            MemRead = 0 ;
                MemtoReg = 2'b00;
                ALUop = 1;
                MemWrite = 0;                
                ALUSrc = 0;
                RegWrite = 0;                
        end

    //Lw
        7'b0000011 : begin
            Jal = 0;
            Branch = 0;
            MemRead = 1 ;
            MemtoReg = 2'b01;
            ALUop = 0;
            MemWrite = 0;           
            ALUSrc = 1;
            RegWrite = 1;
        end

    //Sw
        7'b0100011 : begin
            Jal = 0;
            Branch = 0;
            MemRead = 0 ;
            MemtoReg = 2'b01;
            ALUop = 0;//add
            MemWrite = 1;            
            ALUSrc = 1;
            RegWrite = 0;            
        end

    //Default
        default : begin
            Jal = 0;
            Branch = 0;
            MemtoReg = 2'b00;
            ALUop = 0;//add
            MemWrite = 0; 
                      MemRead = 0 ;  
            ALUSrc = 0;
            RegWrite = 0;           
        end

    endcase
end

endmodule //Control

