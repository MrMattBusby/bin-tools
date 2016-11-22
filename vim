#!/usr/bin/env python
# -*- encoding: utf-8 -*-
"""Sanitize filename inputs to VIM

License
-------
See below __license__

Usage
-----
- $ vim filename.c:15: [more]  # Becomes vim +15 filename.c
- $ vim <(echo 'filename.c' [more])  # Redirection will open filename.c
- $ echo 'filename.c' [more] | vim  # Piping will run vim - (temp buffer)
"""
from __future__ import print_function, with_statement

######################## METADATA #############################################
#
__creator__ = "Matt Busby"
__email__ = "@MrMattBusby"
__date__ = "01/2015"
__version__ = "See GitHub"
__project__ = "https://github.com/MrMattBusby/"

__author__ = "{0} {1}".format(__creator__, __email__)
__copyright__ = "Copyright (c) {year}, {owner}. ".format(
                        owner = __author__,
                        year = "2015-2016") + \
                   "All rights reserved."
__licence__ = """\
        BSD 3-Clause License

        {copyright}

        Redistribution and use in source and binary forms, with or without
        modification, are permitted provided that the following conditions
        are met:

        1. Redistributions of source code must retain the above copyright
           notice, this list of conditions and the following disclaimer.

        2. Redistributions in binary form must reproduce the above copyright
           notice, this list of conditions and the following disclaimer in
           the documentation and/or other materials provided with the
           distribution.

        3. Neither the name of the copyright holder nor the names of its
           contributors may be used to endorse or promote products derived
           from this software without specific prior written permission.

        THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
        "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
        LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
        FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
        COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
        INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
        BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
        LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
        CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
        LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
        WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
        POSSIBILITY OF SUCH DAMAGE.
        """.format(copyright=__copyright__)

######################## IMPORTS ##############################################
#
# BUILT-IN/SYSTEM
#
import sys
import re
import subprocess

######################## GLOBALS ##############################################
#
DEBUG = False
VIM = '/usr/bin/vim'

######################## EXECUTION ############################################
#
if __name__ == '__main__':
    args = [VIM]

    # Is input from a TTY or PIPE
    # 
    if sys.stdin.isatty():

        # Is input from a redirection
        # 
        fd = None
        arglines = sys.argv[1:]
        for each in arglines:
            if 'dev/fd' in each:
                fd = each
                break
        argcount = 0
        if fd is not None:
            with open(fd, 'r') as ifile:
                rawlines = ifile.readlines()
            arglines = [each.strip() for each in rawlines if each not in \
                    ('', '.', '/')]
            argcount = len(arglines)
            assert argcount > 0  # Need at least 1 input file
        else:

            # Search for options
            # 
            for each in arglines:
                if each[0] != '-':
                    argcount += 1

        # If opening multiple files use split buffers
        # 
        if argcount >= 2:
            args.append('-O2')

        # Sanitize filenames
        # 
        for each in arglines:
            result = re.search(':[0-9]+:', each)
            if result is not None:
                pattern = result.group()
                location = each.find(pattern)
                if argcount < 2:
                    args.append('+' + str(pattern[1:-1]))
                args.append(each[:location])
            else:
                args.append(each)
    else:
        args.append('-')

    # Print or run command
    # 
    if DEBUG:
        print(args)
    else:
        subprocess.Popen(args).communicate()
