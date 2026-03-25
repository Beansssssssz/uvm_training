// -----------------------------------------------------------------------------
// File        : const_header_remover_base_test.sv
// Author      : Ariel Hay
// -----------------------------------------------------------------------------

`ifndef CONST_HEADER_REMOVER_BASE_TEST_SV
`define CONST_HEADER_REMOVER_BASE_TEST_SV

`include "uvm_macros.svh"
`include "generation_param.sv"
`include "const_header_remover_item.sv"
`include "const_header_remover_environment.sv"

import uvm_pkg::*;
import generation_param::*;

class const_header_remover_base_test extends uvm_test;
    `uvm_component_utils(const_header_remover_base_test)

    // -------------------------------------------------------------------------
    // Declarations
    // -------------------------------------------------------------------------
    const_header_remover_environment env;

    // -------------------------------------------------------------------------
    // Functions
    // -------------------------------------------------------------------------
    function new(string name = "const_header_remover_base_test", uvm_component parent = null);
        super.new(name, parent);
      
      $display("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    endfunction

    virtual function void build_phase(uvm_phase phase);
        env = const_header_remover_environment::type_id::create("const_header_remover_environment", this);
      $display("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
    endfunction

    virtual function void connect_phase(uvm_phase phase);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        `uvm_info("TEST", "unit tests", UVM_LOW)

        //test_copy();
        //test_print();
        //test_sprint();
        //test_compare();
        //test_pack_unpack();
        //test_pack_unpack_bytes();
        //test_pack_unpack_ints();

        `uvm_info("TEST", "unit tests done", UVM_LOW)

        phase.drop_objection(this);
    endtask

    local function const_header_remover_item make_item(string name);
        const_header_remover_item item;
        item = const_header_remover_item::type_id::create(name);

        if (!item.randomize())
            `uvm_fatal("RAND", $sformatf("randomize failed for: %s", name))

        return item;
    endfunction

    // -------------------------------------------------------------------------
    // Unit tests.
    // -------------------------------------------------------------------------
    local task test_copy();
        const_header_remover_item orig, clone;

        // create value and check if its similair
        orig  = make_item("orig");
        clone = const_header_remover_item::type_id::create("clone");

        clone.do_copy(orig);

        if (orig.data !== clone.data)
            `uvm_error("COPY", "data mismatch after copy")
        else
            `uvm_info("COPY", "data match after copy", UVM_LOW)
    endtask

    local task test_print();
        const_header_remover_item item = make_item("item_print");
      uvm_printer printer = uvm_default_printer;

        `uvm_info("PRINT", "checking do_print():", UVM_LOW)
        item.do_print(printer);
    endtask

    local task test_sprint();
        const_header_remover_item item = make_item("item_sprint");
        //uvm_default_printer printer = uvm_default_printer::get();
      uvm_printer printer = uvm_default_printer;
        string s;

        s = item.do_sprint(printer);

        `uvm_info("SPRINT", {"do_sprint() output:\n", s}, UVM_MEDIUM)
        `uvm_info("SPRINT", "do_sprint() test — PASS", UVM_LOW)
    endtask

    local task test_compare();
        const_header_remover_item item_a, item_b;
        uvm_comparer comparer;
        comparer = new();

        item_a = make_item("item_a");
        item_b = const_header_remover_item::type_id::create("item_b");

        item_b.do_copy(item_a);  // set up identical items

        // save value
        if (!item_a.do_compare(item_b, comparer))
            `uvm_error("COMPARE", "do_compare() returned false for same value")
        else
            `uvm_info("COMPARE", "do_compare() returned true for same values", UVM_LOW)

        // different values
        item_b.data.push_back(8'hFF);
        if (item_a.do_compare(item_b, comparer))
            `uvm_error("COMPARE", "do_compare() returned true for different values")
        else
            `uvm_info("COMPARE", "do_compare() returned false for different values", UVM_LOW)
    endtask

    local task test_pack_unpack();
        const_header_remover_item item, dst;
        uvm_comparer comparer;
        bit packed_bits[];
        bit my_packed_bits[];
        int n_bits;

        comparer = new();
        item = make_item("src_pack");
        dst  = const_header_remover_item::type_id::create("dst_pack");

        n_bits = item.pack(packed_bits);
        `uvm_info("PACK", $sformatf("pack() produced %0d bits", n_bits), UVM_LOW)

        // pack manually using streaming
        my_packed_bits = new[item.data.size() * $bits(byte)];
        {>> {my_packed_bits}} = {>> {item.data}};

        if (packed_bits !== my_packed_bits)
            `uvm_error("PACK", "my packed bits do not match the received packed bits")
        else
            `uvm_info("PACK", "my packed bits match the received packed bits", UVM_LOW)

        // unpack and verify round-trip
        void'(dst.unpack(packed_bits));
        if (!item.do_compare(dst, comparer))
            `uvm_error("PACK", "pack/unpack round-trip failed — items differ")
        else
            `uvm_info("PACK", "pack/unpack round-trip — PASS", UVM_LOW)
    endtask

    local task test_pack_unpack_bytes();
        const_header_remover_item item, dst;
        uvm_comparer comparer;
        byte unsigned packed_bytes[];
        byte unsigned my_packed_bytes[];
        int n_bytes;

        comparer = new();
        item = make_item("src_bytes");
        dst  = const_header_remover_item::type_id::create("dst_bytes");

        n_bytes = item.pack_bytes(packed_bytes);
        `uvm_info("PACK_BYTES", $sformatf("pack_bytes() produced %0d bytes", n_bytes), UVM_LOW)

        // pack manually using streaming
        my_packed_bytes = new[item.data.size()];
        {>> {my_packed_bytes}} = {>> {item.data}};

        if (packed_bytes !== my_packed_bytes)
            `uvm_error("PACK_BYTES", "my packed bytes do not match the received packed bytes")
        else
            `uvm_info("PACK_BYTES", "my packed bytes match the received packed bytes", UVM_LOW)

        // unpack and verify round-trip
        void'(dst.unpack_bytes(packed_bytes));
      if (!item.do_compare(dst, comparer))
            `uvm_error("PACK_BYTES", "pack_bytes/unpack_bytes round-trip failed — items differ")
        else
            `uvm_info("PACK_BYTES", "pack_bytes/unpack_bytes round-trip — PASS", UVM_LOW)
    endtask

    local task test_pack_unpack_ints();
        const_header_remover_item item, dst;
        uvm_comparer comparer;
        int unsigned packed_ints[];
        int unsigned my_packed_ints[];
        int n_ints;
        int n_ints_expected;

        item = make_item("src_ints");
        comparer = new();
        dst  = const_header_remover_item::type_id::create("dst_ints");

        n_ints = item.pack_ints(packed_ints);
        `uvm_info("PACK_INTS", $sformatf("pack_ints() produced %0d ints", n_ints), UVM_LOW)

        // pack manually using streaming
        // ceiling division: how many 32-bit ints needed to hold all bytes
        n_ints_expected = (item.data.size() * $bits(byte) + 31) / 32;
        my_packed_ints = new[n_ints_expected];
        {>> {my_packed_ints}} = {>> {item.data}};

        if (packed_ints !== my_packed_ints)
            `uvm_error("PACK_INTS", "my packed ints do not match the received packed ints")
        else
            `uvm_info("PACK_INTS", "my packed ints match the received packed ints", UVM_LOW)

        // unpack and verify round-trip
        void'(dst.unpack_ints(packed_ints));
        if (!item.do_compare(dst, comparer))
            `uvm_error("PACK_INTS", "pack_ints/unpack_ints round-trip failed — items differ")
        else
            `uvm_info("PACK_INTS", "pack_ints/unpack_ints round-trip — PASS", UVM_LOW)
    endtask

endclass

`endif
