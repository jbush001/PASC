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

module multi_tb;

	reg clk = 0;
	reg reset = 0;
	wire[15:0] value_out;
	wire has_output_value;
	reg[1000:0] filename;
	wire[15:0] output_val;
	wire output_enable;

	top top(
		.clk(clk),
		.reset(reset),
		.output_val(output_val),
		.output_enable(output_enable));

	integer i;

	initial
	begin
		if ($value$plusargs("bin=%s", filename))
		begin
			$readmemh(filename, top.cluster.core0.local_memory.data);
			$readmemh(filename, top.cluster.core1.local_memory.data);
			$readmemh(filename, top.cluster.core2.local_memory.data);
			$readmemh(filename, top.cluster.core3.local_memory.data);
			$readmemh(filename, top.cluster.core4.local_memory.data);
			$readmemh(filename, top.cluster.core5.local_memory.data);
			$readmemh(filename, top.cluster.core6.local_memory.data);
			$readmemh(filename, top.cluster.core7.local_memory.data);
		end
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
			if (output_enable)
				$display("output %04x", output_val);
			
			#5 clk = 1;
		end
	end

endmodule
