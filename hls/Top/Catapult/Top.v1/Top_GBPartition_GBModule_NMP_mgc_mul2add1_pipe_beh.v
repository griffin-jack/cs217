//muladd1
module Top_GBPartition_GBModule_NMP_mgc_mul2add1_pipe(a,b,b2,c,d,d2,cst,clk,en,a_rst,s_rst,z);
  parameter gentype = 0;
  parameter width_a = 0;
  parameter signd_a = 0;
  parameter width_b = 0;
  parameter signd_b = 0;
  parameter width_b2 = 0;
  parameter signd_b2 = 0;
  parameter width_c = 0;
  parameter signd_c = 0;
  parameter width_d = 0;
  parameter signd_d = 0;
  parameter width_d2 = 0;
  parameter signd_d2 = 0;
  parameter width_e = 0;
  parameter signd_e = 0;
  parameter width_z = 0;
  parameter isadd = 1;
  parameter add_b2 = 1;
  parameter add_d2 = 1;
  parameter use_const = 1;
  parameter      clock_edge =  1'b0;  // clock polarity (1=posedge, 0=negedge)
  parameter   enable_active =  1'b0;  // enable polarity (1=posedge, 0=negedge)
  parameter    a_rst_active =  1'b1;  // unused
  parameter    s_rst_active =  1'b1;  // unused
  parameter integer  stages = 32'd2;  // number of output registers + 1 (careful!)
  parameter integer n_inreg = 32'd0;  // number of input registers

  input  [width_a-1:0] a;
  input  [width_b-1:0] b;
  input  [width_b2-1:0] b2; // spyglass disable SYNTH_5121,W240
  input  [width_c-1:0] c;
  input  [width_d-1:0] d;
  input  [width_d2-1:0] d2; // spyglass disable SYNTH_5121,W240
  input  [width_e-1:0] cst; // spyglass disable SYNTH_5121,W240

  input                clk;    // clock
  input                en;     // enable
  input                a_rst;  // spyglass disable SYNTH_5121,W240
  input                s_rst;  // spyglass disable SYNTH_5121,W240

  output [width_z-1:0] z;

  function integer MIN;
    input integer a, b;
  begin
    if (a > b) MIN = b;
    else       MIN = a;
  end endfunction

  function integer f_axb_stages;
    input integer gentype,n_inreg,width_a, signd_a,width_b,signd_b,width_c, signd_c,width_d,signd_d;
  begin
    if (gentype%2==0) begin
      if ((n_inreg > 1) && (width_a>18 | width_b>=19+signd_b | width_c>18 | width_d>=19+signd_d ))
        f_axb_stages = 1;
      else
        f_axb_stages = 0;
    end else begin
      if (n_inreg>1)
        f_axb_stages = 1;
      else
        f_axb_stages = 0;
    end
  end endfunction

  function integer f_cxd_stages;
    input integer gentype,n_inreg,width_a, signd_a,width_b,signd_b,width_c, signd_c,width_d,signd_d;
  begin
    if (gentype%2==0) begin
      f_cxd_stages = 0;
    end else begin
      if (n_inreg>1)
        f_cxd_stages = MIN(n_inreg-1,3);
      else
        f_cxd_stages = 0;
    end
  end endfunction

  function integer f_preadd_stages;
    input integer gentype,n_inreg,width_preaddin;
  begin
    if (gentype%2==0) begin
      f_preadd_stages = 0;
    end else begin
      if (n_inreg>1) begin
        if (width_preaddin>0)
          f_preadd_stages = 1;
        else
          f_preadd_stages = 0;
      end else
        f_preadd_stages = 0;
    end
  end endfunction

  function integer MAX;
    input integer LEFT, RIGHT;
  begin
    if (LEFT > RIGHT) MAX = LEFT;
    else              MAX = RIGHT;
  end endfunction

  function integer PREADDLEN;
    input integer b_len, d_len, width_d;
  begin
    if(width_d>0) PREADDLEN = MAX(b_len,d_len) + 1;
    else        PREADDLEN = b_len;
  end endfunction
  function integer PREADDMULLEN;
    input integer a_len, b_len, d_len, width_d;
  begin
    PREADDMULLEN = a_len + PREADDLEN(b_len,d_len,width_d);
  end endfunction

  localparam axb_stages = f_axb_stages(gentype,n_inreg,width_a, signd_a,width_b,signd_b,width_c, signd_c,width_d,signd_d);
  localparam cxd_stages = f_cxd_stages(gentype,n_inreg,width_a, signd_a,width_b,signd_b,width_c, signd_c,width_d,signd_d);
  localparam preadd_ab_stages = f_preadd_stages(gentype, n_inreg - axb_stages,width_b2);
  localparam preadd_cd_stages = f_preadd_stages(gentype, n_inreg - cxd_stages,width_d2);
  localparam e_stages  = (use_const>1)?n_inreg:0;
  localparam a_stages  = n_inreg - axb_stages;
  localparam b_stages  = n_inreg - axb_stages - preadd_ab_stages;
  localparam c_stages  = n_inreg - cxd_stages;
  localparam d_stages  = n_inreg - cxd_stages - preadd_cd_stages;
  localparam b2_stages  = (width_b2>0)?b_stages:0;
  localparam d2_stages  = (width_d2>0)?d_stages:0;

  localparam a_len    = width_a-signd_a+1;
  localparam b_len    = width_b-signd_b+1;
  localparam b2_len   = width_b2-signd_b2+1;
  localparam c_len    = width_c-signd_c+1;
  localparam d_len    = width_d-signd_d+1;
  localparam d2_len   = width_d2-signd_d2+1;
  localparam e_len    = width_e-signd_e+1;
  localparam bb2_len  = PREADDLEN(b_len, b2_len, width_b2);
  localparam dd2_len  = PREADDLEN(d_len, d2_len, width_d2);
  localparam axb_len  = PREADDMULLEN(a_len, b_len, b2_len, width_b2);
  localparam cxd_len  = PREADDMULLEN(c_len, d_len, d2_len, width_d2);
  localparam z_len    = width_z;

  reg [a_len-1:0]  aa  [a_stages:0];
  reg [b_len-1:0]  bb  [b_stages:0];
  reg [b2_len-1:0] bb2 [b2_stages:0];
  reg [c_len-1:0]  cc  [c_stages:0];
  reg [d_len-1:0]  dd  [d_stages:0];
  reg [d2_len-1:0] dd2 [d2_stages:0];
  reg [e_len-1:0]  ee  [e_stages:0];



  genvar i;

  // make all inputs signed
  always @(*) aa[a_stages] = signd_a ? a : {1'b0, a}; //spyglass disable W164a W164b
  always @(*) bb[b_stages] = signd_b ? b : {1'b0, b}; //spyglass disable W164a W164b
  generate if (width_b2>0) begin
    (* keep ="true" *) reg [b2_len-1:0] b2_keep;
    always @(*) b2_keep = signd_b2 ? b2 : {1'b0, b2}; //spyglass disable W164a W164b
    always @(*) bb2[b2_stages] = b2_keep;
  end endgenerate
  always @(*) cc[c_stages] = signd_c ? c : {1'b0, c}; //spyglass disable W164a W164b
  always @(*) dd[d_stages] = signd_d ? d : {1'b0, d}; //spyglass disable W164a W164b
  generate if (width_d2>0) begin
    (* keep ="true" *) reg [d2_len-1:0] d2_keep;
    always @(*) d2_keep = signd_d2 ? d2 : {1'b0, d2}; //spyglass disable W164a W164b
    always @(*) dd2[d2_stages] = d2_keep;
  end endgenerate

  generate if (use_const>0) begin
    always @(*) ee[e_stages] = signd_e ? cst : {1'b0, cst}; //spyglass disable W164a W164b

    // input registers
    if (e_stages>0) begin
    for(i = e_stages-1; i >= 0; i=i-1) begin:in_pipe_e
      if (clock_edge == 1'b1) begin:pos
        always @(posedge(clk)) if (en == enable_active) ee[i] <= ee[i+1];//spyglass disable FlopEConst
      end else begin:neg
        always @(negedge(clk)) if (en == enable_active) ee[i] <= ee[i+1];//spyglass disable FlopEConst
      end
    end end
  end endgenerate
  generate if (a_stages>0) begin
  for(i = a_stages-1; i >= 0; i=i-1) begin:in_pipe_a
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) aa[i] <= aa[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) aa[i] <= aa[i+1];//spyglass disable FlopEConst
    end
  end end endgenerate
  generate if (b_stages>0) begin
  for(i = b_stages-1; i >= 0; i=i-1) begin:in_pipe_b
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) bb[i] <= bb[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) bb[i] <= bb[i+1];
    end
  end end endgenerate
  generate if (c_stages>0) begin
  for(i = c_stages-1; i >= 0; i=i-1) begin:in_pipe_c
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) cc[i] <= cc[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) cc[i] <= cc[i+1];//spyglass disable FlopEConst
    end
  end end endgenerate
  generate if (d_stages>0) begin
  for(i = d_stages-1; i >= 0; i=i-1) begin:in_pipe_d
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) dd[i] <= dd[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) dd[i] <= dd[i+1];//spyglass disable FlopEConst
    end
  end end endgenerate
  generate if (b2_stages>0) begin
  for(i = b2_stages-1; i >= 0; i=i-1) begin:in_pipe_b2
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) bb2[i] <= bb2[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) bb2[i] <= bb2[i+1];//spyglass disable FlopEConst
    end
  end end endgenerate
  generate if (d2_stages>0) begin
  for(i = d2_stages-1; i >= 0; i=i-1) begin:in_pipe_d2
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) dd2[i] <= dd2[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) dd2[i] <= dd2[i+1];//spyglass disable FlopEConst
    end
  end end endgenerate

  reg [bb2_len-1:0] b_bb2[preadd_ab_stages:0];
  reg [dd2_len-1:0] d_dd2[preadd_cd_stages:0];

  //perform first preadd
  generate
    if (width_b2>0) begin
      if (add_b2) begin always @(*) b_bb2[preadd_ab_stages] = $signed(bb[0]) + $signed(bb2[0]); end
      else        begin always @(*) b_bb2[preadd_ab_stages] = $signed(bb[0]) - $signed(bb2[0]); end
    end else      begin always @(*) b_bb2[preadd_ab_stages] = $signed(bb[0]); end
  endgenerate
  generate if (preadd_ab_stages>0) begin
  for(i = preadd_ab_stages-1; i >= 0; i=i-1) begin:preaddab_pipe
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) b_bb2[i] <= b_bb2[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) b_bb2[i] <= b_bb2[i+1];//spyglass disable FlopEConst
    end
  end end endgenerate

  //perform second preadd
  generate
    if (width_d2>0) begin
      if (add_d2) begin always @(*) d_dd2[preadd_cd_stages] = $signed(dd[0]) + $signed(dd2[0]); end
      else        begin always @(*) d_dd2[preadd_cd_stages] = $signed(dd[0]) - $signed(dd2[0]); end
    end else      begin always @(*) d_dd2[preadd_cd_stages] = $signed(dd[0]); end
  endgenerate
  generate if (preadd_cd_stages>0) begin
  for(i = preadd_cd_stages-1; i >= 0; i=i-1) begin:preaddcd_pipe
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) d_dd2[i] <= d_dd2[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) d_dd2[i] <= d_dd2[i+1];//spyglass disable FlopEConst
    end
  end end endgenerate

  // perform first multiplication
  reg [axb_len-1:0] axb[axb_stages:0];

  always @(*) axb[axb_stages] = $signed(aa[0]) * $signed(b_bb2[0]);
  generate if (axb_stages>0) begin
  for(i = axb_stages-1; i >= 0; i=i-1) begin:axb_pipe
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) axb[i] <= axb[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) axb[i] <= axb[i+1];
    end
  end end endgenerate

  // perform second multiplication
  reg [cxd_len-1:0] cxd[cxd_stages:0];

  always @(*) cxd[cxd_stages] = $signed(cc[0]) * $signed(d_dd2[0]);
  generate if (cxd_stages>0) begin
  for(i = cxd_stages-1; i >= 0; i=i-1) begin:cxd_pipe
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) cxd[i] <= cxd[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) cxd[i] <= cxd[i+1];//spyglass disable FlopEConst
    end
  end end endgenerate

  reg [z_len-1:0]  zz[stages-1:0];
  generate
    if (use_const>1) begin
      reg [z_len-1:0] aux_val;
      if ( isadd) begin
        always @(*) aux_val = $signed(axb[0]) + $signed(cxd[0]);
      end else begin
        always @(*) aux_val = $signed(axb[0]) - $signed(cxd[0]);
      end
      always @(*) zz[stages-1] = $signed(ee[0]) + $signed(aux_val) ;
    end else begin
      if (use_const>0) begin
        if ( isadd) begin always @(*) zz[stages-1] = $signed(axb[0]) + $signed(cxd[0]) + $signed(ee[0]); end else
                    begin always @(*) zz[stages-1] = $signed(axb[0]) - $signed(cxd[0]) + $signed(ee[0]); end
      end else begin
        if ( isadd) begin always @(*) zz[stages-1] = $signed(axb[0]) + $signed(cxd[0]); end else
                    begin always @(*) zz[stages-1] = $signed(axb[0]) - $signed(cxd[0]); end
      end
    end
  endgenerate

  // Output registers:
  generate if (stages>1) begin
  for(i = stages-2; i >= 0; i=i-1) begin:out_pipe
    if (clock_edge == 1'b1) begin:pos
      always @(posedge(clk)) if (en == enable_active) zz[i] <= zz[i+1];//spyglass disable FlopEConst
    end else begin:neg
      always @(negedge(clk)) if (en == enable_active) zz[i] <= zz[i+1];//spyglass disable FlopEConst
    end
  end end endgenerate

  // adjust output
  assign z = zz[0];
endmodule // mgc_mul2add1_pipe
