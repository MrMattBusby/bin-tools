#!/bin/bash
# Concatenate multiple files and print a header with file stats,
# or use via pipe with stdin.
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

SPACER1="${CMDCOL}==================================== ${BGREEN}^..^${CMDCOL} ====================================="
SPACER2="==============================================================================="

if [ $# -eq 0 ]; then
  FILE=/dev/stdin
  CATS=$(<$FILE)
  echo -en "${NC}"
  echo -e $SPACER1
  echo " name   :" $(readlink -fq $FILE)
  echo " base   :" $(basename $FILE)
  echo " file   :" $(file -b $FILE)
  echo " ls     :" $(ls -lhq $FILE)
  echo " lsattr : N/a"
  echo " du     : N/a"
  echo " wc     :" $(echo "$CATS"|wc)
  echo " sum    :" $(echo "$CATS"|sum)
  echo " md5sum :" $(echo "$CATS"|md5sum)
  echo $SPACER2
  echo -en "${NC}"
  echo -n "$CATS"
else
  for FILE in $@; do 
    if [ -f $FILE ]; then
      echo -en "${NC}"
      echo -e $SPACER1
      echo " name   :" $(readlink -fq $FILE)
      echo " base   :" $(basename $FILE)
      echo " file   :" $(file -b $FILE)
      echo " ls     :" $(ls -lhq $FILE|sed "s|\s*$FILE||")
      echo " lsattr :" $(lsattr -v $FILE 2>/dev/null|sed "s|\s*$FILE||")
      echo " du     :" $(du -h $FILE|sed "s|\s*$FILE||")
      echo " wc     :" $(wc $FILE|sed "s|\s*$FILE||")
      echo " sum    :" $(sum $FILE)
      echo " md5sum :" $(md5sum $FILE|sed "s|\s*$FILE||")
      echo $SPACER2
      echo -en "${NC}"
      cat $FILE
    elif [ -d $FILE ]; then
      echo -e "${CMDCOL}>>> cats: ${BRED}^xx^${CMDCOL} error: Cannot concatenate the directory \"$FILE\"!"
      echo -en "${NC}"
    else
      echo -e "${CMDCOL}>>> cats: ${BRED}^xx^${CMDCOL} error: File \"$FILE\" cannot be concatenated!"
      echo -en "${NC}"
    fi
  done
fi

