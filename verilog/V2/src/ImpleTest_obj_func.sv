`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/28 15:22:18
// Design Name: 
// Module Name: ImpleTest_obj_func
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Com ments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ImpleTest_obj_func#(
parameter NUM_ELEMENTS=50,
parameter DATA_WIDTH=32,
parameter DATA_WIDTH_fix=64,
parameter NUM_parallel=3
)(
input                    clk,
input                    rst,
input                    op_objfunc,
input      [5:0]         data_addr,
input      [DATA_WIDTH-1:0] data_coefficient_f,// coefficient_f[6]=trans;

input  [DATA_WIDTH-1:0]   rams_idmatrix_in [4:0],//ram_idmatrix,
input  [11:0]             rams_idmatrix_addr_in ,//expect the last two is ram_impos
input                     rams_idmatrix_we,
input  [DATA_WIDTH-1:0]   ram_impos_in,//ram_idmatrix,
input  [7:0]              ram_impos_in_addr,
input                     ram_impos_we,

output  valid_objfuncf,
output  result_objfuncf,
output  valid_objgradf,
output  result_objgradf,
output  flagover_objgradf
    );
    reg [DATA_WIDTH-1:0] rams_matrix_in_f [NUM_parallel*NUM_ELEMENTS];
    wire [DATA_WIDTH-1:0]   f_wire;//test
    reg  [DATA_WIDTH-1:0]   id             [NUM_ELEMENTS-1:0];
    reg  [DATA_WIDTH-1:0]   coefficient_funcf_in  [9:0];
    always@(posedge clk)begin
       coefficient_funcf_in[data_addr]<=data_coefficient_f;
       id[data_addr]<=data_coefficient_f;
    end


obj_func#(
) ImpleTest_obj_func
(
.coefficient_funcf(coefficient_funcf_in),// coefficient_funcf[6]=trans;
.rams_idmatrix_in(rams_idmatrix_in),//ram_idmatrix,
.rams_idmatrix_addr_in (rams_idmatrix_addr_in),//expect the last two is ram_impos
.rams_idmatrix_we(rams_idmatrix_we),
.ram_impos_in(ram_impos_in),//ram_idmatrix,
.ram_impos_in_addr(ram_impos_in_addr),
.ram_impos_we(ram_impos_we),
.clk(clk),
.rst(rst),    
.op_objfunc(op_objfunc),
.id_objf_in(id),
.valid_objfuncf(valid_objfuncf),  //assgin to reg
.result_objfuncf(result_objfuncf),//assgin to reg
.valid_objgradf(valid_objgradf),
.result_objgradf(result_objgradf),
.flagover_objgradf(flagover_objgradf)
    );

endmodule
