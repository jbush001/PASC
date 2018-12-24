#!/usr/bin/python
# 
# Copyright 2018 Mohammad Amin Nili
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
    "/******************************************************************************\n" + \
    "*\n" + \
    "* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.\n" + \
    "*\n" + \
    "* Permission is hereby granted, free of charge, to any person obtaining a copy\n" + \
    "* of this software and associated documentation files (the \"Software\"), to deal\n" + \
    "* in the Software without restriction, including without limitation the rights\n" + \
    "* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n" + \
    "* copies of the Software, and to permit persons to whom the Software is\n" + \
    "* furnished to do so, subject to the following conditions:\n" + \
    "*\n" + \
    "* The above copyright notice and this permission notice shall be included in\n" + \
    "* all copies or substantial portions of the Software.\n" + \
    "*\n" + \
    "* Use of the Software is limited solely to applications:\n" + \
    "* (a) running on a Xilinx device, or\n" + \
    "* (b) that interact with a Xilinx device through a bus or interconnect.\n" + \
    "*\n" + \
    "* THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n" + \
    "* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n" + \
    "* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL\n" + \
    "* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,\n" + \
    "* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF\n" + \
    "* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n" + \
    "* SOFTWARE.\n" + \
    "*\n" + \
    "* Except as contained in this notice, the name of the Xilinx shall not be used\n" + \
    "* in advertising or otherwise to promote the sale, use or other dealings in\n" + \
    "* this Software without prior written authorization from Xilinx.\n" + \
    "*\n" + \
    "******************************************************************************/\n" + \
    "\n\n" + \
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
        ("    Xil_Out32(AXI_BASE_ADDRESS + (0x%x * 4), 0x%s);\n" % (0x4000 + i, codes[i]))
    
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
    "    printf(\"\\n\");\n" + \
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
