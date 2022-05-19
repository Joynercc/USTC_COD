`timescale 1ns/1ps
module ID_EX (
    input clk , 
    input rst , 
    input ID_EX_flush_branch ,
    input ID_EX_flush_lw ,
    input Branch_ID ,
    output reg Branch_EX ,
    input Jal_ID ,
    output reg Jal_EX ,
    input ALUop_ID ,
    output reg ALUop_EX ,
    input ALUSrc_ID ,
    output reg ALUSrc_EX ,
    input MemWrite_ID ,
    output reg MemWrite_EX ,
    input RegWrite_ID ,
    output reg RegWrite_EX ,
    input [1 : 0] MemtoReg_ID ,
    output reg [1 : 0] MemtoReg_EX ,
    input [31 : 0] PC_ID ,
    output reg [31 : 0] PC_EX ,
    input [31 : 0] reg_read_data_1_ID ,
    input [31 : 0] reg_read_data_2_ID ,
    output reg [31 : 0] reg_read_data_1_EX,
    output reg [31 : 0] reg_read_data_2_EX,
    input [31 : 0] ImmGen_ID ,
    output reg [31 : 0] ImmGen_EX ,
    input [4 : 0] reg_write_address_ID ,
    output reg [4 : 0] reg_write_address_EX ,
    input [4: 0] reg_read_address_1_ID ,  reg_read_address_2_ID ,
    output reg [4: 0] reg_read_address_1_EX ,  reg_read_address_2_EX ,
    input MemRead_ID ,
    output reg MemRead_EX
);

always @(posedge clk or posedge rst ) begin
    
    if(rst == 1 || ID_EX_flush_branch == 1) begin
        Branch_EX <= 0 ;
        Jal_EX <= 0 ;
        ALUop_EX <= 0 ;
        ALUSrc_EX <= 0 ;
        MemWrite_EX <= 0 ;
        RegWrite_EX <= 0 ;
        MemtoReg_EX <= 0 ;
        PC_EX <= 0 ;
        reg_read_data_1_EX <= 0 ;
        reg_read_data_2_EX <= 0 ;
        ImmGen_EX <= 0 ;
        reg_write_address_EX <= 0 ;
        reg_read_address_1_EX <= 0 ;
        reg_read_address_2_EX <= 0 ;
        MemRead_EX <= 0 ;
    end

    else if(ID_EX_flush_lw == 1)begin
        Branch_EX <= 0 ;
        Jal_EX <= 0 ;
        ALUop_EX <= 0 ;
        ALUSrc_EX <= 0 ;
        MemWrite_EX <= 0 ;
        RegWrite_EX <= 0 ;
        MemtoReg_EX <= 0 ;
        PC_EX <= PC_ID ;
        reg_read_data_1_EX <= reg_read_data_1_ID ;
        reg_read_data_2_EX <= reg_read_data_2_ID ;
        ImmGen_EX <= ImmGen_ID ;
        reg_write_address_EX <= reg_write_address_ID ;   
        reg_read_address_1_EX <= reg_read_address_1_ID ;
        MemRead_EX <= MemRead_ID ;
        reg_read_address_2_EX <= reg_read_address_2_ID ; 
    end
    
    else begin
        Branch_EX <= Branch_ID ;
        Jal_EX <= Jal_ID ;
        ALUop_EX <= ALUop_ID ;
        ALUSrc_EX <= ALUSrc_ID ;
        MemWrite_EX <= MemWrite_ID ;
        RegWrite_EX <= RegWrite_ID ;
        MemtoReg_EX <= MemtoReg_ID ;
        PC_EX <= PC_ID ;
        reg_read_data_1_EX <= reg_read_data_1_ID ;
        reg_read_data_2_EX <= reg_read_data_2_ID ;
        ImmGen_EX <= ImmGen_ID ;
        reg_write_address_EX <= reg_write_address_ID ;   
        reg_read_address_1_EX <= reg_read_address_1_ID ;
        MemRead_EX <= MemRead_ID ;
        reg_read_address_2_EX <= reg_read_address_2_ID ;    
    end

end
//assign ID_EX_en = 0 ;
endmodule //ID_EX