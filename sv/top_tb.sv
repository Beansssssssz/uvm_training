`include "uvm_macros.svh"
import uvm_pkg::*;

`include "const_header_remover_item.sv"

module top_tb;
    initial begin
        run_test("const_header_remover_item_test");
    end
endmodule