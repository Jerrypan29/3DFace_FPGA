// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Mon Jul 29 04:28:02 2024
// Host        : cat running 64-bit CentOS Linux release 7.9.2009 (Core)
// Command     : write_verilog -force -mode synth_stub {/home/panhaoran/work/BFGS/large
//               fpga/64_3.21_idmatrix_32/LinearSearch_facescape.srcs/sources_1/ip/float_squareroot/float_squareroot_stub.v}
// Design      : float_squareroot
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu19p-fsva3824-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "floating_point_v7_1_13,Vivado 2021.2" *)
module float_squareroot(aclk, s_axis_a_tvalid, s_axis_a_tdata, 
  m_axis_result_tvalid, m_axis_result_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_a_tvalid,s_axis_a_tdata[63:0],m_axis_result_tvalid,m_axis_result_tdata[63:0]" */;
  input aclk;
  input s_axis_a_tvalid;
  input [63:0]s_axis_a_tdata;
  output m_axis_result_tvalid;
  output [63:0]m_axis_result_tdata;
endmodule
