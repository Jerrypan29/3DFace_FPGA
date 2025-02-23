`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/21 20:01:20
// Design Name: 
// Module Name: obj_func
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


module obj_func#(
parameter NUM_ELEMENTS=50,
parameter NUM_ELEMENTS_matrix=68,
parameter DATA_WIDTH=32,
parameter NUM_DIV=6,
parameter NUM_parallel=3,
//parameter [DATA_WIDTH-1:0] rel_step=32'hBBA1451F /////////test/////////


parameter [DATA_WIDTH-1:0] rel_step=64'h3F3428A3C0000000,//3F3428A3C0000000,//1e-5//36CB2FF5,//b9a1451e,
parameter [DATA_WIDTH-1:0] double_rel_step=64'h3F4428A3C0000000//3F4428A3C0000000//374B2FF5//3A21451E

    )(
input  [DATA_WIDTH-1:0]   coefficient_funcf     [8],// coefficient_funcf[6]=trans;
input  [31:0]   rams_idmatrix_in         [NUM_parallel*NUM_ELEMENTS],//ram_idmatrix,
input  [6:0]              rams_idmatrix_addr_in ,//expect the last two is ram_impos
input                     rams_idmatrix_we,
input  [DATA_WIDTH-1:0]   ram_impos_in0,//ram_idmatrix,
input  [DATA_WIDTH-1:0]   ram_impos_in1,//ram_idmatrix,
input  [6:0]              ram_impos_in_addr,
input                     ram_impos_we,
input [5:0] ram_idvar_in_addr,
input [DATA_WIDTH-1:0] ram_idvar_in,
input [5:0] ram_idmean_in_addr,
input [DATA_WIDTH-1:0] ram_idmean_in,
input ram_idmeanvar_we,

input  [DATA_WIDTH-1:0]   id_objf_in                [NUM_ELEMENTS],
input                     clk,
(* max_fanout = "200" *)input                     rst,    
input                     op_objfunc,

output                    valid_objfuncf,  //assgin to reg
output [DATA_WIDTH-1:0]   result_objfuncf,//assgin to reg
output reg                valid_objgradf,
output reg[DATA_WIDTH-1:0]result_objgradf,
output reg                flagover_objgradf
    );

reg [DATA_WIDTH-1:0]   id_objfunc_reg     [NUM_ELEMENTS];
reg [DATA_WIDTH-1:0]   id_funcf_in        [NUM_ELEMENTS];
reg [DATA_WIDTH-1:0]   id_register        [NUM_ELEMENTS];
reg [6:0]              num_funcf;
wire  [5:0]            num_grad;
reg   [3:0] num_clk0;
localparam             num_0=7'b0000000,num_end=7'b1111111;
reg [DATA_WIDTH-1:0]   obj_step;
(* max_fanout = "200" *)reg                    rst_objf=1'b1;  //��fun
wire [DATA_WIDTH-1:0]  mul0_ina;
wire [DATA_WIDTH-1:0]  mul0_out;
wire [DATA_WIDTH-1:0]  add0_out;
wire [DATA_WIDTH-1:0]  sub0_out;
wire [DATA_WIDTH-1:0]  sub1_out;
wire  [7:0]            add0_op_objfunc;
wire                   valid_funcf;
wire [DATA_WIDTH-1:0]  result_funcf;
reg  [DATA_WIDTH-1:0]  tmp_result_funcf0;
reg  [DATA_WIDTH-1:0]  tmp_result_funcf1;
reg  [DATA_WIDTH-1:0]  tmp_idsub0;
reg  [DATA_WIDTH-1:0]  tmp_idsub1;
reg  [DATA_WIDTH-1:0]  divide0_ina;
reg  [DATA_WIDTH-1:0]  divide0_inb;
assign                 num_grad[5:0]=num_funcf[6:1];
assign                 result_objfuncf=result_funcf;
assign                 valid_objfuncf=valid_funcf&(!op_objfunc);



genvar i;
generate for(i=0;i<=NUM_ELEMENTS;i++)begin 
always@(posedge clk)begin
    if(!rst)begin
        id_funcf_in[i]<=id_objf_in[i];   //rstΪ0��ԭʼid����fun
    end
    else begin
        if(num_clk0==4'b0001)begin
            if(num_grad==i)begin//test
                id_funcf_in[i]<=add0_out;
            end
            else begin
                id_funcf_in[i]<=id_objfunc_reg[i];
            end
        end
    end
end
end
endgenerate
always@(posedge clk)begin//control num_funcf 
    if(!op_objfunc)begin//op_objfunc=0 func_f; op_objfunc=1 grad 
        rst_objf<=rst;
    end
    else begin
        if(!rst)begin
            num_funcf<=num_0;
            id_objfunc_reg<=id_objf_in;
            id_register<=id_objf_in;
            num_clk0<=4'b0000;
            flagover_objgradf<=1'b0;             
        end
        else begin
            if(num_grad!=NUM_ELEMENTS+1)begin
                if((num_clk0==4'b0010+NUM_DIV+1)&&(num_funcf==2*NUM_ELEMENTS+1))begin    //1.14�޸� 51��valid���50��
                    flagover_objgradf<=1'b1;
                end
                else begin
                    flagover_objgradf<=1'b0;
                end
                if(valid_funcf==1'b1)begin
                    num_funcf<=num_funcf+1;
                    num_clk0<=4'b0000;
                    if(num_funcf[0]==1)begin
                        id_register[0:NUM_ELEMENTS-2]<=({id_register[1:NUM_ELEMENTS-1]});
                        tmp_result_funcf1<=result_funcf;
                    end
                    else begin
                        tmp_result_funcf0<=result_funcf;
                    end
                end
                else if(num_clk0!=4'b1111)begin
                    num_clk0<=num_clk0+1;
                end
                case(num_clk0)
                    4'b0000:begin
                        obj_step<=mul0_out;
                    end
                    4'b0001:begin
                        rst_objf<=1'b0;
                         if(num_funcf[0]==1)begin
                            tmp_idsub1<=add0_out;
                         end
                         else begin
                            tmp_idsub0<=add0_out;
                         end
                    end
                    4'b0010:begin
                        rst_objf<=1'b1;
                        if(num_funcf[0]==1)begin
//                            divide0_ina<=sub0_out;
                            divide0_inb<=sub1_out;
                        end
                        if(num_funcf[0]==0)begin
                            divide0_ina<=sub0_out;
                        
                        end
                    end
                    4'b0010+NUM_DIV:begin
                        if(num_funcf[0]==1)begin
                            valid_objgradf<=1'b1&(op_objfunc)&(!flagover_objgradf)&(num_funcf!=7'b0000001);  //1.14�޸� ��������ȥ����һ��valid
                        end
                    end
                    4'b0010+NUM_DIV+1:begin
                            valid_objgradf<=1'b0;
                    end
                endcase
            end
        end
    end
end

assign add0_op_objfunc={7'b0000000,num_funcf[0]};//id_register[0][31]^
//assign mul0_ina=id_register[0][30]?32'h3f800000:id_register[0];//test
float_add_or_sub add0 (
  .s_axis_a_tdata(id_register[0]),                    // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tdata(rel_step),                    // input wire [31 : 0] s_axis_b_tdata
  .s_axis_operation_tdata(add0_op_objfunc),    // input wire [7 : 0] s_axis_operation_tdata
  .m_axis_result_tdata(add0_out)          // output wire [31 : 0] m_axis_result_tdata
);
//float_mul mul0 (
//  .s_axis_a_tdata(mul0_ina),              // input wire [31 : 0] s_axis_a_tdata
//  .s_axis_b_tdata(rel_step),              // input wire [31 : 0] s_axis_b_tdata
//  .m_axis_result_tdata(mul0_out)    // output wire [31 : 0] m_axis_result_tdata
//);
float_sub sub0 (
  .s_axis_a_tdata(tmp_result_funcf0),                    // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tdata(tmp_result_funcf1),                    // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tdata(sub0_out)          // output wire [31 : 0] m_axis_result_tdata
);
float_sub sub1 (////////test////////
  .s_axis_a_tdata(tmp_idsub1),                    // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tdata(tmp_idsub0),                    // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tdata(sub1_out)          // output wire [31 : 0] m_axis_result_tdata
);


//reg [31:0]divide0_inareg;


float_divide divide0 (////////test////////
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tdata(divide0_ina),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tdata(double_rel_step),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tdata(result_objgradf)    // output wire [31 : 0] m_axis_result_tdata
);


functionf #(
    .NUM_ELEMENTS        ( NUM_ELEMENTS ),
    .NUM_ELEMENTS_matrix (NUM_ELEMENTS_matrix),
    .DATA_WIDTH          ( DATA_WIDTH),
    .NUM_parallel        (NUM_parallel)
)
 u_function_f (
    .clk                     ( clk             ),
    .rst                     ( rst_objf        ),
    .id                      ( id_funcf_in     ),
    .coefficient_funcf       ( coefficient_funcf      ),
    .rams_idmatrix_in        ( rams_idmatrix_in       ),
    .rams_idmatrix_addr_in   ( rams_idmatrix_addr_in  ),
    .rams_idmatrix_we        ( rams_idmatrix_we       ),
    .ram_impos_in0           ( ram_impos_in0     ),
    .ram_impos_in1           ( ram_impos_in1     ),
    .ram_impos_in_addr       ( ram_impos_in_addr),
    .ram_impos_we            ( ram_impos_we     ),
    .ram_idvar_in_addr       ( ram_idvar_in_addr    ),
    .ram_idvar_in            ( ram_idvar_in         ),
    .ram_idmean_in_addr      ( ram_idmean_in_addr   ),
    .ram_idmean_in           ( ram_idmean_in        ),
    .ram_idmeanvar_we        ( ram_idmeanvar_we     ),

    .result_funcf            ( result_funcf     ),
    .valid_funcf             ( valid_funcf      )
);


endmodule
