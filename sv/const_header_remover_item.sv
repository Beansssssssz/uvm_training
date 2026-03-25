// -----------------------------------------------------------------------------
// File        : const_header_remover_item.sv
// Author      : Ariel Hay
// Description : item for const header remover
// -----------------------------------------------------------------------------

`include "uvm_macros.svh"
`include "generation_param.sv"

import uvm_pkg::*;
import generation_param::*;

class const_header_remover_item extends uvm_object;

    // -------------------------------------------------------------------------
    // Declarations.
    // -------------------------------------------------------------------------
    rand queue_of_byte data;

    `uvm_object_utils(const_header_remover_item) // factory only, no field automation


    // -------------------------------------------------------------------------
    // Functions.
    // -------------------------------------------------------------------------
    function new(string name = "const_header_remover_item");
        super.new(name);
    endfunction

    virtual function void do_copy(uvm_object rhs);
        const_header_remover_item rhs_;
        super.do_copy(rhs);

        if (!$cast(rhs_, rhs))
            `uvm_fatal("DO_COPY", "Cast of rhs object failed")

        this.data = rhs_.data;
    endfunction

    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        foreach (data[i])
            printer.print_field_int($sformatf("data[%0d]", i), data[i], $bits(byte));
    endfunction

    virtual function string do_sprint(uvm_printer printer);
        string s;
        foreach (data[i])
            s = {s, $sformatf("data[%0d]=0x%0h ", i, data[i])};
        return s;
    endfunction

    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        const_header_remover_item rhs_;
        if (!$cast(rhs_, rhs)) begin
            `uvm_error("DO_COMPARE", "Cast of rhs object failed")
            return 0;
        end
        if (data.size() != rhs_.data.size()) return 0;
        foreach (data[i]) begin
            if (!comparer.compare_field_int($sformatf("data[%0d]", i), data[i], rhs_.data[i], $bits(byte)))
                return 0;
        end
        return super.do_compare(rhs, comparer);
    endfunction

    virtual function void do_pack(uvm_packer packer);
        super.do_pack(packer);
        `uvm_pack_queue(data)
    endfunction

    virtual function void do_unpack(uvm_packer packer);
        super.do_unpack(packer);
        `uvm_unpack_queue(data)
    endfunction
endclass