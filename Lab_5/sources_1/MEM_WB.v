`timescale 1ns/1ps
module MEM_WB (
    input clk ,
    input rst ,
    input [1 : 0] MemtoReg_MEM ,
    input RegWrite_MEM ,
    input [31 : 0] Data_memory_read_data_MEM ,
    input [31 : 0] ALU_result_MEM ,
    input [4 : 0] reg_write_address_MEM ,
    input [31 : 0] PC_MEM ,
    output reg [31 : 0] PC_WB ,
    output reg [1 : 0] MemtoReg_WB ,
    output reg RegWrite_WB ,
    output reg [31 : 0] Data_memory_read_data_WB ,
    output reg [31 : 0] ALU_result_WB ,
    output reg [4 : 0] reg_write_address_WB 
);

always @(posedge clk or posedge rst) begin
    
    if (rst == 1) begin
        MemtoReg_WB <= 0 ;
        RegWrite_WB <= 0 ;
        Data_memory_read_data_WB <= 0 ;
        ALU_result_WB <= 0 ;
        reg_write_address_WB <= 0 ;
        PC_WB <= 0 ;
    end

    else begin
        MemtoReg_WB <= MemtoReg_MEM ;
        RegWrite_WB <= RegWrite_MEM ;
        Data_memory_read_data_WB <= Data_memory_read_data_MEM ;
        ALU_result_WB <= ALU_result_MEM ;
        reg_write_address_WB <= reg_write_address_MEM ;     
        PC_WB <= PC_MEM ;       
    end

end

endmodule //MEM_WB