// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Mon Jul 29 04:30:11 2024
// Host        : cat running 64-bit CentOS Linux release 7.9.2009 (Core)
// Command     : write_verilog -force -mode synth_stub {/home/panhaoran/work/BFGS/large
//               fpga/BFGS64_opt/LinearSearch_facescape.srcs/sources_1/ip/dist_mem_80_32/dist_mem_80_32_stub.v}
// Design      : dist_mem_80_32
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu19p-fsva3824-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2021.2" *)
module dist_mem_80_32(a, d, dpra, clk, we, dpo)
/* synthesis syn_black_box black_box_pad_pin="a[5:0],d[31:0],dpra[5:0],clk,we,dpo[31:0]" */;
  input [5:0]a;
  input [31:0]d;
  input [5:0]dpra;
  input clk;
  input we;
  output [31:0]dpo;
endmodule
