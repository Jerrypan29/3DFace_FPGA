-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
-- Date        : Mon Jul 29 04:27:48 2024
-- Host        : cat running 64-bit CentOS Linux release 7.9.2009 (Core)
-- Command     : write_vhdl -force -mode synth_stub {/home/panhaoran/work/BFGS/large
--               fpga/64_3.21_idmatrix_32/LinearSearch_facescape.srcs/sources_1/ip/dist_mem_lmpos/dist_mem_lmpos_stub.vhdl}
-- Design      : dist_mem_lmpos
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcvu19p-fsva3824-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dist_mem_lmpos is
  Port ( 
    a : in STD_LOGIC_VECTOR ( 6 downto 0 );
    d : in STD_LOGIC_VECTOR ( 63 downto 0 );
    dpra : in STD_LOGIC_VECTOR ( 6 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    dpo : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );

end dist_mem_lmpos;

architecture stub of dist_mem_lmpos is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "a[6:0],d[63:0],dpra[6:0],clk,we,dpo[63:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dist_mem_gen_v8_0_13,Vivado 2021.2";
begin
end;
