// -----------------------------------------------------------------------------
// File        : generation_param.sv
// Author      : Ariel Hay
// Description : The package for the generation parameters
// -----------------------------------------------------------------------------

`ifndef GENERATION_PARAM_SV
`define GENERATION_PARAM_SV

package generation_param;

    // empty constraints 
    int unsigned empty_min = 0;
    int unsigned empty_max = 2;

    // weighted probability for valid and rdy 
    int unsigned valid_weight = 50;
    int unsigned rdy_weight   = 70;

    // packet size constraints 
    int unsigned packet_min_words = 1;
    int unsigned packet_max_words = 100;

    int DATA_WIDTH_IN_BYTES = 4;
    typedef byte queue_of_byte[$];

endpackage

`endif
