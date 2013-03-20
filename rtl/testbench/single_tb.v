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

module single_tb;

	reg clk = 0;
	reg reset = 0;
	wire[15:0] value_out;
	wire has_output_value;
	reg[1000:0] filename;
	wire remote_wren;
	wire remote_rden;
	wire remote_ready;
	wire[15:0] remote_write_val;
	wire[15:0] remote_read_val;
	wire[15:0] remote_addr;

	assign remote_ready = 1;

	core #(2048) core(
		.clk(clk),
		.reset(reset),
		.remote_wren(remote_wren),
		.remote_rden(remote_rden),
		.remote_ready(remote_ready),
		.remote_write_val(remote_write_val),
		.remote_read_val(remote_read_val),
		.remote_addr(remote_addr));

	integer i;

	initial
	begin
		if ($value$plusargs("bin=%s", filename))
			$readmemh(filename, core.local_memory.data);
		else
		begin
			$display("error opening memory image");
			$finish;
		end

		$dumpfile("trace.lxt");
		$dumpvars;

		#5 reset = 1;
		#5 reset = 0;
		for (i = 0; i < 2000; i = i + 1)
		begin
			#5 clk = 0;
			if (remote_wren)
				$display("output %04x", remote_write_val);
			
			#5 clk = 1;
		end
	end

endmodule
