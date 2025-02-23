`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 14:59:35
// Design Name: 
// Module Name: ImpleTest_LS_Compare
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


module ImpleTest_LS_Compare#(
parameter DATA_WIDTH=32
)(
input aclk,
input [DATA_WIDTH-1:0]alphaiT,
input [DATA_WIDTH-1:0]rho_phidif0T,
input [DATA_WIDTH-1:0] phi0T,
input [DATA_WIDTH-1:0] phi_alphaiT,
//output reg [DATA_WIDTH-1:0] phi_alphai_sub_phi0T,
//output reg [DATA_WIDTH-1:0] rho_phidif0_alphaiT,
output reg result_compareT
    );
    
logic [DATA_WIDTH-1:0] alphai;
logic [DATA_WIDTH-1:0] rho_phidif0;
logic [DATA_WIDTH-1:0] phi0;
logic [DATA_WIDTH-1:0] phi_alphai;
//logic [DATA_WIDTH-1:0] phi_alphai_sub_phi0;
//logic [DATA_WIDTH-1:0] rho_phidif0_alphai;

always@(posedge aclk)   begin
alphai<=alphaiT;
rho_phidif0<=rho_phidif0T;
phi0<=phi0T;
phi_alphai<=phi_alphaiT;
result_compareT<=result_compare;
//phi_alphai_sub_phi0T<=phi_alphai_sub_phi0;
//rho_phidif0_alphaiT<=rho_phidif0_alphai;
end

  LS_Compare LS_Compare_test1(
.aclk(aclk),
.alphai(alphai),
.rho_phidif0(rho_phidif0),
.phi0(phi0),
.phi_alphai(phi_alphai),
//.phi_alphai_sub_phi0(phi_alphai_sub_phi0),
//.rho_phidif0_alphai(rho_phidif0_alphai),
.result_compare(result_compare)
    );
endmodule
