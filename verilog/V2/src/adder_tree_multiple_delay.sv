`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/10 15:28:39
// Design Name: 
// Module Name: adder_tree_multiple_delay
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


module adder_tree_multiple_delay
#(
    parameter int NUM_ELEMENTS      = 52,
    parameter int DATA_WIDTH           = 32
)
(   
    input  logic clk,
    input  logic [DATA_WIDTH-1:0] terms[NUM_ELEMENTS],
    output logic [DATA_WIDTH-1:0] S
);
    localparam int NUM_RESULTS_level_0 = integer'(NUM_ELEMENTS/2) + (NUM_ELEMENTS%2);          //26     68
    localparam int NUM_RESULTS_level_1 = integer'(NUM_RESULTS_level_0/2) + (NUM_RESULTS_level_0%2);    //13    34
    localparam int NUM_RESULTS_level_2 = integer'(NUM_RESULTS_level_1/2) + (NUM_RESULTS_level_1%2);    //7    17
    localparam int NUM_RESULTS_level_3 = integer'(NUM_RESULTS_level_2/2) + (NUM_RESULTS_level_2%2);    //4     9
    localparam int NUM_RESULTS_level_4 = integer'(NUM_RESULTS_level_3/2) + (NUM_RESULTS_level_3%2);    //2     5
    localparam int NUM_RESULTS_level_5 = integer'(NUM_RESULTS_level_4/2) + (NUM_RESULTS_level_4%2);    //      3
    localparam int NUM_RESULTS_level_6 = integer'(NUM_RESULTS_level_5/2) + (NUM_RESULTS_level_5%2);    //      2





    localparam integer n0= integer'(NUM_ELEMENTS/2);
    localparam integer n1= integer'(NUM_RESULTS_level_0/2);
    localparam integer n2= integer'(NUM_RESULTS_level_1/2);
    localparam integer n3= integer'(NUM_RESULTS_level_2/2);
    localparam integer n4= integer'(NUM_RESULTS_level_3/2);
    localparam integer n5= integer'(NUM_RESULTS_level_4/2);
    localparam integer n6= integer'(NUM_RESULTS_level_5/2);







    logic [DATA_WIDTH-1:0] results_level_0[NUM_RESULTS_level_0];
    logic [DATA_WIDTH-1:0] results_level_1[NUM_RESULTS_level_1];
    logic [DATA_WIDTH-1:0] results_level_2[NUM_RESULTS_level_2];
    logic [DATA_WIDTH-1:0] results_level_3[NUM_RESULTS_level_3];
    logic [DATA_WIDTH-1:0] results_level_4[NUM_RESULTS_level_4];
    logic [DATA_WIDTH-1:0] results_level_5[NUM_RESULTS_level_5];
    logic [DATA_WIDTH-1:0] results_level_6[NUM_RESULTS_level_6];





    adder_tree_level #  
    ( .NUM_ELEMENTS(NUM_ELEMENTS),
      .DATA_WIDTH(DATA_WIDTH)
    )                       adder_tree_level_0
    (
      .terms(terms),
      .results(results_level_0)
    );
    //////////////////////////////////////////
    logic [DATA_WIDTH-1:0] results_level_0_r[NUM_RESULTS_level_0];
    always_ff @( posedge clk ) begin 
      results_level_0_r<=results_level_0;
    end
    adder_tree_level #  
    ( .NUM_ELEMENTS(NUM_RESULTS_level_0),
      .DATA_WIDTH(DATA_WIDTH)
    )                       adder_tree_level_1
    ( 
      .terms(results_level_0_r),
      .results(results_level_1)
    );
    //////////////////////////////////////////////
    logic [DATA_WIDTH-1:0] results_level_1_r[NUM_RESULTS_level_1];
    always_ff @( posedge clk ) begin 
      results_level_1_r<=results_level_1;
    end
    adder_tree_level #  
    ( .NUM_ELEMENTS(NUM_RESULTS_level_1),
      .DATA_WIDTH(DATA_WIDTH)
    )                       adder_tree_level_2
    ( 
      .terms(results_level_1_r),
      .results(results_level_2)
    );
    ///////////////////////////////////////////////
    logic [DATA_WIDTH-1:0] results_level_2_r[NUM_RESULTS_level_2];
    always_ff @( posedge clk ) begin 
      results_level_2_r<=results_level_2;
    end

    adder_tree_level #  
    ( .NUM_ELEMENTS(NUM_RESULTS_level_2),
      .DATA_WIDTH(DATA_WIDTH)
    )                       adder_tree_level_3
    ( 
      .terms(results_level_2_r),
      .results(results_level_3)
    );
    //////////////////////////////////////////////
    logic [DATA_WIDTH-1:0] results_level_3_r[NUM_RESULTS_level_3];
    always_ff @( posedge clk ) begin 
      results_level_3_r<=results_level_3;
    end

        adder_tree_level #  
    ( .NUM_ELEMENTS(NUM_RESULTS_level_3),
      .DATA_WIDTH(DATA_WIDTH)
    )                       adder_tree_level_4
    ( 
      .terms(results_level_3_r),
      .results(results_level_4)
    );
    /////////////////////////////////////////////
    logic [DATA_WIDTH-1:0] results_level_4_r[NUM_RESULTS_level_4];
    always_ff @( posedge clk ) begin 
      results_level_4_r<=results_level_4;
    end


        adder_tree_level #  
    ( .NUM_ELEMENTS(NUM_RESULTS_level_4),
      .DATA_WIDTH(DATA_WIDTH)
    )                       adder_tree_level_5
    ( 
      .terms(results_level_4_r),
      .results(results_level_5)
    );
    /////////////////////////////////////////////
    logic [DATA_WIDTH-1:0] results_level_5_r[NUM_RESULTS_level_5];
    always_ff @( posedge clk ) begin 
      results_level_5_r<=results_level_5;
    end






    adder_tree_level #  
    ( .NUM_ELEMENTS(NUM_RESULTS_level_5),
      .DATA_WIDTH(DATA_WIDTH)
    )                       adder_tree_level_6
    ( 
      .terms(results_level_5_r),
      .results(results_level_6)
    );
    /////////////////////////////////////////////
    logic [DATA_WIDTH-1:0] results_level_6_r[NUM_RESULTS_level_6];
    always_ff @( posedge clk ) begin 
      results_level_6_r<=results_level_6;
    end


    logic [DATA_WIDTH-1:0] S_r;
   // logic s_axis_tvalid=1'b1;
   // logic m_axis_result_tvalid;
    float_add add_addertree (
       // .s_axis_a_tvalid(s_axis_tvalid),            // input wire s_axis_a_tvalid
        .s_axis_a_tdata(results_level_6_r[0]),              // input wire [31 : 0] s_axis_a_tdata
        //.s_axis_b_tvalid(s_axis_tvalid),            // input wire s_axis_b_tvalid
        .s_axis_b_tdata(results_level_6_r[1]),              // input wire [31 : 0] s_axis_b_tdata
        //.m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
        .m_axis_result_tdata( S_r[DATA_WIDTH-1:0])    // output wire [31 : 0] m_axis_result_tdata
    );
    /////////////////////////////////////
    always_ff @( posedge clk ) begin 
      S<=S_r;
    end
endmodule


module adder_tree_level
   #(
     parameter int NUM_ELEMENTS = 3,
     parameter int DATA_WIDTH      = 32,
     parameter int NUM_RESULTS  = integer'(NUM_ELEMENTS/2) + (NUM_ELEMENTS%2) 
    )
   (
    input  logic [DATA_WIDTH-1:0] terms[NUM_ELEMENTS],
    output logic [DATA_WIDTH-1:0] results[NUM_RESULTS]
   );
   
   localparam integer n= integer'(NUM_ELEMENTS/2);
  // logic m_axis_result_tvalid_level[n];
  // logic valid=1'b1;
    
//   always_comb begin
   genvar i;
   generate
      for ( i=0; i<n; i++) begin:adder_tree_level
            float_add  add (
      //      .s_axis_a_tvalid(valid),            // input wire s_axis_a_tvalid
            .s_axis_a_tdata(terms[i*2]),              // input wire [31 : 0] s_axis_a_tdata
        //    .s_axis_b_tvalid( valid),            // input wire s_axis_b_tvalid
            .s_axis_b_tdata(terms[i*2+1]),              // input wire [31 : 0] s_axis_b_tdata
        //    .m_axis_result_tvalid(m_axis_result_tvalid_level[i]),  // output wire m_axis_result_tvalid
            .m_axis_result_tdata( results[i] )    // output wire [31 : 0] m_axis_result_tdata
            );                  
      end
   endgenerate
    
   always_comb begin
      if( NUM_ELEMENTS % 2 == 1 ) begin
         results[NUM_RESULTS-1] = terms[NUM_ELEMENTS-1];
      end
   end
  // always_ff@(posedge aclk) begin
  //     if( NUM_ELEMENTS % 2 == 1 ) begin
  //        results[NUM_RESULTS-1] = terms[NUM_ELEMENTS-1];
  //     end
  //    end
endmodule