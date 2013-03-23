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

SOURCES=core/dpsram.v \
	core/pipeline.v	\
	core/core.v \
	core/cluster.v \
	core/spsram.v \
	core/top.v \
	core/arbiter.v \
	testbench/multi_tb.v 

multi-sim.vvp: $(SOURCES) core/coreboot.hex
	iverilog -o $@ $(SOURCES)
	
core/coreboot.hex: core/coreboot.asm
	../tools/assemble.py core/coreboot.hex core/coreboot.asm

