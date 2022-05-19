`timescale 1ns/1ps
//先写后读
module Regfile (
    input rst ,
    input clk ,
    input [4 : 0] reg_read_address_1 ,
    input [4 : 0] reg_read_address_2 ,
    input [4 : 0] reg_read_address_3 ,
    output [31 : 0] reg_read_data_1 ,
    output [31 : 0] reg_read_data_2 ,
    output [31 : 0] reg_read_data_3 ,
    input reg_write_en ,
    input [4 : 0] reg_write_address ,
    input [31 : 0] reg_write_data 
);

reg [31 : 0] reg_file [0 : 31];
integer i;

assign reg_read_data_1 = reg_file [reg_read_address_1];
assign reg_read_data_2 = reg_file [reg_read_address_2];
assign reg_read_data_3 = reg_file [reg_read_address_3];

always @(negedge clk or posedge rst) begin
    if (rst == 1)begin
        for (i = 0 ; i < 32 ; i = i + 1)begin
            reg_file[i] <= 32'b0 ; 
        end
    end
    else if(reg_write_address != 5'b0 && reg_write_en == 1)begin
        reg_file[reg_write_address] <= reg_write_data ;
    end
end
endmodule //Regfile