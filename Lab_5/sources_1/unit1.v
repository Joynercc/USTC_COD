`timescale 1ns/1ps
module branch_unit (
    input rst ,
    input PCSrc_EX ,
    output reg IF_ID_flush_branch , ID_EX_flush_branch
);

always @(*) begin
    if (rst == 1) begin
        IF_ID_flush_branch = 0 ;
        ID_EX_flush_branch = 0 ;
    end

    else if (PCSrc_EX == 1) begin
        IF_ID_flush_branch = 1 ;
        ID_EX_flush_branch = 1 ;
    end

    else begin
        IF_ID_flush_branch = 0 ;
        ID_EX_flush_branch = 0 ;
    end
end
endmodule //branch_unit