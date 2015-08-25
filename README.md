This is a multi-core embedded processor. There are a 16 RISC cores,
each with a small chunk of local memory and a shared global memory area.
Documentation is in the wiki
(https://github.com/jbush001/PASC/wiki).

## Required Software

- Python 2.7
- Icarus Verilog (for simulation) [http://iverilog.icarus.com/]
- Altera Quartus (for FPGA)
- GNU Make

## Assembling Programs

These are in the test directory

    tools/assemble.py tests/sourcefile.hex tests/sourcefile.asm

Replace 'sourcefile' in the command line with the desired file.

## Running in Verilog Simulation

1. Build the verilog model and bootloader:

        cd rtl
        make

2. Run a verilog model making the +bin parameter point to the program you
   want to run, which should have been assembled already above.

        vvp multi-sim.vvp +bin=../tests/sourcefile.hex -lxt2

Any value written to address 0xFFFF will be displayed on the console. A trace
file will be dumped into 'trace.lxt', which can be read with GTKWave or the
like.

## Running on FPGA

This is for the Cyclone II Starter Kit. Synthesize design by opening
'fpga/cIIstarter/cIIstarter.qpf'.  Note that the design needs to be
resynthesized each time the program is changed.

