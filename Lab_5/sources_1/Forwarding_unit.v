`timescale 1ns/1ps
module Forwarding_unit (
    input rst ,
   // input ALUSrc_EX ,
    input [4 : 0] reg_read_address_1_EX , reg_read_address_2_EX ,  reg_write_address_EX ,
    input [4 : 0] reg_write_address_MEM , reg_write_address_WB ,
    input RegWrite_MEM , 
    input RegWrite_WB ,
    output reg [1 : 0] forward1_EX , forward2_EX
);

always@( * )begin
    if(rst) forward1_EX = 2'b00 ;
    else
    if ( (RegWrite_MEM == 1) && (reg_write_address_MEM != 0) && (reg_write_address_MEM == reg_read_address_1_EX) )
        forward1_EX = 2'b10;
    else if ( (RegWrite_WB == 1) && (reg_write_address_WB != 0) && (reg_write_address_WB == reg_read_address_1_EX) && (reg_write_address_MEM != reg_read_address_1_EX) )
        forward1_EX = 2'b01;
    else
        forward1_EX = 2'b00;
end

always@( * )begin
if(rst) forward2_EX = 2'b00 ;
    else
    if ( (RegWrite_MEM == 1 ) && (reg_write_address_MEM != 0) && (reg_write_address_MEM == reg_read_address_2_EX) )
        forward2_EX = 2'b10;
    else if ( (RegWrite_WB == 1 ) && (reg_write_address_WB != 0) && (reg_write_address_WB == reg_read_address_2_EX) && (reg_write_address_MEM != reg_read_address_2_EX) )
        forward2_EX = 2'b01;
  //  else if(ALUSrc_EX == 1)
       // forward2_EX = 2'b11;
        else forward2_EX = 2'b00;
end






endmodule //Forwarding_unit