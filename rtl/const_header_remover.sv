

module const_header_remover(
    avalon_st_if.slave in,
    avalon_st_if.master out
);

    assign out.data  = in.data;
    assign out.valid = in.valid;
    assign out.sop   = in.sop;
    assign out.eop   = in.eop;
    assign out.empty = in.empty;

    assign in.rdy = out.rdy;
endmodule
