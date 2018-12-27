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

#
# Core boot ROM
# Each individual core will run this program at startup.  It copies
# code from global memory into local memory, then executes it.
#
# 16 words are reserved for this program
#

                ldi r0, 0x4000      # Base address of global memory
                ldi r1, 16          # Load address in local memory
                load r2, (r0)       # Load code length
                addi r0, r0, 1      # Increment code pointer
                nop
copy_loop:      load r3, (r0)       # Load global
                addi r0, r0, 1
                nop
                store r3, (r1)      # Store local
                addi r1, r1, 1
                addi r2, r2, -1
                bzc copy_loop
                nop
                nop
# Program code starts here
