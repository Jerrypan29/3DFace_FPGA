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
//parameter DELAY_RAM=5+5,//delay between two ram
parameter DELAY_SUM=9,//delay between rst and sum  
//parameter DELAY_ENA=5,//to clean input of mul in f_sub module
//parameter NUM_parallel=3,
parameter NUM_CTRL=17,//how many wires to connect one reg of addr_out 
parameter [DATA_WIDTH-1:0] rel_step=64'h3F3428A3C0000000
)(
input                     clk,
input                     rst,
input  [DATA_WIDTH-1:0]   id              [0:NUM_ELEMENTS-1],

input  [DATA_WIDTH-1:0]   coefficient_funcf     [8],// coefficient_funcf[6]=trans;
input  [31:0]   rams_idmatrix_in         [204],//ram_idmatrix,
input  [5:0]              rams_idmatrix_addr_in ,//expect the last two is ram_impos
input                     rams_idmatrix_we,

input  [DATA_WIDTH-1:0]   ram_impos_in0[68],
input  [DATA_WIDTH-1:0]   ram_impos_in1[68],
input  [6:0]              ram_impos_in_addr,
input                     ram_impos_we,

//�����򻯵�
input [5:0] ram_idvar_in_addr,
input [DATA_WIDTH-1:0] ram_idvar_in,
input [5:0] ram_idmean_in_addr,
input [DATA_WIDTH-1:0] ram_idmean_in,
input ram_idmeanvar_we,

input op_objfunc,
input [5:0] num_grad,
input grad_add_or_sub,

output reg [DATA_WIDTH-1:0]  result_gradsubf,
output reg [DATA_WIDTH-1:0]  result_funcf,//test
output reg                   valid_funcf
    );

//connect muls and rams

    wire    [6:0]               rams_out_addr        [204];
    reg     [6:0]               rams_out_addr_reg    [204/NUM_CTRL];
    reg     [31:0]    rams_idmatrix_in_reg [204];//ram_idmatrix,
   // reg     [DATA_WIDTH-1:0]    muls_out_reg         [204];
  //  reg     [DATA_WIDTH-1:0]    accumulator_out_reg    [204];  
    reg    [DATA_WIDTH-1:0]    accumulator_ina         [204];   
    reg    [DATA_WIDTH-1:0]    accumulator_inb        [204];            
    wire    [DATA_WIDTH-1:0]    accumulator_out         [204];
    wire    [DATA_WIDTH-1:0]    muls_out             [204];
    reg    [DATA_WIDTH-1:0]    muls_ina             [204];
    reg    [DATA_WIDTH-1:0]    muls_inb             [204];
    wire    [31:0]    rams_out             [204];
    reg                     en_add_or_sub;

   (* max_fanout = "100" *) reg     [6:0]            rams_in_addr_reg     [204/NUM_CTRL];//expect the last two is ram_impos
   (* max_fanout = "100" *) reg                      rams_we_reg          [204/NUM_CTRL]; 
    wire    [6:0]            rams_in_addr         [204];//expect the last two is ram_impos
    wire                     rams_we              [204]; 
   // reg                      sum_ena;
    reg                      mul_ena;
    reg   [DATA_WIDTH-1:0]   id_reg               [204/NUM_CTRL];
    reg   [DATA_WIDTH-1:0]   sum_in_reg           [2];
    wire  [DATA_WIDTH-1:0]   sum_out0;
    reg   [DATA_WIDTH-1:0]   sum_out_tmp_reg;
    wire  [DATA_WIDTH-1:0]   add_sum1_out;
    reg   [DATA_WIDTH-1:0]   result_subf;

    wire    [DATA_WIDTH-1:0]    idmatrix64             [204];
    reg    [DATA_WIDTH-1:0]    idmatrix64_reg             [204];
    reg    [DATA_WIDTH-1:0]    lmproj1             [68];
    reg    [DATA_WIDTH-1:0]    lmproj2             [68];


    reg [3:0] state_count;
    reg [3:0] addertree_count;
    localparam state_count0=4'b0000,state_count1=4'b0001,state_count2=4'b0010,state_count3=3'b0011,
