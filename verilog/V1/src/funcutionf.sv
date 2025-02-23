`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/02 20:31:02
// Design Name: 
// Module Name: function_f
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

//all use dist mem 

 
module functionf#(
parameter NUM_ELEMENTS=50,
parameter NUM_ELEMENTS_matrix=68,
parameter DATA_WIDTH=32,
//parameter DATA_WIDTH_fix=64, 
parameter DELAY_RAM=5+5,//delay between two ram
parameter DELAY_SUM=12,//delay between rst and sum  
parameter DELAY_ENA=5,//to clean input of mul in f_sub module
parameter NUM_parallel=3,
parameter NUM_CTRL=10//how many wires to connect one reg of addr_out 
)(
input                     clk,
input                     rst,
input  [DATA_WIDTH-1:0]   id              [NUM_ELEMENTS-1:0],

input  [DATA_WIDTH-1:0]   coefficient_funcf     [8],// coefficient_funcf[6]=trans;
input  [31:0]   rams_idmatrix_in         [NUM_parallel*NUM_ELEMENTS],//ram_idmatrix,
input  [6:0]              rams_idmatrix_addr_in ,//expect the last two is ram_impos
input                     rams_idmatrix_we,

input  [DATA_WIDTH-1:0]   ram_impos_in0,//ram_idmatrix,
input  [DATA_WIDTH-1:0]   ram_impos_in1,//ram_idmatrix,
input  [6:0]              ram_impos_in_addr,
input                     ram_impos_we,

//�����򻯵�
input [5:0] ram_idvar_in_addr,
input [DATA_WIDTH-1:0] ram_idvar_in,
input [5:0] ram_idmean_in_addr,
input [DATA_WIDTH-1:0] ram_idmean_in,
input ram_idmeanvar_we,

output reg [DATA_WIDTH-1:0]  result_funcf,//test
output reg                   valid_funcf
    );

//connect muls and rams

    wire    [6:0]               rams_out_addr        [NUM_parallel*NUM_ELEMENTS];
    reg     [6:0]               rams_out_addr_reg    [NUM_parallel*NUM_ELEMENTS/NUM_CTRL];
    reg     [31:0]    rams_idmatrix_in_reg [NUM_parallel*NUM_ELEMENTS];//ram_idmatrix,
    reg     [DATA_WIDTH-1:0]    muls_out_reg         [NUM_parallel*NUM_ELEMENTS];
    reg     [DATA_WIDTH-1:0]    addertree_out_reg    [NUM_parallel];  
    wire    [DATA_WIDTH-1:0]    addertree_in         [NUM_parallel][NUM_ELEMENTS];              
    wire    [DATA_WIDTH-1:0]    addertree_out        [NUM_parallel];
    wire    [DATA_WIDTH-1:0]    muls_out             [NUM_parallel*NUM_ELEMENTS];
    wire    [DATA_WIDTH-1:0]    muls_ina             [NUM_parallel*NUM_ELEMENTS];
    wire    [DATA_WIDTH-1:0]    muls_inb             [NUM_parallel*NUM_ELEMENTS];
    wire    [31:0]    rams_out             [NUM_parallel*NUM_ELEMENTS];

   (* max_fanout = "100" *) reg     [6:0]            rams_in_addr_reg     [NUM_parallel*NUM_ELEMENTS/NUM_CTRL];//expect the last two is ram_impos
   (* max_fanout = "100" *) reg                      rams_we_reg          [NUM_parallel*NUM_ELEMENTS/NUM_CTRL]; 
    wire    [6:0]            rams_in_addr         [NUM_parallel*NUM_ELEMENTS];//expect the last two is ram_impos
    wire                     rams_we              [NUM_parallel*NUM_ELEMENTS]; 
    reg                      sum_ena;
    reg   [DATA_WIDTH-1:0]   id_reg               [NUM_ELEMENTS];
    reg   [DATA_WIDTH-1:0]   sum_in_reg           [2];
    wire  [DATA_WIDTH-1:0]   sum_out0;
    reg   [DATA_WIDTH-1:0]   sum_out_tmp_reg;
    wire  [DATA_WIDTH-1:0]   add_sum1_out;
    reg   [DATA_WIDTH-1:0]   result_subf;

   genvar  i;genvar j; genvar k;
   //control of clk_num
   generate 
        for(i=0; i<NUM_parallel*NUM_ELEMENTS/NUM_CTRL; i=i+1) begin//no sign for stop!!!
            for(j=0; j<NUM_CTRL; j=j+1) begin
                assign rams_out_addr[i*NUM_CTRL+j]=rams_out_addr_reg[i];   
                assign rams_we[i*NUM_CTRL+j]=rams_we_reg[i];
                assign rams_in_addr[i*NUM_CTRL+j]=rams_in_addr_reg[i];
            end 
            always@(posedge clk)begin
                rams_we_reg[i]<=rams_idmatrix_we;
                rams_in_addr_reg[i]<=rams_idmatrix_addr_in;
                if(!rst)begin
                    rams_out_addr_reg[i]<=0;
                end
                else begin
                    if((rams_out_addr_reg[0]!=7'b1111111))begin 
                        rams_out_addr_reg[i]<=rams_out_addr_reg[i]+1;
                    end
                end
            end
        end
    endgenerate
    always@(posedge clk)begin
        rams_idmatrix_in_reg<=rams_idmatrix_in;
    end
    always@(posedge clk)begin
         if(!rst)begin
                valid_funcf<=1'b0;
                sum_ena<=1'b0;
                id_reg<=id;
         end
         else begin
                    if(rams_out_addr_reg[0]==NUM_ELEMENTS_matrix+1+DELAY_SUM+1) begin
                        valid_funcf<=1'b1;
                        result_funcf<=add_sum1_out;
                    end 
                    else begin
                        valid_funcf<=1'b0;
                    end
                    if(rams_out_addr_reg[0]==DELAY_SUM) begin
                        sum_ena<=1'b1;
                    end 
                    if(rams_out_addr_reg[0]==NUM_ELEMENTS_matrix+1+DELAY_SUM) begin
                        sum_ena<=1'b0;
                    end 
            end
        end

//prior_f here 
    reg                 rst_subf;
    always@(posedge clk)begin
        case(rams_out_addr_reg[0])
        0:begin
            rst_subf<=1'b1;
        end
        1:begin
            rst_subf<=1'b0;
        end
        2:begin 
            rst_subf<=1'b1;
        end
        endcase
    end
 function_subf #(
    .NUM_ELEMENTS ( NUM_ELEMENTS ),
    .DATA_WIDTH   ( DATA_WIDTH ))
 u_function_subf (
    .clk                     ( clk                  ),
    .rst_subf                ( rst            ),
    .id                      ( id                   ),
    .ram_idvar_in_addr       ( ram_idvar_in_addr    ),
    .ram_idvar_in            ( ram_idvar_in         ),
    .ram_idmean_in_addr      ( ram_idmean_in_addr   ),
    .ram_idmean_in           ( ram_idmean_in        ),
    .ram_idmeanvar_we        ( ram_idmeanvar_we     ),

    .result_subf           ( result_subf        )
);   
        
    
//muls, dist_rams and adder_tree
   generate 
        for(i=0; i<NUM_ELEMENTS*NUM_parallel; i=i+1) begin

            float32_64 float_idmatrix (
                .s_axis_a_tdata(rams_out[i]),
                .m_axis_result_tdata(muls_ina[i])
            );



            //assign muls_ina[i]=rams_out[i]; //150x68��
            assign muls_inb[i]=id_reg[i%NUM_ELEMENTS]; //id��������

          dist_mem_80_32 dis_men_idmatrix (
            .a(rams_in_addr[i]),        // input wire [6 : 0] a
            .d(rams_idmatrix_in_reg[i]),        // input wire [31 : 0] d
            .dpra(rams_out_addr[i]),  // input wire [6 : 0] dpra
            .clk(clk),    // input wire clk
            .we(rams_we[i]),      // input wire we
            .dpo(rams_out[i])    // output wire [31 : 0] dpo
          );
          float_mul muls (
            .s_axis_a_tdata(muls_ina[i]),              // input wire [31 : 0] s_axis_a_tdata
            .s_axis_b_tdata(muls_inb[i]),              // input wire [31 : 0] s_axis_b_tdata
            .m_axis_result_tdata(muls_out[i])    // output wire [31 : 0] m_axis_result_tdata
          );
           always@(posedge clk)begin
                muls_out_reg[i]<=muls_out[i];//����lmpos3d
           end
        end      
      for(i=0;i<NUM_parallel;i=i+1) begin//choose addertree
//        AdderTree_FloatToFixed#(
//        .NUM_ELEMENTS(NUM_ELEMENTS),
//        .DATA_WIDTH_float(DATA_WIDTH), 
//        .DATA_WIDTH_fix(DATA_WIDTH_fix)
//        )AdderTree_FloatToFixed1(
//        //.AdderTree_in(muls_out_reg[((i+1)*NUM_ELEMENTS-1):(i*NUM_ELEMENTS)]),
//        .AdderTree_in(addertree_in[i]),
//        .clk(clk),
//        .AdderTree_out(addertree_out[i])
//            ); 
          adder_tree_multiple_delay#(
          .NUM_ELEMENTS(NUM_ELEMENTS),
          .DATA_WIDTH(DATA_WIDTH)
          ) adder_tree_multiple_delay1(   
          .clk(clk),
          .terms(addertree_in[i]),
          .S(addertree_out[i])//lmpos3d x y z
          );     
        always@(posedge clk)begin
           addertree_out_reg[i]<=addertree_out[i];
        end
        for(j=0;j<NUM_ELEMENTS;j++)begin
           assign addertree_in[i][j]=muls_out_reg[i*NUM_ELEMENTS+j];
        end
      end 
    endgenerate
    
// connect: coefficients and addertree 4 to 1
    wire [DATA_WIDTH-1:0] point_tmp [6];
    reg  [DATA_WIDTH-1:0] point_tmp_reg [6];
    wire [DATA_WIDTH-1:0] add_4to1_out_tmp[4];
    wire [DATA_WIDTH-1:0] improj [2];
    generate 
        for(i=0; i<NUM_parallel; i=i+1) begin
            float_mul muls_coefficient0 (
            .s_axis_a_tdata(coefficient_funcf[i]),              // input wire [31 : 0] s_axis_a_tdata
            .s_axis_b_tdata(addertree_out_reg[i]),   //lmpos3d��3��ϵ��           // input wire [31 : 0] s_axis_b_tdata
            .m_axis_result_tdata(point_tmp[i])    // output wire [31 : 0] m_axis_result_tdata
            );
            float_mul muls_coefficient1 (
            .s_axis_a_tdata(coefficient_funcf[3+i]),              // input wire [31 : 0] s_axis_a_tdata
            .s_axis_b_tdata(addertree_out_reg[i]),              // input wire [31 : 0] s_axis_b_tdata
            .m_axis_result_tdata(point_tmp[i+3])    // output wire [31 : 0] m_axis_result_tdata
            );
            always@(posedge clk)begin
                point_tmp_reg[i]<=point_tmp[i];
                point_tmp_reg[i+3]<=point_tmp[i+3];
            end 
        end
    endgenerate
  
    float_add add_4to1_tree0 (
      .s_axis_a_tdata(point_tmp_reg[0]),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tdata(point_tmp_reg[1]),              // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tdata(add_4to1_out_tmp[0])    // output wire [31 : 0] m_axis_result_tdata
    );
    float_add add_4to1_tree1 (
      .s_axis_a_tdata(point_tmp_reg[2]),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tdata(coefficient_funcf[6]),      //trans1        // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tdata(add_4to1_out_tmp[1])    // output wire [31 : 0] m_axis_result_tdata
    );
    float_add add_4to1_tree2 (
      .s_axis_a_tdata(point_tmp_reg[3]),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tdata(point_tmp_reg[4]),              // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tdata(add_4to1_out_tmp[2])    // output wire [31 : 0] m_axis_result_tdata
    );
    float_add add_4to1_tree3 (
      .s_axis_a_tdata(point_tmp_reg[5]),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tdata(coefficient_funcf[7]),   //trans2           // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tdata(add_4to1_out_tmp[3])    // output wire [31 : 0] m_axis_result_tdata
    );
    //
    reg [DATA_WIDTH-1:0] add_4to1_out_tmp_reg [4];
    always@(posedge clk)begin
        add_4to1_out_tmp_reg<=add_4to1_out_tmp;
    end
    float_add add_4to1_tree4 (
      .s_axis_a_tdata(add_4to1_out_tmp_reg[0]),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tdata(add_4to1_out_tmp_reg[1]),              // input wire [31 : 0]  s_axis_b_tdata
      .m_axis_result_tdata(improj[0])    // output wire [31 : 0] m_axis_result_tdata
    );
    float_add add_4to1_tree5 (
      .s_axis_a_tdata(add_4to1_out_tmp_reg[2]),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tdata(add_4to1_out_tmp_reg[3]),              // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tdata(improj[1])    // output wire [31 : 0] m_axis_result_tdata
    );
    reg [DATA_WIDTH-1:0]  improj_reg              [2];
    always@(posedge clk)begin
        improj_reg[0]<=improj[0];
        improj_reg[1]<=improj[1];
    end 
    reg [6:0]          ram_impos_out_addr_reg;
    wire [DATA_WIDTH-1:0] ram_impos_out           [2];

dist_mem_lmpos ram_impos0 (
  .a(ram_impos_in_addr),        // input wire [6 : 0] a
  .d(ram_impos_in0),        // input wire [31 : 0] d
  .dpra(ram_impos_out_addr_reg),  // input wire [6 : 0] dpra
  .clk(clk),    // input wire clk
  .we(ram_impos_we),      // input wire we
  .dpo(ram_impos_out[0])    // output wire [31 : 0] dpo
);
dist_mem_lmpos ram_impos1 (
  .a(ram_impos_in_addr),        // input wire [6 : 0] a
  .d(ram_impos_in1),        // input wire [31 : 0] d
  .dpra(ram_impos_out_addr_reg),  // input wire [6 : 0] dpra
  .clk(clk),    // input wire clk
  .we(ram_impos_we),      // input wire we
  .dpo(ram_impos_out[1])    // output wire [31 : 0] dpo
);
    
//control of rst:
    always@(posedge clk)begin
        if(rams_out_addr_reg[0]==(DELAY_RAM-1))begin// 
            ram_impos_out_addr_reg<=6'b000000;
        end
        else begin
            ram_impos_out_addr_reg<=ram_impos_out_addr_reg+1;
        end
    end
    wire  [DATA_WIDTH-1:0] sub_out_im     [2];
    reg   [DATA_WIDTH-1:0] sub_out_im_reg [2];
    always@(posedge clk)begin
         sub_out_im_reg[0]<=sub_out_im[0];
         sub_out_im_reg[1]<=sub_out_im[1];
    end
    
    reg [DATA_WIDTH-1:0] ram_impos_out_reg [2];  //�����ӵ�reg
    always@(posedge clk)begin
         ram_impos_out_reg[0]<=ram_impos_out[0];
         ram_impos_out_reg[1]<=ram_impos_out[1];
    end
    
    
    float_sub float_sub_im0 (
    .s_axis_a_tdata(ram_impos_out_reg[0]),      //��һ��reg        // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tdata(improj_reg[0]),              // input wire [31 : 0] s_axis_b_tdata
    .m_axis_result_tdata(sub_out_im[0])    // output wire [31 : 0] m_axis_result_tdata
    );
    float_sub float_sub_im1 (
    .s_axis_a_tdata(ram_impos_out_reg[1]),              // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tdata(improj_reg[1]),              // input wire [31 : 0] s_axis_b_tdata
    .m_axis_result_tdata(sub_out_im[1])    // output wire [31 : 0] m_axis_result_tdata
    );
    wire  [DATA_WIDTH-1:0] mul_im_out        [2];
    reg   [DATA_WIDTH-1:0] mul_im_out_reg    [2];
    float_mul mul_im0 (
         .s_axis_a_tdata(sub_out_im_reg[0]),              // input wire [31 : 0] s_axis_a_tdata
         .s_axis_b_tdata(sub_out_im_reg[0]),              // input wire [31 : 0] s_axis_b_tdata
         .m_axis_result_tdata(mul_im_out[0])    // output wire [31 : 0] m_axis_result_tdata
         );
    float_mul mul_im1 (
         .s_axis_a_tdata(sub_out_im_reg[1]),              // input wire [31 : 0] s_axis_a_tdata
         .s_axis_b_tdata(sub_out_im_reg[1]),              // input wire [31 : 0] s_axis_b_tdata
         .m_axis_result_tdata(mul_im_out[1])    // output wire [31 : 0] m_axis_result_tdata
    );
    always@(posedge clk)begin
         mul_im_out_reg[0]<=mul_im_out[0];
         mul_im_out_reg[1]<=mul_im_out[1];
    end
    wire  [DATA_WIDTH-1:0] add_im_out;
    float_add add_im (
        .s_axis_a_tdata(mul_im_out_reg[0]),              // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tdata(mul_im_out_reg[1]),              // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tdata(add_im_out)    // output wire [31 : 0] m_axis_result_tdata
    );

      always@(posedge clk)begin
        if(sum_ena==1'b1)begin
           sum_in_reg[0]<=add_im_out;
           sum_in_reg[1]<=sum_out0;
        end
        else begin
           sum_in_reg[0]<=64'h0000000000000000;
           sum_in_reg[1]<=64'h0000000000000000;
        end
    end
    float_add add_sum0 (
        .s_axis_a_tdata(sum_in_reg[0]),              // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tdata(sum_in_reg[1]),              // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tdata(sum_out0)    // output wire [31 : 0] m_axis_result_tdata
    );
    always@(posedge clk)begin
        //sum_out_reg<=sum_out;
        if(rams_out_addr_reg[0]==NUM_ELEMENTS_matrix+DELAY_SUM+1) begin
            sum_out_tmp_reg<=sum_out0;
        end 
    end
    float_add add_sum1 (
        .s_axis_a_tdata(sum_out_tmp_reg),        //��׼��      // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tdata(result_subf),    //����          // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tdata(add_sum1_out) //res   // output wire [31 : 0] m_axis_result_tdata
    );
    
endmodule
