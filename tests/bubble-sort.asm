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
# r0 - pointer into array
# r1 - count of elements
# r2 - first element
# r3 - second element
# r4 - temporary
# r5 - set if another loop is necessary
#
            
                res __end           # Size for bootloader to copy
                org 16

sort_loop:      lea r0, data_array
                load r1, (r0)       # Load element count
                addi r0, r0, 1      # skip to start of data array
                ldi r5, 0
                addi r1, r1, -1
item_loop:      load r2, (r0)       # first element
                load r3, 1(r0)      # second element
                nop
                nop
                sub r4, r3, r2      # Compare
                bnc noswap          # Skip if these are already in order                
                nop                 # delay slot 0
                nop                 # delay slot 1

                store r3, (r0)      # Swap
                store r2, 1(r0)
                addi r5, r5, 1      # set r5
noswap:         addi r1, r1, -1
                bzc item_loop
                addi r0, r0, 1      # delay slot 0  
                nop                 # delay slot 1

                # Bottom of loop
                and r5, r5, r5      # Is this zero?
                bzc sort_loop       # No, we swapped, do another pass
                nop
                nop

#
# Write the result to output device
#
output_result:  lea r0, data_array
                load r1, (r0)
                addi r0, r0, 1
                ldi r3, -1          # Output port address
char_loop:      load r2, (r0)   
                addi r0, r0, 1
                nop
                store r2, (r3)
                addi r1, r1, -1
                bzc char_loop
                nop
                nop

done:           jump done               
                nop
                nop


# First element is total element count
data_array:     res 10, 1, 4, 2, 8, 6, 5, 10, 3, 7, 9  
