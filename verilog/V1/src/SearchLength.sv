`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/31 15:00:18
// Design Name: 
// Module Name: SearchLength
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
// Create Date: 2022/01/18 13:39:12
// Design Name: 
// Module Name: LineSearch_control
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


module SearchLength#(
parameter DATA_WIDTH=32,
parameter NUM_DIV=6,
parameter NUM_ROOT=5
)(
  input clk,
  input rst_SearchLength,//=ready  phi0,phi_dif0 ,phi1
  input [DATA_WIDTH-1:0] phi0,
  input [DATA_WIDTH-1:0] phi1,
  input [DATA_WIDTH-1:0] phi_dif0,
  input ready_phi_alphai,
  input [DATA_WIDTH-1:0] phi_alphai_in,
  output reg rst_compute_phi,
  output reg [DATA_WIDTH-1:0] result_alpha_to_compute,
  output logic [DATA_WIDTH-1:0] result_alpha_satisfied,
  output reg valid_searchlength=1'b0
    );

//instance
  reg [DATA_WIDTH-1:0] alpha0;
  reg [DATA_WIDTH-1:0] alpha1;
  reg [DATA_WIDTH-1:0] alpha2;  
  reg [DATA_WIDTH-1:0] phi_alpha0_sub_phi0;    
  reg [DATA_WIDTH-1:0] phi_alpha1_sub_phi0; 
  reg [DATA_WIDTH-1:0] phi_alpha2_sub_phi0;
  reg [DATA_WIDTH-1:0] rho_mul_phi_dif0;   
  reg [DATA_WIDTH-1:0] rho_phidif0;  
  reg [DATA_WIDTH-1:0] phi_dif0_alpha1;
  reg [DATA_WIDTH-1:0] B0;  //  phi_alpha_1_sub_phi_0_sub_phi_dif_0_mul_alpha_1;  
  reg [DATA_WIDTH-1:0] B1;  //  phi_alpha_0_sub_phi_0_sub_phi_dif_0_mul_alpha_0;  
  reg [DATA_WIDTH-1:0] A0_3; 
  reg [DATA_WIDTH-1:0] A1;  
  reg [DATA_WIDTH-1:0] alpha0_2;
  reg [DATA_WIDTH-1:0] alpha1_2;
  reg [DATA_WIDTH-1:0] alpha1_2_B1;
  
  logic [DATA_WIDTH-1:0] phi_alpha0;
  logic [DATA_WIDTH-1:0] phi_alpha1;
  logic [DATA_WIDTH-1:0] phi_alpha2;   
  logic [DATA_WIDTH-1:0] sub1_ina;
  logic [DATA_WIDTH-1:0] sub1_inb;
  logic [DATA_WIDTH-1:0] sub1_out;
  logic [DATA_WIDTH-1:0] sub2_ina;
  logic [DATA_WIDTH-1:0] sub2_inb;
  logic [DATA_WIDTH-1:0] sub2_out;
  logic [DATA_WIDTH-1:0] sub3_ina;
  logic [DATA_WIDTH-1:0] sub3_inb;
  logic [DATA_WIDTH-1:0] sub3_out;
  logic [DATA_WIDTH-1:0] mul1_ina;
  logic [DATA_WIDTH-1:0] mul1_inb;
  logic [DATA_WIDTH-1:0] mul1_out;
  logic [DATA_WIDTH-1:0] mul2_ina;
  logic [DATA_WIDTH-1:0] mul2_inb;
  logic [DATA_WIDTH-1:0] mul2_out;
  logic [DATA_WIDTH-1:0] mul3_ina;
  logic [DATA_WIDTH-1:0] mul3_inb;
  logic [DATA_WIDTH-1:0] mul3_out;
  logic [DATA_WIDTH-1:0] mul4_ina;
  logic [DATA_WIDTH-1:0] mul4_inb;
  logic [DATA_WIDTH-1:0] mul4_out;
  logic [DATA_WIDTH-1:0] mul5_ina;
  logic [DATA_WIDTH-1:0] mul5_inb;
  logic [DATA_WIDTH-1:0] mul5_out;
  logic [DATA_WIDTH-1:0] mul6_ina;
  logic [DATA_WIDTH-1:0] mul6_inb;
  logic [DATA_WIDTH-1:0] mul6_out;
  logic [DATA_WIDTH-1:0] div1_ina;
  logic [DATA_WIDTH-1:0] div1_inb;
  logic [DATA_WIDTH-1:0] div1_out;
  logic [DATA_WIDTH-1:0] squroot_in;
  logic [DATA_WIDTH-1:0] squroot_out;
  logic [DATA_WIDTH-1:0] compare_subina;
  logic [DATA_WIDTH-1:0] compare_subinb;
  logic [DATA_WIDTH-1:0] compare_mulina;
  logic [DATA_WIDTH-1:0] compare_mulinb;
  logic [DATA_WIDTH-1:0] compare_mulout;
  logic [DATA_WIDTH-1:0] compare_subout;
  logic compare_out;
  logic [DATA_WIDTH-1:0] b;
  logic [DATA_WIDTH-1:0] a3;

  localparam Armijo1=4'b0001,
  Armijo2_start=4'b0010,Armijo2_wait=4'b0011,Armijo2_ready=4'b0100,
  Armijo3_start=4'b0101,Armijo3_wait=4'b0110,Armijo3_ready=4'b0111,
  Armijo3_start_loop=4'b1000,Armijo_ify=4'b1001,Armijo_ifn=4'b1010,
  Armijio_over=4'b0000;  
  reg [3:0] state_now=4'b0000;
  reg [3:0] state_next=4'b0000;
  logic [5:0] num_now;
  logic [5:0] num_next;
  localparam num_start=6'b000000,num_1=6'b000001,num_2=6'b000010,num_3=6'b000011,num_4=6'b000100,
  num_5=6'b000101,num_6=6'b000110,num_7=6'b000111,num_8=6'b001000,num_9=6'b001001,num_end=6'b111111;

logic flag_alpha2if;
alpha2_if#(
.DATA_WIDTH(DATA_WIDTH)
) alpha2_if1(
.clk(clk),
.alpha2(alpha2),
.alpha1(alpha1),
.result_alpha2_if(flag_alpha2if)
    );
    
   LS_Compare #(
.DATA_WIDTH(DATA_WIDTH)
) LS_compare1(
.aclk(clk),
.alphai(compare_mulina),
.rho_phidif0(compare_mulinb),
.phi0(compare_subinb),
.phi_alphai(compare_subina),
.phi_alphai_sub_phi0(compare_subout),
.rho_phidif0_alphai(compare_mulout),
.result_compare(compare_out)
    );
    
float_mul mul1 (
  .s_axis_a_tdata(mul1_ina),       
  .s_axis_b_tdata(mul1_inb),       
  .m_axis_result_tdata(mul1_out)   
);
float_mul mul2 (
  .s_axis_a_tdata(mul2_ina),       
  .s_axis_b_tdata(mul2_inb),       
  .m_axis_result_tdata(mul2_out)   
);
float_mul mul3 (
  .s_axis_a_tdata(mul3_ina),       
  .s_axis_b_tdata(mul3_inb),       
  .m_axis_result_tdata(mul3_out)   
);
float_mul mul4 (
  .s_axis_a_tdata(mul4_ina),       
  .s_axis_b_tdata(mul4_inb),       
  .m_axis_result_tdata(mul4_out)   
);
float_mul mul5 (
  .s_axis_a_tdata(mul5_ina),       
  .s_axis_b_tdata(mul5_inb),       
  .m_axis_result_tdata(mul5_out)   
);
float_mul mul6 (
  .s_axis_a_tdata(mul6_ina),       
  .s_axis_b_tdata(mul6_inb),       
  .m_axis_result_tdata(mul6_out)   
);

float_sub sub1 (
  .s_axis_a_tdata(sub1_ina),       
  .s_axis_b_tdata(sub1_inb),       
  .m_axis_result_tdata(sub1_out)   
);
float_sub sub2 (
  .s_axis_a_tdata(sub2_ina),       
  .s_axis_b_tdata(sub2_inb),       
  .m_axis_result_tdata(sub2_out)   
);
float_sub sub3 (
  .s_axis_a_tdata(sub3_ina),       
  .s_axis_b_tdata(sub3_inb),       
  .m_axis_result_tdata(sub3_out)   
);
float_divide div1 (
  .aclk(clk),                      
  .s_axis_a_tdata(div1_ina),       
  .s_axis_b_tdata(div1_inb),       
  .m_axis_result_tdata(div1_out)   
);
     float_squareroot squareroot1( 
   .aclk(clk),
   .s_axis_a_tdata(squroot_in),    
   .m_axis_result_tdata(squroot_out) 
 ); 


//state machine 
always_ff @(posedge clk) begin //1
  if(!rst_SearchLength)begin
    state_now<=Armijo1;
    num_now<=num_start;
  end
  else begin
    state_now<=state_next;
    num_now<=num_next;
  end
end
                                           
always_comb begin    //2
 if(!rst_SearchLength)begin
    valid_searchlength<=1'b0;  
    num_next=num_start;
 end
 else begin
  case(state_now)
    Armijo1:begin 
      if(num_now==num_3) begin //
        if(compare_out==1'b1)  begin 
          state_next=Armijio_over; 
          result_alpha_satisfied=64'h3FF0000000000000;//1
          valid_searchlength<=1'b1;
        end 
        else begin  
          state_next=Armijo2_start;
          num_next=num_start;
        end 
      end 
      else begin 
        state_next=Armijo1;
        if(num_next!=num_end)begin 
          num_next=num_now+1;
        end
      end
    end
    Armijo2_start:begin      //state2
      if(num_now==num_1+1+NUM_DIV+1+1) begin   //14
        state_next=Armijo2_wait;
        num_next=num_start;
      end
      else begin
        state_next=Armijo2_start;
        if(num_next!=num_end)begin
        num_next=num_now+1;
        end
      end
    end
    Armijo2_wait:begin
      if(ready_phi_alphai==1'b1) begin 
        state_next=Armijo2_ready;
        num_next=num_start;
      end
      else begin 
        state_next=Armijo2_wait;
     if(num_next!=num_end)begin
        num_next=num_now+1;
        end
      end
    end
    Armijo2_ready:begin    
      if(num_now==num_3)begin//
        if(compare_out==1'b1)  begin 
          state_next =Armijio_over; 
          result_alpha_satisfied=alpha1;
          valid_searchlength<=1'b1;
        end 
        else begin  
          state_next=Armijo3_start_loop;     //8
          num_next=num_start;
        end
      end
      else begin
        state_next=Armijo2_ready;
   if(num_next!=num_end)begin
        num_next=num_now+1;
        end
      end
    end
    Armijo3_start_loop:begin     //8
      if(num_now==num_3+1+NUM_DIV+1+1+num_2+1+NUM_ROOT+1+1+1) begin    //12.17�?????
      //if(num_now==num_3+1+NUM_DIV+1+NUM_TRAN+2+NUM_MUL+1+NUM_TRAN+1+NUM_SUB+1+NUM_ROOT+1+NUM_SUB+1+NUM_TRAN+1+1+1) begin
        
        state_next=Armijo3_wait;
        num_next=num_start;
      end
      else begin
        state_next=Armijo3_start_loop;
        if(num_next!=num_end)begin
        num_next=num_now+1;
        end
      end
    end
    Armijo3_wait:begin
      if(ready_phi_alphai==1'b1) begin 
        state_next=Armijo3_ready;
        num_next=num_start;
      end
      else begin 
        state_next=Armijo3_wait;
         if(num_next!=num_end)begin
        num_next=num_now+1;
        end
      end
    end
    Armijo3_ready:begin
      if(num_now==num_3)begin//
        if(compare_out==1'b1)  begin 
          state_next=Armijio_over; 
          result_alpha_satisfied=alpha2;
          valid_searchlength<=1'b1;
        end 
        else begin 
          if(flag_alpha2if==1'b1)begin
            state_next=Armijo_ify;
            num_next=num_start;
          end
          else begin
            state_next=Armijo_ifn;
              if(num_next!=num_end)begin
        num_next=num_now+1;
        end
          end
        end
      end
      else begin
        state_next=Armijo3_ready;
        num_next=num_now+1;
      end
    end
    Armijo_ify:begin
       if(num_now==num_1)begin
            state_next=Armijo3_start_loop;
            num_next=num_start;
        end
        else begin
            state_next=Armijo_ify;
            if(num_next!=num_end)begin
        num_next=num_now+1;
        end
      end
    end
    Armijo_ifn:begin
        state_next=Armijo3_start_loop;
        num_next=num_start;
    end
  endcase
end    
end            

always@(posedge clk) begin  
    if(!rst_SearchLength)begin 
        alpha0<=64'h3FF0000000000000;
         phi_alpha0<=phi1;
    end
  
  case(state_now)
        Armijo1:begin 
        compare_mulina<=phi_dif0;
        compare_mulinb<=64'h3F1A36E2E0000000;// 3C960AAD;//e^-4=32'h 3C960AAD=d0.01831563888873418029371802127324;
        compare_subina<=phi_alpha0;
        compare_subinb<=phi0;
        phi_alpha0_sub_phi0<=compare_subout;
        rho_phidif0<=compare_mulout;
        end
        Armijo2_start:begin    //2
            case(num_now)
            num_start:begin
                mul1_ina<=phi_dif0;
                mul1_inb<=64'hBFE0000000000000;//-0.5
                sub1_ina<=phi_alpha0_sub_phi0;
                sub1_inb<=phi_dif0;
            end
            num_1:begin
                B1<=sub1_out;
                div1_ina<=mul1_out;
                div1_inb<=sub1_out;
          end
            num_1+1+NUM_DIV:begin
                alpha1<=div1_out;
                rst_compute_phi<=1'b0;
                result_alpha_to_compute<=div1_out;
            end
            num_1+1+NUM_DIV+1:begin
                rst_compute_phi<=1'b1;
                 //flag_2<=flag_over;
            end
            endcase
        end
        Armijo2_wait: begin     //3
            if(ready_phi_alphai==1'b1) begin
                phi_alpha1<=phi_alphai_in;    //resultfunction
            end
        end 
        Armijo2_ready:begin  //4       判断第二个if
            compare_mulina<=rho_phidif0;
            compare_mulinb<=alpha1;
            compare_subina<=phi_alpha1;
            compare_subinb<=phi0;
            phi_alpha1_sub_phi0<=compare_subout;
        end
        Armijo3_wait: begin
            if(ready_phi_alphai==1'b1) begin
                phi_alpha2<=phi_alphai_in;
            end
        end 
          Armijo3_start_loop:begin   //8
        case(num_now)
          num_start:begin
                mul3_ina<=alpha0;
                mul3_inb<=alpha0;
                mul4_ina<=alpha1;
                mul4_inb<=alpha1;
                mul5_ina<=phi_dif0;
                mul5_inb<=alpha1;
                sub3_ina<=alpha1;
                sub3_inb<=alpha0;
          end
          num_1:begin
               alpha0_2<=mul3_out;
               mul3_ina<=mul3_out;//out is  alpha0_2
               mul3_inb<=alpha0;
               alpha1_2<=mul4_out;
               mul4_ina<=mul4_out;//out is  alpha1_2
               mul4_inb<=alpha1;
               mul5_ina<=mul3_out;//out is  alpha0_2
               mul5_inb<=mul4_out;
               mul6_ina<=mul4_out;//out is  alpha1_2
               mul6_inb<=B1;
               sub2_ina<=phi_alpha1_sub_phi0;
               sub2_inb<=mul5_out;//out is phi_dif0_alpha1;
          end
          num_2:begin
              B0<=sub2_out; 
              alpha1_2_B1<=mul6_out;
              mul3_ina<=mul5_out;
              mul3_inb<=sub3_out;
              mul4_ina<=alpha0_2;
              mul4_inb<=sub2_out;
              mul5_ina<=mul3_out;//out is alpha0_3
              mul5_inb<=sub2_out;
              mul6_ina<=mul4_out;//out is alpha1_3
              mul6_inb<=B1;
          end
          num_3:begin
             div1_ina<=64'h3FF0000000000000;//1
             div1_inb<=mul3_out;
             sub2_ina<=mul4_out;
             sub2_inb<=alpha1_2_B1;
             sub3_ina<=mul6_out;
             sub3_inb<=mul5_out;
          end
          num_4:begin
             A1<=sub3_out;
             mul3_ina<=sub2_out;
             mul3_inb<=64'h4008000000000000;
          end
          num_5:begin
            A0_3<=mul3_out;
          end
          num_3+1+NUM_DIV:begin
            mul4_ina<=A0_3;
            mul4_inb<=div1_out;
            mul5_ina<=A1;
            mul5_inb<=div1_out;
          end
          num_3+1+NUM_DIV+1:begin
            a3<=mul4_out;
            b<=mul5_out;  
          end
            num_3+1+NUM_DIV+1+1:begin
                mul1_ina<=b;
                mul1_inb<=b;
                mul2_ina<=a3;
                mul2_inb<=phi_dif0;
                div1_ina<=64'h3FF0000000000000;
                div1_inb<=a3;
           end
           num_3+1+NUM_DIV+1+1+num_1: begin 
              sub1_ina<=mul1_out;
              sub1_inb<=mul2_out;
           end
           num_3+1+NUM_DIV+1+1+num_2:begin 
              squroot_in<=sub1_out;
           end
           num_3+1+NUM_DIV+1+1+num_2+1+NUM_ROOT: begin 
                   sub2_ina<=squroot_out;
                   sub2_inb<=b;
           end
           num_3+1+NUM_DIV+1+1+num_2+1+NUM_ROOT+1: begin 
                   mul1_ina<=sub2_out;
                   mul1_inb<=div1_out;
           end
           num_3+1+NUM_DIV+1+1+num_2+1+NUM_ROOT+1+1: begin 
                  alpha2<=mul1_out;
                  rst_compute_phi<=1'b0;
                  result_alpha_to_compute<=mul1_out;      
           end
           num_3+1+NUM_DIV+1+1+num_2+1+NUM_ROOT+1+1+1: begin 
                  rst_compute_phi<=1'b1;
           end
          endcase
          end


          /*
            num_3+1+NUM_DIV+1+1:begin   //num12
                mul1_ina<=b;
                mul1_inb<=b;    //mul1_out = v^2
                mul2_ina<=a3;
                mul2_inb<=phi_dif0;    //mul2_out = 3u x phi_dif0
                div1_ina<=32'h3f800000;
                div1_inb<=a3;
           end
           num_3+1+NUM_DIV+1+1+num_1: begin  //num13
              sub1_ina<=mul1_out;
              sub1_inb<=mul2_out;
           end
           num_3+1+NUM_DIV+1+1+num_2:begin 
              squroot_in<=sub1_out;
           end
           num_3+1+NUM_DIV+1+1+num_2+1+NUM_ROOT: begin 
                   sub2_ina<=squroot_out;      
                   sub2_inb<=b;
           end*/

           //12.17
         /* num_3+1+NUM_DIV+1+1:begin   //num12
                //mul1_ina<=b;
               // mul1_inb<=b;    //mul1_out = v^2
                mul2_ina<=a3;
                mul2_inb<=phi_dif0;    //mul2_out = 3u x phi_dif0
                div1_ina<=32'h3f800000;
                div1_inb<=a3;
           end
           num_3+1+NUM_DIV+1+1+num_1: begin
              squroot_in<=mul2_out;
           end
           num_3+1+NUM_DIV+1+1+num_1+1+NUM_ROOT:begin
              sub1_ina<=b;
              sub1_inb<=squroot_out;
              add_ina<=b;
              add_inb<=squroot_out;
           end
           num_3+1+NUM_DIV+1+1+num_1+1+NUM_ROOT+1:begin  //20
              squroot_in<=sub1_out;
           end
           num_3+1+NUM_DIV+1+1+num_1+1+NUM_ROOT+1+1+NUM_ROOT:begin   //26
              mul1_ina<=squroot_out;
              squroot_in<=add_out;
           end
           num_3+1+NUM_DIV+1+1+num_1+1+NUM_ROOT+1+1+NUM_ROOT+1+NUM_ROOT:begin
              mul1_inb<=squroot_out;
           end
           num_3+1+NUM_DIV+1+1+num_1+1+NUM_ROOT+1+1+NUM_ROOT+1+NUM_ROOT+num_1:begin
                   sub2_ina<=mul1_out;      
                   sub2_inb<=b;
           end

           num_3+1+NUM_DIV+1+1+num_1+1+NUM_ROOT+1+1+NUM_ROOT+1+NUM_ROOT+num_1+1: begin 
                   mul1_ina<=sub2_out;
                   mul1_inb<=div1_out;    //1/3u
           end
           num_3+1+NUM_DIV+1+1+num_1+1+NUM_ROOT+1+1+NUM_ROOT+1+NUM_ROOT+num_1+1+1: begin 
                  alpha2<=mul1_out;
                  rst_compute_phi<=1'b0;
                  result_alpha_to_compute<=mul1_out;      
           end
           num_3+1+NUM_DIV+1+1+num_1+1+NUM_ROOT+1+1+NUM_ROOT+1+NUM_ROOT+num_1+1+1+1: begin 
                  rst_compute_phi<=1'b1;
           end*/
         
        Armijo3_ready:begin
            compare_mulina<=rho_phidif0;
            compare_mulinb<=alpha2;
            compare_subina<=phi_alpha2;
            compare_subinb<=phi0;
            phi_alpha2_sub_phi0<=compare_subout;
      end 
      
      Armijo_ify:begin
           if(num_now==num_start)begin
                alpha0<=alpha1;
                phi_alpha0<=phi_alpha1;
                phi_alpha1<=phi_alpha2;
                phi_alpha1_sub_phi0<=phi_alpha2_sub_phi0;
                B1<=B0;
                mul1_ina<=alpha1;
                mul1_inb<=64'h3FE0000000000000;//0.5
            end
            if(num_now==num_1)begin
                alpha1<=mul1_out;
            end
      end
      Armijo_ifn:begin
            alpha0<=alpha1;
            alpha1<=alpha2;
            phi_alpha0<=phi_alpha1;
            phi_alpha1<=phi_alpha2;
            phi_alpha1_sub_phi0<=phi_alpha2_sub_phi0;
            B1<=B0;
      end   

     
        endcase
       end
        


    
endmodule
