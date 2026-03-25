// -----------------------------------------------------------------------------
// File        : const_header_remover_environment.sv
// Author      : Ariel Hay
// -----------------------------------------------------------------------------


`ifndef CONST_HEADER_REMOVER_ENVIRONMENT_SV
`define CONST_HEADER_REMOVER_ENVIRONMENT_SV

`include "uvm_macros.svh"

import uvm_pkg::*;
import generation_param::*;

class const_header_remover_environment extends uvm_component;

    
    // -------------------------------------------------------------------------
    // Declarations.
    // -------------------------------------------------------------------------
    `uvm_component_utils(const_header_remover_environment)


    // -------------------------------------------------------------------------
    // Functions.
    // -------------------------------------------------------------------------
    function new(string name = "const_header_remover_item", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
    endtask

endclass
`endif
