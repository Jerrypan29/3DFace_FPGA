`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/20 14:40:05
// Design Name: 
// Module Name: memory
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


module memory#(
    parameter DATA_WIDTH=32,
    parameter NUM_ELEMENTS=50,
    parameter DATA_DEPTH=10
)
(
  input logic clk,
  input logic rst,
  input logic rd_en,
  input logic wr_en ,
  input logic loop_next,
  input logic [DATA_WIDTH-1:0] din[NUM_ELEMENTS],
  output logic [DATA_WIDTH-1:0] dout[NUM_ELEMENTS] 
);
localparam BOTTOM =DATA_DEPTH-1 ;
logic [DATA_WIDTH-1:0] memory[DATA_DEPTH][NUM_ELEMENTS];
   (* max_fanout = "50" *)logic [$clog2(DATA_DEPTH)-1:0] rd_ptr=0;
logic [$clog2(DATA_DEPTH)-1:0] wr_ptr=0;
logic [$clog2(DATA_DEPTH)-1:0]din_cnt=0;
logic [$clog2(DATA_DEPTH)-1:0]dout_cnt=0;

always_ff @( posedge clk or negedge rst ) begin 
    if(!rst) begin
        rd_ptr<=0;
        wr_ptr<=0;
        din_cnt<=0;
        dout_cnt<=0;
    end
    else if (wr_en&&(!rd_en)) begin
        memory[wr_ptr]=din;
        rd_ptr = wr_ptr;
        if(wr_ptr!=BOTTOM) begin
            wr_ptr=wr_ptr+1;
        end 
        else begin
            wr_ptr =0;
        end
        if(din_cnt!=DATA_DEPTH) begin
            din_cnt = din_cnt+1;
        end
        dout_cnt=0;
    end
    else if((!wr_en)&&rd_en&&(!loop_next)) begin
        dout = memory[rd_ptr];
        if(dout_cnt!=din_cnt-1) begin
            if(rd_ptr!=0) begin
                rd_ptr=rd_ptr-1;
            end 
            else begin
                rd_ptr=BOTTOM;
            end
        end
        dout_cnt = dout_cnt+1;
    end
    else if((!wr_en)&&rd_en&&loop_next) begin
        dout = memory[rd_ptr];
        if(rd_ptr!=BOTTOM) begin
            rd_ptr=rd_ptr+1;
        end
        else begin
            rd_ptr = 0;
        end
    end
       
end
endmodule

