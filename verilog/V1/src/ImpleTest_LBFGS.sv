`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/11 16:05:49
// Design Name: 
// Module Name: tb_LBFGS
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


module ImpleTest_LBFGS #(
parameter NUM_ELEMENTS         = 50,
parameter NUM_ELEMENTS_matrix  = 68,
parameter DATA_WIDTH           = 64,
parameter NUM_DIV              = 6 ,
parameter NUM_parallel         = 3 ,
parameter DATA_DEPTH           = 10
)(
input   rst_LBFGS,
input   clk,
input   [DATA_WIDTH-1:0]  data_in [2:0],
input   [9:0]  data_in_addr1,
input   [9:0]  data_in_addr2,
input   [9:0]  data_in_addr3,
// input  [DATA_WIDTH-1:0]   rams_idmatrix_in [4:0],//ram_idmatrix,
input  [6:0]             rams_idmatrix_addr_in ,//expect the last two is ram_impos
input                     rams_idmatrix_we,
input  [DATA_WIDTH-1:0]   ram_impos_in0,//ram_idmatrix,
input  [DATA_WIDTH-1:0]   ram_impos_in1,
input  [7:0]              ram_impos_in_addr,
input                     ram_impos_we,

output  valid_LBFGS,
output  [DATA_WIDTH-1:0] data_out
    );

    // LBFGS Parameters


// LBFGS Inputs

(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  id_datain_reg                [NUM_ELEMENTS-1:0];
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  coefficient_funcf_reg        [7:0];
(* DONT_TOUCH= "TRUE" *)reg   [31:0]  rams_idmatrix_in_reg         [NUM_parallel*NUM_ELEMENTS];

// LBFGS Outputs

(* DONT_TOUCH= "TRUE" *)wire  [DATA_WIDTH-1:0]  result_LBFGS  [NUM_ELEMENTS-1:0];
(* DONT_TOUCH= "TRUE" *)logic  [DATA_WIDTH-1:0]  data_out0  [11];
(* DONT_TOUCH= "TRUE" *)logic  [DATA_WIDTH-1:0]  data_out1  [2];




genvar i;
generate

    always@(posedge clk)begin
        id_datain_reg[data_in_addr1]<=data_in[0];
        coefficient_funcf_reg[data_in_addr1]<=data_in[1];
        rams_idmatrix_in_reg[data_in_addr1]<=  data_in[2][31:0];
     end
 for(i=0; i<10; i=i+1) begin
    always@(posedge clk)begin
       data_out0[i]<=result_LBFGS[5*i]^result_LBFGS[5*i+1]^result_LBFGS[5*i+2]^result_LBFGS[5*i+3]^result_LBFGS[5*i+4];
    end
 end
 for(i=0; i<2; i=i+1) begin
    always@(posedge clk)begin
       data_out1[i]<=data_out0[5*i]^data_out0[5*i+1]^data_out0[5*i+2]^data_out0[5*i+3]^data_out0[5*i+4];
    end
 end
endgenerate 
 always@(posedge clk)begin
       data_out0[10]<=result_LBFGS[50]^result_LBFGS[51];
      
    end
assign  data_out=data_out1[1]^data_out1[0]^data_out0[10];
LBFGS_v1 #(
    .NUM_ELEMENTS        ( NUM_ELEMENTS ),  
    .NUM_ELEMENTS_matrix ( DATA_WIDTH ),
    .DATA_WIDTH          ( 64 ),
    .NUM_DIV             ( 6  ),
    .NUM_parallel        ( 3  ),
    .DATA_DEPTH          ( 10 ))
 u_LBFGS (
    .rst_LBFGS                        ( rst_LBFGS           ),
    .clk                              ( clk                 ),
    .id_datain                        ( id_datain_reg           ),
    .coefficient_funcf                ( coefficient_funcf_reg   ),
    .rams_idmatrix_in                 ( rams_idmatrix_in_reg    ),
    .rams_idmatrix_addr_in            ( rams_idmatrix_addr_in  ),
    .rams_idmatrix_we                 ( rams_idmatrix_we       ),
    .ram_impos_in0                     ( ram_impos_in0           ),
    .ram_impos_in1                     ( ram_impos_in1           ),
    .ram_impos_in_addr                ( ram_impos_in_addr      ),
    .ram_impos_we                     ( ram_impos_we           ),

    .valid_LBFGS                      ( valid_LBFGS            ),
    .result_LBFGS                     ( result_LBFGS           )
);
endmodule
