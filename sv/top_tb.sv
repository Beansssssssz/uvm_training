`include "uvm_macros.svh"
import uvm_pkg::*;

module const_header_remover_base_test;

    localparam int NUM_OF_WORDS_TO_CHECK = 100;
    

    const_header_remover_item item1;
    const_header_remover_item item2;

    initial begin
        item1 = new();
        item2 = new();

        item1.randomize();
        item2.randomize();

      item1.print();
      item1.data = 5;
      item2.print();
      $display(item1.compare(item2));
          
        item1.data  = 0;
        item1.empty = 0;
        item1.rdy   = 0;
        item1.valid = 0;
        item1.sop   = 0;
        item1.eop   = 0;
        
        item2.data  = 0;
        item2.empty = 0;
        item2.rdy   = 0;
        item2.valid = 0;
        item2.sop   = 0;
        item2.eop   = 0;

      $display(item1.compare(item2));

        uvm_report_info("UVM Test", "Starting simulation", UVM_LOW);
        $finish;
    end



    task check_compare(const_header_remover_item item1, const_header_remover_item item2);
      
    endtask

endmodule