state_count4=4'b0100,state_count5=4'b0101,state_count6=4'b0110,state_count7=4'b0111,state_count8=4'b1000,
state_count9=4'b1001,state_count10=4'b1010,state_count11=4'b1011,state_count12=4'b1100,state_count13=4'b1101;

    reg    [DATA_WIDTH-1:0]    temp_delta_lmproj1             [68];
    reg    [DATA_WIDTH-1:0]    temp_delta_lmproj2             [68];

   genvar  i;genvar j; genvar k;
   //control of clk_num
   generate 
        for(i=0; i<204/NUM_CTRL; i=i+1) begin//no sign for stop!!!
            for(j=0; j<NUM_CTRL; j=j+1) begin
                assign rams_out_addr[i*NUM_CTRL+j]=rams_out_addr_reg[i];   
                assign rams_we[i*NUM_CTRL+j]=rams_we_reg[i];
                assign rams_in_addr[i*NUM_CTRL+j]=rams_in_addr_reg[i];
            end 
            always@(posedge clk)begin
                rams_we_reg[i]<=rams_idmatrix_we;
                rams_in_addr_reg[i]<=rams_idmatrix_addr_in;
            end
        end
    endgenerate
    always@(posedge clk)begin
        rams_idmatrix_in_reg<=rams_idmatrix_in;
    end
    always@(posedge clk)begin
        
        if(!rst) begin
                state_count<=state_count0;
                valid_funcf<=1'b0;
               // sum_ena<=1'b0;
                mul_ena<=1'b0;
                en_add_or_sub<=1'b0;
                for(integer i=0; i<204/NUM_CTRL; i=i+1) begin
                    id_reg[i]<=64'h0000000000000000;  
                end
                for(integer i=0; i<204; i=i+1) begin
                     accumulator_ina[i]<=64'h0000000000000000;  
                     accumulator_inb[i]<=64'h0000000000000000;   
                    muls_ina[i]<=64'h0000000000000000;   
                    muls_inb[i]<=64'h0000000000000000;   
                    idmatrix64_reg[i]<=64'h0000000000000000;  
                end
                if(!op_objfunc) begin
                    for(integer i=0; i<204/NUM_CTRL; i=i+1) begin
                        rams_out_addr_reg[i]<=0;
                    end
                end
             end
        else begin 
            if(!op_objfunc) begin    

                if((rams_out_addr_reg[0]!=7'b1111111))begin 
                    for(integer i=0; i<204/NUM_CTRL; i=i+1) begin
                        rams_out_addr_reg[i]<=rams_out_addr_reg[i]+1;
                    end
                end

                if(mul_ena==1'b0)begin
                    for(integer i=0; i<204; i=i+1) begin
                    idmatrix64_reg<=idmatrix64;
                    muls_ina[i]<=idmatrix64_reg[i]; //150x68��
                    muls_inb[i]<=id_reg[i/NUM_CTRL];
                    accumulator_ina[i]<=muls_out[i];
                    accumulator_inb[i]<=accumulator_out[i];
            
                    end
                end


                for(integer i=0; i<204/NUM_CTRL; i=i+1) begin
                    id_reg[i]<=id[rams_out_addr[0]];   
                    end
                        
                if(rams_out_addr_reg[0]==NUM_ELEMENTS+1+1+1+1+1+1+1+1+DELAY_SUM+1) begin
                        valid_funcf<=1'b1;
                        result_funcf<=add_sum1_out;
                end 
                else begin
                        valid_funcf<=1'b0;
                end
                        //if(rams_out_addr_reg[0]==DELAY_SUM) begin
                        //    sum_ena<=1'b1;
                    // end 
                    // if(rams_out_addr_reg[0]==NUM_ELEMENTS_matrix+1+DELAY_SUM) begin
                        //   sum_ena<=1'b0;
                        //end 

                if(rams_out_addr_reg[0]==NUM_ELEMENTS+1) begin
                            mul_ena<=1'b1;
                end
                if(rams_out_addr_reg[0]==NUM_ELEMENTS+1+1) begin
                            for(integer i=0; i<204; i=i+1) begin
                                muls_ina[i]<=accumulator_out[i]; 
                                //lmpos3d[i]<=accumulator_out[i]; 
                            end
                            for(integer i=0; i<68; i=i+1) begin
                                muls_inb[3*i]<=coefficient_funcf[0];
                                muls_inb[3*i+1]<=coefficient_funcf[1];
                                muls_inb[3*i+2]<=coefficient_funcf[2];
                            end
                end 
                if(rams_out_addr_reg[0]==NUM_ELEMENTS+1+1+1) begin
                    for(integer i=0; i<68; i=i+1) begin
                                muls_inb[3*i]<=coefficient_funcf[3];
                                muls_inb[3*i+1]<=coefficient_funcf[4];
                                muls_inb[3*i+2]<=coefficient_funcf[5];
                    end
                    for(integer i=0; i<68; i=i+1) begin
                                accumulator_ina[i]<=muls_out[i*3];      //1st column
                                accumulator_inb[i]<=muls_out[i*3+1];  //2nd column
                                accumulator_ina[i+68]<=muls_out[i*3+2];//3rd column
                                accumulator_inb[i+68]<=coefficient_funcf[6];//trans
                    end                   
                end 
                if(rams_out_addr_reg[0]==NUM_ELEMENTS+1+1+1+1) begin
                            for(integer i=0; i<68; i=i+1) begin
                                accumulator_ina[i]<=muls_out[i*3];      //1st column
                                accumulator_inb[i]<=muls_out[i*3+1];  //2nd column
                                accumulator_ina[i+68]<=muls_out[i*3+2];//3rd column
                                accumulator_inb[i+68]<=coefficient_funcf[7];//trans
                                accumulator_ina[i+136]<=accumulator_out[i];
                                accumulator_inb[i+136]<=accumulator_out[i+68];      //c0*1st +c1*2nd + c2 *3rd +trans1
                            end                        
                end
                if(rams_out_addr_reg[0]==NUM_ELEMENTS+1+1+1+1+1) begin
                            for(integer i=0; i<68; i=i+1) begin
                                accumulator_ina[i]<=accumulator_out[i];
                                accumulator_inb[i]<=accumulator_out[i+68];       ////c4*1st +c5*2nd + c6 *3rd +trans2
                                
                            end                        
                end
                if(rams_out_addr_reg[0]==NUM_ELEMENTS+1+1+1+1+1+1) begin //begin sub
                            en_add_or_sub<=1'b1;
                            for(integer i=0; i<68; i=i+1) begin
                                accumulator_ina[i]<=accumulator_out[i+136]  ;   //1st column
                                accumulator_inb[i]<=ram_impos_in0[i];
                                accumulator_ina[i+68]<=accumulator_out[i];  //2nd column
                                accumulator_inb[i+68]<=ram_impos_in1[i];
                                lmproj1[i]<=accumulator_out[i+136]  ; 
                                lmproj2[i]<=accumulator_out[i]; 
                            end                        
                end
                if(rams_out_addr_reg[0]==NUM_ELEMENTS+1+1+1+1+1+1+1) begin //begin sub
                            for(integer i=0; i<68; i=i+1) begin
                                muls_ina[i]<=accumulator_out[i];
                                muls_inb[i]<=accumulator_out[i];
                                muls_ina[i+68]<=accumulator_out[i+68];
                                muls_inb[i+68]<=accumulator_out[i+68];
                            end         
                end
                if(rams_out_addr_reg[0]==NUM_ELEMENTS+1+1+1+1+1+1+1+1) begin //begin sub
                            for(integer i=0; i<636; i=i+1) begin
                            addertree_in[i]<=muls_out[i];
                            end         
                    end
            end
            if(op_objfunc) begin
                case(state_count)
                    state_count0:begin
                        for(integer i=0; i<204/NUM_CTRL; i=i+1) begin
                        rams_out_addr_reg[i][5:0]<=num_grad;
                        end
                        if (!grad_add_or_sub)
                        state_count<=state_count1;
                        else state_count<=state_count12;
                    end
                    state_count1:begin
                        for(integer i=0; i<204; i=i+1) begin
                            muls_ina[i]<=idmatrix64[i]; 
                            muls_inb[i]<=rel_step;
                        end
                        state_count<=state_count2;
                    end
                    state_count2:begin
                        for(integer i=0; i<204; i=i+1) begin
                            muls_ina[i]<=muls_out[i];  
                            end
                        for(integer i=0; i<68; i=i+1) begin
                            muls_inb[3*i]<=coefficient_funcf[0];
                            muls_inb[3*i+1]<=coefficient_funcf[1];
                            muls_inb[3*i+2]<=coefficient_funcf[2];
                        end
                        state_count<=state_count3;
                    end
                    state_count3:begin
                        for(integer i=0; i<68; i=i+1) begin
                            accumulator_ina[i]<=muls_out[i*3];      //1st column
                            accumulator_inb[i]<=muls_out[i*3+1];  //2nd column
                            accumulator_ina[i+68]<=muls_out[i*3+2];//3rd column
                            end  
                        for(integer i=0; i<68; i=i+1) begin
                            muls_inb[3*i]<=coefficient_funcf[3];
                            muls_inb[3*i+1]<=coefficient_funcf[4];
                            muls_inb[3*i+2]<=coefficient_funcf[5];
                        end    
                        state_count<=state_count4;
                        end
                    state_count4:begin
                        for(integer i=0; i<68; i=i+1) begin
                            accumulator_inb[i+68]<=accumulator_out[i];//1st column
                            accumulator_ina[i]<=muls_out[i*3];     
                            accumulator_inb[i]<=muls_out[i*3+1]; 
                        end
                        state_count<=state_count5;
                    end
                    state_count5:begin
                        for(integer i=0; i<68; i=i+1) begin
                            accumulator_ina[i]<=accumulator_out[i]  ;
                            accumulator_inb[i]<=muls_out[i*3+2]; //2st column
                        end
                        state_count<=state_count6;
                    end
                    state_count6:begin
                        for(integer i=0; i<68; i=i+1) begin
                            accumulator_inb[i]<=accumulator_out[i+68]  ;
                            accumulator_ina[i]<=lmproj1[i]; //1st column
                            accumulator_inb[i+68]<=accumulator_out[i]  ;
                            accumulator_ina[i+68]<=lmproj2[i]; //2st column
                            temp_delta_lmproj1[i]<=accumulator_out[i+68]  ;
                            temp_delta_lmproj2[i]<=accumulator_out[i]  ;
                        end
                        en_add_or_sub<=grad_add_or_sub;
                        state_count<=state_count7;
                    end
                    state_count7:begin
                        en_add_or_sub<=1'b1;
                        for(integer i=0; i<68; i=i+1) begin
                            accumulator_ina[i]<=accumulator_out[i]  ;   //1st column
                            accumulator_inb[i]<=ram_impos_in0[i];
                            accumulator_ina[i+68]<=accumulator_out[i+68];  //2nd column
                            accumulator_inb[i+68]<=ram_impos_in1[i];   
                        end  
                        state_count<=state_count8;
                    end
                    state_count8:begin
                        for(integer i=0; i<68; i=i+1) begin
                                muls_ina[i]<=accumulator_out[i];
                                muls_inb[i]<=accumulator_out[i];
                                muls_ina[i+68]<=accumulator_out[i+68];
                                muls_inb[i+68]<=accumulator_out[i+68];
                            end     
                        state_count<=state_count9;
                    end
                    state_count9:begin
                        for(integer i=0; i<636; i=i+1) begin
                            addertree_in[i]<=muls_out[i];
                            end  
                        state_count<=state_count10; 
                        addertree_count<=4'b0000;
                    end
                    state_count10:begin
                        addertree_count<=addertree_count+1; 
                        if(addertree_count == 4'b1001)begin
                            valid_funcf<=1'b1;
                            result_funcf<=addertree_out;
                            result_gradsubf<=result_subf;
                            state_count<=state_count11; 
                        end
                    end
                    state_count11:begin
                        valid_funcf<=1'b0;
                    end       
                    state_count12:begin
                        for(integer i=0; i<68; i=i+1) begin
                            accumulator_inb[i]<=temp_delta_lmproj1[i]  ;
                            accumulator_ina[i]<=lmproj1[i]; //1st column
                            accumulator_inb[i+68]<=temp_delta_lmproj2[i]  ;
                            accumulator_ina[i+68]<=lmproj2[i]; //2st column
                        end
                        en_add_or_sub<=grad_add_or_sub;
                        state_count<=state_count7; 
                    end    
                endcase
            end
        end
    end

reg    [DATA_WIDTH-1:0]             addertree_in[136];
wire    [DATA_WIDTH-1:0]             addertree_out;
reg     [DATA_WIDTH-1:0]             addertree_out_reg;
        adder_tree_multiple_delay#(
          .NUM_ELEMENTS(136),
          .DATA_WIDTH(DATA_WIDTH)
          ) adder_tree(   
          .clk(clk),
          .terms(addertree_in),
          .S(addertree_out)
          );     
        always@(posedge clk)begin
           addertree_out_reg<=addertree_out;
        end


    reg                 rst_subf;
    always@(posedge clk)begin
        if(!op_objfunc) begin
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
    .num_grad                (num_grad),
    .op_objfunc              (op_objfunc),

    .result_subf           ( result_subf        )
);   
        

//muls, dist_rams and adder_tree
   generate 
        for(i=0; i<204; i=i+1) begin

            float32_64 float_idmatrix (
                .s_axis_a_tdata(rams_out[i]),
                .m_axis_result_tdata(idmatrix64[i])//,
                //.aclk(clk)
            );

          dist_mem_80_32 dis_men_idmatrix (
            .a(rams_in_addr[i][5:0]),        // input wire [6 : 0] a
            .d(rams_idmatrix_in_reg[i]),        // input wire [31 : 0] d
            .dpra(rams_out_addr[i][5:0]),  // input wire [6 : 0] dpra
            .clk(clk),    // input wire clk
            .we(rams_we[i]),      // input wire we
            .dpo(rams_out[i])    // output wire [31 : 0] dpo
          );
          float_mul muls (
            .s_axis_a_tdata(muls_ina[i]),              // input wire [31 : 0] s_axis_a_tdata
            .s_axis_b_tdata(muls_inb[i]),              // input wire [31 : 0] s_axis_b_tdata
            .m_axis_result_tdata(muls_out[i])    // output wire [31 : 0] m_axis_result_tdata
          );
             
 
        float_add_or_sub accumulator(   
          .s_axis_a_tdata(accumulator_ina[i]),
          .s_axis_b_tdata(accumulator_inb[i]),
          .s_axis_operation_tdata({7'b0000000,en_add_or_sub}),
          .m_axis_result_tdata(accumulator_out[i])//lmpos3d x y z
          );     
        end 
                
    endgenerate
    

    float_add add_sum1 (
        .s_axis_a_tdata(addertree_out_reg),        //��׼��      // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tdata(result_subf),    //����          // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tdata(add_sum1_out) //res   // output wire [31 : 0] m_axis_result_tdata
    );

    
endmodule
