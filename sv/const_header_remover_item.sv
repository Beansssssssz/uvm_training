// -----------------------------------------------------------------------------
// File        : const_header_remover_item.sv
// Author      : Ariel Hay
// Description : item for const header remover
// -----------------------------------------------------------------------------

`include "uvm_macros.svh"

import uvm_pkg::*;
import generation_param::*;

class const_header_remover_item #(int DATA_WIDTH_IN_BYTES = 4) extends uvm_object;

    // -------------------------------------------------------------------------
    // item fields
    // -------------------------------------------------------------------------
    rand bit [DATA_WIDTH_IN_BYTES * $bits(byte) - 1 : 0] data;
    rand bit [$clog2(DATA_WIDTH_IN_BYTES) - 1 : 0]       empty;
    rand bit valid;
    rand bit rdy;
    bit sop;
    bit eop;

    // field for packet size to decide when to send sop and eop
    rand int packet_size;
    bit mid_packet;

    // -------------------------------------------------------------------------
    // Constraints — all driven by generation_param package variables
    // -------------------------------------------------------------------------

    constraint c_data {
        data inside {[data_min : data_max]};
    }

    constraint c_empty {
        empty inside {[empty_min : empty_max]};
    }

    constraint c_valid {
        valid dist {
            1 := valid_weight,
            0 := (100 - valid_weight)
        };
    }

    constraint c_rdy {
        rdy dist {
            1 := rdy_weight,
            0 := (100 - rdy_weight)
        };
    }

    constraint c_packet_size {
        if(mid_packet)
            packet_size inside {packet_size};
        else
            data inside {[packet_min_words : packet_max_words]};
    }

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------
    function new(string name = "const_header_remover_item");
        super.new(name);
    endfunction


    // -------------------------------------------------------------------------
    // Item functions
    // -------------------------------------------------------------------------
    function void post_randomize();
        if(mid_packet) begin
            sop = 1'b0;
            packet_size--;
            if (packet_size == 0) begin
                mid_packet = 0;
                eop = 1'b1;
            end
        end else begin
            mid_packet = 1'b1;
            sop = 1'b1;
            eop = 1'b0;
        end
    endfunction;

    // -------------------------------------------------------------------------
    // UVM field macros
    // -------------------------------------------------------------------------
    `uvm_object_utils_begin(const_header_remover_item)
        `uvm_field_int (data,  UVM_DEFAULT)
        `uvm_field_int (empty, UVM_DEFAULT)
        `uvm_field_int (valid, UVM_DEFAULT)
        `uvm_field_int (rdy,   UVM_DEFAULT)
        `uvm_field_int (sop,   UVM_DEFAULT)
        `uvm_field_int (eop,   UVM_DEFAULT)
    `uvm_object_utils_end

endclass