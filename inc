#!/usr/bin/env python
# -*- encoding: utf-8 -*-
"""Replace indices (or some symbol) using a counter via pipe.

COPYRIGHT:
- See __copyright__ below.

LICENSE:
- See __license__ below.

USAGE:
  $ echo -e 'asdf[##]\\nfdsa[##]' | inc -2::-2
  > asdf[-2]
  > asdf[-4]

"""
from __future__ import print_function, with_statement, division

######################## METADATA #############################################
#
__creator__ = "Matt Busby"
__email__ = "@MrMattBusby"
__author__ = "{0} {1}".format(__creator__, __email__)
__date__ = "20 May, 2015"
__copyright__ = "Copyright (c) {year}, {owner}. All rights reserved.".format(\
        year=__date__.replace(',', '').split()[-1], owner=__creator__)
__licence__ = """\
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
__version__ = "1.0.0"

######################## IMPORTS ##############################################
#

IMPORT_ERRORS = []
USE_ARG = True
try:
    import argparse as argv_parser
except ImportError:
    IMPORT_ERRORS.append("Can't import 'argparse', using 'optparse'!")
    import optparse as argv_parser
    USE_ARG = False
import logging
try:
    import pudb as pdb
except ImportError:
    IMPORT_ERRORS.append("Can't import 'pudb', using 'pdb'!")
    import pdb
import sys

######################## GLOBALS ##############################################
#
OPT = None  # Options populated below

######################## FUNCTIONS ############################################
#
def parse_argv():
    "Parse input arguments."""
    options = {}
    get_parser = argv_parser.ArgumentParser if USE_ARG \
            else argv_parser.OptionParser
    parser = get_parser()
    add_arg = parser.add_argument if USE_ARG else parser.add_option
    add_arg('-d', '--debug', action='store_true',
            default=False, help='debug')
    add_arg('slice', metavar='S', type=str, nargs='?',
            default='', help='replacement start[:[stop[:[step]]]]')
    if USE_ARG:
        opts, unk = parser.parse_known_args()
        if not opts.slice and len(unk) > 0:
            opts.slice = unk[0]
    else:
        opts, _ = parser.parse_args()
    options['slice'] = opts.slice
    options['debug'] = opts.debug
    return options

def inc():
    """Index incrementer."""
    rstr = None
    slice_ = None
    start = None
    step = None
    stop = None
    # Find start, stop, step
    try:
    ranges = [int(each) if each else None for each in \
            OPT.get('slice').split(':')]
    if len(ranges) == 1:
        ranges = ranges + [None]*2  # Default slice is stop, we need it start
    logging.debug(ranges)
    slice_ = slice(*ranges)
    start = slice_.start if slice_.start is not None else 0
    step = slice_.step if slice_.step is not None else 1
    stop = slice_.stop if slice_.stop is not None else float('inf') * \
            ((step > 0)*2-1)
    logging.debug((start, stop, step))
    ridx = start
    except (ValueError):  # Use entire string as replacement string
        ridx = OPT.get('slice')
        logging.debug(ridx)
    # Parse each line
    for line in sys.stdin:
        # Determine replacement string
        if rstr is None:
            if '###' in line:
                rstr = '###'
            elif '##' in line:
                rstr = '##'
            elif '_##_' in line:
                rstr = '_##_'
            elif '_#_' in line:
                rstr = '_#_'
            elif 'XXX' in line:
                rstr = 'XXX'
            elif 'XX' in line:
                rstr = 'XX'
            elif '_XX_' in line:
                rstr = '_XX_'
            elif '_X_' in line:
                rstr = '_X_'
            else:
                sys.stdout.write(line)
                continue
        if rstr in line:
            # Make replacement for last index in the line
            idx = line.rfind(rstr)
            sys.stdout.write(line[:idx] + line[idx:].replace(rstr, str(ridx)))
            sys.stdout.flush()
            if step is not None and stop is not None:
            if abs(ridx + step) < abs(stop):
                ridx += step
        else:
            # Otherwise simply print the line
            sys.stdout.write(line)
            sys.stdout.flush()

######################## EXECUTION ############################################
#
if __name__ == '__main__':
    OPT = parse_argv()
    if OPT.get('debug'):
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.WARN)
    def print_import_errors():
        """Print any import issues."""
        for each in IMPORT_ERRORS:
            logging.warn(each)
    print_import_errors()
    del IMPORT_ERRORS
    try:
        inc()
    except KeyboardInterrupt:
        sys.stdout.flush()
        sys.stderr.flush()
    except Exception as err:
        if OPT.get('debug'):
            pdb.post_mortem()  # 'e' to view
        else:
            raise
else:
    pass  # If imported
