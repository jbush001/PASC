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

SOURCES=blinky \
	bubble-sort \
	bubble-sort-memory
	

ASSEMBLE=../tools/assemble.py

AXI_TEST_GEN=./axi-test-gen.py
ADDRS_TO_PRINT=4100 4101 4102 4103 4104 4105 4106 4107 4108 4109 410A 410B 410C 410D 410E 410F

all: axi-test-file

axi-test-file: $(ASM_SOURCES) $(AXI_TEST_GEN)
	@$(foreach SOURCE, $(SOURCES), $(AXI_TEST_GEN) $(SOURCE).c $(SOURCE).asm $(ADDRS_TO_PRINT);)

hex-file: $(ASM_SOURCES) $(ASSEMBLE)
	@$(foreach SOURCE, $(SOURCES), $(ASSEMBLE) $(SOURCE).hex $(SOURCE).asm;)

clean:
	rm *.hex *.c

