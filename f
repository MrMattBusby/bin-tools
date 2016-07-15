#!/bin/bash
# Find files or search within them.
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

USAGE='f COMMAND [OPTIONS] [GREP_OPTIONS] Arg1 [Arg2]'

HELP='Find files or search within them.

\033[1mUSAGE:\033[0m '"$USAGE"'
Search for PATTERN(s) with COMMAND method below.

  \033[1mCOMMAND:\033[0m

  All commands operate on current directory `./`.

    \033[1m1-PATTERN:\033[0m
       d    Find                     (d)irectory $Arg1
       f    Find                     (f)ile      $Arg1
      af    Find            (a)da    (f)ile      $Arg1
      cf    Find            (c)      (f)ile      $Arg1
      pf    Find            (p)ython (f)ile      $Arg1
      i     Find $Arg1 (i)n any      file
      ia    Find $Arg1 (i)n (a)da    file
      ic    Find $Arg1 (i)n (c)      file
      ip    Find $Arg1 (i)n (p)ython file

    \033[1m2-PATTERN:\033[0m
      if    Find $Arg1 (i)n          (f)ile      $Arg2
      iaf   Find $Arg1 (i)n (a)da    (f)ile      $Arg2
      icf   Find $Arg1 (i)n (c)      (f)ile      $Arg2
      ipf   Find $Arg1 (i)n (p)ython (f)ile      $Arg2
  
  \033[1mOPTIONS:\033[0m
    -I     Str(I)ct case (ignorecase is the default)
    -p      Print (p)lainly without highlighting
    -P     (P)rint the command that would run
    -n      Search for (n)otes within files, used with 1-PATTERN i* cmds,
              no PATTERNs are necessary
    -N      Search for (N)asty words within files, used with 1-PATTERN i* cmds,
              no PATTERNs are necessary
  
  \033[1mGREP_OPTIONS:\033[0m
    - See `egrep --help`
    - Can only use short 1-character options ATM
  
  \033[1mPATTERN-1:\033[0m
    Used when searching for PATTERN-1 as a name or inside any file of certain
    type.

  \033[1mPATTERN-2:\033[0m
    Used when searching for PATTERN-1 inside of file containing a PATTERN-2.

\033[1mEXAMPLES:\033[0m
  - Find a C file containing "run", without highlighting and with strict-case
    \033[1mf cf -Ip run\033[0m

  - Find the following tags inside a python file, disregarding case
    \033[1mf ip "(xxx|fixme|todo|removeme)"\033[0m

  - Count the number of directories that end in bin
    \033[1mf d -c bin$\033[0m

  - Search for any notes in c files below .
    \033[1mf ic -n\033[0m

  - Print the command to find "ABC" inside an Ada file that contains the
    string "user"
    \033[1mf iaf -P ABC user\033[0m

\033[1mCUSTOMIZATION:\033[0m
  Set F_IGNORE_RE, or F_*FILE_RE (where * is C/P/A) to an regex string of
  your liking in your env.

\033[1mNOTES:\033[0m
  - Only disallowed filename characters in linux are \\0 and /
  - Can pass arguments before search criteria
  - To avoid finding /foo/bar when searching for foo use foo[^/]*$

\033[1mWARNING:\033[0m
  - Only works on Bash >= 4.2 due to [ -v ] test

\033[1mSEE ALSO:\033[0m
  \033[1mgrep\033[0m(1), \033[1mfind\033[0m(1), \033[1mxargs\033[0m(1)

\033[1mHISTORY:\033[0m
  - See git history
  - \033[1mf\033[0m started as a bash alias, then function, then standalone
    scripts fic, fia, etc, finally merged into one complete script

\033[1mLICENSE:\033[0m
  - BSD-3 (See source code)
  - Copyright (c) Matt Busby'

# Help
if [ "$1" == '-h' -o "$1" == '--help' -o "$2" == '-h' -o "$2" == '--help' ] ; then
  echo -e "$HELP" # | less -r #N
  exit 0
fi
if [ "$#" -le 1 ] ; then
  echo -e "Usage: ${USAGE}\nTry \`f --help\` for more information." 1>&2
  exit 1
fi

# Parse options (or [ -n .. )
if [ ! -v F_IGNORE_RE ] ; then
  F_IGNORE_RE='(\/.*\.(svn-base|page)|\/cscope.out|\/tags)$'
fi
if [ ! -v F_CFILE_RE ] ; then
  F_CFILE_RE='.*/(makefile|.*\.(nmk|mk|cfg|tab|ic|cc|[ch](pp|xx)?))$'
fi
if [ ! -v F_PFILE_RE ] ; then
  F_PFILE_RE='.*/(makefile|.*\.py)$'
fi
if [ ! -v F_AFILE_RE ] ; then
  F_AFILE_RE='.*/(makefile|.*\.(nmk|gnatmake|cfg|tab|gpr|ali|adb|ads))$'
fi
if [ ! -v F_NOTES_RE ] ; then
  F_NOTES_RE='(\<todo|\<fixme|\<removeme|\<xxx|\?\?\?|\!\!\!|\<unknown\>|\<maybe\>|\<future\>|\<hack|\<bug\>|\<review\>|\<kludg|\<klug|\<cludg|\<recheck\>|\<omg|\<seriously\>|t work|why [wd]|\<ever\>|\<every\>|\<always\>|\<nothing\>|\<never\>)' #|\<warning\>)'
fi
if [ ! -v F_NASTY_RE ] ; then
  F_NASTY_RE='(\<crap|\<dumb|\>stupid|\<stoopid|\<wtf\>|\<wth\>|\<hell\>|\<idiot|\<dick\>|\<d\*ck\>|\<penis\>|\<cock\>|\<ass\>|\<asshole\>|\<assh\*le\>|\<fag\>|\<faggot\>|\<butthole\>|\<douche\>|\<slut\>|fuck|f\*ck|\<piss off\>|\<bitch|\<cunt\>|\<boob|\<tits|\<puss|\<vag\>|\<shit\>|\<sh\*t\>|\<shitty|\<sh\*tty)'
fi

ICASE='-i'
COLR='always'
PRINTCMD=false
ARGS=()
SEARCH=()
for each in ${@:2} ; do 
  if [ "${each::1}" == '-' ] ; then
    while read -r -n1 ch ; do 
      if [ "$ch" == 'p' ] ; then
        COLR='never'
      elif [ "$ch" == 'P' ] ; then
        PRINTCMD=true
      elif [ "$ch" == 'I' ] ; then
        ICASE=''
      elif [ "$ch" == 'n' ] ; then
        SEARCH=($F_NOTES_RE)
      elif [ "$ch" == 'N' ] ; then
        SEARCH=($F_NASTY_RE)
      else
        ARGS+=($ch)
      fi
    done <<< "${each:1}"
  else
    SEARCH+=($each)
  fi
done

# Find all, c, or python files
if [ "$1" == "d" ] ; then
  CMD1='find . -type d -print0'
elif [ "$1" == "f" -o "$1" == "i" -o "$1" == "if" ] ; then
  CMD1='find . -type f -print0'
elif [ "$1" == "cf" -o "$1" == "ic" -o "$1" == "icf" ] ; then
  CMD1='find . -type f -regextype egrep -iregex '\'"$F_CFILE_RE"\'' -print0'
elif [ "$1" == "pf" -o "$1" == "ip" -o "$1" == "ipf" ] ; then
  CMD1='find . -type f -regextype egrep -iregex '\'"$F_PFILE_RE"\'' -print0'
elif [ "$1" == "af" -o "$1" == "ia" -o "$1" == "iaf" ] ; then
  CMD1='find . -type f -regextype egrep -iregex '\'"$F_AFILE_RE"\'' -print0'
else
  echo -e "f: invalid command -- '$1'\nUsage: ${USAGE}\nTry \`f --help\` for more information." 1>&2
  exit 1
fi

# Find filename or in file
if [ "$1" == "d" -o "$1" == "f" -o "$1" == "af" -o "$1" == "cf" -o "$1" == "pf" ] ; then
  CMD2="egrep -z $ICASE ${ARGS[*]/#/-} --color=${COLR} \"${SEARCH[*]}\" | tr '\0' '\n'"
elif [ "$1" == "if" -o "$1" == "iaf" -o "$1" == "icf" -o "$1" == "ipf" ] ; then
  CMD2="egrep -z $ICASE --color=never \"${SEARCH[1]}\" | xargs -0 -P0 egrep -IHn $ICASE ${ARGS[*]/#/-} --color=${COLR} \"${SEARCH[0]}\" | tr '\0' '\n'"
else
  # CMD2="xargs -0 -P0 egrep --exclude='*svn-base*' -IHn"
  CMD2="xargs -0 -P0 egrep -IHn $ICASE ${ARGS[*]/#/-} --color=${COLR} \"${SEARCH[*]}\" | tr '\0' '\n'"
fi

# Run
CMD="${CMD1} | egrep -zv '${F_IGNORE_RE}' | ${CMD2}"
if $PRINTCMD ; then
  echo "$CMD"
else
  eval "$CMD"
fi

