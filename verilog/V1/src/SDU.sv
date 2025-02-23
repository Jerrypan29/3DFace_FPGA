`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/15 16:58:06
// Design Name: 
// Module Name: SearchDirection
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


module SDU #(
parameter DATA_WIDTH=32,
parameter NUM_ELEMENTS=50,
parameter NUM_LOOP=10
)
(
input logic clk,
input logic rst,
input logic [1:0]operation, //x1:searchdirection  , 00: xk+alpha*dk, 10: vector multiplication
input logic [DATA_WIDTH-1:0] vector_ina[NUM_ELEMENTS],  //xk             gk
input logic [DATA_WIDTH-1:0] vector_inb[NUM_ELEMENTS],  //dk             dk
input logic [DATA_WIDTH-1:0] scalar_in,                 //alpha 

input logic[DATA_WIDTH-1:0] q_in[NUM_ELEMENTS],
input logic[DATA_WIDTH-1:0] y[NUM_ELEMENTS],
input logic[DATA_WIDTH-1:0] s[NUM_ELEMENTS],
input logic[DATA_WIDTH-1:0] rho,
input logic[$clog2(NUM_LOOP)-1:0] num_loop_current,
output logic[DATA_WIDTH-1:0] new_iteration_point[NUM_ELEMENTS],
output logic[DATA_WIDTH-1:0] direction[NUM_ELEMENTS],
output logic[DATA_WIDTH-1:0] result_vec_mul,          //result of vector multiplication
output logic result_vec_mul_valid,
output logic result_new_iteration_point_valid,
output logic loop_end,
output logic loop_next,
output logic s_rd_en,
output logic y_rd_en,
output logic rho_rd_en
);
localparam NUM_TWO_LOOP =2*NUM_LOOP ;
logic loop_control_0 ;                  //Scalar multiplication: 0  Vector multiplication: 1
logic loop_control_1 ;                  //First loop: 0  Second loop:1
logic loop_end_r;                        //Loop end flag  one clk
logic loop_end_flag;                     //Loop end flag 
logic [$clog2(NUM_TWO_LOOP)-1:0]loop_cnt;  //record the number of iteration
logic [3:0]loop_cnt_control ;              //control the signals "loop_control_0""loop_control_1" 
logic loop_next_r;

logic[DATA_WIDTH-1:0] q_r[NUM_ELEMENTS];
logic [DATA_WIDTH-1:0]parallel_mul_data_a[NUM_ELEMENTS];
logic [DATA_WIDTH-1:0]parallel_mul_data_b[NUM_ELEMENTS];
logic [DATA_WIDTH-1:0]parallel_mul_out[NUM_ELEMENTS];
logic [DATA_WIDTH-1:0]alpha[NUM_LOOP];      //Restore intermediate value of alpha

logic [DATA_WIDTH-1:0]alpha_i;
logic [$clog2(NUM_LOOP)-1:0] alpha_ptr;
logic [DATA_WIDTH-1:0] addertree_out;
logic [DATA_WIDTH-1:0] single_mul_out;
logic [DATA_WIDTH-1:0] parallel_sub_add_data_a[NUM_ELEMENTS];
logic [DATA_WIDTH-1:0] parallel_sub_add_data_b[NUM_ELEMENTS];
logic [DATA_WIDTH-1:0] parallel_sub_add_out[NUM_ELEMENTS];




always_ff @( posedge clk or negedge rst ) begin
    if(!rst||!operation[0]) begin
        loop_next_r<=1'b0;
    end
    else if(!loop_control_1&&(loop_cnt_control==4'b1010||loop_cnt_control==4'b0||loop_cnt_control==4'b1)&&loop_cnt==num_loop_current) begin
        loop_next_r<=1'b1;
    end 
    else begin
        loop_next_r<=loop_control_1;
    end
end
assign loop_next=loop_next_r;


always_ff @( posedge clk or negedge rst ) begin : LOOP_CONTROL_0_AND_LOOP_CNT_CONTROL 
    if(!rst||!operation[0]) begin
        loop_cnt_control<=4'b0;// 如果复位信号为低电平，或者执行的操作类型不是 searchdirection，则初始化控制变量
        loop_control_0<=1'b0;
    end
    else if(loop_cnt_control==4'b0001) begin      
    //2 clk    // the module starts when loop_control_0 equals 1  
    // 如果 loop_cnt_control 的当前值为 4'b0001，则表示在 2 个时钟周期内执行的操作开始
        // 在这个阶段，将 loop_cnt_control 加 1，loop_control_0 设置为逻辑 1
        loop_cnt_control<=loop_cnt_control+1'b1;
        loop_control_0<=1'b1;
    end
    else if(loop_cnt_control==4'b1010) begin //(8+2)-1=9 clk
     // 如果 loop_cnt_control 的当前值为 4'b1010，则表示在 (8 + 2) - 1 = 9 个时钟周期后执行的操作结束
        // 在这个阶段，将 loop_cnt_control 重置为 4'b0，loop_control_0 设置为逻辑 0
        loop_cnt_control<=4'b0;
        loop_control_0<=1'b0;
    end 
    else begin
        loop_cnt_control<=loop_cnt_control+1'b1; //counter// 在其他情况下，增加 loop_cnt_control 的值，作为计数器
    end
end

always_ff @(posedge clk or negedge rst ) begin : LOOP_CONTROL_1_AND_LOOP_CNT_AND_LOOP_END_R
    if(!rst||!operation[0]) begin
        loop_control_1<=1'b0;
        loop_cnt<='0;
        loop_end_r<='0;
        loop_end_flag<=1'b0;
    end
    else if(loop_cnt==num_loop_current&&loop_cnt_control==1'b1) begin 
        //loop_cnt==NUM_LOOP&&loop_cnt_control==1'b1
        loop_control_1<=1;
        loop_cnt<=loop_cnt+1;
    end
    else if (loop_cnt==(num_loop_current<<1)&&loop_cnt_control==1'b1)begin 
        if(!loop_end_flag) begin
            loop_end_r<=1;
        end
        loop_end_flag<=1'b1;
        loop_control_1<=0;
        loop_cnt<=1;
    end
    else if(loop_cnt_control==1'b1)begin
        loop_cnt<=loop_cnt+1;
    end
    else begin
        loop_end_r<=0;
    end
end
assign loop_end=loop_end_r;


always_comb begin
    if(loop_cnt==0) begin
        alpha_ptr=0;
    end
    else if(!loop_control_1) begin
        alpha_ptr=loop_cnt-1;
    end
    else if(loop_control_1) begin
        alpha_ptr=(num_loop_current<<1)-loop_cnt;
    end
end
assign alpha_i=alpha[alpha_ptr];

logic s_axis_a_tvalid_mul=1'b1;
logic s_axis_b_tvalid_mul=1'b1;
logic s_axis_a_tvalid_sub_add;
logic s_axis_b_tvalid_sub_add;
logic s_axis_a_tvalid_sub_add_wire;
logic s_axis_b_tvalid_sub_add_wire;
logic [7:0] s_axis_operation_tdata_sub_add;
logic [7:0] s_axis_operation_tdata_sub_add_wire;
logic s_axis_operation_tvalid_sub_add;
logic m_axis_result_tvalid_mul[NUM_ELEMENTS];
logic m_axis_result_tvalid_sub_add[NUM_ELEMENTS];
logic [DATA_WIDTH-1:0]parallel_mul_out_r[NUM_ELEMENTS];
logic [3:0] counter;
always_ff @( posedge clk or negedge rst) begin 
    if(!rst) begin
        s_axis_a_tvalid_sub_add<=1'b0;
        s_axis_b_tvalid_sub_add<=1'b0;
        s_axis_operation_tvalid_sub_add<=1'b0;
    end
    else if(loop_cnt_control==0&&operation[0]) begin
        s_axis_a_tvalid_sub_add<=1'b1;
        s_axis_b_tvalid_sub_add<=1'b1;
        s_axis_operation_tvalid_sub_add<=1'b1;
        s_axis_operation_tdata_sub_add<=8'b1; //subtract
    end
    else if(counter=='0&&operation==2'b00) begin
        s_axis_a_tvalid_sub_add<=1'b1;
        s_axis_b_tvalid_sub_add<=1'b1;
        s_axis_operation_tvalid_sub_add<=1'b1;
        s_axis_operation_tdata_sub_add<=8'b0; //add
    end
    else begin
        s_axis_a_tvalid_sub_add<=1'b0;
        s_axis_b_tvalid_sub_add<=1'b0;
        s_axis_operation_tvalid_sub_add<=1'b0;
    end
end
assign  s_axis_operation_tdata_sub_add_wire =s_axis_operation_tdata_sub_add;
assign  s_axis_a_tvalid_sub_add_wire= s_axis_a_tvalid_sub_add;
assign  s_axis_b_tvalid_sub_add_wire= s_axis_b_tvalid_sub_add;
genvar i;
generate
for(i=0;i<NUM_ELEMENTS;i=i+1) begin
    always_comb begin 
        casex({operation,loop_control_1,loop_control_0})
            4'b?100:begin                                    //第二步 等加法树加完
            parallel_mul_data_a[i]=alpha_i;
            parallel_mul_data_b[i]= y[i] ;
            parallel_sub_add_data_a[i]=q_r[i];
            parallel_sub_add_data_b[i]=parallel_mul_out[i];
            end
            4'b?101:begin                                 //第一步 ，然后再single mul中乘以rho
            parallel_mul_data_a[i]= q_r[i] ;
            parallel_mul_data_b[i]= s[i] ;
            end
            4'b?110:begin                               //第四步      
            parallel_mul_data_a[i]= alpha_i ;   
            parallel_mul_data_b[i]= s[i] ;
            parallel_sub_add_data_a[i]=q_r[i];
            parallel_sub_add_data_b[i]=parallel_mul_out[i];
            end
            4'b?111:begin                          //第三步
            parallel_mul_data_a[i]= q_r[i] ;
            parallel_mul_data_b[i]= y[i] ;
            end
            4'b00??:begin
            parallel_mul_data_a[i]=scalar_in;
            parallel_mul_data_b[i]=vector_inb[i];
            parallel_sub_add_data_a[i]=vector_ina[i];
            parallel_sub_add_data_b[i]=parallel_mul_out[i];
            end
            4'b10??:begin
            parallel_mul_data_a[i]= vector_ina[i];
            parallel_mul_data_b[i]= vector_inb[i];
            end
        endcase
    end  

   
    float_mul parallel_mul (
    .s_axis_a_tvalid(s_axis_a_tvalid_mul),            // input wire s_axis_a_tvalid
    .s_axis_a_tdata(parallel_mul_data_a[i]),              // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tvalid(s_axis_b_tvalid_mul),            // input wire s_axis_b_tvalid
    .s_axis_b_tdata(parallel_mul_data_b[i]),              // input wire [31 : 0] s_axis_b_tdata
    .m_axis_result_tvalid(m_axis_result_tvalid_mul[i]),  // output wire m_axis_result_tvalid
    .m_axis_result_tdata(parallel_mul_out_r[i])    // output wire [31 : 0] m_axis_result_tdata
    );
    // floating_point_Subtract parallel_sub (
    // .s_axis_a_tvalid(s_axis_a_tvalid_sub_wire),            // input wire s_axis_a_tvalid
    // .s_axis_a_tdata(parallel_sub_data_a[i]),              // input wire [31 : 0] s_axis_a_tdata
    // .s_axis_b_tvalid(s_axis_b_tvalid_sub_wire),            // input wire s_axis_b_tvalid
    // .s_axis_b_tdata(parallel_sub_data_b[i]),              // input wire [31 : 0] s_axis_b_tdata
    // .m_axis_result_tvalid(m_axis_result_tvalid_sub[i]),  // output wire m_axis_result_tvalid
    // .m_axis_result_tdata(parallel_sub_out[i])    // output wire [31 : 0] m_axis_result_tdata
    // );

    float_add_or_sub  parallel_sub_or_add(
    .s_axis_a_tvalid(s_axis_a_tvalid_sub_add_wire),                  // input wire s_axis_a_tvalid
    .s_axis_a_tdata(parallel_sub_add_data_a[i]),                    // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tvalid(s_axis_b_tvalid_sub_add_wire),                  // input wire s_axis_b_tvalid
    .s_axis_b_tdata(parallel_sub_add_data_b[i]),                    // input wire [31 : 0] s_axis_b_tdata
    .s_axis_operation_tvalid(s_axis_operation_tvalid_sub_add),  // input wire s_axis_operation_tvalid
    .s_axis_operation_tdata(s_axis_operation_tdata_sub_add_wire),    // input wire [7 : 0] s_axis_operation_tdata
    .m_axis_result_tvalid(m_axis_result_tvalid_sub_add[i]),        // output wire m_axis_result_tvalid
    .m_axis_result_tdata(parallel_sub_add_out[i])          // output wire [31 : 0] m_axis_result_tdata
    );

end
endgenerate
logic [DATA_WIDTH-1:0] new_iteration_point_r[NUM_ELEMENTS];

always_ff @( posedge clk ) begin 
    new_iteration_point_r<=parallel_sub_add_out;
end
assign new_iteration_point=new_iteration_point_r;
always_ff @( posedge clk ) begin 
    parallel_mul_out<=parallel_mul_out_r;
end


adder_tree_multiple_delay#(
    .NUM_ELEMENTS(NUM_ELEMENTS),
    .DATA_WIDTH(DATA_WIDTH)
)addertree
(
    .clk(clk),
    .terms(parallel_mul_out),
    .S(addertree_out)
);

assign result_vec_mul=addertree_out;////

//judge 

logic multi_end_flag;
logic result_vec_mul_valid_r;
logic result_new_iteration_point_valid_r;
assign result_vec_mul_valid=result_vec_mul_valid_r;
assign result_new_iteration_point_valid=result_new_iteration_point_valid_r;
always_ff @( posedge clk or negedge rst ) begin 
    if(!rst||operation[0]) begin
        counter<=0;
        multi_end_flag<=0;
        result_vec_mul_valid_r<=0;
        result_new_iteration_point_valid_r<=0;
    end
    else if(counter==4'b01&&operation==2'b00&&!multi_end_flag) begin
        result_new_iteration_point_valid_r<=1;
        multi_end_flag<=1;
        counter<=counter+1;
    end
    else if(counter==4'b0110&&operation==2'b10&&!multi_end_flag) begin
        result_vec_mul_valid_r<=1;
        multi_end_flag<=1;
        counter<=counter+1;
    end
    else begin
       
        counter<=counter+1;
        result_vec_mul_valid_r<=0;
        result_new_iteration_point_valid_r<=0;
    end
end

logic [DATA_WIDTH-1:0] single_mul_out_r;

always_ff @( posedge clk ) begin 
    single_mul_out<=single_mul_out_r;
end

logic m_axis_result_tvalid_single_mul;
// assign single_mul_out=addertree_out*rho;
 float_mul single_mul (
    .s_axis_a_tvalid(s_axis_a_tvalid_mul),            // input wire s_axis_a_tvalid
    .s_axis_a_tdata(addertree_out),              // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tvalid(s_axis_b_tvalid_mul),            // input wire s_axis_b_tvalid
    .s_axis_b_tdata(rho),              // input wire [31 : 0] s_axis_b_tdata
    .m_axis_result_tvalid(m_axis_result_tvalid_single_mul),  // output wire m_axis_result_tvalid
    .m_axis_result_tdata(single_mul_out_r)    // output wire [31 : 0] m_axis_result_tdata
    );
    
logic s_axis_a_tvalid_single_sub=1'b1;
logic s_axis_b_tvalid_single_sub=1'b1;
logic [DATA_WIDTH-1:0]single_sub_out;
logic m_axis_result_tvalid_single_sub;
logic [DATA_WIDTH-1:0] alpha_temp;
float_sub single_sub (
    .s_axis_a_tvalid(s_axis_a_tvalid_single_sub),            // input wire s_axis_a_tvalid
    .s_axis_a_tdata(single_mul_out),              // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tvalid(s_axis_b_tvalid_single_sub),            // input wire s_axis_b_tvalid
    .s_axis_b_tdata(alpha_temp),              // input wire [31 : 0] s_axis_b_tdata
    .m_axis_result_tvalid(m_axis_result_tvalid_single_sub),  // output wire m_axis_result_tvalid
    .m_axis_result_tdata(single_sub_out)    // output wire [31 : 0] m_axis_result_tdata
    );

always_ff @( posedge clk) begin 
    if(!loop_control_0&&!loop_control_1 ) begin
        alpha_temp<=alpha[alpha_ptr];
    end
    else if(!loop_control_0&&loop_control_1) begin
        alpha_temp<=alpha[alpha_ptr-1];
    end
end

always_ff @( posedge clk or negedge rst) begin 
    if(!rst||!operation[0]) begin
        integer i;
        for(i=0;i<NUM_LOOP;i=i+1) begin
            alpha[i]<='0;
        end
    end
    else if(loop_control_0&&!loop_control_1) begin
        alpha[alpha_ptr]<=single_mul_out;
    end
    else if(loop_control_0&&loop_control_1) begin
        alpha[alpha_ptr]<=single_sub_out;
    end
end

always_ff @( posedge clk or negedge rst ) begin 
    if(!rst||!operation[0]) begin
        integer j;
        for(j=0;j<NUM_ELEMENTS;j=j+1) begin
            q_r[j]<=32'b0;
        end   
    end
    else if (loop_cnt==0) begin
        q_r<=q_in;
    end
    else if(!loop_control_0&&!loop_control_1&&loop_cnt_control==1) begin
        q_r<=parallel_sub_add_out;
    end
    else if(!loop_control_0&&loop_control_1&&loop_cnt_control==1) begin
        q_r<=parallel_sub_add_out;
    end
end
assign direction=q_r;

always_ff@(posedge clk or negedge rst) begin:S_RD_EN
    if(!rst||loop_end_flag||!operation[0]) begin 
       s_rd_en<=1'b0;  
    end
    else if(!loop_cnt_control&&!loop_cnt)begin
        s_rd_en<=1'b1;
    end
    else if(!loop_control_1&&loop_cnt_control==4'b1010&&loop_cnt!=num_loop_current) begin
        s_rd_en<=1'b1;
    end
    else if(loop_control_1&&loop_cnt_control==4'b0100) begin
        s_rd_en<=1'b1;
    end
    else if(s_rd_en) begin
        s_rd_en<=1'b0;
    end
end

always_ff@(posedge clk or negedge rst) begin:Y_RD_EN
    if(!rst||loop_end_flag||!operation[0]) begin 
       y_rd_en<=1'b0; 
    end
    else if(!loop_control_1&&loop_cnt_control==4'b0100) begin  //1-9 is ok
        y_rd_en<=1'b1;
    end
    else if(!loop_control_1&&loop_cnt_control==4'b1010&&loop_cnt==num_loop_current) begin
        y_rd_en<=1'b1;
    end
    else if(loop_control_1&&loop_cnt_control==4'b1010&&(loop_cnt!=(num_loop_current<<1))) begin  
        y_rd_en<=1'b1;
    end
    else if(y_rd_en) begin
        y_rd_en<=1'b0;
    end
end

always_ff@(posedge clk or negedge rst) begin:RHO_RD_EN
    if(!rst||loop_end_flag||!operation[0]) begin 
       rho_rd_en<=1'b0;  
 
    end
    else if(!loop_cnt_control&&!loop_cnt)begin
        rho_rd_en<=1'b1;
        
    end
    else if(loop_cnt_control==4'b1010&&loop_cnt!=(num_loop_current<<1)) begin
        rho_rd_en<=1'b1;
    end
    else if(rho_rd_en) begin
        rho_rd_en<=1'b0;
    end
end
endmodule
