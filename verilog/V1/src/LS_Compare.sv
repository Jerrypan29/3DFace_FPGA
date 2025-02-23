`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 14:38:16
// Design Name: 
// Module Name: LS_Compare
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


module LS_Compare #(
parameter DATA_WIDTH=32
//parameter CLK_NUM_ADD=5,  
//parameter CLK_NUM_MUL=3
)(
input aclk,
input [DATA_WIDTH-1:0]alphai,
input [DATA_WIDTH-1:0]rho_phidif0,
input [DATA_WIDTH-1:0] phi0,
input [DATA_WIDTH-1:0] phi_alphai,
output [DATA_WIDTH-1:0] phi_alphai_sub_phi0,
output [DATA_WIDTH-1:0] rho_phidif0_alphai,
output  result_compare
    );
    logic [6:0] result_compare6;
    wire [DATA_WIDTH-1:0] mulout_LSCompare;
    wire [DATA_WIDTH-1:0] subout_LSCompare;
    reg [DATA_WIDTH-1:0] reg_mulout_LSCompare;
    reg [DATA_WIDTH-1:0] reg_subout_LSCompare;
    logic valid1,valid2,valid3;
    assign rho_phidif0_alphai=mulout_LSCompare;
    assign phi_alphai_sub_phi0=subout_LSCompare;
    always@(posedge aclk) begin 
         reg_mulout_LSCompare<=mulout_LSCompare;
         reg_subout_LSCompare<=subout_LSCompare;
    end
    
   // logic in_valid1,in_valid2,in_valid3;
float_sub float_sub_in_LSCompare (
 // .aclk(aclk),                                  // input wire aclk
 // .aclken(1'b1),                              // input wire aclken
  .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(phi_alphai),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(phi0),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(valid1),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(subout_LSCompare)    // output wire [31 : 0] m_axis_result_tdata
);
 float_nolessthan float_nolessthan_LSCompare (
 // .aclk(aclk),                                  // input wire aclk
  //.aclken(1'b1),                              // input wire aclken
  .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(reg_mulout_LSCompare),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(reg_subout_LSCompare),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(valid2),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata({result_compare6[6:0],result_compare})    // output wire [7 : 0] m_axis_result_tdata
);
 float_mul float_mul_LSCompare (
  //.aclk(aclk),                                  // input wire aclk
  //.aclken(1'b1),                              // input wire aclken
  .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(rho_phidif0),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(alphai),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(valid3),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(mulout_LSCompare)    // output wire [31 : 0] m_axis_result_tdata
);
     
     
endmodule
