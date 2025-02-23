`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/03 15:09:43
// Design Name: 
// Module Name: alpha2_if
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


module alpha2_if#(
parameter DATA_WIDTH=32
)(
input clk,
input [DATA_WIDTH-1:0]alpha2,
input [DATA_WIDTH-1:0]alpha1,
output result_alpha2_if
    );


//logic clk;
//logic [DATA_WIDTH-1:0]alpha2;
//logic [DATA_WIDTH-1:0]alpha1;
//logic result_alpha2_if;
//initial begin 
//   clk=1'b0;
//   forever #5 clk=~clk;
//end
//initial begin 
//   alpha1=32'h3f800000;//1
//   alpha2=32'h40400000;//3
//   #50
//   alpha1=32'hC1200000;//-10
//   alpha2=32'hBF800000;//-1
//      #50
//   alpha1=32'hC1200000;//-10
//   alpha2=32'h40400000;//3
//         #50
//   alpha1=32'h3f800000;//1
//   alpha2=32'hBF800000;//-1
//end


    logic [7:0]result1;
    logic [7:0]result2;
    logic [DATA_WIDTH-1:0]mul1_ina;
    logic [DATA_WIDTH-1:0]mul1_inb;
    logic [DATA_WIDTH-1:0]mul1_out;
    logic [DATA_WIDTH-1:0]mul2_ina;
    logic [DATA_WIDTH-1:0]mul2_inb;
    logic [DATA_WIDTH-1:0]mul2_out;  
    logic [DATA_WIDTH-1:0]compare1_ina;
    logic [DATA_WIDTH-1:0]compare1_inb;
    logic [DATA_WIDTH-1:0]compare2_ina;
    logic [DATA_WIDTH-1:0]compare2_inb; 
    assign mul1_ina=alpha2;
    assign mul2_ina=alpha2;
    assign mul1_inb=64'h3FE0000000000000;//0.5
    assign mul2_inb=64'h3FA47AE147AE147B;//0.04
    always@(posedge clk)begin
         compare1_ina<=alpha1;
         compare1_inb<=mul1_out;
         compare2_ina<=alpha1;
         compare2_inb<=mul2_out;
    end
    
    assign result_alpha2_if=(result1[0])|(!result2[0]);
    
    float_mul mul1 (
 // .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(mul1_ina),              // input wire [31 : 0] s_axis_a_tdata
 // .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(mul1_inb),              // input wire [31 : 0] s_axis_b_tdata
 // .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(mul1_out)    // output wire [31 : 0] m_axis_result_tdata
);float_mul mul2 (
 // .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(mul2_ina),              // input wire [31 : 0] s_axis_a_tdata
 // .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(mul2_inb),              // input wire [31 : 0] s_axis_b_tdata
 // .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(mul2_out)    // output wire [31 : 0] m_axis_result_tdata
);
    float_nolessthan nolessthan_alpha2_if1 (
 // .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(compare1_ina),              // input wire [31 : 0] s_axis_a_tdata
//  .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(compare1_inb),              // input wire [31 : 0] s_axis_b_tdata
//  .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(result1)    // output wire [7 : 0] m_axis_result_tdata
);
       float_nolessthan nolessthan_alpha2_if2(
 // .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(compare2_ina),              // input wire [31 : 0] s_axis_a_tdata
//  .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(compare2_inb),              // input wire [31 : 0] s_axis_b_tdata
//  .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(result2)    // output wire [7 : 0] m_axis_result_tdata
);
    
    
    
    //have bugs:
//    floate_fused_muladd floate_fused_muladd1 (
//  .aclk(clk),                                        // input wire aclk
////  .s_axis_a_tvalid(s_axis_a_tvalid),                  // input wire s_axis_a_tvalid
//  .s_axis_a_tdata(alpha1),                    // input wire [31 : 0] s_axis_a_tdata
// // .s_axis_b_tvalid(s_axis_b_tvalid),                  // input wire s_axis_b_tvalid
//  .s_axis_b_tdata(32'h3F000000),    //0.5                // input wire [31 : 0] s_axis_b_tdata
////  .s_axis_c_tvalid(s_axis_c_tvalid),                  // input wire s_axis_c_tvalid
//  .s_axis_c_tdata(alpha2),                    // input wire [31 : 0] s_axis_c_tdata
// // .s_axis_operation_tvalid(s_axis_operation_tvalid),  // input wire s_axis_operation_tvalid
//  .s_axis_operation_tdata(8'b00000001),    // input wire [7 : 0] s_axis_operation_tdata
// // .m_axis_result_tvalid(m_axis_result_tvalid),        // output wire m_axis_result_tvalid
//  .m_axis_result_tdata(result1)          // output wire [31 : 0] m_axis_result_tdata
//);
//   floate_fused_muladd floate_fused_muladd2 (
//  .aclk(clk),                                        // input wire aclk
////  .s_axis_a_tvalid(s_axis_a_tvalid),                  // input wire s_axis_a_tvalid
//  .s_axis_a_tdata(alpha1),                    // input wire [31 : 0] s_axis_a_tdata
// // .s_axis_b_tvalid(s_axis_b_tvalid),                  // input wire s_axis_b_tvalid
//  .s_axis_b_tdata(32'h3D23D70A),      //0.04              // input wire [31 : 0] s_axis_b_tdata
////  .s_axis_c_tvalid(s_axis_c_tvalid),                  // input wire s_axis_c_tvalid
//  .s_axis_c_tdata(alpha2),                    // input wire [31 : 0] s_axis_c_tdata
// // .s_axis_operation_tvalid(s_axis_operation_tvalid),  // input wire s_axis_operation_tvalid
//  .s_axis_operation_tdata(8'b00000001),    // input wire [7 : 0] s_axis_operation_tdata
// // .m_axis_result_tvalid(m_axis_result_tvalid),        // output wire m_axis_result_tvalid
//  .m_axis_result_tdata(result2)          // output wire [31 : 0] m_axis_result_tdata
//);

    
endmodule
