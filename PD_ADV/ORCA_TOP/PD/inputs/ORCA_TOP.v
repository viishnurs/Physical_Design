module CLOCKING ( pclk_in, sdram_clk_in, sys_2x_clk_in, prst_n, test_mode, 
        shutdown, pclk, sdram_clk, sys_clk, sys_2x_clk, pci_rst_n, sdram_rst_n, 
        sys_rst_n, sys_2x_rst_n );
  input pclk_in, sdram_clk_in, sys_2x_clk_in, prst_n, test_mode, shutdown;
  output pclk, sdram_clk, sys_clk, sys_2x_clk, pci_rst_n, sdram_rst_n,
         sys_rst_n, sys_2x_rst_n;
  wire   sys_clk_in, sys_clk_qn_d, prst_ff, pci_rst_n_buf, sdram_rst_ff,
         sdram_rst_n_buf, sys_rst_ff, sys_rst_n_buf, sys_2x_rst_ff,
         sys_2x_rst_n_buf, n5, n3, n4, n6, n7, n9;

  NBUFFX16_LVT I_CLK_SOURCE_PCLK ( .A(pclk_in), .Y(pclk) );
  NBUFFX16_LVT I_CLK_SOURCE_SDRAM_CLK ( .A(sdram_clk_in), .Y(sdram_clk) );
  NBUFFX16_LVT I_CLK_SOURCE_SYS_2X_CLK ( .A(sys_2x_clk_in), .Y(sys_2x_clk) );
  NBUFFX16_LVT I_CLK_SOURCE_SYS_CLK ( .A(sys_clk_in), .Y(sys_clk) );
  DFFX1_LVT sys_clk_in_reg ( .D(sys_clk_qn_d), .CLK(sys_2x_clk_in), .Q(
        sys_clk_in), .QN(sys_clk_qn_d) );
  DFFARX1_HVT prst_ff_reg ( .D(1'b1), .CLK(pclk), .RSTB(n5), .Q(prst_ff) );
  DFFARX1_HVT sys_rst_ff_reg ( .D(1'b1), .CLK(sys_clk), .RSTB(n5), .Q(
        sys_rst_ff) );
  DFFARX1_HVT sdram_rst_ff_reg ( .D(1'b1), .CLK(sdram_clk), .RSTB(n5), .Q(
        sdram_rst_ff) );
  DFFARX1_HVT pci_rst_n_buf_reg ( .D(prst_ff), .CLK(pclk), .RSTB(n5), .Q(
        pci_rst_n_buf) );
  DFFARX1_HVT sys_rst_n_buf_reg ( .D(sys_rst_ff), .CLK(sys_clk), .RSTB(n5), 
        .Q(sys_rst_n_buf) );
  NBUFFX2_HVT U11 ( .A(prst_n), .Y(n5) );
  INVX1_HVT U3 ( .A(test_mode), .Y(n3) );
  AO22X2_LVT U5 ( .A1(test_mode), .A2(n5), .A3(n3), .A4(sys_rst_n_buf), .Y(
        sys_rst_n) );
  DFFARX1_LVT sdram_rst_n_buf_reg ( .D(sdram_rst_ff), .CLK(sdram_clk), .RSTB(
        n5), .Q(sdram_rst_n_buf) );
  DFFARX1_LVT sys_2x_rst_n_buf_reg ( .D(sys_2x_rst_ff), .CLK(sys_2x_clk), 
        .RSTB(n5), .Q(sys_2x_rst_n_buf) );
  INVX1_LVT U9 ( .A(n6), .Y(n9) );
  NBUFFX2_LVT U10 ( .A(n4), .Y(sdram_rst_n) );
  NBUFFX8_HVT U13 ( .A(n7), .Y(pci_rst_n) );
  INVX8_LVT U14 ( .A(n9), .Y(sys_2x_rst_n) );
  MUX21X1_LVT U8 ( .A1(n5), .A2(sys_2x_rst_n_buf), .S0(n3), .Y(n6) );
  AO22X1_LVT U6 ( .A1(test_mode), .A2(n5), .A3(n3), .A4(sdram_rst_n_buf), .Y(
        n4) );
  AO22X1_HVT U4 ( .A1(test_mode), .A2(n5), .A3(n3), .A4(pci_rst_n_buf), .Y(n7)
         );
  DFFARX1_HVT sys_2x_rst_ff_reg ( .D(1'b1), .CLK(sys_2x_clk), .RSTB(n5), .Q(
        sys_2x_rst_ff) );
endmodule


module SNPS_CLOCK_GATE_HIGH_PCI_CORE ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;
  wire   n3, n4;

  CGLPPRX2_LVT latch ( .CLK(CLK), .EN(EN), .SE(n4), .GCLK(ENCLK) );
  NBUFFX2_HVT U2 ( .A(TE), .Y(n3) );
  NBUFFX4_HVT U3 ( .A(n3), .Y(n4) );
endmodule


module PCI_TOP ( pclk, pci_rst_n, pidsel, pgnt_n, pad_in, pad_out, pad_en, 
        ppar_in, ppar_out, ppar_en, pc_be_in, pc_be_out, pc_be_en, pframe_n_in, 
        pframe_n_out, pframe_n_en, ptrdy_n_in, ptrdy_n_out, ptrdy_n_en, 
        pirdy_n_in, pirdy_n_out, pirdy_n_en, pdevsel_n_in, pdevsel_n_en, 
        pstop_n_in, pstop_n_out, pstop_n_en, pperr_n_in, pperr_n_out, 
        pperr_n_en, pserr_n_in, pserr_n_out, pserr_n_en, pack_n, pm66en, 
        cmd_valid_BAR, cmd_in_valid, cmd_in, sys_clk, sys_rst_n, test_mode, 
        rfifo_pop, rfifo_empty_BAR, wfifo_push, wfifo_full, pci_read_data, 
        pci_write_data, light_sleep, deep_sleep, shutdown, pdevsel_n_out_BAR, 
        preq_n_, IN0, IN1, test_si5, test_si4, test_si3, test_si2, test_si1, 
        test_so7, test_so6, test_so5, test_so4, test_so3, test_so2, test_so1, 
        test_se, IN2, IN3, test_se_hfs_netlink_162, test_se_hfs_netlink_163, 
        test_se_hfs_netlink_164, test_se_hfs_netlink_165, 
        test_se_hfs_netlink_166, test_se_hfs_netlink_167, 
        test_se_hfs_netlink_168, test_se_hfs_netlink_169, 
        test_se_hfs_netlink_170, test_se_hfs_netlink_171, 
        test_se_hfs_netlink_172, test_se_hfs_netlink_173, 
        test_se_hfs_netlink_174, test_se_hfs_netlink_175, 
        test_se_hfs_netlink_176, \cmd[3]_BAR , \cmd[2] , \cmd[1] , \cmd[0]  );
  input [31:0] pad_in;
  output [31:0] pad_out;
  input [3:0] pc_be_in;
  output [3:0] pc_be_out;
  input [3:0] cmd_in;
  output [31:0] pci_read_data;
  input [31:0] pci_write_data;
  input pclk, pci_rst_n, pidsel, pgnt_n, ppar_in, pframe_n_in, ptrdy_n_in,
         pirdy_n_in, pdevsel_n_in, pstop_n_in, pperr_n_in, pserr_n_in, pm66en,
         cmd_in_valid, sys_clk, sys_rst_n, test_mode, rfifo_pop, wfifo_push,
         light_sleep, deep_sleep, shutdown, IN0, IN1, test_si5, test_si4,
         test_si3, test_si2, test_si1, test_se, IN2, IN3,
         test_se_hfs_netlink_162, test_se_hfs_netlink_163,
         test_se_hfs_netlink_164, test_se_hfs_netlink_165,
         test_se_hfs_netlink_166, test_se_hfs_netlink_167,
         test_se_hfs_netlink_168, test_se_hfs_netlink_169,
         test_se_hfs_netlink_170, test_se_hfs_netlink_171,
         test_se_hfs_netlink_172, test_se_hfs_netlink_173,
         test_se_hfs_netlink_174, test_se_hfs_netlink_175,
         test_se_hfs_netlink_176;
  output pad_en, ppar_out, ppar_en, pc_be_en, pframe_n_out, pframe_n_en,
         ptrdy_n_out, ptrdy_n_en, pirdy_n_out, pirdy_n_en, pdevsel_n_en,
         pstop_n_out, pstop_n_en, pperr_n_out, pperr_n_en, pserr_n_out,
         pserr_n_en, pack_n, cmd_valid_BAR, rfifo_empty_BAR, wfifo_full,
         pdevsel_n_out_BAR, preq_n_, test_so7, test_so6, test_so5, test_so4,
         test_so3, test_so2, test_so1, \cmd[3]_BAR , \cmd[2] , \cmd[1] ,
         \cmd[0] ;
  wire   pdevsel_n_out, n734, net_pci_read_push, net_pci_read_full,
         net_pci_write_pop, \I_PCI_CORE/net23307 , \I_PCI_CORE/N560 ,
         \I_PCI_CORE/N559 , \I_PCI_CORE/N558 , \I_PCI_CORE/N557 ,
         \I_PCI_CORE/N556 , \I_PCI_CORE/N555 , \I_PCI_CORE/N554 ,
         \I_PCI_CORE/N553 , \I_PCI_CORE/N552 , \I_PCI_CORE/N551 ,
         \I_PCI_CORE/N550 , \I_PCI_CORE/N548 , \I_PCI_CORE/N547 ,
         \I_PCI_CORE/N546 , \I_PCI_CORE/N545 , \I_PCI_CORE/N544 ,
         \I_PCI_CORE/N543 , \I_PCI_CORE/N542 , \I_PCI_CORE/N541 ,
         \I_PCI_CORE/N540 , \I_PCI_CORE/N539 , \I_PCI_CORE/N538 ,
         \I_PCI_CORE/N537 , \I_PCI_CORE/N536 , \I_PCI_CORE/N535 ,
         \I_PCI_CORE/N534 , \I_PCI_CORE/N533 , \I_PCI_CORE/N532 ,
         \I_PCI_CORE/N531 , \I_PCI_CORE/N529 , \I_PCI_CORE/N528 ,
         \I_PCI_CORE/N527 , \I_PCI_CORE/N526 , \I_PCI_CORE/N525 ,
         \I_PCI_CORE/N524 , \I_PCI_CORE/N523 , \I_PCI_CORE/N522 ,
         \I_PCI_CORE/N521 , \I_PCI_CORE/N520 , \I_PCI_CORE/N518 ,
         \I_PCI_CORE/N517 , \I_PCI_CORE/N516 , \I_PCI_CORE/N515 ,
         \I_PCI_CORE/N514 , \I_PCI_CORE/N513 , \I_PCI_CORE/N512 ,
         \I_PCI_CORE/N511 , \I_PCI_CORE/N510 , \I_PCI_CORE/N509 ,
         \I_PCI_CORE/N508 , \I_PCI_CORE/N507 , \I_PCI_CORE/N506 ,
         \I_PCI_CORE/N505 , \I_PCI_CORE/N504 , \I_PCI_CORE/N503 ,
         \I_PCI_CORE/N502 , \I_PCI_CORE/N501 , \I_PCI_CORE/N500 ,
         \I_PCI_CORE/N499 , \I_PCI_CORE/N497 , \I_PCI_CORE/N496 ,
         \I_PCI_CORE/N495 , \I_PCI
