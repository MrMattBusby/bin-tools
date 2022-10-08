# bin-tools

Bash tools & scripts helpful for your Linux environment.

# Content Highlights

1. **f**: (F)inder [shell] -- *A quick finder of ALL things, made easy*
  - `$ f ip '(todo|fixme)'` Find either tag inside a 'python' filetype below '.' (disregarding case by default)
  - `$ f d -c bin$` Count the number of dirs that end in 'bin'
  - `$ f cf -Ip run` Find a 'C' filetype containing 'run' without highlighting and exact case
  
2. **line**: (Line) select [shell] -- *Select a line from a pipe (counts from 0)*
  + `$ cat myfile | line 1` Select second line of myfile
  
3. **col**: (Col)umn select [shell] -- *Select a column from a piped input (counts from 0)*
  + `$ echo -n 'a b c\nd e f' | line 1 | col 1` Select 'e'
  + `$ svn st | grep ^? | col 1 rm` Remove unknown files  
  
4. **me**: (Me) [shell] -- *Print information on user/pc/etc*
  + `$ me` Show information about yourself
  
5. **conv**: (Conv)ert [python3] -- *Show all common number bases for an input and/or its en/decoding*
  + `$ conv 0x30` Shows all bases and encodings for hex number 0x30
