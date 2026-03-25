`include "uvm_macros.svh"
import uvm_pkg::*;

module top_tb;

    uvm_root root;
    initial begin
        root = uvm_root::get();
        root.run_test("const_header_remover_item_test");
    end
endmodule