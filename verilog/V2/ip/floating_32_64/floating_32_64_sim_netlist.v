// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Tue Dec 26 21:43:18 2023
// Host        : DESKTOP-DLOSRD5 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               C:/Users/Dell/Desktop/prj_bfgs/project_1.srcs/sources_1/ip/floating_32_64/floating_32_64_sim_netlist.v
// Design      : floating_32_64
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx485tffg1157-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "floating_32_64,floating_point_v7_1_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "floating_point_v7_1_9,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module floating_32_64
   (aclk,
    s_axis_a_tvalid,
    s_axis_a_tdata,
    m_axis_result_tvalid,
    m_axis_result_tdata);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 aclk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME aclk_intf, ASSOCIATED_BUSIF S_AXIS_OPERATION:M_AXIS_RESULT:S_AXIS_C:S_AXIS_B:S_AXIS_A, ASSOCIATED_RESET aresetn, ASSOCIATED_CLKEN aclken, FREQ_HZ 10000000, PHASE 0.000, INSERT_VIP 0" *) input aclk;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_A TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS_A, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0" *) input s_axis_a_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_A TDATA" *) input [31:0]s_axis_a_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME M_AXIS_RESULT, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0" *) output m_axis_result_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TDATA" *) output [63:0]m_axis_result_tdata;

  wire aclk;
  wire [63:0]m_axis_result_tdata;
  wire m_axis_result_tvalid;
  wire [31:0]s_axis_a_tdata;
  wire s_axis_a_tvalid;
  wire NLW_U0_m_axis_result_tlast_UNCONNECTED;
  wire NLW_U0_s_axis_a_tready_UNCONNECTED;
  wire NLW_U0_s_axis_b_tready_UNCONNECTED;
  wire NLW_U0_s_axis_c_tready_UNCONNECTED;
  wire NLW_U0_s_axis_operation_tready_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_result_tuser_UNCONNECTED;

  (* C_ACCUM_INPUT_MSB = "32" *) 
  (* C_ACCUM_LSB = "-31" *) 
  (* C_ACCUM_MSB = "32" *) 
  (* C_A_FRACTION_WIDTH = "24" *) 
  (* C_A_TDATA_WIDTH = "32" *) 
  (* C_A_TUSER_WIDTH = "1" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_BRAM_USAGE = "0" *) 
  (* C_B_FRACTION_WIDTH = "24" *) 
  (* C_B_TDATA_WIDTH = "32" *) 
  (* C_B_TUSER_WIDTH = "1" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_COMPARE_OPERATION = "8" *) 
  (* C_C_FRACTION_WIDTH = "24" *) 
  (* C_C_TDATA_WIDTH = "32" *) 
  (* C_C_TUSER_WIDTH = "1" *) 
  (* C_C_WIDTH = "32" *) 
  (* C_FIXED_DATA_UNSIGNED = "0" *) 
  (* C_HAS_ABSOLUTE = "0" *) 
  (* C_HAS_ACCUMULATOR_A = "0" *) 
  (* C_HAS_ACCUMULATOR_PRIMITIVE_A = "0" *) 
  (* C_HAS_ACCUMULATOR_PRIMITIVE_S = "0" *) 
  (* C_HAS_ACCUMULATOR_S = "0" *) 
  (* C_HAS_ACCUM_INPUT_OVERFLOW = "0" *) 
  (* C_HAS_ACCUM_OVERFLOW = "0" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_ADD = "0" *) 
  (* C_HAS_ARESETN = "0" *) 
  (* C_HAS_A_TLAST = "0" *) 
  (* C_HAS_A_TUSER = "0" *) 
  (* C_HAS_B = "0" *) 
  (* C_HAS_B_TLAST = "0" *) 
  (* C_HAS_B_TUSER = "0" *) 
  (* C_HAS_C = "0" *) 
  (* C_HAS_COMPARE = "0" *) 
  (* C_HAS_C_TLAST = "0" *) 
  (* C_HAS_C_TUSER = "0" *) 
  (* C_HAS_DIVIDE = "0" *) 
  (* C_HAS_DIVIDE_BY_ZERO = "0" *) 
  (* C_HAS_EXPONENTIAL = "0" *) 
  (* C_HAS_FIX_TO_FLT = "0" *) 
  (* C_HAS_FLT_TO_FIX = "0" *) 
  (* C_HAS_FLT_TO_FLT = "1" *) 
  (* C_HAS_FMA = "0" *) 
  (* C_HAS_FMS = "0" *) 
  (* C_HAS_INVALID_OP = "0" *) 
  (* C_HAS_LOGARITHM = "0" *) 
  (* C_HAS_MULTIPLY = "0" *) 
  (* C_HAS_OPERATION = "0" *) 
  (* C_HAS_OPERATION_TLAST = "0" *) 
  (* C_HAS_OPERATION_TUSER = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_RECIP = "0" *) 
  (* C_HAS_RECIP_SQRT = "0" *) 
  (* C_HAS_RESULT_TLAST = "0" *) 
  (* C_HAS_RESULT_TUSER = "0" *) 
  (* C_HAS_SQRT = "0" *) 
  (* C_HAS_SUBTRACT = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_ACCUMULATOR_A = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_ACCUMULATOR_S = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_ADD = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_SUB = "0" *) 
  (* C_LATENCY = "2" *) 
  (* C_MULT_USAGE = "0" *) 
  (* C_OPERATION_TDATA_WIDTH = "8" *) 
  (* C_OPERATION_TUSER_WIDTH = "1" *) 
  (* C_OPTIMIZATION = "1" *) 
  (* C_RATE = "1" *) 
  (* C_RESULT_FRACTION_WIDTH = "53" *) 
  (* C_RESULT_TDATA_WIDTH = "64" *) 
  (* C_RESULT_TUSER_WIDTH = "1" *) 
  (* C_RESULT_WIDTH = "64" *) 
  (* C_THROTTLE_SCHEME = "3" *) 
  (* C_TLAST_RESOLUTION = "0" *) 
  (* C_XDEVICEFAMILY = "virtex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  floating_32_64_floating_point_v7_1_9 U0
       (.aclk(aclk),
        .aclken(1'b1),
        .aresetn(1'b1),
        .m_axis_result_tdata(m_axis_result_tdata),
        .m_axis_result_tlast(NLW_U0_m_axis_result_tlast_UNCONNECTED),
        .m_axis_result_tready(1'b0),
        .m_axis_result_tuser(NLW_U0_m_axis_result_tuser_UNCONNECTED[0]),
        .m_axis_result_tvalid(m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata),
        .s_axis_a_tlast(1'b0),
        .s_axis_a_tready(NLW_U0_s_axis_a_tready_UNCONNECTED),
        .s_axis_a_tuser(1'b0),
        .s_axis_a_tvalid(s_axis_a_tvalid),
        .s_axis_b_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_b_tlast(1'b0),
        .s_axis_b_tready(NLW_U0_s_axis_b_tready_UNCONNECTED),
        .s_axis_b_tuser(1'b0),
        .s_axis_b_tvalid(1'b0),
        .s_axis_c_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_c_tlast(1'b0),
        .s_axis_c_tready(NLW_U0_s_axis_c_tready_UNCONNECTED),
        .s_axis_c_tuser(1'b0),
        .s_axis_c_tvalid(1'b0),
        .s_axis_operation_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_operation_tlast(1'b0),
        .s_axis_operation_tready(NLW_U0_s_axis_operation_tready_UNCONNECTED),
        .s_axis_operation_tuser(1'b0),
        .s_axis_operation_tvalid(1'b0));
endmodule

(* C_ACCUM_INPUT_MSB = "32" *) (* C_ACCUM_LSB = "-31" *) (* C_ACCUM_MSB = "32" *) 
(* C_A_FRACTION_WIDTH = "24" *) (* C_A_TDATA_WIDTH = "32" *) (* C_A_TUSER_WIDTH = "1" *) 
(* C_A_WIDTH = "32" *) (* C_BRAM_USAGE = "0" *) (* C_B_FRACTION_WIDTH = "24" *) 
(* C_B_TDATA_WIDTH = "32" *) (* C_B_TUSER_WIDTH = "1" *) (* C_B_WIDTH = "32" *) 
(* C_COMPARE_OPERATION = "8" *) (* C_C_FRACTION_WIDTH = "24" *) (* C_C_TDATA_WIDTH = "32" *) 
(* C_C_TUSER_WIDTH = "1" *) (* C_C_WIDTH = "32" *) (* C_FIXED_DATA_UNSIGNED = "0" *) 
(* C_HAS_ABSOLUTE = "0" *) (* C_HAS_ACCUMULATOR_A = "0" *) (* C_HAS_ACCUMULATOR_PRIMITIVE_A = "0" *) 
(* C_HAS_ACCUMULATOR_PRIMITIVE_S = "0" *) (* C_HAS_ACCUMULATOR_S = "0" *) (* C_HAS_ACCUM_INPUT_OVERFLOW = "0" *) 
(* C_HAS_ACCUM_OVERFLOW = "0" *) (* C_HAS_ACLKEN = "0" *) (* C_HAS_ADD = "0" *) 
(* C_HAS_ARESETN = "0" *) (* C_HAS_A_TLAST = "0" *) (* C_HAS_A_TUSER = "0" *) 
(* C_HAS_B = "0" *) (* C_HAS_B_TLAST = "0" *) (* C_HAS_B_TUSER = "0" *) 
(* C_HAS_C = "0" *) (* C_HAS_COMPARE = "0" *) (* C_HAS_C_TLAST = "0" *) 
(* C_HAS_C_TUSER = "0" *) (* C_HAS_DIVIDE = "0" *) (* C_HAS_DIVIDE_BY_ZERO = "0" *) 
(* C_HAS_EXPONENTIAL = "0" *) (* C_HAS_FIX_TO_FLT = "0" *) (* C_HAS_FLT_TO_FIX = "0" *) 
(* C_HAS_FLT_TO_FLT = "1" *) (* C_HAS_FMA = "0" *) (* C_HAS_FMS = "0" *) 
(* C_HAS_INVALID_OP = "0" *) (* C_HAS_LOGARITHM = "0" *) (* C_HAS_MULTIPLY = "0" *) 
(* C_HAS_OPERATION = "0" *) (* C_HAS_OPERATION_TLAST = "0" *) (* C_HAS_OPERATION_TUSER = "0" *) 
(* C_HAS_OVERFLOW = "0" *) (* C_HAS_RECIP = "0" *) (* C_HAS_RECIP_SQRT = "0" *) 
(* C_HAS_RESULT_TLAST = "0" *) (* C_HAS_RESULT_TUSER = "0" *) (* C_HAS_SQRT = "0" *) 
(* C_HAS_SUBTRACT = "0" *) (* C_HAS_UNDERFLOW = "0" *) (* C_HAS_UNFUSED_MULTIPLY_ACCUMULATOR_A = "0" *) 
(* C_HAS_UNFUSED_MULTIPLY_ACCUMULATOR_S = "0" *) (* C_HAS_UNFUSED_MULTIPLY_ADD = "0" *) (* C_HAS_UNFUSED_MULTIPLY_SUB = "0" *) 
(* C_LATENCY = "2" *) (* C_MULT_USAGE = "0" *) (* C_OPERATION_TDATA_WIDTH = "8" *) 
(* C_OPERATION_TUSER_WIDTH = "1" *) (* C_OPTIMIZATION = "1" *) (* C_RATE = "1" *) 
(* C_RESULT_FRACTION_WIDTH = "53" *) (* C_RESULT_TDATA_WIDTH = "64" *) (* C_RESULT_TUSER_WIDTH = "1" *) 
(* C_RESULT_WIDTH = "64" *) (* C_THROTTLE_SCHEME = "3" *) (* C_TLAST_RESOLUTION = "0" *) 
(* C_XDEVICEFAMILY = "virtex7" *) (* ORIG_REF_NAME = "floating_point_v7_1_9" *) (* downgradeipidentifiedwarnings = "yes" *) 
module floating_32_64_floating_point_v7_1_9
   (aclk,
    aclken,
    aresetn,
    s_axis_a_tvalid,
    s_axis_a_tready,
    s_axis_a_tdata,
    s_axis_a_tuser,
    s_axis_a_tlast,
    s_axis_b_tvalid,
    s_axis_b_tready,
    s_axis_b_tdata,
    s_axis_b_tuser,
    s_axis_b_tlast,
    s_axis_c_tvalid,
    s_axis_c_tready,
    s_axis_c_tdata,
    s_axis_c_tuser,
    s_axis_c_tlast,
    s_axis_operation_tvalid,
    s_axis_operation_tready,
    s_axis_operation_tdata,
    s_axis_operation_tuser,
    s_axis_operation_tlast,
    m_axis_result_tvalid,
    m_axis_result_tready,
    m_axis_result_tdata,
    m_axis_result_tuser,
    m_axis_result_tlast);
  input aclk;
  input aclken;
  input aresetn;
  input s_axis_a_tvalid;
  output s_axis_a_tready;
  input [31:0]s_axis_a_tdata;
  input [0:0]s_axis_a_tuser;
  input s_axis_a_tlast;
  input s_axis_b_tvalid;
  output s_axis_b_tready;
  input [31:0]s_axis_b_tdata;
  input [0:0]s_axis_b_tuser;
  input s_axis_b_tlast;
  input s_axis_c_tvalid;
  output s_axis_c_tready;
  input [31:0]s_axis_c_tdata;
  input [0:0]s_axis_c_tuser;
  input s_axis_c_tlast;
  input s_axis_operation_tvalid;
  output s_axis_operation_tready;
  input [7:0]s_axis_operation_tdata;
  input [0:0]s_axis_operation_tuser;
  input s_axis_operation_tlast;
  output m_axis_result_tvalid;
  input m_axis_result_tready;
  output [63:0]m_axis_result_tdata;
  output [0:0]m_axis_result_tuser;
  output m_axis_result_tlast;

  wire \<const0> ;
  wire \<const1> ;
  wire aclk;
  wire [63:29]\^m_axis_result_tdata ;
  wire m_axis_result_tvalid;
  wire [31:0]s_axis_a_tdata;
  wire s_axis_a_tvalid;
  wire NLW_i_synth_m_axis_result_tlast_UNCONNECTED;
  wire NLW_i_synth_s_axis_a_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_b_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_c_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_operation_tready_UNCONNECTED;
  wire [60:0]NLW_i_synth_m_axis_result_tdata_UNCONNECTED;
  wire [0:0]NLW_i_synth_m_axis_result_tuser_UNCONNECTED;

  assign m_axis_result_tdata[63:62] = \^m_axis_result_tdata [63:62];
  assign m_axis_result_tdata[61] = \^m_axis_result_tdata [59];
  assign m_axis_result_tdata[60] = \^m_axis_result_tdata [59];
  assign m_axis_result_tdata[59:29] = \^m_axis_result_tdata [59:29];
  assign m_axis_result_tdata[28] = \<const0> ;
  assign m_axis_result_tdata[27] = \<const0> ;
  assign m_axis_result_tdata[26] = \<const0> ;
  assign m_axis_result_tdata[25] = \<const0> ;
  assign m_axis_result_tdata[24] = \<const0> ;
  assign m_axis_result_tdata[23] = \<const0> ;
  assign m_axis_result_tdata[22] = \<const0> ;
  assign m_axis_result_tdata[21] = \<const0> ;
  assign m_axis_result_tdata[20] = \<const0> ;
  assign m_axis_result_tdata[19] = \<const0> ;
  assign m_axis_result_tdata[18] = \<const0> ;
  assign m_axis_result_tdata[17] = \<const0> ;
  assign m_axis_result_tdata[16] = \<const0> ;
  assign m_axis_result_tdata[15] = \<const0> ;
  assign m_axis_result_tdata[14] = \<const0> ;
  assign m_axis_result_tdata[13] = \<const0> ;
  assign m_axis_result_tdata[12] = \<const0> ;
  assign m_axis_result_tdata[11] = \<const0> ;
  assign m_axis_result_tdata[10] = \<const0> ;
  assign m_axis_result_tdata[9] = \<const0> ;
  assign m_axis_result_tdata[8] = \<const0> ;
  assign m_axis_result_tdata[7] = \<const0> ;
  assign m_axis_result_tdata[6] = \<const0> ;
  assign m_axis_result_tdata[5] = \<const0> ;
  assign m_axis_result_tdata[4] = \<const0> ;
  assign m_axis_result_tdata[3] = \<const0> ;
  assign m_axis_result_tdata[2] = \<const0> ;
  assign m_axis_result_tdata[1] = \<const0> ;
  assign m_axis_result_tdata[0] = \<const0> ;
  assign m_axis_result_tlast = \<const0> ;
  assign m_axis_result_tuser[0] = \<const0> ;
  assign s_axis_a_tready = \<const1> ;
  assign s_axis_b_tready = \<const1> ;
  assign s_axis_c_tready = \<const1> ;
  assign s_axis_operation_tready = \<const1> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  (* C_ACCUM_INPUT_MSB = "32" *) 
  (* C_ACCUM_LSB = "-31" *) 
  (* C_ACCUM_MSB = "32" *) 
  (* C_A_FRACTION_WIDTH = "24" *) 
  (* C_A_TDATA_WIDTH = "32" *) 
  (* C_A_TUSER_WIDTH = "1" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_BRAM_USAGE = "0" *) 
  (* C_B_FRACTION_WIDTH = "24" *) 
  (* C_B_TDATA_WIDTH = "32" *) 
  (* C_B_TUSER_WIDTH = "1" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_COMPARE_OPERATION = "8" *) 
  (* C_C_FRACTION_WIDTH = "24" *) 
  (* C_C_TDATA_WIDTH = "32" *) 
  (* C_C_TUSER_WIDTH = "1" *) 
  (* C_C_WIDTH = "32" *) 
  (* C_FIXED_DATA_UNSIGNED = "0" *) 
  (* C_HAS_ABSOLUTE = "0" *) 
  (* C_HAS_ACCUMULATOR_A = "0" *) 
  (* C_HAS_ACCUMULATOR_PRIMITIVE_A = "0" *) 
  (* C_HAS_ACCUMULATOR_PRIMITIVE_S = "0" *) 
  (* C_HAS_ACCUMULATOR_S = "0" *) 
  (* C_HAS_ACCUM_INPUT_OVERFLOW = "0" *) 
  (* C_HAS_ACCUM_OVERFLOW = "0" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_ADD = "0" *) 
  (* C_HAS_ARESETN = "0" *) 
  (* C_HAS_A_TLAST = "0" *) 
  (* C_HAS_A_TUSER = "0" *) 
  (* C_HAS_B = "0" *) 
  (* C_HAS_B_TLAST = "0" *) 
  (* C_HAS_B_TUSER = "0" *) 
  (* C_HAS_C = "0" *) 
  (* C_HAS_COMPARE = "0" *) 
  (* C_HAS_C_TLAST = "0" *) 
  (* C_HAS_C_TUSER = "0" *) 
  (* C_HAS_DIVIDE = "0" *) 
  (* C_HAS_DIVIDE_BY_ZERO = "0" *) 
  (* C_HAS_EXPONENTIAL = "0" *) 
  (* C_HAS_FIX_TO_FLT = "0" *) 
  (* C_HAS_FLT_TO_FIX = "0" *) 
  (* C_HAS_FLT_TO_FLT = "1" *) 
  (* C_HAS_FMA = "0" *) 
  (* C_HAS_FMS = "0" *) 
  (* C_HAS_INVALID_OP = "0" *) 
  (* C_HAS_LOGARITHM = "0" *) 
  (* C_HAS_MULTIPLY = "0" *) 
  (* C_HAS_OPERATION = "0" *) 
  (* C_HAS_OPERATION_TLAST = "0" *) 
  (* C_HAS_OPERATION_TUSER = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_RECIP = "0" *) 
  (* C_HAS_RECIP_SQRT = "0" *) 
  (* C_HAS_RESULT_TLAST = "0" *) 
  (* C_HAS_RESULT_TUSER = "0" *) 
  (* C_HAS_SQRT = "0" *) 
  (* C_HAS_SUBTRACT = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_ACCUMULATOR_A = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_ACCUMULATOR_S = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_ADD = "0" *) 
  (* C_HAS_UNFUSED_MULTIPLY_SUB = "0" *) 
  (* C_LATENCY = "2" *) 
  (* C_MULT_USAGE = "0" *) 
  (* C_OPERATION_TDATA_WIDTH = "8" *) 
  (* C_OPERATION_TUSER_WIDTH = "1" *) 
  (* C_OPTIMIZATION = "1" *) 
  (* C_RATE = "1" *) 
  (* C_RESULT_FRACTION_WIDTH = "53" *) 
  (* C_RESULT_TDATA_WIDTH = "64" *) 
  (* C_RESULT_TUSER_WIDTH = "1" *) 
  (* C_RESULT_WIDTH = "64" *) 
  (* C_THROTTLE_SCHEME = "3" *) 
  (* C_TLAST_RESOLUTION = "0" *) 
  (* C_XDEVICEFAMILY = "virtex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  floating_32_64_floating_point_v7_1_9_viv i_synth
       (.aclk(aclk),
        .aclken(1'b0),
        .aresetn(1'b0),
        .m_axis_result_tdata({\^m_axis_result_tdata [63:62],\^m_axis_result_tdata [59],NLW_i_synth_m_axis_result_tdata_UNCONNECTED[60:59],\^m_axis_result_tdata [58:29],NLW_i_synth_m_axis_result_tdata_UNCONNECTED[28:0]}),
        .m_axis_result_tlast(NLW_i_synth_m_axis_result_tlast_UNCONNECTED),
        .m_axis_result_tready(1'b0),
        .m_axis_result_tuser(NLW_i_synth_m_axis_result_tuser_UNCONNECTED[0]),
        .m_axis_result_tvalid(m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata),
        .s_axis_a_tlast(1'b0),
        .s_axis_a_tready(NLW_i_synth_s_axis_a_tready_UNCONNECTED),
        .s_axis_a_tuser(1'b0),
        .s_axis_a_tvalid(s_axis_a_tvalid),
        .s_axis_b_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_b_tlast(1'b0),
        .s_axis_b_tready(NLW_i_synth_s_axis_b_tready_UNCONNECTED),
        .s_axis_b_tuser(1'b0),
        .s_axis_b_tvalid(1'b0),
        .s_axis_c_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_c_tlast(1'b0),
        .s_axis_c_tready(NLW_i_synth_s_axis_c_tready_UNCONNECTED),
        .s_axis_c_tuser(1'b0),
        .s_axis_c_tvalid(1'b0),
        .s_axis_operation_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_operation_tlast(1'b0),
        .s_axis_operation_tready(NLW_i_synth_s_axis_operation_tready_UNCONNECTED),
        .s_axis_operation_tuser(1'b0),
        .s_axis_operation_tvalid(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
AjZB+YVLd1bTTa3WQVDZlW8SmeBH1XsEnW+cd9vBo88QDxI5OnPvKDRv7dLl9m6fF2bToriQttjX
EVbwPEdtWA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
pZ6Sc104qCnNiKGoLJZ9crkD/EMrEX083KVoG1qkYhUTWB6FL12Zoz4AlAEtTS7wMZX3hnhQizz2
w/8JTalvLaVb3+84yFptB16n/caxZqC387B8OJ+rUqlU9i0FvXdj0oLV+zC1aUGz4NnNJGGECNJY
JOMJyoyszss2JGTfCUc=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ZSlnSztvgpRUQP6Gk9jZgQM3X58QrkBrUva/G1n2j9vQqI7pY//DdMmu54WB7d7cmGU/yeFSPyy6
+ko9o6RaPvAOr4ofgFZ+++Q54YWrUY+IlR9TVY2OEra7l9B/oEgGxRqXrmoUTy86F9kBbiEtJFf2
B6Cw7YEWokaAi4ExPfZCvW/E4iKePPuYeanwibn06ZLgMHQ7PUXi9ENXFAmIPdPuT7BigBm60214
2eXMakfo3bhj5eF5EFs0skrKhq4fPqdda2PdiR95ZynbZtbuzHeEczc3EW6RtXaMxxMZin5IPARz
7p8ncWfmJjHWjVnUQ2U9ih9XRaaEhv41NvIj2w==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
uU/BOVQ04gMjsTE2xf7l6wF035bngTUwhIFMcb7kOaZSIHqrd99S0J5ndJBUPvVbLPZEy1unGPtC
tBwkIrNCmonX4x/VE313gi1MbstvovReF4auAaCDnSKe8PONAzldyzXzaUnjv+07ETeqbrUCiHzK
3SA3sucV677rW14m/x4Jgvfm0F88nlBu9j3F+p6C7shd4emv/5pTa5+JUBIEkiCWQog+zLQNCnsr
jlPlOi0AiTYQkQUDNmo0vxcvMZ0CGnF/T1Gad8Orirs3MUr68jFUvS/U1z013SUUrnI9WruDQVBb
yie+gRf7eF+UTtjtqnvbK6r4zU+ed+0S2ocXtQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UxeuCiEbyQMyXkSYONtECmLrU4LpHM+flSFspv2dZPSz/LD2JGLLBufpYzLZhWjYqeEi+DvyNAC7
Ae5kyiNsR2+BTuYde55y/JsH1fOwHMLIInw3HVnW60KY40/RaH4xZ+v2T4sHNaSRgMAGvUVMslnX
63U8XzRJCvIkFIHTAfSh2mizW2xQDSWE7O9aWnb+wfHzNQsBxvBw+wlTUkVrUdz24dgrg+vYsNjt
IBHNCHWOcx1m5jgJmhCZRxBMSHSs+bJmL2ZaxN5I7aO0qhHCSzs0SGT6z94h4j7khKJSY7hNJuLo
BlZ/jDu+H25WUiUajpW+gqT5vYJT4C/vl6wRNg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
VddFTyDGw+IoWQ+5Axqhm9zHBmBDlLzN/0wDa2XfUUGWSDcC6df3L1o/0jCIkMzXg9Zcnz7dAPid
E20SEOTmm1gZZ2LdOfWySQxBjuNuqlMBxQlFfwksr8s+YrmVkqacvmjPOzKipO6OxdJybRkGTV8D
JdWUyR12kGSnn1gd4Rc=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
aln1xJ/D3cPv6b1D4QZIDmheM6mGLg5cjAj+/HaeWzVAOTyVwnyjHAYj6/hRnLk6vJ46tCy+opLu
U19OzlJMFQbichN++UIWLo+x+Is6UgYNBIYcRMp1RlCsvs6eGVaGgyM9YJFx6lLHHgF9qCQmVMxI
NZDhUcbb79cloWuhddwTLoZ+KpbXi0Rog9T/yqACDibfi/TAY/cVnGp2utcxHcksaoY3K6ZLqM5Y
PRlu5oKePXfePWZtKbrb+A71EXvpqyd6fyRf+RgdlcuVhzuRjF8C6caK+ZgWUpFYEapBIUcGmE7P
UjmuQ27qRmIxzwEZjVZ9DoM6JV8iulBuVRPlfw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
G0blZXyfhFOdWvGQRAEvUBoxqUsL0Y6pvnmlrnRKHvq11cUaM7iPu6qQSKMOTbaDhj7txHqVG5hY
Y+L+ttkoxHIeV4Jvwad3DdSFeno1UwFdE2948ZGJFwx4+bZ+jOWE+e/xlaBfDdp0+rLBmSZ6iEbK
Du7mZ05rKyEE3/+sp06gy9rmGizmr75uZIx6s4det2dvZ5OEPAfkoY/zulTYCn0J7qrVhkjVc3FI
Jzax7p0D4AeSWElIH9I6C/pCJeugy6wVPB50r/Pm5HSPNCtqp4eXsTSU1a1C+9MX3pp1UH4Jlc2e
tP6Oc+j1sRDOv3WkhlnRqfFk5VL038voavcc9g==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eN0f5PI39NOLnlYqzENyMxjuIPsBd6fxX2ie5tPXHzPGgywlc1uZF4cv7K29BmuUzZgA8G3r8vkW
t3NEvN2x0IolSUBvML9PdzkechWvyfPTgMmjx+Tz3wpMxtmzhSwEuPzBxOLtd8exHZG6jMHCKT7z
fsrueF6QACoJbpBN0ADjZ8CuU2czpHrTOsDs0Udh84HK4LTkv82mT23me6w6iUiutAK0DTtZ8ZQB
K+Th5s92+hA6ELUBjHxoew7IwaNtBmwU8yDadgmq7nQnKeiKkDC8/X3D1+4glqMz+g5wJ8qY4fcz
ORmoEfeT0iQzDd9UxT2/U4dhCv/k5MTWrY5kwA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
dZMv9FEG6fGiVSt2W0rref8PU2a3rkfSzve57G5xxPUis8wyptPAgPD+mG/lFhX5wBlFgy1pBLX4
zej58F4MFQLB+AGyuxsmXmQuc0PZwgdOOF17NsRPXTGj8PIE7H0xRh4Pb0IefUyCqUAbFwDxPSJ5
wsqfwotnkJNOMNZiH5SIENdBMo2Y2newjmuVE1F0TtAp0IZhD7PbOpXXiRzSSYaIw0ozqZqMkAK2
Kg9dIub1LRPyQvyS4ZgC8ikYnbwu+JSEjovDoD+1npXxfHrZQh5ZvHgbOd8d2HynSqTjFR4CoYfP
hmtCXZU31jUMIEwXUYcQncmCU4GMsiBtHxQDdQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 39584)
`pragma protect data_block
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
0saRBSESh8MYjhmowSxDV9MhEu2NVABS02g=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
