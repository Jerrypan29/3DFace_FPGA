`timescale 1ns / 1ps

module AdderTree3to2 #(
     parameter int NUM_ELEMENTS= 52,//NUM)_ELEMENTS>2
     parameter int DATA_WIDTH= 32
   )
    (
    input  logic [DATA_WIDTH-1:0] addertree_in [NUM_ELEMENTS],
    output logic [DATA_WIDTH-1:0] addertree_out,
    input logic clk
    );
       //    logic     [DATA_WIDTH-1:0] addertree_out_reg;//to be optimized...
      //always@(posedge clk) begin  addertree_out<=addertree_out_reg; end
      generate
 if (NUM_ELEMENTS == 2) begin 
         always_comb begin
           addertree_out=addertree_in[0]+addertree_in[1];//to be optimized...
         end
      end 
      else begin
         localparam integer NUM_RESULTS = integer'((2*(NUM_ELEMENTS/3)) + (NUM_ELEMENTS%3));
         logic [DATA_WIDTH-1:0] next_level_in  [NUM_RESULTS];

         adder_tree_level1 #(.NUM_ELEMENTS(NUM_ELEMENTS),
                            .DATA_WIDTH(DATA_WIDTH),
                            .NUM_RESULTS(NUM_RESULTS)
         ) adder_tree_level1 (
                            .addertree_level_in(addertree_in),
                            .addertree_level_out(next_level_in)
         );

         AdderTree3to2 #(.NUM_ELEMENTS(NUM_RESULTS),
                                  .DATA_WIDTH(DATA_WIDTH)
         ) AdderTree3to2(
                                  .addertree_in(next_level_in),
                                  .addertree_out(addertree_out)
         );
      end
      endgenerate
endmodule

module adder_tree_level1
#(parameter NUM_ELEMENTS=1, DATA_WIDTH=1, NUM_RESULTS=1  //= integer '(2*NUM_ELEMENTS/3) + (NUM_ELEMENTS%3)
)(
    input  logic [DATA_WIDTH-1:0] addertree_level_in[NUM_ELEMENTS],
    output logic [DATA_WIDTH-1:0] addertree_level_out[NUM_RESULTS]
   );

   genvar i;
   generate  for ( i=0; i<(NUM_ELEMENTS / 3); i++) begin
   
         adder3to2 #(
         .OUT_WIDTH(DATA_WIDTH),
         .IN_WIDTH(DATA_WIDTH)
         )
         addertree_adder3to2 (
         .in_a0(addertree_level_in[3*i]), 
         .in_a1(addertree_level_in[3*i+1]), 
         .in_a2(addertree_level_in[3*i+2]),
         .out_b0(addertree_level_out[2*i]), 
         .out_b1(addertree_level_out[2*i+1])
         );
         end
    endgenerate
    
      if( NUM_ELEMENTS % 3 == 1 ) begin
         assign  addertree_level_out[NUM_RESULTS-1] = addertree_level_in[NUM_ELEMENTS-1];
      end
      else if( NUM_ELEMENTS % 3 == 2 ) begin
         assign  addertree_level_out[NUM_RESULTS-1] = addertree_level_in[NUM_ELEMENTS-1];
         assign addertree_level_out[NUM_RESULTS-2] =addertree_level_in[NUM_ELEMENTS-2];
      end
   
endmodule

module  adder3to2 #(parameter OUT_WIDTH = 32, 
parameter IN_WIDTH = 32
)
(//fulladder
in_a0, in_a1, in_a2,
out_b0, out_b1
);
output logic [OUT_WIDTH-1:0] out_b0;
output logic [OUT_WIDTH-1:0] out_b1;
input logic [IN_WIDTH-1:0] in_a0;
input logic [IN_WIDTH-1:0] in_a1;
input logic [IN_WIDTH-1:0] in_a2;
logic [IN_WIDTH-1:0] co_0;
assign out_b1[0]=1'b0;
assign out_b1[OUT_WIDTH-1:1]=co_0[OUT_WIDTH-2:0];

FullAdder#(
   .OUT_WIDTH(OUT_WIDTH),
   .IN_WIDTH(IN_WIDTH)
)
fulladder0(
    .a(in_a0),
    .b(in_a1),
    .ci(in_a2),
    .s(out_b0),
    .co(co_0)
);

endmodule

module FullAdder#(parameter OUT_WIDTH = 32, 
parameter IN_WIDTH = 32
)
(//fulladder
s, co,
a, b, ci
);

output logic [OUT_WIDTH-1:0] s;
output logic [OUT_WIDTH-1:0] co;
input logic [IN_WIDTH-1:0] a;
input logic [IN_WIDTH-1:0] b;
input logic [IN_WIDTH-1:0] ci;

assign s = ~((~a&~b&~ci)|(a&~b&ci)|(~a&b&ci)|(a&b&~ci));//
assign co = ~((~a&~b)|(~b&~ci)|(~a&~ci));//
endmodule