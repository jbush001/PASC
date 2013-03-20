# 
# Copyright 2013 Jeff Bush
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 

COMMON_FILES=core/dpsram.v \
	core/pipeline.v	\
	core/core.v 

SINGLE_FILES=$(COMMON_FILES) \
	testbench/single_tb.v

MULTI_FILES =$(COMMON_FILES) \
	core/cluster.v \
	core/spsram.v \
	core/top.v \
	testbench/multi_tb.v 

single-sim.vvp: $(SINGLE_FILES)
	iverilog -o $@ $(SINGLE_FILES)

multi-sim.vvp: $(MULTI_FILES)
	iverilog -o $@ $(MULTI_FILES)

runsingle: single-sim.vvp
	vvp single-sim.vvp +bin=../tests/bubble-sort.hex -lxt2

runmulti: multi-sim.vvp
	vvp multi-sim.vvp +bin=../tests/synchronize.hex -lxt2

