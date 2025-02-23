`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/28 15:23:51
// Design Name: 
// Module Name: ImpleTest_function_f
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ImpleTest_function_f#(
parameter NUM_ELEMENTS=50,
parameter DATA_WIDTH=32,
parameter DATA_WIDTH_fix=64,
parameter NUM_parallel=3
)(
input                    clk,
input                    rst,
input      [7:0]         data_addr,
input      [DATA_WIDTH-1:0] data_id,
input      [DATA_WIDTH-1:0] data_rams_in,
input      [6:0]         data_rams_in_addr,
input      [6:0]         data_rams_out_addr,
input                    data_rams_we,
input      [DATA_WIDTH-1:0] data_ram_impos_in      [2],//ram_idmatrix,
input      [6:0]         data_ram_impos_in_addr [2],//expect the last two is ram_impos
input                    data_ram_impos_we      [2],
input      [DATA_WIDTH-1:0] data_coefficient_f,// coefficient_f[6]=trans;
output reg [DATA_WIDTH-1:0] result,
output                  valid_funcf
    );
    reg [DATA_WIDTH-1:0] rams_matrix_in_f [NUM_parallel*NUM_ELEMENTS];
    wire [DATA_WIDTH-1:0]   f_wire;//test
    reg  [DATA_WIDTH-1:0]   id             [NUM_ELEMENTS-1:0];
    reg  [DATA_WIDTH-1:0]   coefficient_f  [9:0];
    always@(posedge clk)begin
       result<=f_wire;
       id[data_addr]<=data_id;
       coefficient_f[data_addr]<=data_coefficient_f;
       rams_matrix_in_f[data_addr]<=data_rams_in;
    end

      
//function_f#(
//) function_f1(
//.clk(clk),//input                  clk,
//.rst(rst),

//.id(id),//input  [DATA_WIDTH-1:0]   id             [NUM_ELEMENTS-1:0],
//.coefficient_funcf(coefficient_f),
//.rams_idmatrix_in(rams_matrix_in_f),//input  [DATA_WIDTH-1:0]   rams_in        [NUM_parallel*NUM_ELEMENTS],
//.rams_idmatrix_addr_in(data_rams_in_addr),//input  [6:0]           rams_in_addr   [NUM_parallel*NUM_ELEMENTS],
//.rams_idmatrix_we(data_rams_we),//input                  rams_we        [NUM_parallel*NUM_ELEMENTS]
//.ram_impos_in(data_ram_impos_in),//input      [DATA_WIDTH-1:0] ram_impos_in      [2],//ram_idmatrix,
//.ram_impos_in_addr(data_ram_impos_in_addr),//input      [6:0]         ram_impos_in_addr [2],//expect the last two is ram_impos
//.ram_impos_we(data_ram_impos_we),//input                    ram_impos_we      [2],
//.result_funcf(f_wire),//output [DATA_WIDTH-1:0]   f              [NUM_parallel],//test
//.valid_funcf(valid_funcf)
//    );
     
    
    
endmodule