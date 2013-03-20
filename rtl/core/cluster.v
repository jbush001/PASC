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

module cluster(
	input 			clk,
	input			reset,
	output reg[2:0]	device_core_id,
	output			device_write_en,
	output			device_read_en,
	output[9:0]		device_addr,
	output[15:0]	device_data_out,
	input[15:0]		device_data_in);

	localparam NUM_CORES = 8;
	localparam LOCAL_MEMORY_SIZE = 512;

	reg[15:0] remote_addr;
	wire[15:0] remote_read_val;
	reg remote_wren;
	reg remote_rden;
	reg[15:0] remote_write_val;
	wire[15:0] remote_addr0;
	wire remote_wren0;
	wire remote_rden0;
	wire[15:0] remote_write_val0;
	wire[15:0] remote_addr1;
	wire remote_wren1;
	wire remote_rden1;
	wire[15:0] remote_write_val1;
	wire[15:0] remote_addr2;
	wire remote_wren2;
	wire remote_rden2;
	wire[15:0] remote_write_val2;
	wire[15:0] remote_addr3;
	wire remote_wren3;
	wire remote_rden3;
	wire[15:0] remote_write_val3;
	wire[15:0] remote_addr4;
	wire remote_wren4;
	wire remote_rden4;
	wire[15:0] remote_write_val4;
	wire[15:0] remote_addr5;
	wire remote_wren5;
	wire remote_rden5;
	wire[15:0] remote_write_val5;
	wire[15:0] remote_addr6;
	wire remote_wren6;
	wire remote_rden6;
	wire[15:0] remote_write_val6;
	wire[15:0] remote_addr7;
	wire remote_wren7;
	wire remote_rden7;
	wire[15:0] remote_write_val7;
	wire[15:0] global_mem_q;
	wire device_memory_select;
	reg device_memory_select_l;
	wire gmem_write;

	reg[NUM_CORES-1:0] core_enable;

	core #(LOCAL_MEMORY_SIZE, 0) core0(
		.clk(clk),
		.reset(reset),
		.remote_addr(remote_addr0),
		.remote_wren(remote_wren0),	
		.remote_rden(remote_rden0),
		.remote_ready(core_enable[0]),
		.remote_write_val(remote_write_val0),
		.remote_read_val(remote_read_val));

	core #(LOCAL_MEMORY_SIZE, 1) core1(
		.clk(clk),
		.reset(reset),
		.remote_addr(remote_addr1),
		.remote_wren(remote_wren1),	
		.remote_rden(remote_rden1),
		.remote_ready(core_enable[1]),
		.remote_write_val(remote_write_val1),
		.remote_read_val(remote_read_val));

	core #(LOCAL_MEMORY_SIZE, 2) core2(
		.clk(clk),
		.reset(reset),
		.remote_addr(remote_addr2),
		.remote_wren(remote_wren2),	
		.remote_rden(remote_rden2),
		.remote_ready(core_enable[2]),
		.remote_write_val(remote_write_val2),
		.remote_read_val(remote_read_val));

	core #(LOCAL_MEMORY_SIZE, 3) core3(
		.clk(clk),
		.reset(reset),
		.remote_addr(remote_addr3),
		.remote_wren(remote_wren3),	
		.remote_rden(remote_rden3),
		.remote_ready(core_enable[3]),
		.remote_write_val(remote_write_val3),
		.remote_read_val(remote_read_val));

	core #(LOCAL_MEMORY_SIZE, 4) core4(
		.clk(clk),
		.reset(reset),
		.remote_addr(remote_addr4),
		.remote_wren(remote_wren4),	
		.remote_rden(remote_rden4),
		.remote_ready(core_enable[4]),
		.remote_write_val(remote_write_val4),
		.remote_read_val(remote_read_val));

	core #(LOCAL_MEMORY_SIZE, 5) core5(
		.clk(clk),
		.reset(reset),
		.remote_addr(remote_addr5),
		.remote_wren(remote_wren5),	
		.remote_rden(remote_rden5),
		.remote_ready(core_enable[5]),
		.remote_write_val(remote_write_val5),
		.remote_read_val(remote_read_val));

	core #(LOCAL_MEMORY_SIZE, 6) core6(
		.clk(clk),
		.reset(reset),
		.remote_addr(remote_addr6),
		.remote_wren(remote_wren6),	
		.remote_rden(remote_rden6),
		.remote_ready(core_enable[6]),
		.remote_write_val(remote_write_val6),
		.remote_read_val(remote_read_val));

	core #(LOCAL_MEMORY_SIZE, 7) core7(
		.clk(clk),
		.reset(reset),
		.remote_addr(remote_addr7),
		.remote_wren(remote_wren7),	
		.remote_rden(remote_rden7),
		.remote_ready(core_enable[7]),
		.remote_write_val(remote_write_val7),
		.remote_read_val(remote_read_val));
	
	// Request mux
	always @*
	begin
		case (core_enable)
			8'b10000000: { remote_wren, remote_rden, remote_addr, remote_write_val, device_core_id } 
				= { remote_wren7, remote_rden7, remote_addr7, remote_write_val7, 3'd7 };
			8'b01000000: { remote_wren, remote_rden, remote_addr, remote_write_val, device_core_id } 
				= { remote_wren6, remote_rden6, remote_addr6, remote_write_val6, 3'd6 };
			8'b00100000: { remote_wren, remote_rden, remote_addr, remote_write_val, device_core_id } 
				= { remote_wren5, remote_rden5, remote_addr5, remote_write_val5, 3'd5 };
			8'b00010000: { remote_wren, remote_rden, remote_addr, remote_write_val, device_core_id } 
				= { remote_wren4, remote_rden4, remote_addr4, remote_write_val4, 3'd4 };
			8'b00001000: { remote_wren, remote_rden, remote_addr, remote_write_val, device_core_id } 
				= { remote_wren3, remote_rden3, remote_addr3, remote_write_val3, 3'd3 };
			8'b00000100: { remote_wren, remote_rden, remote_addr, remote_write_val, device_core_id } 
				= { remote_wren2, remote_rden2, remote_addr2, remote_write_val2, 3'd2 };
			8'b00000010: { remote_wren, remote_rden, remote_addr, remote_write_val, device_core_id } 
				= { remote_wren1, remote_rden1, remote_addr1, remote_write_val1, 3'd1 };
			default: { remote_wren, remote_rden, remote_addr, remote_write_val, device_core_id } 
				= { remote_wren0, remote_rden0, remote_addr0, remote_write_val0, 3'd0 };

		endcase
	end

	assign device_memory_select = remote_addr[15:10] == 6'b111111;
	assign device_addr = remote_addr[9:0];
	assign gmem_write = !device_memory_select && remote_wren;
	assign remote_read_val = device_memory_select_l ? device_data_in : global_mem_q;
	assign device_write_en = device_memory_select && remote_wren; 
	assign device_read_en = device_memory_select && remote_rden;
	assign device_data_out = remote_write_val;

	localparam GMEM_SIZE = 1024;
	localparam GMEM_ADDR_WIDTH = $clog2(GMEM_SIZE);

	spsram #(GMEM_SIZE, 16, GMEM_ADDR_WIDTH) global_memory(
		.clk(clk),
		.addr_a(remote_addr[GMEM_ADDR_WIDTH - 1:0]),
		.q_a(global_mem_q),
		.we_a(gmem_write),
		.data_a(remote_write_val));

	always @(posedge reset, posedge clk)
	begin
		if (reset)
		begin
			device_memory_select_l <= 0;
			core_enable <= {{NUM_CORES - 1{1'b0}}, 1'b1};
		end
		else 
		begin
			device_memory_select_l <= device_memory_select;
			core_enable = { core_enable[NUM_CORES - 2:0], core_enable[NUM_CORES - 1] };
		end
	end
endmodule
