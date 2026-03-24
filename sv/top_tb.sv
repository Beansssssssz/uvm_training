`include "uvm_macros.svh"
import uvm_pkg::*;

`include "const_header_remover_item.sv"
`include "const_header_remover_base_test.sv"

module top_tb;

    const_header_remover_item item1;
    const_header_remover_item item2;

    initial begin

        // Checking the unit tests
        run_test("const_header_remover_item_test");

        // Checking the do virtual functions
        item1 = new();
        item2 = new();

        item1.randomize();
        item2.randomize();
        item1.do_print();
        item2.do_print();
        item1.do_copy(item2);
    end
endmodule