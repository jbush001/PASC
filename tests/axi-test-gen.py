#!/usr/bin/python
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

import os, sys

def generate_AXI_Test_File(input_path, output_path):
    f_in  = open(input_path, "r") 
    f_out = open(output_path, "w")
    
    codes = f_in.read().split("\n")

    axi_test_code = \
    "#include <stdio.h>\n" + \
    "#include <sleep.h>\n" + \
    "#include <xil_io.h>\n" + \
    "#include \"platform.h\"\n" + \
    "#include \"xil_printf.h\"\n" + \
    "\n" + \
    "#define AXI_BASE_ADDRESS 0xA0000000\n" + \
    "\n" + \
    "int main()\n" + \
    "{\n" + \
    "    init_platform();\n" + \
    "    print(\"Program started ...\\n\\r\");\n" + \
    "\n"
    
    for i in range(len(codes) - 1):
        axi_test_code = axi_test_code + \
        ("    Xil_Out32(AXI_BASE_ADDRESS + (0x%x * 4), 0x%s);\n" % (i, codes[i]))
    
    axi_test_code = axi_test_code + \
    "\n" + \
    "    u32 result = 0;\n\n"

    for i in range(3, len(sys.argv)):
        axi_test_code = axi_test_code + \
        "    result = Xil_In32(AXI_BASE_ADDRESS + (0x" + sys.argv[i] + " * 4));\n" + \
        "    printf(\"[0x" + sys.argv[i] + "] = 0x%x\\n\", result);\n"

    axi_test_code = axi_test_code + \
    "\n" + \
    "    sleep(1);\n" + \
    "\n"
    
    for i in range(3, len(sys.argv)):
        axi_test_code = axi_test_code + \
        "    result = Xil_In32(AXI_BASE_ADDRESS + (0x" + sys.argv[i] + " * 4));\n" + \
        "    printf(\"[0x" + sys.argv[i] + "] = 0x%x\\n\", result);\n"
    
    axi_test_code = axi_test_code + \
    "\n" + \
    "    cleanup_platform();\n" + \
    "    return 0;\n" + \
    "}\n"

    f_out.write(axi_test_code)

    f_in.close()
    f_out.close()

if len(sys.argv) < 4:
    print 'Usage: axi-test-gen <output file> <input file> <addresses to print>'
    sys.exit(1)

asmFile = sys.argv[2].split(".")[0] + ".asm"
hexFile = sys.argv[1].split(".")[0] + ".hex"
cmd = "../tools/assemble.py" + " " + hexFile + " " + asmFile
os.system(cmd)
generate_AXI_Test_File(hexFile, sys.argv[1])
