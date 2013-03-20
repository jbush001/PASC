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

import shlex, sys

class AssembleError(Exception):
	def __init__(self, msg, lineno = -1):
		self.lineno = lineno
		self.msg = msg

	def __str__(self):
		return str(self.lineno) + ': ' + self.msg

class CodeBuilder:
	FIXUP_UNCONDITIONAL = 0
	FIXUP_CONDITIONAL = 1
	FIXUP_DATA_REF = 2

	def __init__(self):
		self.fixups = []
		self.code = []
		self.labels = {}

	def emitData(self, value):
		self.code += [ value ]

	def _emit(self, type, instr):
		self.code += [ ((type << 13) | instr) ]

	def emitArith(self, operation, dest, opa, opb):
		self._emit(0, (operation << 9) | (opb << 6) | (opa << 3) | dest)
		
	def emitLoad(self, dest, ptr, offset):
		self._emit(1, (offset << 6) | (ptr << 3) | dest)
		
	def emitStore(self, src, ptr, offset):
		self._emit(2, (((offset >> 3) & 0xf) << 9) | (src << 6) | (ptr << 3) | (offset & 7))

	def emitRegisterBranch(self, reg, link):
		self._emit(7, (link << 12) | (reg << 6))
		
	def emitLui(self, dest, value):
		if value > 512 or value < -512:
			raise AssembleError('immediate value out of range ' + str(value))

		self._emit(4, ((value & 0x3ff) << 3) | dest)
		
	def emitAddi(self, dest, opa, value):
		if value > 63 or value < -63:
			raise AssembleError('immediate value out of range ' + str(value))

		self._emit(3, ((value & 0x7f) << 6) | (opa << 3) | dest)

	def emitUnconditionalBranch(self, lineno, target, link):
		self.fixups += [ ( self.FIXUP_UNCONDITIONAL, self.getPc(), target, lineno ) ]
		self._emit(6, (link << 12))

	def emitConditionalBranch(self, lineno, target, condition):
		self.fixups += [ ( self.FIXUP_CONDITIONAL, self.getPc(), target, lineno ) ]
		self._emit(5, (condition << 10))
		
	def emitLabel(self, label):
		if label in self.labels:
			raise AssembleError('redefined label ' + str(label))
	
		self.labels[label] = self.getPc()

	def emitLea(self, lineno, reg, target):
		self.fixups += [ ( self.FIXUP_DATA_REF, self.getPc(), target, lineno ) ]
		self.emitLui(reg, 0)
		self.emitAddi(reg, reg, 0)

	def getPc(self):
		return len(self.code)

	def doFixups(self):
		for type, addr, label, lineno in self.fixups:
			if label not in self.labels:
				raise AssembleError('unknown label ' + label, lineno)
		
			targetAddress = self.labels[label]
			offset = targetAddress - addr - 1
			if type == self.FIXUP_DATA_REF:
				# LUI followed by ADDI
				self.code[addr] |= (((targetAddress >> 6) & 0x3ff) << 3) 
				self.code[addr + 1] |= ((targetAddress & 0x3f) << 6)
			elif type == self.FIXUP_UNCONDITIONAL:
				if offset > 0x7fff or offset < -0x7fff:
					raise AssembleError('fixup out of range', lineno)
					
				self.code[addr] = (self.code[addr] & ~0xfff) | (offset & 0xfff)
			else:
				assert type == self.FIXUP_CONDITIONAL
				if offset > 0x1ff or offset < -0x1ff:
					raise AssembleError('fixup out of range', lineno)

				self.code[addr] = (self.code[addr] & ~0x3ff) | (offset & 0x3ff)

	def dumpHex(self):
		for x in self.code:
			print '%04x' % x

