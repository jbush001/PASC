// 
// Copyright 2013 Jeff Bush
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 

//
// A cluster is the group of processors and global memory that is shared
// between them.
//

`include "config.v"

module cluster
    #(parameter NUM_CORES = 16)
    
    (input          clk,
    input           reset,
    input[15:0]     device_data_in,
    output          device_write_en,
    output          device_read_en,
    output[9:0]     device_addr,
    output[15:0]    device_data_out,
    output reg [$clog2(NUM_CORES) - 1:0] device_core_id);
    
    localparam LOCAL_MEMORY_SIZE = 512;
    localparam GLOBAL_MEMORY_SIZE = 1024;
    
    wire[15:0] shared_addr;
    wire[15:0] shared_addr_tmp [0:NUM_CORES-1];
    
    wire[15:0] shared_read_val;
    
    wire shared_wren;
    wire shared_wren_tmp [NUM_CORES-1:0];
    
    wire shared_rden;
    wire shared_rden_tmp [NUM_CORES-1:0];
    
    wire[15:0] shared_write_val;
    wire[15:0] shared_write_val_tmp[0:NUM_CORES-1];
    
    wire[15:0] global_mem_q;
    wire device_memory_select;
    reg device_memory_select_l;
    wire global_mem_write;
    wire[NUM_CORES-1:0] core_enable;
    wire[NUM_CORES-1:0] core_request;
    
    assign shared_wren = shared_wren_tmp[device_core_id];
    assign shared_rden = shared_rden_tmp[device_core_id];
    assign shared_addr = shared_addr_tmp[device_core_id];
    assign shared_write_val = shared_write_val_tmp[device_core_id];

    genvar i;
    generate
        for (i = 0; i < NUM_CORES; i = i + 1)
        begin: core
            core #(LOCAL_MEMORY_SIZE) inst (
                .clk(clk),
                .reset(reset),
                .shared_ready(core_enable[i]),
                .shared_request(core_request[i]),
                .shared_addr(shared_addr_tmp[i]),
                .shared_wren(shared_wren_tmp[i]),    
                .shared_rden(shared_rden_tmp[i]),
                .shared_write_val(shared_write_val_tmp[i]),
                .shared_read_val(shared_read_val));
        end
    endgenerate

    assign device_memory_select = shared_addr[15:10] == 6'b111111;
    assign device_addr = shared_addr[9:0];
    assign global_mem_write = !device_memory_select && shared_wren;
    assign shared_read_val = device_memory_select_l ? device_data_in : global_mem_q;
    assign device_write_en = device_memory_select && shared_wren; 
    assign device_read_en = device_memory_select && shared_rden;
    assign device_data_out = shared_write_val;

    localparam GMEM_ADDR_WIDTH = $clog2(GLOBAL_MEMORY_SIZE);

    // Convert one-hot to binary
    integer oh_index;
    always @*
    begin : convert
        device_core_id = 0;
        for (oh_index = 0; oh_index < NUM_CORES; oh_index = oh_index + 1)
        begin
            if (core_enable[oh_index])
            begin : convert
                 // Use 'or' to avoid synthesizing priority encoder
                device_core_id = device_core_id | oh_index[$clog2(NUM_CORES) - 1:0];
            end
        end
    end

    spsram 
`ifdef FEATURE_FPGA
    #(GLOBAL_MEMORY_SIZE, 16, GMEM_ADDR_WIDTH, 1, `PROGRAM_PATH) 
`else
    #(GLOBAL_MEMORY_SIZE, 16, GMEM_ADDR_WIDTH) 
`endif
    global_memory(
        .clk(clk),
        .addr_a(shared_addr[GMEM_ADDR_WIDTH - 1:0]),
        .q_a(global_mem_q),
        .we_a(global_mem_write),
        .data_a(shared_write_val));

    always @(posedge reset, posedge clk)
    begin
        if (reset)
            device_memory_select_l <= 0;
        else 
            device_memory_select_l <= device_memory_select;
    end

`ifdef STATIC_ARBITRATION
    reg[NUM_CORES - 1:0] core_enable_ff;
    
    assign core_enable = core_enable_ff;

    always @(posedge reset, posedge clk)
    begin
        if (reset)
            core_enable_ff <= {{NUM_CORES - 1{1'b0}}, 1'b1};
        else 
            core_enable_ff = { core_enable_ff[NUM_CORES - 2:0], core_enable_ff[NUM_CORES - 1] };
    end
`else
    arbiter #(NUM_CORES) global_mem_arbiter(
        .clk(clk),
        .reset(reset),
        .request(core_request),
        .grant_oh(core_enable));
`endif
endmodule
