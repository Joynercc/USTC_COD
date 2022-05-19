//final
// stall : 不变 �? flush �? 清零

`timescale 1ns/1ps
module CPU (
    input clk, 
  input rst,

  //IO_BUS
  output [7:0] io_addr,      //led?seg???
  output [31:0] io_dout,     //??led?seg???
  output io_we,                 //??led?seg????????
  input [31:0] io_din,        //??sw?????

  //Debug_BUS
  input [7:0] m_rf_addr,   //???(MEM)?????(RF)???????
  output [31:0] rf_data,    //?RF?????
  output [31:0] m_data,    //?MEM?????

  //PC/IF/ID ??????
    output [31:0] pc,
  output [31:0] pcd,
  output [31:0] ir,
  output [31:0] pcin,

  // ID/EX ??????
  output [31:0] pce,
  output [31:0] a,
  output [31:0] b,
  output [31:0] imm,
  output [4:0] rd,
  output [31:0] ctrl,

  // EX/MEM ??????
  output [31:0] y,
    output [31:0] bm,
  output [4:0] rdm,
  output [31:0] ctrlm,

  // MEM/WB ??????
  output [31:0] yw,
  output [31:0] mdr,
  output [4:0] rdw,
  output [31:0] ctrlw

);

wire [1 : 0] MemtoReg_ID , MemtoReg_EX , MemtoReg_MEM , MemtoReg_WB ;
wire [31 : 0] PC_MEM , PC_WB ;
wire MemRead_ID , MemRead_EX;
wire ID_EX_flush_lw , IF_ID_stall , pc_stall ;
wire [1 : 0] forward1_EX , forward2_EX ;
wire [4 : 0] reg_read_address_1_EX , reg_read_address_2_EX ;
wire [31 : 0] PC_IF , Instruction_IF  ;
wire [31 : 0] PC_ID , Instruction_ID ,reg_read_data_1_ID , reg_read_data_2_ID ;
wire RegWrite_ID , ALUSrc_ID , Jal_ID , MemWrite_ID  , ALUop_ID , Branch_ID ;
wire [31 : 0] ImmGen_ID ;
wire RegWrite_EX , ALUSrc_EX , Jal_EX , MemWrite_EX  , ALUop_EX , Branch_EX ;
wire [31 : 0] PC_EX , reg_read_data_1_EX , reg_read_data_2_EX ,ImmGen_EX ;
wire [4 : 0] reg_write_address_EX ;
wire [31 : 0] ALU_result_EX , ALU_b_EX , ALU_a_EX ;
wire ALU_zero_EX ;
reg [31 : 0] PCwithImm_EX  ;
reg  PCSrc_EX ;
wire RegWrite_MEM  ;
wire  MemWrite_MEM ;
wire [31 : 0] ALU_result_MEM , reg_read_data_2_MEM , Data_memory_read_data_MEM;
wire [4 : 0] reg_write_address_MEM ;
wire [31 : 0] Data_memory_Mux_3_WB ;
wire RegWrite_WB ;
wire [31 : 0] Data_memory_read_data_WB , ALU_result_WB ;
wire [4 : 0] reg_write_address_WB ;
wire IF_ID_flush_branch , ID_EX_flush_branch ;
//wire RegWrite_EX , MemWrite_EX ;
wire [31 :0] Datamemory;
reg [31 : 0]temp ;

assign io_addr = ALU_result_MEM[7 : 0] ;
assign io_dout = reg_read_data_2_EX ;
assign io_we = MemWrite_MEM && (ALU_result_MEM[10]) ;
assign pcin = PC_IF - 32'd4;
assign pc = PC_IF  ;
assign pcd = PC_ID ;
assign ir = Instruction_ID ;
assign pce = PC_EX ;
assign a = reg_read_data_1_EX ;
assign b = reg_read_data_2_EX ;
assign imm = ImmGen_EX ;
assign rd = reg_write_address_EX ;
assign ctrl = {pc_stall , IF_ID_stall , IF_ID_flush_branch , (ID_EX_flush_branch | ID_EX_flush_lw) , 
              2'b0 , forward1_EX , 2'b0 , forward2_EX ,1'b0 ,  RegWrite_EX , MemtoReg_EX ,
              2'b0 , MemRead_EX , MemWrite_EX , 2'b0 , Jal_EX , Branch_EX , 7'b0 , ALUop_EX };

assign y = ALU_result_MEM ;
assign bm = reg_read_data_2_MEM ;
assign rdm = reg_write_address_MEM ;

assign ctrlm = {pc_stall , IF_ID_stall , IF_ID_flush_branch , (ID_EX_flush_branch | ID_EX_flush_lw) , 
              2'b0 , forward1_EX , 2'b0 , forward2_EX ,1'b0 ,  RegWrite_MEM , MemtoReg_MEM ,
              2'b0 , MemRead_EX , MemWrite_MEM , 12'b0  };

assign yw = ALU_result_WB ;
assign mdr = Data_memory_read_data_WB ;
assign rdw = reg_write_address_WB ;

assign ctrlw = {pc_stall , IF_ID_stall , IF_ID_flush_branch , (ID_EX_flush_branch | ID_EX_flush_lw) , 
              2'b0 , forward1_EX , 2'b0 , forward2_EX ,1'b0 ,  RegWrite_WB , MemtoReg_WB , 16'b0 };

PC_change pc_change_1(
    .clk(clk) ,
    .rst(rst) ,
    .pc_stall(pc_stall) ,
    .PC_not_branch(PC_IF + 32'd4) ,
    .PC_branch(PCwithImm_EX) ,
    .PCSrc(PCSrc_EX) ,
    .PC_next(PC_IF)
);

Instruction_memory Instruction(
    .a(PC_IF[9 : 2]) ,
    .spo(Instruction_IF)
) ;

IF_ID IF_ID_Change(
    .clk(clk) ,
    .rst(rst) ,
    .en(IF_ID_flush_branch) ,
    .IF_ID_stall(IF_ID_stall) ,
    .PC_IF(PC_IF) ,
    .Instruction_IF(Instruction_IF) ,
    .PC_ID(PC_ID) ,
    .Instruction_ID(Instruction_ID)
);

lw_unit unit_2(
    .rst(rst) ,
    .MemRead_EX(MemRead_EX) ,
    .RS_ID(Instruction_ID[19 : 15]) , 
    .RT_EX(reg_write_address_EX) , 
    .RT_ID(Instruction_ID[24 : 20]) ,
    .ID_EX_flush_lw(ID_EX_flush_lw) , 
    .IF_ID_stall(IF_ID_stall) , 
    .pc_stall(pc_stall)
);

Regfile regfile(
    .rst(rst) ,
    .clk(clk) ,
    .reg_read_address_1(Instruction_ID[19 : 15]) ,
    .reg_read_address_2(Instruction_ID[24 : 20]) ,
    .reg_write_address(reg_write_address_WB) ,
    .reg_write_data(Data_memory_Mux_3_WB) ,
    .reg_read_data_1(reg_read_data_1_ID) ,
    .reg_read_data_2(reg_read_data_2_ID) ,
    .reg_write_en(RegWrite_WB) ,
    .reg_read_address_3(m_rf_addr[4 : 0]) ,
    .reg_read_data_3(rf_data)
);

Control control(
    .opcode(Instruction_ID[6 : 0]) ,
    .RegWrite(RegWrite_ID) ,
    .ALUSrc(ALUSrc_ID) ,
    .Jal(Jal_ID) ,
    .Branch(Branch_ID) ,
    .MemWrite(MemWrite_ID) ,
    .MemtoReg(MemtoReg_ID) ,
    .ALUop(ALUop_ID) ,
    .MemRead(MemRead_ID)
);

Imm_Gen_Control Imm_Gen(
    .Instruction(Instruction_ID) ,
    .ImmGen(ImmGen_ID)
);

ID_EX ID_EX_Change(
    .clk(clk) ,
    .rst(rst) ,
    .ID_EX_flush_branch(ID_EX_flush_branch) ,
    .ID_EX_flush_lw(ID_EX_flush_lw) ,

    .Branch_ID(Branch_ID) ,
    .Branch_EX(Branch_EX) ,
    .Jal_ID(Jal_ID) ,
    .Jal_EX(Jal_EX) ,
    .ALUop_ID(ALUop_ID) ,
    .ALUop_EX(ALUop_EX) ,
    .ALUSrc_ID(ALUSrc_ID) ,
    .ALUSrc_EX(ALUSrc_EX) ,
    .MemWrite_ID(MemWrite_ID) ,
    .MemWrite_EX(MemWrite_EX) ,
    .RegWrite_ID(RegWrite_ID) ,
    .RegWrite_EX(RegWrite_EX) ,
    .MemtoReg_ID(MemtoReg_ID) ,
    .MemtoReg_EX(MemtoReg_EX) ,

    .PC_ID(PC_ID) ,
    .PC_EX(PC_EX) ,
    .reg_read_data_1_ID(reg_read_data_1_ID) ,
    .reg_read_data_1_EX(reg_read_data_1_EX) ,
    .reg_read_data_2_EX(reg_read_data_2_EX) ,
    .reg_read_data_2_ID(reg_read_data_2_ID) ,
    .ImmGen_ID(ImmGen_ID) ,
    .ImmGen_EX(ImmGen_EX) ,
    .reg_write_address_ID(Instruction_ID[11 : 7]) ,
    .reg_write_address_EX(reg_write_address_EX) ,
    .reg_read_address_1_ID(Instruction_ID[19 : 15]) ,
    .reg_read_address_2_ID(Instruction_ID[24 : 20]) ,
    .reg_read_address_1_EX(reg_read_address_1_EX) ,
    .reg_read_address_2_EX(reg_read_address_2_EX) ,
    .MemRead_ID(MemRead_ID ) ,
    .MemRead_EX(MemRead_EX)
);

branch_unit unit_3(
    .rst(rst) ,
    .PCSrc_EX(PCSrc_EX) ,
    .IF_ID_flush_branch(IF_ID_flush_branch) ,
    .ID_EX_flush_branch(ID_EX_flush_branch)
);

Mux_3 mux_3_alu_a(
    .choose00(reg_read_data_1_EX) ,
    .choose01(Data_memory_Mux_3_WB) ,
    .choose10(ALU_result_MEM) ,
    .mux(forward1_EX) ,
    .result(ALU_a_EX) 
);
wire [31 : 0] ALU_b_EX_a;
Mux_3 mux_3_alu_b(
    .choose00(reg_read_data_2_EX) ,
    .choose01(Data_memory_Mux_3_WB) ,
    .choose10(ALU_result_MEM) ,
  // .choose11(ImmGen_EX) ,
    .mux(forward2_EX) ,
    .result(ALU_b_EX_a) 
);

Mux_2 mux_2_alu_b(
    .choose0(ALU_b_EX_a) ,
    .choose1(ImmGen_EX) ,
    .mux(ALUSrc_EX) ,
    .result(ALU_b_EX)
);


Forwarding_unit unit_1(
    .rst(rst) ,
   // .ALUSrc_EX(ALUSrc_EX) ,
    .reg_read_address_1_EX(reg_read_address_1_EX) ,
    .reg_read_address_2_EX(reg_read_address_2_EX) ,
    .reg_write_address_EX(reg_write_address_EX) ,
    .reg_write_address_MEM(reg_write_address_MEM) ,
    .reg_write_address_WB(reg_write_address_WB) ,
    .RegWrite_MEM(RegWrite_MEM ) ,
    .RegWrite_WB(RegWrite_WB ) ,
    .forward1_EX(forward1_EX) ,
    .forward2_EX(forward2_EX) 
);

/*@ (*) begin
    if(MemWrite_EX == 1) */

ALU ALU_1(
    //.rst(rst) ,
    .ALU_a(ALU_a_EX) ,
    .ALU_b(ALU_b_EX) ,
    .ALUop(ALUop_EX) ,
    .Alu_zero(ALU_zero_EX) ,
    .ALU_result(ALU_result_EX)
);

always@* begin
    if(Jal_EX == 1 || (ALU_zero_EX == 1 && Branch_EX == 1) )
        PCSrc_EX = 1 ;
    else PCSrc_EX = 0 ;
end

always@* begin
    PCwithImm_EX = ( ImmGen_EX<<1 ) + PC_EX ;
end

EX_MEM EX_MEM_Change(
    .clk(clk) ,
    .rst(rst) ,
    .PC_MEM(PC_MEM) ,
    .PC_EX(PC_EX) ,
    .RegWrite_EX(RegWrite_EX) ,
    .RegWrite_MEM(RegWrite_MEM) ,
    .MemWrite_EX(MemWrite_EX) ,
    .MemWrite_MEM(MemWrite_MEM) ,
    .MemtoReg_EX(MemtoReg_EX) ,
    .MemtoReg_MEM(MemtoReg_MEM) ,

    .ALU_result_EX(ALU_result_EX) ,
    .ALU_result_MEM(ALU_result_MEM) ,
    .reg_read_data_2_EX(ALU_b_EX_a) ,
    .reg_read_data_2_MEM(reg_read_data_2_MEM) ,

    .reg_write_address_EX(reg_write_address_EX) ,
    .reg_write_address_MEM(reg_write_address_MEM) 
);
//reg mem ;
//always@* mem = MemWrite_MEM ;
//always@* 
Data_memory Data(
    .a(ALU_result_MEM[9: 2]) ,
    .clk(clk) ,
    .d(reg_read_data_2_MEM) ,
    .we(MemWrite_MEM & (~ALU_result_MEM[10]) ) ,
    .spo(Data_memory_read_data_MEM) ,
    .dpo(m_data) ,
    .dpra(m_rf_addr)
);  



MEM_WB MEM_WB_Change(
    .clk(clk) ,
    .rst(rst) ,
    .PC_MEM(PC_MEM) ,
    .PC_WB(PC_WB) ,
    .MemtoReg_MEM(MemtoReg_MEM) ,
    .MemtoReg_WB(MemtoReg_WB) ,
    .RegWrite_MEM(RegWrite_MEM) ,
    .RegWrite_WB(RegWrite_WB) ,

    .Data_memory_read_data_MEM(Datamemory) ,
    .Data_memory_read_data_WB(Data_memory_read_data_WB) ,
    .ALU_result_MEM(ALU_result_MEM) ,
    .ALU_result_WB(ALU_result_WB) ,
    .reg_write_address_MEM(reg_write_address_MEM) ,
    .reg_write_address_WB(reg_write_address_WB) 
);



Mux_2 Mux_2_datamemory(
    .choose0(Data_memory_read_data_MEM) ,
    .choose1(io_din) ,
    .mux(ALU_result_MEM[10]) ,
    .result(Datamemory)
);


Mux_3 Mux_3_regwrite(
    .choose10(PC_WB + 32'd4) ,
    .choose01(Data_memory_read_data_WB) ,
    .choose00(ALU_result_WB) ,
    .mux(MemtoReg_WB) ,
    .result(Data_memory_Mux_3_WB) 
);

endmodule //CPU