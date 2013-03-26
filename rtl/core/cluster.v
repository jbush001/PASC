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
	output reg[3:0]	device_core_id,
	output			device_write_en,
	output			device_read_en,
	output[9:0]		device_addr,
	output[15:0]	device_data_out,
	input[15:0]		device_data_in);

	localparam NUM_CORES = 8;
	localparam LOCAL_MEMORY_SIZE = 512;
	localparam GLOBAL_MEMORY_SIZE = 1024;

	reg[15:0] shared_addr;
	wire[15:0] shared_read_val;
	reg shared_wren;
	reg shared_rden;
	reg[15:0] shared_write_val;
	wire[15:0] global_mem_q;
	wire device_memory_select;
	reg device_memory_select_l;
	wire global_mem_write;
	wire[NUM_CORES-1:0] core_enable;

	// Interconnecting wires
	// (Icarus verilog does not support generate, hence all of the manual
	// instantiations).
	wire[15:0] shared_addr0;
	wire shared_wren0;
	wire shared_rden0;
	wire[15:0] shared_write_val0;
	wire[15:0] shared_addr1;
	wire shared_wren1;
	wire shared_rden1;
	wire[15:0] shared_write_val1;
	wire[15:0] shared_addr2;
	wire shared_wren2;
	wire shared_rden2;
	wire[15:0] shared_write_val2;
	wire[15:0] shared_addr3;
	wire shared_wren3;
	wire shared_rden3;
	wire[15:0] shared_write_val3;
	wire[15:0] shared_addr4;
	wire shared_wren4;
	wire shared_rden4;
	wire[15:0] shared_write_val4;
	wire[15:0] shared_addr5;
	wire shared_wren5;
	wire shared_rden5;
	wire[15:0] shared_write_val5;
	wire[15:0] shared_addr6;
	wire shared_wren6;
	wire shared_rden6;
	wire[15:0] shared_write_val6;
	wire[15:0] shared_addr7;
	wire shared_wren7;
	wire shared_rden7;
	wire[15:0] shared_write_val7;

	core #(LOCAL_MEMORY_SIZE, 4'd0) core0(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr0),
		.shared_wren(shared_wren0),	
		.shared_rden(shared_rden0),
		.shared_ready(core_enable[0]),
		.shared_write_val(shared_write_val0),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE, 4'd1) core1(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr1),
		.shared_wren(shared_wren1),	
		.shared_rden(shared_rden1),
		.shared_ready(core_enable[1]),
		.shared_write_val(shared_write_val1),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE, 4'd2) core2(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr2),
		.shared_wren(shared_wren2),	
		.shared_rden(shared_rden2),
		.shared_ready(core_enable[2]),
		.shared_write_val(shared_write_val2),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE, 4'd3) core3(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr3),
		.shared_wren(shared_wren3),	
		.shared_rden(shared_rden3),
		.shared_ready(core_enable[3]),
		.shared_write_val(shared_write_val3),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE, 4'd4) core4(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr4),
		.shared_wren(shared_wren4),	
		.shared_rden(shared_rden4),
		.shared_ready(core_enable[4]),
		.shared_write_val(shared_write_val4),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE, 4'd5) core5(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr5),
		.shared_wren(shared_wren5),	
		.shared_rden(shared_rden5),
		.shared_ready(core_enable[5]),
		.shared_write_val(shared_write_val5),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE, 4'd6) core6(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr6),
		.shared_wren(shared_wren6),	
		.shared_rden(shared_rden6),
		.shared_ready(core_enable[6]),
		.shared_write_val(shared_write_val6),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE, 4'd7) core7(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr7),
		.shared_wren(shared_wren7),	
		.shared_rden(shared_rden7),
		.shared_ready(core_enable[7]),
		.shared_write_val(shared_write_val7),
		.shared_read_val(shared_read_val));
	
	// Request mux
	always @*
	begin
		case (core_enable)
			8'b10000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren7, shared_rden7, shared_addr7, shared_write_val7, 4'd7 };
			8'b01000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren6, shared_rden6, shared_addr6, shared_write_val6, 4'd6 };
			8'b00100000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren5, shared_rden5, shared_addr5, shared_write_val5, 4'd5 };
			8'b00010000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren4, shared_rden4, shared_addr4, shared_write_val4, 4'd4 };
			8'b00001000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren3, shared_rden3, shared_addr3, shared_write_val3, 4'd3 };
			8'b00000100: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren2, shared_rden2, shared_addr2, shared_write_val2, 4'd2 };
			8'b00000010: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren1, shared_rden1, shared_addr1, shared_write_val1, 4'd1 };
			default: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren0, shared_rden0, shared_addr0, shared_write_val0, 4'd0 };

		endcase
	end

	assign device_memory_select = shared_addr[15:10] == 6'b111111;
	assign device_addr = shared_addr[9:0];
	assign global_mem_write = !device_memory_select && shared_wren;
	assign shared_read_val = device_memory_select_l ? device_data_in : global_mem_q;
	assign device_write_en = device_memory_select && shared_wren; 
	assign device_read_en = device_memory_select && shared_rden;
	assign device_data_out = shared_write_val;

	localparam GMEM_ADDR_WIDTH = $clog2(GLOBAL_MEMORY_SIZE);

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
	wire[NUM_CORES - 1:0] request;

	assign request = {
		shared_wren7 || shared_rden7,
		shared_wren6 || shared_rden6,
		shared_wren5 || shared_rden5,
		shared_wren4 || shared_rden4,
		shared_wren3 || shared_rden3,
		shared_wren2 || shared_rden2,
		shared_wren1 || shared_rden1,
		shared_wren0 || shared_rden0
	};
	
	arbiter #(NUM_CORES) global_mem_arbiter(
		.clk(clk),
		.reset(reset),
		.request(request),
		.grant_oh(core_enable));
`endif
endmodule
