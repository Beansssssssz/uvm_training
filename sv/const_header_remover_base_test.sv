// -----------------------------------------------------------------------------
// File        : const_header_remover_item.sv
// Author      : Ariel Hay
// Description : item for const header remover
// -----------------------------------------------------------------------------

`include "uvm_macros.svh"

import uvm_pkg::*;
import generation_param::*;

class const_header_base_item extends uvm_test;

    `uvm_component_utils (my_test)

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------
    function new(string name = "const_header_base_item");
        super.new(name);
    endfunction


endclass