class Parser:
	def __init__(self):
		self.lexer = shlex.shlex(sys.stdin)
		self.lexer.commenters = '#'
		self.lexer.wordchars += '_:-'
		self.builder = None

	def parseSource(self, builder):
		self.builder = builder
		while self._parseInstruction():
			pass

	def _match(self, want):
		got = self.lexer.get_token()
		if got != want:
			raise AssembleError('unexpected token, wanted ' + want + ' got ' + got)
	
	def _parseRegister(self):
		token = self.lexer.get_token()
		if token[0] != 'r':
			raise AssembleError('unexpected token ' + token + ' expected register')
		
		id = int(token[1:])
		if id < 0 or id > 7:
			raise AssembleError('bad register index')
			
		return id

	FORM_THREE_REG = 0
	FORM_TWO_REG = 1
	FORM_LOAD = 2
	FORM_STORE = 3
	FORM_ADDI = 4
	FORM_LUI = 5
	FORM_CONDITIONAL_BRANCH = 6
	FORM_UNCONDITIONAL_BRANCH = 7
	FORM_REG_BRANCH = 8
	FORM_LDI = 9
	FORM_NOP = 10
	FORM_LEA = 11

	INSTRUCTIONS = { 
		'and' : ( FORM_THREE_REG, 0 ),
		'or' : ( FORM_THREE_REG, 1 ),
		'shl' : ( FORM_THREE_REG, 2 ), 
		'shr' : ( FORM_THREE_REG, 3 ),
		'add' : ( FORM_THREE_REG, 4 ), 
		'sub' : ( FORM_THREE_REG, 5 ), 
		'xor' : ( FORM_THREE_REG, 6 ),
		'not' : ( FORM_TWO_REG, 7 ),
		'adc' : ( FORM_THREE_REG, 8 ),
		'sbc' : ( FORM_THREE_REG, 9 ),
		'rol' : ( FORM_TWO_REG, 10 ),
		'ror' : ( FORM_TWO_REG, 11 ),
		'load' : ( FORM_LOAD, 0 ),
		'store' : (FORM_STORE, 0 ),
		'addi' : ( FORM_ADDI, 0 ),
		'lui' : ( FORM_LUI, 0 ),
		'jump' : ( FORM_UNCONDITIONAL_BRANCH, 0 ),
		'call' : ( FORM_UNCONDITIONAL_BRANCH, 1 ),
		'jumpr' : ( FORM_REG_BRANCH, 0 ),
		'callr' : ( FORM_REG_BRANCH, 1 ),
		'bcc' : ( FORM_CONDITIONAL_BRANCH, 6 ),
		'bcs' : ( FORM_CONDITIONAL_BRANCH, 2 ),
		'bzc' : ( FORM_CONDITIONAL_BRANCH, 4 ),
		'bzs' : ( FORM_CONDITIONAL_BRANCH, 0 ),
		'bnc' : ( FORM_CONDITIONAL_BRANCH, 5 ),
		'bns' : ( FORM_CONDITIONAL_BRANCH, 1 ),
		'boc' : ( FORM_CONDITIONAL_BRANCH, 7 ),
		'bos' : ( FORM_CONDITIONAL_BRANCH, 3 ),
		'ldi' : ( FORM_LDI, 0 ),
		'nop' : ( FORM_NOP, 0 ),
		'lea' : ( FORM_LEA, 0 )
	}

	def _parseInstruction(self):
		global INSTRUCTIONS
		
		try:
			token = self.lexer.get_token()
			if token == '':
				return False
		
			if token[-1] == ':':
				# define label
				self.builder.emitLabel(token[:-1])
			elif token == 'res':
				# Reserve data words
				while True:
					value = int(self.lexer.get_token())
					self.builder.emitData(value)
					lookahead = self.lexer.get_token()
					if lookahead != ',':
						self.lexer.push_token(lookahead)
						break
			elif token in self.INSTRUCTIONS:
				form, param = self.INSTRUCTIONS[token]
				if form == self.FORM_THREE_REG:
					# opcode reg, reg, reg
					dest = self._parseRegister()
					self._match(',')
					srca = self._parseRegister()
					self._match(',')
					srcb = self._parseRegister()
					self.builder.emitArith(param, dest, srca, srcb)
				elif form == self.FORM_TWO_REG:
					# opcode reg, reg
					dest = self._parseRegister()
					self._match(',')
					srca = self._parseRegister()
					self.builder.emitArith(param, dest, srca, 0)
				elif form == self.FORM_LOAD or form == self.FORM_STORE:
					# opcode reg, offset(reg)
					# opcode reg, (reg)
					destsrc = self._parseRegister()
					self._match(',')
					lookahead = self.lexer.get_token()
					if lookahead != '(':
						if not lookahead.isdigit():
							raise AssembleError('unexpected token')

						offset = int(lookahead)
						self._match('(')
					else:
						offset = 0
					
					ptrreg = self._parseRegister()
					self._match(')')
					if form == self.FORM_LOAD:
						self.builder.emitLoad(destsrc, ptrreg, offset)
					else:
						self.builder.emitStore(destsrc, ptrreg, offset)
				elif form == self.FORM_ADDI:
					# opcode reg, reg, immediate
					dest = self._parseRegister()
					self._match(',')
					opa = self._parseRegister()
					self._match(',')
					val = int(self.lexer.get_token())
					self.builder.emitAddi(dest, opa, val)
				elif form == self.FORM_LUI:
					# opcode reg, immediate
					dest = self._parseRegister()
					self._match(',')
					val = self.lexer.get_token()
					self.builder.emitLui(dest, val)
				elif form == self.FORM_CONDITIONAL_BRANCH:
					# opcode label
					target = self.lexer.get_token()
					self.builder.emitConditionalBranch(self.lexer.lineno, target, param)
				elif form == self.FORM_UNCONDITIONAL_BRANCH:
					# opcode target
					target = self.lexer.get_token()
					self.builder.emitUnconditionalBranch(self.lexer.lineno, target, param)
				elif form == self.FORM_REG_BRANCH:
					# opcode reg
					dest = self._parseRegister()
					self.builder.emitRegisterBranch(dest, param)
				elif form == self.FORM_LDI:
					# pseudo op load immediate.  Build this out of LUI and/ADDI
					dest = self._parseRegister()
					self._match(',')
					value = int(self.lexer.get_token())
					if value > 0x7fff or value < -0x7fff:
						raise AssembleError('constant out of range')

					self.builder.emitLui(dest, value / 64)
					if (value & 0x1f) != 0:
						self.builder.emitAddi(dest, dest, value % 64)
				elif form == self.FORM_NOP:
					self.builder.emitArith(0, 0, 0, 0)
				elif form == self.FORM_LEA:
					dest = self._parseRegister()
					self._match(',')
					target = self.lexer.get_token()
					self.builder.emitLea(self.lexer.lineno, dest, target)
				else:
					raise AssembleError('internal error: unknown instruction format')
			else:
				raise AssembleError('bad instruction' + token)	
		except AssembleError as e:
			e.lineno = self.lexer.lineno
			raise

		return True

builder = CodeBuilder()
parser = Parser()
parser.parseSource(builder)
builder.doFixups()
builder.dumpHex()


