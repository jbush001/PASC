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

module core
	#(parameter MEM_SIZE = 2048,
	parameter CORE_ID = 0)
	
	(input clk,
	input reset,
	output[15:0] remote_addr,
	output remote_wren,
	output remote_rden,
	input remote_ready,
	output[15:0] remote_write_val,
	input[15:0] remote_read_val);

	localparam LMEM_ADDR_WIDTH = $clog2(MEM_SIZE);

	wire[15:0] iaddr;
	wire[15:0] idata;
	wire[15:0] daddr;
	wire[15:0] ddata_out;
	wire[15:0] local_mem_q;
	wire dwrite_en;
	wire dread_en;
	wire local_memory_select;
	reg local_memory_select_l;	// last cycle was local memory access
	wire device_memory_access;
	wire[15:0] data_to_pipeline;
	wire stall_pipeline;
	wire local_memory_write;
	
	assign local_memory_select = daddr[15:14] == 2'b00;	// Bottom 16k words
	assign remote_wren = !local_memory_select && dwrite_en;
	assign remote_rden = !local_memory_select && dread_en;
	assign remote_addr = daddr;
	assign remote_write_val = ddata_out;
	assign local_memory_write = dwrite_en && local_memory_select;

	// This is delayed by one cycle
	assign data_to_pipeline = local_memory_select_l ? local_mem_q : remote_read_val;

	dpsram #(MEM_SIZE, 16, LMEM_ADDR_WIDTH, "core/coreboot.hex") local_memory(
		.clk(clk),
		.addr_a(iaddr[LMEM_ADDR_WIDTH - 1:0]),	// Instruction Port
		.q_a(idata),
		.we_a(1'b0),
		.data_a(16'd0),
		.addr_b(daddr[LMEM_ADDR_WIDTH - 1:0]),	// Data Port
		.q_b(local_mem_q),
		.we_b(local_memory_write),
		.data_b(ddata_out));

	assign stall_pipeline = !remote_ready && (dread_en || dwrite_en) 
		&& !local_memory_select;

	pipeline pipeline(
		.clk(clk),
		.reset(reset),
		.iaddr(iaddr),
		.idata(idata),
		.daddr(daddr),
		.ddata_out(ddata_out),
		.ddata_in(data_to_pipeline),
		.dwrite_en(dwrite_en),
		.dread_en(dread_en),
		.stall(stall_pipeline));

	always @(posedge reset, posedge clk)
	begin
		if (reset)
			local_memory_select_l <= 0;
		else
			local_memory_select_l <= local_memory_select;
	end
endmodule
