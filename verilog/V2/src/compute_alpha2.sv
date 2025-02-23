`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/21 20:22:17
// Design Name: 
// Module Name: compute_alpha2
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


module compute_alpha2#(
parameter DATA_WIDTH=32,
parameter NUM_ROOT=5,
parameter NUM_DIV=6
) (
input clk,
input rst,
input [DATA_WIDTH-1:0] b,
input [DATA_WIDTH-1:0] a3,
input [DATA_WIDTH-1:0]  phi_dif0,
output logic  [DATA_WIDTH-1:0]alpha2,
output logic flag_alpha2ready
    );
   
//    logic clk;
//    logic rst;
//    logic [DATA_WIDTH-1:0] b;
//    logic [DATA_WIDTH-1:0] a3;
//    logic [DATA_WIDTH-1:0] phi_dif0;
//    logic [DATA_WIDTH-1:0] alpha2;
//    logic flag_alpha2ready;
    
//    always #2 clk=~clk;
//    initial begin 
//    clk=1'b0;
//    rst=1'b0;
//    b=32'h40A00000;//5
//    a3=32'h40400000;//3
//    phi_dif0=32'h40400000;//3  result=-1/3
//    #4
//    rst=1'b1;
//      end
   
   
  logic [DATA_WIDTH-1:0] mul1_ina;
  logic [DATA_WIDTH-1:0] mul1_inb;
  logic [DATA_WIDTH-1:0] mul1_out;
  logic [DATA_WIDTH-1:0] sub1_ina;
  logic [DATA_WIDTH-1:0] sub1_inb;
  logic [DATA_WIDTH-1:0] sub1_out;
  logic [DATA_WIDTH-1:0] sub2_ina;
  logic [DATA_WIDTH-1:0] sub2_inb;
  logic [DATA_WIDTH-1:0] sub2_out;
  logic [DATA_WIDTH-1:0] mul2_ina;
  logic [DATA_WIDTH-1:0] mul2_inb;
  logic [DATA_WIDTH-1:0] mul2_out;
  logic [DATA_WIDTH-1:0] squroot_in;
  logic [DATA_WIDTH-1:0] squroot_out;
  logic [DATA_WIDTH-1:0] rec_in;
  logic [DATA_WIDTH-1:0] rec_out;
  logic [3:0] clk_num;
  logic flag;
//  parameter num_0=4'b0000,num_1=4'b0001,num_2=4'b0010,num_over=4'b1111;
  localparam num_0=4'b0000,num_1=4'b0001,num_2=4'b0010,num_over=4'b1111;
 
     float_squareroot squareroot1 (
   .aclk(clk),
 // .s_axis_a_tvalid(squroot_valid),            // input wire s_axis_a_tvalid
   .s_axis_a_tdata(squroot_in),              // input wire [31 : 0] s_axis_a_tdata
  // .m_axis_result_tvalid(squroot_validm),  // output wire m_axis_result_tvalid
   .m_axis_result_tdata(squroot_out)    // output wire [31 : 0] m_axis_result_tdata
 ); 
 float_mul mul1 (
 // .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(mul1_ina),              // input wire [31 : 0] s_axis_a_tdata
 // .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(mul1_inb),              // input wire [31 : 0] s_axis_b_tdata
 // .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(mul1_out)    // output wire [31 : 0] m_axis_result_tdata
);
float_mul mul2 (
 // .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(mul2_ina),              // input wire [31 : 0] s_axis_a_tdata
 // .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(mul2_inb),              // input wire [31 : 0] s_axis_b_tdata
 // .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(mul2_out)    // output wire [31 : 0] m_axis_result_tdata
);
float_sub sub1 (
//  .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(sub1_ina),              // input wire [31 : 0] s_axis_a_tdata
// .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(sub1_inb),              // input wire [31 : 0] s_axis_b_tdata
//  .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(sub1_out)    // output wire [31 : 0] m_axis_result_tdata
);
float_sub sub2 (
//  .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(sub2_ina),              // input wire [31 : 0] s_axis_a_tdata
// .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(sub2_inb),              // input wire [31 : 0] s_axis_b_tdata
//  .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(sub2_out)    // output wire [31 : 0] m_axis_result_tdata
);
float_reciprocal rec (
  .aclk(clk),                                  // input wire aclk
 // .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(rec_in),              // input wire [31 : 0] s_axis_a_tdata
//  .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(rec_out)    // output wire [31 : 0] m_axis_result_tdata
);

always@(posedge clk)begin
    if(clk_num!=num_over) begin
        clk_num=clk_num+1;
    end
    if(rst==1'b0)begin
        clk_num<=num_0;
        mul1_ina<=b;
        mul1_inb<=b;
        mul2_ina<=a3;
        mul2_inb<=phi_dif0;
        rec_in<=a3;
    end
    else begin
        case(clk_num)
        num_1: begin 
              sub1_ina<=mul1_out;
              sub1_inb<=mul2_out;
        end
       num_2:begin 
              squroot_in<=sub1_out;
        end
       num_2+1+NUM_ROOT: begin 
                   sub2_ina<=squroot_out;
                   sub2_inb<=b;
        end
        num_2+1+NUM_ROOT+1: begin 
                   mul1_ina<=sub2_out;
                   mul1_inb<=rec_out;
        end
        num_2+1+NUM_ROOT+1+1: begin 
                   alpha2<=mul1_out;
                   flag_alpha2ready<=1'b1;
        end
        num_2+1+NUM_ROOT+1+1+1: begin 
                flag_alpha2ready<=1'b0;
        end
        endcase
     end
     
//        if( flag==1'b1)begin
//            clk_num<=clk_num+1;
//        end
//        if(flag_alpha2ready==1'b1) begin 
//             flag<=1'b0;
//             flag_alpha2ready<=1'b0;
//        end

    
//    case(clk_num)
//      4'b1110:begin
//            flag_alpha2ready<=1'b1;
//        end
//    endcase
end
    
endmodule
