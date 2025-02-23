// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Mon Jul 29 04:30:11 2024
// Host        : cat running 64-bit CentOS Linux release 7.9.2009 (Core)
// Command     : write_verilog -force -mode funcsim {/home/panhaoran/work/BFGS/large
//               fpga/BFGS64_opt/LinearSearch_facescape.srcs/sources_1/ip/dist_mem_80_32/dist_mem_80_32_sim_netlist.v}
// Design      : dist_mem_80_32
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcvu19p-fsva3824-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dist_mem_80_32,dist_mem_gen_v8_0_13,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module dist_mem_80_32
   (a,
    d,
    dpra,
    clk,
    we,
    dpo);
  input [5:0]a;
  input [31:0]d;
  input [5:0]dpra;
  input clk;
  input we;
  output [31:0]dpo;

  wire [5:0]a;
  wire clk;
  wire [31:0]d;
  wire [31:0]dpo;
  wire [5:0]dpra;
  wire we;
  wire [31:0]NLW_U0_qdpo_UNCONNECTED;
  wire [31:0]NLW_U0_qspo_UNCONNECTED;
  wire [31:0]NLW_U0_spo_UNCONNECTED;

  (* C_FAMILY = "virtexuplus" *) 
  (* C_HAS_CLK = "1" *) 
  (* C_HAS_D = "1" *) 
  (* C_HAS_DPO = "1" *) 
  (* C_HAS_DPRA = "1" *) 
  (* C_HAS_QDPO = "0" *) 
  (* C_HAS_QDPO_CE = "0" *) 
  (* C_HAS_QDPO_CLK = "0" *) 
  (* C_HAS_QDPO_RST = "0" *) 
  (* C_HAS_QDPO_SRST = "0" *) 
  (* C_HAS_QSPO = "0" *) 
  (* C_HAS_QSPO_RST = "0" *) 
  (* C_HAS_QSPO_SRST = "0" *) 
  (* C_HAS_SPO = "0" *) 
  (* C_HAS_WE = "1" *) 
  (* C_MEM_TYPE = "4" *) 
  (* C_REG_DPRA_INPUT = "0" *) 
  (* c_addr_width = "6" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "64" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_i_ce = "0" *) 
  (* c_has_qspo_ce = "0" *) 
  (* c_mem_init_file = "dist_mem_80_32.mif" *) 
  (* c_parser_type = "1" *) 
  (* c_pipeline_stages = "0" *) 
  (* c_qce_joined = "0" *) 
  (* c_qualify_we = "0" *) 
  (* c_read_mif = "1" *) 
  (* c_reg_a_d_inputs = "0" *) 
  (* c_sync_enable = "1" *) 
  (* c_width = "32" *) 
  (* is_du_within_envelope = "true" *) 
  dist_mem_80_32_dist_mem_gen_v8_0_13 U0
       (.a(a),
        .clk(clk),
        .d(d),
        .dpo(dpo),
        .dpra(dpra),
        .i_ce(1'b1),
        .qdpo(NLW_U0_qdpo_UNCONNECTED[31:0]),
        .qdpo_ce(1'b1),
        .qdpo_clk(1'b0),
        .qdpo_rst(1'b0),
        .qdpo_srst(1'b0),
        .qspo(NLW_U0_qspo_UNCONNECTED[31:0]),
        .qspo_ce(1'b1),
        .qspo_rst(1'b0),
        .qspo_srst(1'b0),
        .spo(NLW_U0_spo_UNCONNECTED[31:0]),
        .we(we));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
qBHgXmwbTbZKEU9tcjZbsi+ExctvD8XefVx14BkxLFOTaColWRgtKU9vhojRxOADVyuCsE7IUw5/
fIBh9Lwwg/1gRLE7njxHZhWAz9S1sVJTpj4NzEQ/HyJYMIoxPpczRyPcn1WxmVNQqNuYI1QUkQdA
njnTdD+zeIXLmFmD1F8=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
V/TizgGPju21MuRFF7y/ABvr1JqliOqk4fYco5uCOBoyUST+UXZx+hvy+kbS/LIOoofVkSPNsgIB
cZoZuq7YCpk/jDm/+3eTRWDEB56vO8JkeH1jwR7EzYU3QoipBAujdnlLacwL/Qy/9BMtpw8ZC+MO
wBnu3Kj0Q1dJVGnfxGEY6YDPJ+d21AYrk0MUpKHc8NVxv4Hojk39AhtxcEVXw2v2A/fQ9jZC/Ndf
05gPeW4R8LQP/EGbOdtsgq9I5dfdsNv7iKW511rAce2zY8b2yC3vfsAK+YvJlJhR9xErRgfrNVjL
Wf/LCVNpz2k1nBpoU73eFFZpZpBgcK2RDNk23w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Bq6b1vbyY3ChcNU6TEnpKgFXql2W7SCpYB5BjNQXc3pXJDMmVkEfYRRu3dus6SDMFXRHG0YcdGWS
/wS2NHW3Y4jbYKRazEyz7v6YOZcyrun1KL6tR+AG/wFDOveXfxNNB+zhBzCpD4rjZneOXH/S238v
1RhzzAtXry9bFvLFEvM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bYFsVmVVlPDgpJA7LNUGgEzYGUdTNv5Vsc3Jwzl3M7dMROVIX3hQvamUB9EXDcek0Zh/sGPCLhKi
ldQUStkE/1cexALf6/IyDRsZwk6TfIOli5xAX33R98gH53kMGqm4LeMSjvxdw1HFasq3DFQf9MFS
2Vd3MBk2RQ7oHEiynkyQ6u6rVzyv/fEvYXD4vddz2P59pyQWGFNkNK2IO+xY995zx5+zEWsxRbhY
BiKHBy3THjpQOfIu9GAuI55cn3CQjjpvKXcx+Y3heO9CKpqZLGfEqa24KfEbqGfiApu6kTIVexUg
dDBIIdD+N8LJltHRpZ+jbHfXPp+zcquX5mHHjw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Qj/0qDRoIRfY71MSM/IDZuivT67/prQAAFtf0lEbUPKKco5uVYjUx2y9eBkAfFGhs2fZalRebtNk
xUbSGT68uQ1coh2Q6nhS4cdo4YPsspTH1Nhu4RIhtPgRxdUttXHYX/Gr97N9TcXoMsfDghFW64X1
k5hEWEfn83fPzGIjm+7kdnV/4img9Fa3ZxxYUrgr5ny+/n9TADBfPj0nanLXP9IfpXIXFMO4cZ0z
Bn1eYo5PYUkIMm2NtSetwGM6Rot106wWg5O8rFVPs19cOE8+1EqXo7dNBHsY+L8Kc+GyZSZKYJeV
JveQ0goTcw48qT7c20RAD9/7ios9uAXp0PTvpQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
n4eN8OcgE2ytgAerPG7drDMcMy/2Ng9XyKzdLoueXaLeh19zquDnQa2TeOOi0kQM7hGEW4N0KSLe
m6/JDweeF+Zh9xzzoNG/7KoO99Lq3PLQiMZJ59hyawaj7oI6PxjJXrmtNuERK3VaiwAJCkdIROIA
KQWVzBm/UM8v21JbncRVWz79jVq9PoB0JyDeHd8yQSMkqhlQuqJk6w0/g6hvk6v0eZ8cm+YQPd0g
lcExsPMEJVUIstZmgw7cO9bw9rbVgiwyICyHMF9e9m+Fe/Erm8j76lm7U0ARiW5L4G85A2pA7Npy
R4KxewsytXQLOLLLVKSJgeQsFsNGQkjyZbzRJw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Xr27ZXCB8OnsIkHZpOeCueAdq2OspASj7YxAKEG4q8NqrecPF23quvvBjuwcB49ClOEqtHMTy8Wx
weKE0jw+n98eLI9Twla9KkITonZCHdMyBRODorH0IaSSb4J6rlebTz4yIeDkU+T39FfS19iVrJv9
YqXU3m1SGEsOT1DI4s/uVoxGxOXgwU9vp+nGCLp4cWSDJ5NmNma3Bkvy1AofNpsy04s51ATfy536
dpOLpy/2AJscmf6UromXJmy3AjFYU5O9tgB+VG+ew3ZTMKUxBUQgIg6qI3jmIkWZ3kN/k2X52CIU
cKg6JWkdfO6Yk9nM2sROGf/SLG8ybirlacy0SQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
R2nz22UK9YsaRdZIY3kGldutQifE5DDy7NbJzgHH9NuMVkNCseU6780lVUn1OPAvaNVfCBMh5aZB
Qa0UQVeAStJarB7+LT6a3OM60oJ6FEegSw1JKYWlpr0J4bm0S8AP9vR86sm2qfGICS2ZYl4qJmT8
m4T3EkhhzBehr+YTSE5DVzXiDX1G5ichGCmCZeSTKbpaMUP4CxdLB3GXI3i/Q8iml9J42mVCnpUw
iemH4c94zF6h8A9D4QXZyzCcG7ls+jKtBjHptjiIu8+V0cg9S7zgQsphkLKIetlWBVuL7zqnpbWe
8s/b5fnpCatZemVgKkFuy8UKlkzOt0yBn4MFWqFhLaoZWztlyHiXcUuSgmaIK7C0o6rpozCRxgkr
/krI39PGhNLvh9r+dLgiXtDNHEPG7Rc1kGWMV4Tv/wTcuizsdwyK5ULiX9zDkm9Wp8wc2FmonXXs
zUMW2MTsj6qNgl3ly6aR71kz80w3HEm6vpYE0PgIioLUHtXSJrNI0YZH

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
KxbkAZO3A4DCLBukfrGMdxDyiqe7FeV3hRi5vLrwE66pgRsrzhpdsdVNVm9GBFGyirgfJc8Msa9K
Y4YDSFDYTsg59E8GFTF+GyDnevyA+S2gpVNFB0n2xfXaYhsh3iGMlmbrfQJILt4u+8Vuch+DunTO
8I4THbi625TC6yg0oe4r3JPCuc0C+w0RF2tsnPzM8RExC1kOIqKZaY9q1/wcBS5yGvCu13nNJIh8
IjjeDlgUK3GKB5FLzKJjUN79rMWT/qzH5OvgP7qaduyP5OfGm9E21O9eYtZEDGyGoM6ob08/TjSI
IIIPgVDQr6hOVM58Dogadky8yVeXSxHRau5RRA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19392)
`pragma protect data_block
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
IqgHpJ13Y/RyoKt2
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
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
    reg GRESTORE_int;

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
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

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

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
