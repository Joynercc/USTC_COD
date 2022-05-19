`timescale 1ns / 1ps

module cpu_one_cycle(
    input run,  //SW6
    input step,  //BUTTON
    input valid, //SW5
    input [4:0] in, //SW[4 : 0]
    input rst,  //SW7
    input clk,  
    output [1:0]check,  //LED[6 : 5]
    output [4:0] out0,    //LED [4 : 0]
    //OUT1
    output [2:0] an,    
    output [3:0] seg,
    output ready           //LED7
);
wire io_we , clk_cpu ;
wire[7:0]io_addr , m_rf_addr ;
wire[31:0]io_dout , io_din , rf_data , m_data  ;
wire  [31 : 0] pcin , pc , pcd , pce , ir , imm , mdr , a , b , y , bm , yw ,  ctrl , ctrlm , ctrlw ;
wire [ 4: 0] rd , rdm , rdw ;
PDU PDU( .clk(clk) , .rst(rst) ,
    .run(run) , .step(step), .clk_cpu(clk_cpu) ,
    .valid(valid) , .in(in) ,
    .check(check) , .out0(out0),   .an(an) , .seg(seg) , .ready(ready) ,      
    //IO_BUS
    .io_addr(io_addr) , .io_dout(io_dout) , .io_we(io_we) , .io_din(io_din),
    //Debug_BUS
    .m_rf_addr(m_rf_addr) , .rf_data(rf_data) , .m_data(m_data) , 
    //流水线寄存器
    .pcin(pcin) , .pc(pc) , .pcd(pcd) , .pce(pce) ,
    .ir(ir) , .imm(imm) , .mdr(mdr) ,
    .a(a) , .b(b) ,. y(y) ,. bm(bm) ,. yw(yw) ,
    .rd(rd) , .rdm(rdm) , .rdw(rdw) ,
    .ctrl(ctrl) , .ctrlm(ctrlm) , .ctrlw(ctrlw)
    );


CPU CPU(
    .clk(clk_cpu) , .rst(rst) ,
    //IO_BUS
    .io_addr(io_addr) , .io_dout(io_dout) , .io_we(io_we) , .io_din(io_din),          
    //Debug_BUS
    .m_rf_addr(m_rf_addr) , .rf_data(rf_data) , .m_data(m_data) , 
    .pcin(pcin) , .pc(pc) , .pcd(pcd) , .pce(pce) ,
    .ir(ir) , .imm(imm) , .mdr(mdr) ,
    .a(a) , .b(b) ,. y(y) ,. bm(bm) ,. yw(yw) ,
    .rd(rd) , .rdm(rdm) , .rdw(rdw) ,
    .ctrl(ctrl) , .ctrlm(ctrlm) , .ctrlw(ctrlw)        
);
endmodule
