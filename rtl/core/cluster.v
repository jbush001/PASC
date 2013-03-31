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

module cluster(
	input 			clk,
	input			reset,
	output [3:0]	device_core_id,
	output			device_write_en,
	output			device_read_en,
	output[9:0]		device_addr,
	output[15:0]	device_data_out,
	input[15:0]		device_data_in);

	localparam NUM_CORES = 16;
	localparam LOCAL_MEMORY_SIZE = 512;
	localparam GLOBAL_MEMORY_SIZE = 1024;

	wire[15:0] shared_addr;
	wire[15:0] shared_read_val;
	wire shared_wren;
	wire shared_rden;
	wire[15:0] shared_write_val;
	wire[15:0] global_mem_q;
	wire device_memory_select;
	reg device_memory_select_l;
	wire global_mem_write;
	wire[NUM_CORES-1:0] core_enable;
	wire[NUM_CORES-1:0] core_request;

	core #(LOCAL_MEMORY_SIZE) core0(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[0]),
		.shared_request(core_request[0]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core1(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[1]),
		.shared_request(core_request[1]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core2(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[2]),
		.shared_request(core_request[2]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core3(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[3]),
		.shared_request(core_request[3]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core4(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[4]),
		.shared_request(core_request[4]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core5(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[5]),
		.shared_request(core_request[5]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core6(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[6]),
		.shared_request(core_request[6]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core7(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[7]),
		.shared_request(core_request[7]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core8(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[8]),
		.shared_request(core_request[8]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core9(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[9]),
		.shared_request(core_request[9]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core10(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[10]),
		.shared_request(core_request[10]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core11(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[11]),
		.shared_request(core_request[11]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core12(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[12]),
		.shared_request(core_request[12]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core13(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[13]),
		.shared_request(core_request[13]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core14(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[14]),
		.shared_request(core_request[14]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core15(
		.clk(clk),
		.reset(reset),
		.shared_ready(core_enable[15]),
		.shared_request(core_request[15]),
		.shared_addr(shared_addr),
		.shared_wren(shared_wren),	
		.shared_rden(shared_rden),
		.shared_write_val(shared_write_val),
		.shared_read_val(shared_read_val));

	assign device_memory_select = shared_addr[15:10] == 6'b111111;
	assign device_addr = shared_addr[9:0];
	assign global_mem_write = !device_memory_select && shared_wren;
	assign shared_read_val = device_memory_select_l ? device_data_in : global_mem_q;
	assign device_write_en = device_memory_select && shared_wren; 
	assign device_read_en = device_memory_select && shared_rden;
	assign device_data_out = shared_write_val;

	localparam GMEM_ADDR_WIDTH = $clog2(GLOBAL_MEMORY_SIZE);

	// Convert one-hot to binary
	assign device_core_id = {
		core_enable[15:8] != 0,
		core_enable[7:4] != 0 || core_enable[15:12] != 0,
		core_enable[3:2] != 0 || core_enable[7:6] != 0 || core_enable[11:10] != 0
			|| core_enable[15:14],
		core_enable[1] || core_enable[3] || core_enable[5] || core_enable[7]
			|| core_enable[9] || core_enable[11] || core_enable[13] || core_enable[15]
	};

	spsram 
`ifdef FEATURE_FPGA
	#(GLOBAL_MEMORY_SIZE, 16, GMEM_ADDR_WIDTH, 1, "program.hex") 
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
