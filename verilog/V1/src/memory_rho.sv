`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/08 19:26:52
// Design Name: 
// Module Name: memory_ram
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


module memory_rho#(
parameter DATA_WIDTH = 32,
parameter DATA_DEPTH = 10,
parameter NUM_LOOP=10
)
(
  input logic clk,
  input logic rst,
  input logic rd_en,
  input logic wr_en ,
  input logic loop_next,
  input logic [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout ,
  output logic [$clog2(NUM_LOOP)-1:0] num_loop_current
);
//If the value of 'DATA_WIDTH_RAM' or 'DATA_DEPTH' changes,
// the single port ram ip need to be reset appropriately.
localparam BOTTOM =DATA_DEPTH-1 ;

logic [DATA_WIDTH-1:0] memory[DATA_DEPTH];
//address
logic [$clog2(DATA_DEPTH)-1:0] rd_ptr;
logic [$clog2(DATA_DEPTH)-1:0] wr_ptr;
// record the number of input data 
logic [$clog2(DATA_DEPTH)-1:0] din_cnt;
logic [$clog2(DATA_DEPTH)-1:0] dout_cnt;
logic [$clog2(NUM_LOOP)-1:0] num_loop_current_r;
assign num_loop_current=num_loop_current_r;
always_ff @( posedge clk or negedge rst ) begin 
    if(!rst) begin
        integer i;
        for(i=0;i<DATA_DEPTH;i=i+1) begin
            memory[i]<=0;
        end
        rd_ptr<=0;
        wr_ptr<=0;
        din_cnt<=0;
        dout_cnt<=0;
        num_loop_current_r<=0;
    end
    else if (wr_en) begin
        memory[wr_ptr]<=din;
        if(num_loop_current_r<NUM_LOOP) begin
            num_loop_current_r<=num_loop_current_r+1'b1;
        end
        else begin
            num_loop_current_r<=NUM_LOOP;
        end
        rd_ptr <= wr_ptr;
        if(wr_ptr!=BOTTOM) begin
            wr_ptr<=wr_ptr+1;
        end 
        else begin
            wr_ptr <=0;
        end
        dout_cnt<=0;
        if(din_cnt!=DATA_DEPTH) begin
            din_cnt <= din_cnt+1;
        end 
    end
    else if((!wr_en)&&rd_en&&(!loop_next)) begin
        dout<= memory[rd_ptr];
        if(dout_cnt!=din_cnt-1) begin
            if(rd_ptr!=0) begin
                rd_ptr<=rd_ptr-1;
            end 
            else begin
                rd_ptr<=BOTTOM;
            end
        end
        dout_cnt <= dout_cnt+1;
    end
    else if((!wr_en)&&rd_en&&loop_next) begin
        dout<= memory[rd_ptr];
        if(rd_ptr!=BOTTOM) begin
            rd_ptr<=rd_ptr+1;
        end
        else begin
            rd_ptr <= 0;
        end
    end     
end
endmodule
