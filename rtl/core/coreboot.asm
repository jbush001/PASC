#
# Core boot ROM
# Each individual core will run this program at startup.  It copies
# code from global memory into local memory, then executes it.
#
# 16 words are reserved for this program
#

				ldi r0, 0x4000		# Base address of global memory
				ldi r1, 16			# Load address in local memory
				load r2, (r0)		# Load code length
				addi r0, r0, 1		# Increment code pointer
				nop
copy_loop:		load r3, (r0)		# Load global
				addi r0, r0, 1
				nop
				store r3, (r1)		# Store local
				addi r1, r1, 1
				addi r2, r2, -1
				bzc copy_loop
				nop
				nop
# Program code starts here