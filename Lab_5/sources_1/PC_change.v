`timescale 1ns/1ps
module PC_change (
    input clk , 
    input rst ,
    input pc_stall ,
    input [31 : 0] PC_not_branch ,
    input [31 : 0] PC_branch ,
    input PCSrc ,
    output  [31 : 0] PC_next 
);

reg [31 : 0 ] pc_temp ;
always @(posedge clk or posedge rst) begin
    if (rst == 1) begin
        pc_temp <= 32'h0000_3000;
    end
    else if(pc_stall == 1) begin pc_temp <= pc_temp; end
    else begin
        if (PCSrc == 1)     pc_temp <= PC_branch ;
        else    pc_temp <= PC_not_branch ;
    end
end

assign PC_next = pc_temp ;
endmodule //PC_change