`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/06 13:53:13
// Design Name: 
// Module Name: function_f_prior
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


module function_subf#(
parameter NUM_ELEMENTS=50,
parameter DATA_WIDTH=32
)(
input                  clk,
input                  rst_subf,
input [DATA_WIDTH-1:0]   id [NUM_ELEMENTS],
input [5:0] ram_idvar_in_addr,
input [DATA_WIDTH-1:0] ram_idvar_in,
input [5:0] ram_idmean_in_addr,
input [DATA_WIDTH-1:0] ram_idmean_in,
input ram_idmeanvar_we,
//ram_idvar[0]=prior_weight
output reg [DATA_WIDTH-1:0]   result_subf//test
    );

// initial begin 
//     $readmemh("C://Users//dell//Desktop//data_id.txt",dis_men_idvar);
//     $readmemh("C://Users//dell//Desktop//data_idmean.txt",dis_men_idmean);
// end

    reg   [DATA_WIDTH-1:0]  sub_out_reg;
    reg   [DATA_WIDTH-1:0]  mul_out_reg      [3];
    reg   [DATA_WIDTH-1:0]  prior_weight_reg;
    reg   [DATA_WIDTH-1:0]  sum_reg;
    wire  [DATA_WIDTH-1:0]  sum;
    wire  [DATA_WIDTH-1:0]  mul_out          [3];
    wire  [DATA_WIDTH-1:0]  sub_out;
    reg  [6:0] num_clk;
    wire [5:0] id_num;
    wire [DATA_WIDTH-1:0] id_sub;
    wire [6:0] ram_idvar_out_addr;
    wire [6:0] ram_idmean_out_addr;
    wire [DATA_WIDTH-1:0]  ram_idvar_out;
    wire [DATA_WIDTH-1:0]  ram_idmean_out;
    assign id_num=num_clk[5:0];
    assign ram_idvar_out_addr=num_clk;              //+6'b110010;
    assign ram_idmean_out_addr=num_clk;
    assign id_sub=id[num_clk];
    localparam num_clk0=6'b000000,num_clk1=6'b000001;
    localparam num_delay=2;


    float_sub sub0 (
    .s_axis_a_tdata(id_sub),              // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tdata(ram_idmean_out),              // input wire [31 : 0] s_axis_b_tdata
    .m_axis_result_tdata(sub_out)    // output wire [31 : 0] m_axis_result_tdata
    );
    always@(posedge clk)begin      
        sub_out_reg<=sub_out; 
    end  
    float_mul mul0 (
    .s_axis_a_tdata(sub_out_reg),              // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tdata(sub_out_reg),              // input wire [31 : 0] s_axis_b_tdata
    .m_axis_result_tdata(mul_out[0])    // output wire [31 : 0] m_axis_result_tdata
    );
    
    
    
    reg [DATA_WIDTH-1:0]  ram_idvar_outdelay;
    always@(posedge clk)begin
        ram_idvar_outdelay<=ram_idvar_out;
    end
    float_mul mul1 (
    .s_axis_a_tdata(prior_weight_reg),              // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tdata(ram_idvar_outdelay),              // input wire [31 : 0] s_axis_b_tdata
    .m_axis_result_tdata(mul_out[1])    // output wire [31 : 0] m_axis_result_tdata
    );
//  assign   mul_out[1] = ram_idvar_out;
    
    
    always@(posedge clk)begin
        mul_out_reg[0]<=mul_out[0];
        mul_out_reg[1]<=mul_out[1];
    end
    float_mul mul2 (
    .s_axis_a_tdata(mul_out_reg[0]),              // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tdata(mul_out_reg[1]),              // input wire [31 : 0] s_axis_b_tdata
    .m_axis_result_tdata(mul_out[2])    // output wire [31 : 0] m_axis_result_tdata
    );
     always@(posedge clk)begin
        mul_out_reg[2]<=mul_out[2];
    end
    float_add add0 (
    .s_axis_a_tdata(mul_out_reg[2]),              // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tdata(sum_reg),              // input wire [31 : 0] s_axis_b_tdata
    .m_axis_result_tdata(sum)    // output wire [31 : 0] m_axis_result_tdata
    );
    dist_mem_64_32 dis_men_idvar (
      .a(ram_idvar_in_addr),        // input wire [6 : 0] a
      .d(ram_idvar_in),        // input wire [31 : 0] d
      .dpra(ram_idvar_out_addr),  // input wire [6 : 0] dpra
      .clk(clk),    // input wire clk
      .we(ram_idmeanvar_we),      // input wire we
      .dpo(ram_idvar_out)    // output wire [31 : 0] dpo
    );
    dist_mem_64_32 dis_men_idmean (
      .a(ram_idmean_in_addr),        // input wire [6 : 0] a
      .d(ram_idmean_in),        // input wire [31 : 0] d
      .dpra(ram_idmean_out_addr),  // input wire [6 : 0] dpra
      .clk(clk),    // input wire clk
      .we(ram_idmeanvar_we),      // input wire we
      .dpo(ram_idmean_out)    // output wire [31 : 0] dpo
    );


    always@(posedge clk)begin
        if(rst_subf==1'b0)begin
            num_clk<=num_clk0;
        end
        else begin
            if(num_clk!=NUM_ELEMENTS+num_delay+1)begin
            num_clk<=num_clk+1;
            end
        end

        case(num_clk)
        num_clk0:begin
//            prior_weight_reg<=ram_idvar_out;
           prior_weight_reg<=64'h3FF0000000000000;
  
        end
        NUM_ELEMENTS+num_delay:begin
            result_subf<=sum;
        end
        endcase
        if(num_clk==num_delay)begin
              sum_reg<=64'h0000000000000000;//rst_priorf and ena control sum_reg 
        end
        else begin
            sum_reg<=sum;//rst_priorf and ena control sum_reg 
        end
    end

endmodule
