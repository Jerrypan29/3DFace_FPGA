`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/04 09:17:36
// Design Name: 
// Module Name: LBFGS_v1
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/15 19:59:55
// Design Name: 
// Module Name: LBFGS
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

//change state_now from [2:0] to [6:0]
//change module function_f to functionf
module LBFGS_v1
#(
parameter NUM_ELEMENTS=50,//
parameter NUM_ELEMENTS_matrix=68,
parameter NUM_IO_ADDR=10,
parameter DATA_WIDTH=64,
parameter NUM_DIV=6,
parameter NUM_parallel=3,
parameter DATA_DEPTH =10

)(
    input                     rst_LBFGS,
    input                     clk,
    input   [DATA_WIDTH-1:0]  id_datain                [NUM_ELEMENTS],
    input   [DATA_WIDTH-1:0]  coefficient_funcf        [8],
    input   [31:0]  rams_idmatrix_in         [204],
    input   [6:0]             rams_idmatrix_addr_in,
    input                     rams_idmatrix_we,
    input  [DATA_WIDTH-1:0]   ram_impos_in0[68],//ram_idmatrix,
    input  [DATA_WIDTH-1:0]   ram_impos_in1[68],//ram_idmatrix,
    input  [7:0]              ram_impos_in_addr,
    input                     ram_impos_we,
    input [6:0] ram_idvar_in_addr,
    input [DATA_WIDTH-1:0] ram_idvar_in,
    input [6:0] ram_idmean_in_addr,
    input [DATA_WIDTH-1:0] ram_idmean_in,
    input ram_idmeanvar_we,
    output  reg               valid_LBFGS ,
    output  reg [DATA_WIDTH-1:0]   result_LBFGS  [NUM_ELEMENTS]
    );

localparam float_1=64'h3FF0000000000000;
localparam neg_float_1=64'hBFF0000000000000;


//localparam [DATA_WIDTH-1:0] rel_step_LGFGS=32'h39A1451E;//2^-23
//localparam [DATA_WIDTH-1:0] double_rel_step_LGFGS=32'h3A21451E;//2^-22
//localparam [DATA_WIDTH-1:0] neg_rel_step_LGFGS=32'hb9a1451e;//2^-23 
//localparam [DATA_WIDTH-1:0] epsilon0=32'h39A1451E;//2^-23 
//localparam [DATA_WIDTH-1:0] epsilon1=32'h39A1451E;//2^-23 


//������һ�µ�epilon 1.13
localparam [DATA_WIDTH-1:0] epsilon0=64'h3EE4F8B588E368F1;
localparam [DATA_WIDTH-1:0] epsilon1=64'h3EE4F8B588E368F1; 

//localparam [DATA_WIDTH-1:0] epsilon0=32'h34000000;//b38D1B717;//2^-23 epsilon0=32'hb4000000;
//localparam [DATA_WIDTH-1:0] epsilon1=32'h34000000; //b38D1B717;//2^-23 epsilon1=32'hb4000000??
localparam state_start=7'b0000001,state_df=7'b0000010,state_SearchDirection=7'b0000100,
state_SearchLength=7'b0001000,state_Judge_f=7'b0010000,state_Next_loop=7'b0100000,state_LoopEnd=7'b1000000;
localparam state_count0=4'b0000,state_count1=4'b0001,state_count2=4'b0010,state_count3=3'b0011,
state_count4=4'b0100,state_count5=4'b0101,state_count6=4'b0110,state_count7=4'b0111,state_count8=4'b1000,
state_count9=4'b1001,state_count10=4'b1010,state_count11=4'b1011,state_count12=4'b1100,state_count13=4'b1101;
localparam state_count_div0=3'b000,state_count_div1=3'b001,state_count_div2=3'b010,state_count_div3=3'b011,
state_count_div4=3'b100,state_count_div5=3'b101,state_count_div6=3'b110,state_count_div7=3'b111;

reg flag_end_df;
//reg flag_end_SearchDirection;
reg flag_end_SearchLength;
reg [1:0] flag_end_Judge_f;
reg flag_end_Next_loop;
reg flag_begin_SearchDirection;
reg flag_begin_SearchLength;
reg flag_begin_Judge_f;
reg flag_begin_Next_loop;
reg flag_begin_Loop;

reg [6:0] state_now;
//reg [6:0] state_now1;
reg [6:0] state_next;
reg [3:0] state_count;
reg [2:0] state_count_div;
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  id_now            [NUM_ELEMENTS];
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  id_next           [NUM_ELEMENTS];
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  id_grad_now       [NUM_ELEMENTS];
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  id_grad_next       [NUM_ELEMENTS];//result of obf_grad, input of SDU
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  result_direction_reg       [NUM_ELEMENTS];//result of SDU��input of SLU
//reg   [DATA_WIDTH-1:0]  alpha_k;//step_length

(* DONT_TOUCH= "TRUE" *)reg [DATA_WIDTH-1:0 ] id_grad_register [NUM_ELEMENTS];
//reg [DATA_WIDTH-1:0 ] phidif0_add0;
//reg [DATA_WIDTH-1:0 ] phidif0_sub1;


// obj_func Inputs
// reg   [DATA_WIDTH-1:0]  coefficient_funcf     [9:0];
// reg   [DATA_WIDTH-1:0]  rams_idmatrix_in         [NUM_parallel*NUM_ELEMENTS];
// reg   [6:0]  rams_idmatrix_addr_in;
// reg   rams_idmatrix_we;
// reg   [DATA_WIDTH-1:0]  ram_impos_in      [2];
// reg   [6:0]  ram_impos_in_addr [2];
// reg   ram_impos_we      [2];
(* DONT_TOUCH= "TRUE" *)reg   rst_obj_func;
(* DONT_TOUCH= "TRUE" *)reg   op_objfunc;
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  id_objf_in                [NUM_ELEMENTS];
// obj_func Outputs
wire  valid_objfuncf;
wire  [DATA_WIDTH-1:0]  result_objfuncf;
wire  valid_objgradf;
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  result_objgradf; 
wire  flagover_objgradf;
obj_func #(
.NUM_ELEMENTS(NUM_ELEMENTS),
.DATA_WIDTH(DATA_WIDTH)
)
 u_obj_func (
    .coefficient_funcf     ( coefficient_funcf     ),
    .rams_idmatrix_in      ( rams_idmatrix_in      ),
    .rams_idmatrix_addr_in ( rams_idmatrix_addr_in ),
    .rams_idmatrix_we      ( rams_idmatrix_we      ),
.ram_impos_in0(ram_impos_in0),
.ram_impos_in1(ram_impos_in1),
    .ram_impos_in_addr     ( ram_impos_in_addr     ),
    .ram_impos_we          ( ram_impos_we          ),
    .ram_idvar_in_addr       ( ram_idvar_in_addr    ),
    .ram_idvar_in            ( ram_idvar_in         ),
    .ram_idmean_in_addr      ( ram_idmean_in_addr   ),
    .ram_idmean_in           ( ram_idmean_in        ),
    .ram_idmeanvar_we        ( ram_idmeanvar_we     ),
    
    .clk                   ( clk                   ),
    .rst                   ( rst_obj_func          ),
    .op_objfunc            ( op_objfunc            ),
    .id_objf_in            ( id_objf_in            ),

    .valid_objfuncf        ( valid_objfuncf        ),
    .result_objfuncf       ( result_objfuncf       ),
    .valid_objgradf        ( valid_objgradf        ),
    .result_objgradf       ( result_objgradf       ),
    .flagover_objgradf     ( flagover_objgradf     )
);
// SearchLength Inputs
(* DONT_TOUCH= "TRUE" *)reg   rst_SearchLength;
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  phi0;
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  phi1;
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  phi_dif0;
(* DONT_TOUCH= "TRUE" *)reg   ready_phi_alphai;
(* DONT_TOUCH= "TRUE" *)reg   [DATA_WIDTH-1:0]  phi_alphai_in;
// SearchLength Outputs
wire  rst_compute_phi;
wire  [DATA_WIDTH-1:0]  result_alpha_to_compute;
wire  [DATA_WIDTH-1:0]  result_alpha_satisfied;
wire  valid_searchlength;
SearchLength #(
.DATA_WIDTH(DATA_WIDTH)
)
 u_SearchLength (
    .clk                                     ( clk                                      ),
    .rst_SearchLength                        ( rst_SearchLength                         ),
    .phi0                                    ( phi0                                     ),
    .phi1                                    ( phi1                                     ),
    .phi_dif0                                ( phi_dif0                                 ),
    .ready_phi_alphai                        ( ready_phi_alphai                         ),
    .phi_alphai_in                           ( phi_alphai_in                            ),

    .rst_compute_phi                         ( rst_compute_phi                          ),
    .result_alpha_to_compute                        (result_alpha_to_compute                         ),
    .result_alpha_satisfied                         (result_alpha_satisfied   ),
    .valid_searchlength                  ( valid_searchlength                   )
);
//searchDirection
logic rst_searchdirection;
logic rst_memory;
logic s_rd_en;
logic y_rd_en;
logic rho_rd_en;
logic wr_en_s;
logic wr_en_y;
logic wr_en_rho;
logic [3:0] num_loop_current;
logic loop_next;
logic valid_SDU_loop_end;
//logic[DATA_WIDTH-1:0] q_in[NUM_ELEMENTS];
logic[DATA_WIDTH-1:0] result_direction[NUM_ELEMENTS];
logic[DATA_WIDTH-1:0] result_new_iteration_point[NUM_ELEMENTS];

logic[DATA_WIDTH-1:0] s_din[NUM_ELEMENTS];
logic[DATA_WIDTH-1:0] y_din[NUM_ELEMENTS];
logic[DATA_WIDTH-1:0] rho_din;

logic[DATA_WIDTH-1:0] vector_ina[NUM_ELEMENTS];
logic[DATA_WIDTH-1:0] vector_inb[NUM_ELEMENTS];
logic[DATA_WIDTH-1:0] scalar_in;
logic[DATA_WIDTH-1:0] result_vec_mul;
logic[DATA_WIDTH-1:0] s_dout[NUM_ELEMENTS];
logic[DATA_WIDTH-1:0] y_dout[NUM_ELEMENTS];
logic[DATA_WIDTH-1:0] rho_dout;
logic [1:0] operation;
logic valid_SDU_vec_mul;
logic valid_SDU_new_iteration_point;
//memory_sy #
memory#
(
.DATA_WIDTH(DATA_WIDTH),
.DATA_DEPTH(DATA_DEPTH),
.NUM_ELEMENTS(NUM_ELEMENTS)
) memory_s_
(
.clk(clk),
.rst(rst_memory),
.rd_en(s_rd_en),
.wr_en(wr_en_s),
.loop_next(loop_next),
.din(s_din),
.dout(s_dout)
);
//memory_sy #
memory#
(
.DATA_WIDTH(DATA_WIDTH),
.DATA_DEPTH(DATA_DEPTH),
.NUM_ELEMENTS(NUM_ELEMENTS)
) memory_y_
(
.clk(clk),
.rst(rst_memory),
.rd_en(y_rd_en),
.wr_en(wr_en_y),
.loop_next(loop_next),
.din(y_din),
.dout(y_dout)
);
memory_rho #
(
.DATA_WIDTH(DATA_WIDTH),
.DATA_DEPTH(DATA_DEPTH)
) memory_rho_
(
.clk(clk),
.rst(rst_memory),
.rd_en(rho_rd_en),
.wr_en(wr_en_rho),
.loop_next(loop_next),
.din(rho_din),
.dout(rho_dout),
.num_loop_current(num_loop_current)
);
SDU#
(
    .DATA_WIDTH(DATA_WIDTH),
    .NUM_ELEMENTS(NUM_ELEMENTS)
) SDU
(
    .clk(clk),
    .rst(rst_searchdirection),
    .operation(operation),
    .vector_ina(vector_ina),
    .vector_inb(vector_inb),
    .scalar_in(scalar_in),
    //.q_in(q_in),
    .q_in(id_grad_now),      //2.25 result_direction_reg  to id_grad_now
    .y(y_dout),
    .s(s_dout),
    .rho(rho_dout),
    .num_loop_current(num_loop_current),
    .direction(result_direction),
    .result_vec_mul(result_vec_mul),
    .result_vec_mul_valid(valid_SDU_vec_mul),
    .new_iteration_point(result_new_iteration_point),
    .result_new_iteration_point_valid(valid_SDU_new_iteration_point),
    .loop_end(valid_SDU_loop_end),
    .loop_next(loop_next),
    .s_rd_en(s_rd_en),
    .y_rd_en(y_rd_en),
    .rho_rd_en(rho_rd_en)
);
//adder and divider 
  logic [DATA_WIDTH-1:0] div1_ina;
  logic [DATA_WIDTH-1:0] div1_inb;
  logic [DATA_WIDTH-1:0] div1_out;

float_divide div1 (
  .aclk(clk),                      
  .s_axis_a_tdata(div1_ina),       
  .s_axis_b_tdata(div1_inb),       
  .m_axis_result_tdata(div1_out)   
);
  logic [DATA_WIDTH-1:0] sub1_ina;
  logic [DATA_WIDTH-1:0] sub1_inb;
  logic [DATA_WIDTH-1:0] sub1_out;
float_sub sub1 (
  .s_axis_a_tdata(sub1_ina),       
  .s_axis_b_tdata(sub1_inb),       
  .m_axis_result_tdata(sub1_out)   
);
  logic [DATA_WIDTH-1:0] nolessthan1_ina;
  logic [DATA_WIDTH-1:0] nolessthan1_inb;
  logic [DATA_WIDTH-1:0] nolessthan1_out;
float_nolessthan nolessthan1 (
  .s_axis_a_tdata(nolessthan1_ina),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tdata(nolessthan1_inb),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tdata(nolessthan1_out)    // output wire [7 : 0] m_axis_result_tdata
);

// start 
always_ff @(posedge clk) begin
  if(!rst_LBFGS)begin
    state_now<=state_start;
  
    //state_now1<=state_start;
  end
  else begin
    state_now<=state_next;
    //state_now1<=state_next;
  end
end

always@(posedge clk) begin   
    case(state_now)
    state_start:begin
      state_next<=state_df;
    end
    state_df:begin  
      if(flag_end_df)begin
        state_next<=state_SearchLength;
        flag_begin_SearchLength<=1'b1;  
      end
    end
    state_SearchDirection:begin 
        flag_begin_SearchDirection<=1'b0;
      if(valid_SDU_loop_end)begin
        state_next<=state_SearchLength;
        flag_begin_SearchLength<=1'b1;
      end
    end
    state_SearchLength:begin 
        flag_begin_SearchLength<=1'b0;
      if(flag_end_SearchLength)begin
        state_next<=state_Judge_f;
        flag_begin_Judge_f<=1'b1;
      end
    end
    state_Judge_f:begin 
      flag_begin_Judge_f<=1'b0;
      if(flag_end_Judge_f[1])begin
        if(flag_end_Judge_f[0])begin
          state_next<=state_Next_loop;
          flag_begin_Next_loop<=1'b1;
        end
        else begin
          state_next<=state_LoopEnd;
        end
      end
    end
    state_Next_loop:begin 
      flag_begin_Next_loop<=1'b0;
      if(flag_end_Next_loop)begin
        state_next<=state_SearchDirection;
        flag_begin_SearchDirection<=1'b1;
      end
    end
  endcase
end     

always@(posedge clk) begin
    if(state_now[0])begin
        id_objf_in<=id_datain;
        id_now<=id_datain;
        rst_obj_func<=1'b0;
        op_objfunc<=1'b0;
        state_count<=state_count0;
        flag_end_df<=1'b0;
        rst_memory<=1'b0;
    end
    if(state_now[1])begin 
      case(state_count)
        state_count0:begin
          rst_obj_func<=1'b1;
          rst_memory<=1'b1;
          state_count<=state_count1;
        end
        state_count1:begin
          if(valid_objfuncf)begin
            phi0<=result_objfuncf;
            op_objfunc<=1'b1;
            rst_obj_func<=1'b0;
            state_count<=state_count2;
          end
        end
        state_count2:begin
          rst_obj_func<=1'b1;
          if(flagover_objgradf) begin
            op_objfunc<=1'b0;     // 4.18
            id_grad_now<=id_grad_register;
            //result_direction_reg<=id_grad_register;
            ///dk=-id_grad   need to add //12.21??
            foreach (result_direction_reg[i]) begin
              result_direction_reg[i] <= {~id_grad_register[i][DATA_WIDTH-1], id_grad_register[i][DATA_WIDTH-2:0]};
            end
            flag_end_df<=1'b1;
          end
          if(valid_objgradf)begin
            id_grad_register[0:NUM_ELEMENTS-2]<=id_grad_register[1:NUM_ELEMENTS-1];
            id_grad_register[NUM_ELEMENTS-1]<=result_objgradf;
          end
        end
      endcase
      
    end
    
    if(state_now[2])begin //to be continue    SDU
      if(flag_begin_SearchDirection)begin
        flag_end_Next_loop<=1'b0;
        wr_en_rho<=1'b0;
        rst_searchdirection<=1'b0;
        operation<=2'b11;
      end
      else begin
        rst_searchdirection<=1'b1;
      end
      if(valid_SDU_loop_end)begin
        //result_direction_reg<=result_direction;

          foreach (result_direction_reg[i]) begin
        result_direction_reg[i] <= {~result_direction[i][DATA_WIDTH-1], result_direction[i][DATA_WIDTH-2:0]};
      end
            /////need to add neg direction ///
            //////
            /////
      end
    end
    if(state_now[3])begin   //??????
    //prepare: first to compute  phi1  phi_dif0 
      if(flag_begin_SearchLength)begin
        //compute x(k+1)=xk+1*dk
        rst_searchdirection<=1'b0;
        operation<=2'b00;
        vector_ina<=id_now;
        vector_inb<=result_direction_reg;
        scalar_in<=float_1;//float_1=32'h3f800000 
        state_count<=state_count0;
      end
      else begin
      case(state_count)
        state_count0:begin
          if(valid_SDU_new_iteration_point)begin
            //compute phi(1)=f(xk+dk)
            id_next<=result_new_iteration_point;   //xk+dk
            id_objf_in<=result_new_iteration_point;//xk+dk
            rst_obj_func<=1'b0;
            op_objfunc<=1'b0;
            state_count<=state_count1; 
            //compute xk+dx*dk
            
          end
          else begin
            rst_searchdirection<=1'b1;
            rst_obj_func<=1'b1;
          end
        end
        state_count1:begin
            if(valid_objfuncf)begin
                phi1<=result_objfuncf;//get phi(1)=f(xk+dk)
                rst_searchdirection<=1'b0;
                operation<=2'b10;
                vector_ina<=id_grad_register;
                vector_inb<=result_direction_reg;
                //scalar_in<=float_1;     
                state_count<=state_count2;              
            end
            else begin
              rst_obj_func<=1'b1;
            end
        end
        state_count2:begin
          if(valid_SDU_vec_mul)begin //get phi_dif_add0=f(xk+dx*dk)
  
              phi_dif0<=result_vec_mul;
              state_count<=state_count3;
              rst_SearchLength<=1'b0;
            end
            else begin
               rst_searchdirection<=1'b1;
            end
              
        end
        state_count3:begin  //searchlength begin
            rst_SearchLength<=1'b1;
            if(valid_searchlength)begin 
              flag_end_SearchLength<=1'b1;//here to stop
              // rst_searchdirection<=1'b0;
              // operation<=2'b00;
              // vector_ina<=id_now;//compute x(k+1)=xk+alpha*dk
              // vector_inb<=result_direction_reg;
              // scalar_in<=result_alpha_satisfied;
              // state_count<=state_count7;    
            end
            if(!rst_compute_phi)begin
                rst_searchdirection<=1'b0;
                operation<=2'b00;
                vector_ina<=id_now;//compute x(k+1)=xk+alpha*dk
                vector_inb<=result_direction_reg;
                scalar_in<=result_alpha_to_compute;     //b793ee48 -0.000017
            end
            else begin
                rst_searchdirection<=1'b1;
            end
            if(valid_SDU_new_iteration_point)begin
                id_objf_in<=result_new_iteration_point;     //xk+akdk
                id_next<=result_new_iteration_point;
                rst_obj_func<=1'b0;
                op_objfunc<=1'b0;
            end
            else begin
              rst_obj_func<=1'b1;
            end
            if(valid_objfuncf)begin
              ready_phi_alphai<=1'b1;
              phi_alphai_in<=result_objfuncf;   //747
            end
            else begin
              ready_phi_alphai<=1'b0;
            end   
        end
        endcase
        end
    end
    if(state_now[4])begin   
      if(flag_begin_Judge_f)begin 
          flag_end_SearchLength<=1'b0;//here to stop
        //compute gk+1
          id_objf_in<=id_next;    //xk+akdk   
          rst_obj_func<=1'b0;
          op_objfunc<=1'b1;    //grad next1
        //judge |fk-fk+1|<=epsilon0
          //12.12???   sub1_ina<=result_alpha_satisfied;
          sub1_ina<=result_objfuncf;
          sub1_inb<=phi0;
          state_count<=state_count0;
      end
      else begin
        case(state_count)
        state_count0:begin
          nolessthan1_ina<=epsilon0;
          nolessthan1_inb<={1'b0,sub1_out[DATA_WIDTH-2:0]};   
          rst_obj_func<=1'b1;
          state_count<=state_count1;
        end
        state_count1:begin
          if(nolessthan1_out[0]==1'b1)begin                //12.29??????????????0??????0
            valid_LBFGS<=1'b1;
            result_LBFGS<=id_next;
            flag_end_Judge_f<=2'b10;
            //flag_end_SearchDirection<=1'b0;
          end
          else if(flagover_objgradf)begin 
            op_objfunc<=1'b0;       //4.18
            id_grad_next<=id_grad_register;   //gk+1
            flag_end_Judge_f<=2'b11;
            //flag_end_SearchDirection<=1'b0;
          end
          if(valid_objgradf)begin
            id_grad_register[0:NUM_ELEMENTS-2]<=id_grad_register[1:NUM_ELEMENTS-1];
            id_grad_register[NUM_ELEMENTS-1]<=result_objgradf;
            nolessthan1_ina<=epsilon1;                 
            nolessthan1_inb<={1'b0,result_objgradf[DATA_WIDTH-2:0]};    //?????? ???????
          end
        end
        endcase
      end
      end
    if(state_now[5])begin 
      if(flag_begin_Next_loop)begin
        flag_end_Judge_f<=2'b00;
        //compute sk=xk+1-xk
        rst_searchdirection<=1'b0;
        operation<=2'b00;
        vector_ina<=id_next;
        vector_inb<=id_now;
        scalar_in<=neg_float_1;  
        state_count<=state_count0;
      end
      else begin
      case(state_count)
      state_count0:begin
        if(valid_SDU_new_iteration_point)begin
          wr_en_s<=1'b1;
          s_din<=result_new_iteration_point;
           //compute yk=gk+1-gk
          rst_searchdirection<=1'b0;
          operation<=2'b00;
          vector_ina<=id_grad_next;
          vector_inb<=id_grad_now;
          scalar_in<=neg_float_1;  
          state_count<=state_count1;
        end
        else begin
          rst_searchdirection<=1'b1;
        end
      end
      state_count1:begin
        wr_en_s<=1'b0;
        if(valid_SDU_new_iteration_point)begin
          wr_en_y<=1'b1;
          y_din<=result_new_iteration_point;
          rst_searchdirection<=1'b0;
          operation<=2'b10;
          vector_ina<=s_din;
          vector_inb<=result_new_iteration_point; 
          state_count<=state_count2;
          
        end
        else begin
          rst_searchdirection<=1'b1;
        end
      end

      state_count2:begin
        wr_en_y<=1'b0;
        rst_searchdirection<=1'b1;
        if(valid_SDU_vec_mul)begin
            div1_ina<=float_1;
            div1_inb<=result_vec_mul;
            state_count<=state_count3;
            state_count_div<=state_count_div0;
            end
        end
        state_count3:begin  
            if(state_count_div==NUM_DIV)begin
              wr_en_rho<=1'b1;
              rho_din<=div1_out; 
              id_now<=id_next;
              id_grad_now<=id_grad_next;
              phi0<=phi_alphai_in;   //4.18
              state_count<=state_count4;
      end  
              state_count_div<=state_count_div+1;
        end
        state_count4:begin
          flag_end_Next_loop<=1'b1;
          wr_en_rho<=1'b0;
        end

      endcase
    end

    
    end
    
  
end       



endmodule

