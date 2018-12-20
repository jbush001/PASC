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

RTL_SOURCES=core/dpsram.v \
	core/pipeline.v \
	core/core.v \
	core/cluster.v \
	core/spsram.v \
	core/pasc.v \
	core/arbiter.v \
	testbench/multi_tb.v

ASSEMBLE=../tools/assemble.py

COREBOOT=../os/coreboot
COREBOOT_ASM=$(COREBOOT).asm
COREBOOT_HEX=$(COREBOOT).hex

SAMPLE_PROGRAM=../tests/bubble-sort
SAMPLE_PROGRAM_ASM=$(SAMPLE_PROGRAM).asm
SAMPLE_PROGRAM_HEX=$(SAMPLE_PROGRAM).hex

all: multi-sim.vvp

multi-sim.vvp: $(RTL_SOURCES) sample_program coreboot
	mkdir simulation
	iverilog -I core/ -o simulation/multi-sim.vvp $(RTL_SOURCES)
	vvp simulation/multi-sim.vvp +bin=$(SAMPLE_PROGRAM_HEX) -lxt2
	mv trace.lxt simulation
	
coreboot: $(COREBOOT_ASM)
	$(ASSEMBLE) $(COREBOOT_HEX) $(COREBOOT_ASM)

sample_program: $(SAMPLE_PROGRAM_ASM)
	$(ASSEMBLE) $(SAMPLE_PROGRAM_HEX) $(SAMPLE_PROGRAM_ASM)

clean:
	rm -rf simulation 

