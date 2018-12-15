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
    wire[15:0] value_out;
    wire has_output_value;
    reg[1000:0] filename;
    wire[15:0] output_data_val;
    wire output_enable;

    top top(
        .clk(clk),
        .output_data_val(output_data_val),
        .output_enable(output_enable));

    integer i;

    initial
    begin
        if ($value$plusargs("bin=%s", filename))
            $readmemh(filename, top.cluster.global_memory.data);
        else
        begin
            $display("error opening memory image");
            $finish;
        end

        $dumpfile("trace.lxt");
        $dumpvars;

        for (i = 0; i < 2000; i = i + 1)
        begin
            #5 clk = 0;
            if (output_enable)
                $display("output %04x", output_data_val);
            
            #5 clk = 1;
        end
    end

endmodule
