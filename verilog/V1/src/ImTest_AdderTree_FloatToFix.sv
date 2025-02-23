`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/19 14:37:25
// Design Name: 
// Module Name: ImTest_AdderTree_FloatToFix
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


module ImTest_AdderTree_FloatToFix#(
parameter NUM_ELEMENTS=50,
parameter DATA_WIDTH_float=32,
parameter DATA_WIDTH_fix=64
)(
input [DATA_WIDTH_float-1:0] AdderTree_in_test [5],
input clk,
output reg [DATA_WIDTH_float-1:0] AdderTree_out_test
    );
//logic [DATA_WIDTH_float-1:0]AdderTree_in_test [5];
//logic clk;
//logic  [DATA_WIDTH_float-1:0] AdderTree_out_test;
//initial begin 
// forever #5 clk=~clk;
//end  
//initial begin 
//    clk=1'b0;
//    for(integer k=0;k<5;k=k+1)begin
//         AdderTree_in_test[k]=32'h3F800000;
//    end
//    #200
//     for(integer k=0;k<5;k=k+1)begin
//         AdderTree_in_test[k]=32'h40400000;
//    end
//end    
    
    
    logic [DATA_WIDTH_float-1:0]AdderTree_in [NUM_ELEMENTS];
    logic [DATA_WIDTH_fix-1:0] AdderTree_out;
    
  genvar  i;genvar j;
  generate
    for(j=0;j<5;j=j+1) begin
        for(i=0; i<10; i=i+1) begin
           always@(posedge clk) begin
                 AdderTree_in[i+j*10]<=AdderTree_in_test[j];
           end
        end
    end
  endgenerate 
  always@(posedge clk) begin
                 AdderTree_out_test<=AdderTree_out;
           end
           
    AdderTree_FloatToFixed test_addertree_fl_to_fix(
.AdderTree_in(AdderTree_in),
.clk(clk),
.AdderTree_out(AdderTree_out)
    );
endmodule
