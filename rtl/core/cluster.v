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

	localparam NUM_CORES = 16;
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
	wire[15:0] shared_addr8;
	wire shared_wren8;
	wire shared_rden8;
	wire[15:0] shared_write_val8;
	wire[15:0] shared_addr9;
	wire shared_wren9;
	wire shared_rden9;
	wire[15:0] shared_write_val9;
	wire[15:0] shared_addr10;
	wire shared_wren10;
	wire shared_rden10;
	wire[15:0] shared_write_val10;
	wire[15:0] shared_addr11;
	wire shared_wren11;
	wire shared_rden11;
	wire[15:0] shared_write_val11;
	wire[15:0] shared_addr12;
	wire shared_wren12;
	wire shared_rden12;
	wire[15:0] shared_write_val12;
	wire[15:0] shared_addr13;
	wire shared_wren13;
	wire shared_rden13;
	wire[15:0] shared_write_val13;
	wire[15:0] shared_addr14;
	wire shared_wren14;
	wire shared_rden14;
	wire[15:0] shared_write_val14;
	wire[15:0] shared_addr15;
	wire shared_wren15;
	wire shared_rden15;
	wire[15:0] shared_write_val15;

	core #(LOCAL_MEMORY_SIZE) core0(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr0),
		.shared_wren(shared_wren0),	
		.shared_rden(shared_rden0),
		.shared_ready(core_enable[0]),
		.shared_write_val(shared_write_val0),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core1(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr1),
		.shared_wren(shared_wren1),	
		.shared_rden(shared_rden1),
		.shared_ready(core_enable[1]),
		.shared_write_val(shared_write_val1),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core2(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr2),
		.shared_wren(shared_wren2),	
		.shared_rden(shared_rden2),
		.shared_ready(core_enable[2]),
		.shared_write_val(shared_write_val2),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core3(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr3),
		.shared_wren(shared_wren3),	
		.shared_rden(shared_rden3),
		.shared_ready(core_enable[3]),
		.shared_write_val(shared_write_val3),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core4(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr4),
		.shared_wren(shared_wren4),	
		.shared_rden(shared_rden4),
		.shared_ready(core_enable[4]),
		.shared_write_val(shared_write_val4),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core5(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr5),
		.shared_wren(shared_wren5),	
		.shared_rden(shared_rden5),
		.shared_ready(core_enable[5]),
		.shared_write_val(shared_write_val5),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core6(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr6),
		.shared_wren(shared_wren6),	
		.shared_rden(shared_rden6),
		.shared_ready(core_enable[6]),
		.shared_write_val(shared_write_val6),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core7(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr7),
		.shared_wren(shared_wren7),	
		.shared_rden(shared_rden7),
		.shared_ready(core_enable[7]),
		.shared_write_val(shared_write_val7),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core8(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr8),
		.shared_wren(shared_wren8),	
		.shared_rden(shared_rden8),
		.shared_ready(core_enable[8]),
		.shared_write_val(shared_write_val8),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core9(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr9),
		.shared_wren(shared_wren9),	
		.shared_rden(shared_rden9),
		.shared_ready(core_enable[9]),
		.shared_write_val(shared_write_val9),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core10(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr10),
		.shared_wren(shared_wren10),	
		.shared_rden(shared_rden10),
		.shared_ready(core_enable[10]),
		.shared_write_val(shared_write_val10),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core11(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr11),
		.shared_wren(shared_wren11),	
		.shared_rden(shared_rden11),
		.shared_ready(core_enable[11]),
		.shared_write_val(shared_write_val11),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core12(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr12),
		.shared_wren(shared_wren12),	
		.shared_rden(shared_rden12),
		.shared_ready(core_enable[12]),
		.shared_write_val(shared_write_val12),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core13(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr13),
		.shared_wren(shared_wren13),	
		.shared_rden(shared_rden13),
		.shared_ready(core_enable[13]),
		.shared_write_val(shared_write_val13),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core14(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr14),
		.shared_wren(shared_wren14),	
		.shared_rden(shared_rden14),
		.shared_ready(core_enable[14]),
		.shared_write_val(shared_write_val14),
		.shared_read_val(shared_read_val));

	core #(LOCAL_MEMORY_SIZE) core15(
		.clk(clk),
		.reset(reset),
		.shared_addr(shared_addr15),
		.shared_wren(shared_wren15),	
		.shared_rden(shared_rden15),
		.shared_ready(core_enable[15]),
		.shared_write_val(shared_write_val15),
		.shared_read_val(shared_read_val));
	
	// Request mux
	always @*
	begin
		case (core_enable)
			16'b1000000000000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren15, shared_rden15, shared_addr15, shared_write_val15, 4'd15 };
			16'b0100000000000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren14, shared_rden14, shared_addr14, shared_write_val14, 4'd14 };
			16'b0010000000000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren13, shared_rden13, shared_addr13, shared_write_val13, 4'd13 };
			16'b0001000000000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren12, shared_rden12, shared_addr12, shared_write_val12, 4'd12 };
			16'b0000100000000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren11, shared_rden11, shared_addr11, shared_write_val11, 4'd11 };
			16'b0000010000000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren10, shared_rden10, shared_addr10, shared_write_val10, 4'd10 };
			16'b0000001000000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren9, shared_rden9, shared_addr9, shared_write_val9, 4'd9 };
			16'b0000000100000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren8, shared_rden8, shared_addr8, shared_write_val8, 4'd8 };
			16'b0000000010000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren7, shared_rden7, shared_addr7, shared_write_val7, 4'd7 };
			16'b0000000001000000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren6, shared_rden6, shared_addr6, shared_write_val6, 4'd6 };
			16'b0000000000100000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren5, shared_rden5, shared_addr5, shared_write_val5, 4'd5 };
			16'b0000000000010000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren4, shared_rden4, shared_addr4, shared_write_val4, 4'd4 };
			16'b0000000000001000: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren3, shared_rden3, shared_addr3, shared_write_val3, 4'd3 };
			16'b0000000000000100: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
				= { shared_wren2, shared_rden2, shared_addr2, shared_write_val2, 4'd2 };
			16'b0000000000000010: { shared_wren, shared_rden, shared_addr, shared_write_val, device_core_id } 
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
		shared_wren15 || shared_rden15,
		shared_wren14 || shared_rden14,
		shared_wren13 || shared_rden13,
		shared_wren12 || shared_rden12,
		shared_wren11 || shared_rden11,
		shared_wren10 || shared_rden10,
		shared_wren9 || shared_rden9,
		shared_wren8 || shared_rden8,
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
