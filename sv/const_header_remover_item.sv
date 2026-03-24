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
    // Declarations.
    // -------------------------------------------------------------------------

    rand bit [DATA_WIDTH_IN_BYTES * $bits(byte) - 1 : 0] data;
    rand bit [$clog2(DATA_WIDTH_IN_BYTES) - 1 : 0]       empty;
    rand bit valid;
    rand bit rdy;
    bit sop;
    bit eop;

    // field for packet size to decide when to send sop and eop
    local rand int packet_size;
    local bit mid_packet;

    // -------------------------------------------------------------------------
    // Constraints.
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
        if (mid_packet)
            packet_size == packet_size;   // hold current value
        else
            packet_size inside {[packet_min_words : packet_max_words]};
    }

    // -------------------------------------------------------------------------
    // Functions.
    // -------------------------------------------------------------------------

    function new(string name = "const_header_remover_item");
        super.new(name);
        mid_packet  = 1'b0;
        packet_size = 0;
    endfunction

    function void post_randomize();
        if (mid_packet) begin
            sop = 1'b0;
            eop = 1'b0;
            packet_size--;
            if (packet_size == 0) begin
                mid_packet = 1'b0;
                eop        = 1'b1;
            end
        end else begin
            mid_packet  = 1'b1;
            sop         = 1'b1;
            eop         = 1'b0;
            packet_size--;          // consume the SOP word
            if (packet_size == 0) begin   // single-word packet
                mid_packet = 1'b0;
                eop        = 1'b1;
            end
        end
    endfunction

    `uvm_object_utils_begin(const_header_remover_item)
        `uvm_field_int(data,  UVM_DEFAULT)
        `uvm_field_int(empty, UVM_DEFAULT)
        `uvm_field_int(valid, UVM_DEFAULT)
        `uvm_field_int(rdy,   UVM_DEFAULT)
        `uvm_field_int(sop,   UVM_DEFAULT)
        `uvm_field_int(eop,   UVM_DEFAULT)
    `uvm_object_utils_end

    virtual function void do_copy(uvm_object rhs);
        const_header_remover_item rhs_;
        super.do_copy(rhs);                         

        if (!$cast(rhs_, rhs))
            `uvm_fatal("DO_COPY", "Cast of rhs object failed")

        this.data        = rhs_.data;
        this.empty       = rhs_.empty;
        this.valid       = rhs_.valid;
        this.rdy         = rhs_.rdy;
        this.sop         = rhs_.sop;
        this.eop         = rhs_.eop;
        this.packet_size = rhs_.packet_size;
        this.mid_packet  = rhs_.mid_packet;
    endfunction

    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field_int("data"       , data,        DATA_WIDTH_IN_BYTES * $bits(byte) - 1 );
        printer.print_field_int("empty"      , empty,       $clog2(DATA_WIDTH_IN_BYTES));
        printer.print_field_int("valid"      , valid,       1);
        printer.print_field_int("rdy"        , rdy,         1);
        printer.print_field_int("sop"        , sop,         1);
        printer.print_field_int("eop"        , eop,         1);
        printer.print_field_int("packet_size", packet_size, 32);
        printer.print_field_int("mid_packet" , mid_packet,  1);
    endfunction

    virtual function string do_sprint(uvm_printer printer);
        string s;
        s = super.do_sprint(printer);
        s = {s, $sformatf("data=0x%0h empty=%0d valid=%0b rdy=%0b sop=%0b eop=%0b",
                           data, empty, valid, rdy, sop, eop)};
        return s;
    endfunction


    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        const_header_remover_item rhs_;
        if (!$cast(rhs_, rhs)) begin
            `uvm_error("DO_COMPARE", "Cast of rhs object failed")
            return 0;
        end
        return (super.do_compare(rhs, comparer)  &&
                comparer.compare_field_int("data",  data,  rhs_.data,  DATA_WIDTH_IN_BYTES * $bits(byte) - 1) &&
                comparer.compare_field_int("empty", empty, rhs_.empty, $clog2(DATA_WIDTH_IN_BYTES))       &&
                comparer.compare_field_int("valid", valid, rhs_.valid, 1)                                 &&
                comparer.compare_field_int("rdy",   rdy,   rhs_.rdy,   1)                                 &&
                comparer.compare_field_int("sop",   sop,   rhs_.sop,   1)                                 &&
                comparer.compare_field_int("eop",   eop,   rhs_.eop,   1));
    endfunction

    virtual function void do_pack(uvm_packer packer);
        super.do_pack(packer);
        `uvm_pack_int(data)
        `uvm_pack_int(empty)
        `uvm_pack_int(valid)
        `uvm_pack_int(rdy)
        `uvm_pack_int(sop)
        `uvm_pack_int(eop)
    endfunction

    virtual function void do_unpack(uvm_packer packer);
        super.do_unpack(packer);
        `uvm_unpack_int(data)
        `uvm_unpack_int(empty)
        `uvm_unpack_int(valid)
        `uvm_unpack_int(rdy)
        `uvm_unpack_int(sop)
        `uvm_unpack_int(eop)
    endfunction

endclass