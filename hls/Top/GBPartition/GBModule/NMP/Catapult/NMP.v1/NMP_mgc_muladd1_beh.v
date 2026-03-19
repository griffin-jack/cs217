//muladd1
module NMP_mgc_muladd1(a,b,c,cst,d,z);
  // operation is z = a * (b + d) + c + cst
  parameter width_a = 0;
  parameter signd_a = 0;
  parameter width_b = 0;
  parameter signd_b = 0;
  parameter width_c = 0;
  parameter signd_c = 0;
  parameter width_cst = 0;
  parameter signd_cst = 0;
  parameter width_d = 0;
  parameter signd_d = 0;
  parameter width_z = 0;
  parameter add_axb = 1;
  parameter add_c = 1;
  parameter add_d = 1;
  parameter use_const = 1;

  function integer is_square_op;
    input integer alen;
  begin
    if (alen > 1) is_square_op = 0;
    else       is_square_op = 1;
  end endfunction

  input  [width_a-1:0] a;
  input  [width_b-1:0] b;
  input  [width_c-1:0] c;
  input  [width_cst-1:0] cst; // spyglass disable SYNTH_5121,W240
  input  [width_d-1:0] d;
  output [width_z-1:0] z;

  reg [width_a-signd_a:0] aa;
  reg [width_b-signd_b:0] bb;
  reg [width_c-signd_c:0] cc;
  reg [width_d-signd_d:0] dd;
  reg [width_cst-signd_cst:0] cstin;

  localparam width_bd = (width_d) ? 1+ ((width_b-signd_b>width_d-signd_d) ? width_b - signd_b
                                                                          : width_d - signd_d)
                                  : width_b - signd_b;
  localparam is_square = is_square_op(width_a);
  localparam axb_len = (is_square)?width_bd+1+width_bd+1:width_a-signd_a+1+width_bd+1;

  reg [width_bd:0] bd;
  reg [axb_len-1:0] axb;



  // make all inputs signed
  always @(*) aa = signd_a ? a : {1'b0, a};
  always @(*) bb = signd_b ? b : {1'b0, b};
  generate if (width_c != 0) begin
    always @(*) cc = signd_c ? c : {1'b0, c};
  end endgenerate

  generate if (width_d) begin
    if ( !is_square) begin
      (* keep ="true" *) reg [width_d-signd_d:0] d_keep;
      always @(*) d_keep = signd_d ? d : {1'b0, d};
      always @(*) dd = d_keep;
    end else begin
      always @(*) dd = signd_d ? d : {1'b0, d};
    end
  end endgenerate

  always @(*) cstin = signd_cst ? cst : {1'b0, cst};

  // perform pre-adder
  generate
    if (width_d != 0) begin
      if (add_d) begin always @(*)  bd = $signed(bb) + $signed(dd); end
      else       begin always @(*)  bd = $signed(bb) - $signed(dd); end
    end else     begin always @(*)  bd = $signed(bb); end
  endgenerate

  generate
    if (is_square)
      always @(*) axb = $signed(bd) * $signed(bd);
    else
      always @(*) axb = $signed(aa) * $signed(bd);
  endgenerate

  // perform muladd1
  wire [width_z-1:0]  zz;

  generate
    if (use_const) begin
      if ( add_axb &&  add_c && width_c) begin assign zz = $signed(axb) + $signed(cc) + $signed(cstin); end else
      if ( add_axb && !add_c && width_c) begin assign zz = $signed(axb) - $signed(cc) + $signed(cstin); end else
      if (!add_axb &&  add_c && width_c) begin assign zz = $signed(cc) - $signed(axb) + $signed(cstin); end else
      if (!add_axb && !add_c && width_c) begin assign zz = $signed(cstin) - $signed(axb) - $signed(cc); end else
      if ( add_axb )                     begin assign zz = $signed(axb) + $signed(cstin); end else
                                         begin assign zz = $signed(cstin) - $signed(axb); end
    end  else begin
      if ( add_axb &&  add_c && width_c) begin assign zz = $signed(axb) + $signed(cc); end else
      if ( add_axb && !add_c && width_c) begin assign zz = $signed(axb) - $signed(cc); end else
      if (!add_axb &&  add_c && width_c) begin assign zz = $signed(cc) - $signed(axb); end else
      if (!add_axb && !add_c && width_c) begin assign zz = -$signed(axb) - $signed(cc); end else
      if ( add_axb )                     begin assign zz = $signed(axb); end else
                                         begin assign zz = -$signed(axb); end
    end
  endgenerate

  // adjust output
  assign z = zz;
endmodule // mgc_muladd1
