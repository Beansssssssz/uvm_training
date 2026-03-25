// -----------------------------------------------------------------------------
// File        : const_header_remover_item_test.sv
// Author      : Ariel Hay

// -----------------------------------------------------------------------------

`include "uvm_macros.svh"
`include "generation_param.sv"

import uvm_pkg::*;
import generation_param::*;

class const_header_remover_base_test extends uvm_test;

    `uvm_component_utils(const_header_remover_base_test)
    

    // -------------------------------------------------------------------------
    // Functions
    // -------------------------------------------------------------------------
    function new(string name = "const_header_remover_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        `uvm_info("TEST", "unit tests", UVM_LOW)

        test_copy();
        test_print();
        test_sprint();
        test_compare();
        test_pack_unpack();
        test_pack_unpack_bytes();
        test_pack_unpack_ints();

        `uvm_info("TEST", "unit tests done", UVM_LOW)

        phase.drop_objection(this);
    endtask

    local function const_header_remover_item make_item(string name);
        const_header_remover_item item;
        item = const_header_remover_item::type_id::create(name);
        
        if (!item.randomize()) begin
            `uvm_fatal("RAND", $sformatf("randomize failed for: %s'", name))
        end

        return item;
    endfunction

    // -------------------------------------------------------------------------
    // Unit tests.
    // -------------------------------------------------------------------------
    local task test_copy();
        const_header_remover_item orig, clone;

        orig  = make_item("orig");
        clone = const_header_remover_item::type_id::create("clone");
        clone.copy(orig);

        // --- field equality ---
        if (orig.data  !== clone.data) 
            `uvm_error("COPY", "data  mismatch after copy")
        if (orig.empty !== clone.empty) 
            `uvm_error("COPY", "empty mismatch after copy")
        if (orig.valid !== clone.valid) 
            `uvm_error("COPY", "valid mismatch after copy")
        if (orig.rdy   !== clone.rdy)  
            `uvm_error("COPY", "rdy   mismatch after copy")
        if (orig.sop   !== clone.sop) 
            `uvm_error("COPY", "sop   mismatch after copy")
        if (orig.eop   !== clone.eop) 
            `uvm_error("COPY", "eop   mismatch after copy")

        `uvm_info("COPY", "Field equality check — PASS", UVM_LOW)

        // --- independence ---
        clone.data = ~orig.data;
        if (orig.data === clone.data) begin
            `uvm_error("COPY", "copy is not independent — modifying clone changed orig")
        end
        else begin
            `uvm_info("COPY", "Deep-copy independence check — PASS", UVM_LOW)
        end
    endtask

    local task test_print();
        const_header_remover_item item = make_item("item_print");

        `uvm_info("PRINT", "Calling print() — output follows:", UVM_LOW)
        item.print();
        `uvm_info("PRINT", "print() completed without errors — PASS", UVM_LOW)
    endtask

    local task test_sprint();
        const_header_remover_item item = make_item("item_sprint");
        string s;
        string expected_fields[$] = '{"data", "empty", "valid", "rdy", "sop", "eop"};

        s = item.sprint();

        if (s.len() == 0)
            `uvm_error("SPRINT", "sprint() returned an empty string")
        else
            `uvm_info("SPRINT", "Non-empty string check — PASS", UVM_LOW)

        foreach (expected_fields[i]) begin
            if (s.substr(0, s.len() - 1).search(expected_fields[i]) == -1)
                `uvm_warning("SPRINT",
                    $sformatf("Field '%s' not found in sprint() output", expected_fields[i]))
        end

        `uvm_info("SPRINT", {"sprint() output:\n", s}, UVM_MEDIUM)
        `uvm_info("SPRINT", "sprint() test — PASS", UVM_LOW)
    endtask

    local task test_compare();
        const_header_remover_item item_a, item_b;

        item_a = make_item("item_a");
        item_b = const_header_remover_item::type_id::create("item_b");
        item_b.copy(item_a);

        // equal
        if (!item_a.do_compare(item_b)) begin
            `uvm_error("COMPARE", "compare() returned 0 for identical items")
        end else begin
            `uvm_info("COMPARE", "Equal items check — PASS", UVM_LOW)
        end

        // differing data
        item_b.data = {item_a.data, 0};
        if (item_a.do_compare(item_b)) begin
            `uvm_error("COMPARE", "do_compare returned true for items with different data")
        end else begin
            `uvm_info("COMPARE", "compare returned false on differing data", UVM_LOW)
        end
    endtask

    local task test_pack_unpack();
        const_header_remover_item src, dst;
        bit  packed_bits[];
        int  n_bits;

        src = make_item("src_pack");
        dst = const_header_remover_item::type_id::create("dst_pack");

        n_bits = src.pack(packed_bits);
        `uvm_info("PACK", $sformatf("pack() produced %0d bits", n_bits), UVM_LOW)

        void'(dst.unpack(packed_bits));

        if (!src.compare(dst)) begin
            `uvm_error("PACK", "pack/unpack round-trip failed — items differ")
        end else begin
            `uvm_info("PACK", "pack/unpack round-trip — PASS", UVM_LOW)
        end
    endtask

    local task test_pack_unpack_bytes();
        const_header_remover_item src, dst;
        byte unsigned packed_bytes[];
        int n_bytes;

        src = make_item("src_bytes");
        dst = const_header_remover_item::type_id::create("dst_bytes");

        n_bytes = src.pack_bytes(packed_bytes);
        `uvm_info("PACK_BYTES", $sformatf("pack_bytes() produced %0d bytes", n_bytes), UVM_LOW)

        void'(dst.unpack_bytes(packed_bytes));

        if (!src.compare(dst)) begin
            `uvm_error("PACK_BYTES", "pack_bytes/unpack_bytes round-trip failed — items differ")
        end else begin
            `uvm_info("PACK_BYTES", "pack_bytes/unpack_bytes round-trip — PASS", UVM_LOW)
        end
    endtask

    local task test_pack_unpack_ints();
        const_header_remover_item src, dst;
        int unsigned packed_ints[];
        int n_ints;

        src = make_item("src_ints");
        dst = const_header_remover_item::type_id::create("dst_ints");

        n_ints = src.pack_ints(packed_ints);
        `uvm_info("PACK_INTS", $sformatf("pack_ints() produced %0d ints", n_ints), UVM_LOW)

        void'(dst.unpack_ints(packed_ints));

        if (!src.compare(dst)) begin
            `uvm_error("PACK_INTS", "pack_ints/unpack_ints round-trip failed — items differ")
        end else begin
            `uvm_info("PACK_INTS", "pack_ints/unpack_ints round-trip — PASS", UVM_LOW)
        end
    endtask
endclass