`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/19 13:02:26
// Design Name: 
// Module Name: AdderTree_FloatToFixed
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


module AdderTree_FloatToFixed#(
parameter NUM_ELEMENTS=50,
parameter DATA_WIDTH_float=32,
parameter DATA_WIDTH_fix=64
)(
input [DATA_WIDTH_float-1:0]AdderTree_in [NUM_ELEMENTS],
input clk,
output [DATA_WIDTH_float-1:0] AdderTree_out
    );
//logic [DATA_WIDTH_float-1:0]AdderTree_in [NUM_ELEMENTS];
//logic clk;
//logic  [DATA_WIDTH_float-1:0] AdderTree_out;
//initial begin 
// forever #5 clk=~clk;
//end  
//initial begin 
//    clk=1'b0;
//    for(integer j=0;j<NUM_ELEMENTS;j=j+1)begin
//         AdderTree_in[j]=32'h3F800000;
//    end
//    #200
//     for(integer j=0;j<NUM_ELEMENTS;j=j+1)begin
//         AdderTree_in[j]=32'h40400000;
//    end
//end    
    
    logic [DATA_WIDTH_fix-1:0] Fix_AdderTree_in [NUM_ELEMENTS];
    logic [DATA_WIDTH_fix-1:0] Fix_AdderTree_out;
    
//    logic [DATA_WIDTH_fix-1:0] reg_Fix_AdderTree_in [NUM_ELEMENTS];
//    logic [DATA_WIDTH_fix-1:0] reg_Fix_AdderTree_out;
//    always@(posedge clk)begin
//        reg_Fix_AdderTree_in<=Fix_AdderTree_in;
//        Fix_AdderTree_out<=reg_Fix_AdderTree_out;
//    end
    
    genvar  i;
    generate
        for(i=0; i<NUM_ELEMENTS; i=i+1) begin
            float_to_fixed float_to_fix1 (
             // .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
            .s_axis_a_tdata(AdderTree_in[i]),              // input wire [31 : 0] s_axis_a_tdata
             // .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
            .m_axis_result_tdata(Fix_AdderTree_in[i])    // output wire [63 : 0] m_axis_result_tdata
            );
        end
   endgenerate 

   fix_to_float fix_to_float1 (
    //  .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
     .s_axis_a_tdata(Fix_AdderTree_out),              // input wire [63 : 0] s_axis_a_tdata
    // .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
     .m_axis_result_tdata(AdderTree_out)    // output wire [31 : 0] m_axis_result_tdata
   );

     AdderTree3to2 #(
     .NUM_ELEMENTS(NUM_ELEMENTS),
     .DATA_WIDTH(DATA_WIDTH_fix)
     ) AdderTree3to2_1 (
     .addertree_in(Fix_AdderTree_in),
     .addertree_out(Fix_AdderTree_out),
     .clk(clk)
     );
endmodule
