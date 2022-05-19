`timescale 1ns/1ps
module EX_MEM (
    input clk ,
    input rst ,
    input RegWrite_EX ,
    input MemWrite_EX ,
    input [1 : 0] MemtoReg_EX ,
    input [31 : 0] ALU_result_EX ,
    input [31 : 0] reg_read_data_2_EX ,
    input [4 : 0] reg_write_address_EX ,
    input [31 : 0] PC_EX ,
    output reg [31 : 0] PC_MEM ,
    output reg RegWrite_MEM ,
    output reg MemWrite_MEM ,
    output reg [1 : 0] MemtoReg_MEM ,
    output reg [31 : 0] ALU_result_MEM ,
    output reg [31 : 0] reg_read_data_2_MEM ,
    output reg [4 : 0] reg_write_address_MEM 
    
); 

always @(posedge clk or posedge rst) begin
    
    if (rst == 1) begin
        RegWrite_MEM <= 0 ;
        MemWrite_MEM <= 0 ;
        MemtoReg_MEM <= 0 ;
        ALU_result_MEM <= 0 ;
        reg_read_data_2_MEM <= 0 ;
        reg_write_address_MEM <= 0 ;
        PC_MEM <= 0 ;
    end

    else begin
        RegWrite_MEM <= RegWrite_EX ;
        MemWrite_MEM <= MemWrite_EX ;
        MemtoReg_MEM <= MemtoReg_EX ;
        ALU_result_MEM <= ALU_result_EX ;
        reg_read_data_2_MEM <= reg_read_data_2_EX ;
        reg_write_address_MEM <= reg_write_address_EX ;     
        PC_MEM <= PC_EX ;   
    end

end

endmodule //EX_MEM