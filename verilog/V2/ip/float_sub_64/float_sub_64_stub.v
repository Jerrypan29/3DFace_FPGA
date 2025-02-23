// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Tue Dec 26 21:51:58 2023
// Host        : DESKTOP-DLOSRD5 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/Dell/Desktop/ibfgs/verilog/LinearSearch_facescape.srcs/sources_1/ip/float_sub_64/float_sub_64_stub.v
// Design      : float_sub_64
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1157-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "floating_point_v7_1_9,Vivado 2019.2" *)
module float_sub_64(aclk, s_axis_a_tvalid, s_axis_a_tdata, 
  s_axis_b_tvalid, s_axis_b_tdata, m_axis_result_tvalid, m_axis_result_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_a_tvalid,s_axis_a_tdata[63:0],s_axis_b_tvalid,s_axis_b_tdata[63:0],m_axis_result_tvalid,m_axis_result_tdata[63:0]" */;
  input aclk;
  input s_axis_a_tvalid;
  input [63:0]s_axis_a_tdata;
  input s_axis_b_tvalid;
  input [63:0]s_axis_b_tdata;
  output m_axis_result_tvalid;
  output [63:0]m_axis_result_tdata;
endmodule
