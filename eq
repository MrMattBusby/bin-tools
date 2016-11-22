#!/bin/bash
PURPOSE='(eq)uals: Use python to evaluate your input (e.g. for math functions)'
#
# LICENSE
# 
#   Copyright (c) 2014-2016, Matt Busby @MrMattBusby.
#   All rights reserved.
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions
#   are met:
#   
#   1. Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#   
#   2. Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in
#      the documentation and/or other materials provided with the
#      distribution.
#   
#   3. Neither the name of the copyright holder nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#   
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
#   FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
#   COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
#   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
#   BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#   CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
#   WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#   POSSIBILITY OF SUCH DAMAGE.
# 
# WARNING
# 
# Unsafe for widespread useage.

CMDNAME='eq'
USAGE="$CMDNAME 'EQUATION'
  eq 4.+8/2                               # Simple functions w/o spaces or ()s don't need quotes
  eq 'count(4, 8) * sin(pi/2.) * FT_TO_M' # Can use math, pyutils, and consts directly
  eq '(wait(2), isodd(3)))[1]'            # Multiple functions, tuples
  eq 'os.system(\"ls ..\")'                 # Do things you probably shouldn't

Both os and sys are imported, math is imported *."
HELP="${PURPOSE}\n\nUsage: ${USAGE}"
BRED='\e[1;31m'
SDARK='\e[2m'
NC='\e[0m'

if [ "$1" == '-h' ] ; then
  >&2 echo -e "${HELP}"
  exit 0
elif [ "$#" -lt 1 ] ; then
  >&2 echo -e "${BRED}${CMDNAME}: error: ${NC}Invalid arguments!\n"
  >&2 echo -e "${SDARK}${HELP}${NC}"
  exit 2
fi

# Call python
/usr/bin/env python -c "\
from __future__ import print_function, division

import sys, os, math
from math import *
import imp

DEBUG = False
IMPORTS = True

instr = '''$@'''

if IMPORTS:
  try:
    imp.load_source('pythonrc','${HOME}/.pythonrc.py')
    try:
      from pythonrc import *
    except: 
      if DEBUG:
        print('eq: warning: can\'t import * from ~/.pythonrc.py!\n',
        file=sys.stderr)
  except: 
    if DEBUG:
      print('eq: warning: can\'t import ~/.pythonrc.py!\n', file=sys.stderr)
  del imp

del DEBUG
del IMPORTS

try:
  print(eval(compile(instr, '<string>', 'eval')))
except: 
  print('eq: error: executing eval on compiled input string: \"' + instr + \
  '\"!', file=sys.stderr)
"

