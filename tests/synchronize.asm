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


					ldi r0, -2		# semaphore address
					ldi r2, 4096	# global address
					ldi r1, 1		# store value
spinlock:			store r1, (r0)	# acquire semaphore
					load r3, (r0)	# did we grab it?
					nop
					nop
					and r3, r3, r3
					bzs spinlock	# no, so wait
					nop
					nop
					
					load r3, (r2)	# load value
					nop
					nop
					addi r3, r3, 1	# increment
					store r3, (r2)	# update
					
					xor r1, r1, r1	# clear
					store r1, (r0)	# Reset seamaphore
					
					ldi r0, -1		# load print address
					store r3, (r0)	# write out value
					
done:				jump done
					nop
					nop
					
					
					
					
					
					
					
					
