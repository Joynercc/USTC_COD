`timescale 1ns/1ps
module lw_unit (
    input rst ,
    input MemRead_EX ,
    input [4 : 0] RS_ID , RT_ID , RT_EX ,
    output reg ID_EX_flush_lw , IF_ID_stall , pc_stall
);

always @(*) begin
    if(rst == 1)begin
        ID_EX_flush_lw = 0 ;
        IF_ID_stall = 0;
        pc_stall = 0;
    end
    else begin
    if( (MemRead_EX == 1 ) && ( (RT_EX == RS_ID) || (RT_EX == RT_ID) )) begin
        ID_EX_flush_lw = 1 ;
        IF_ID_stall = 1;
        pc_stall = 1;
    end
    else begin
        ID_EX_flush_lw = 0 ;
        IF_ID_stall = 0;
        pc_stall = 0;
    end
    end
end


endmodule //Hazard_detection_unit