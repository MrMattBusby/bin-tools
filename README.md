# bin-tools

Bash tools & scripts helpful for your Linux environment. Add to your PATH.

# Content Highlights

## 1. (f)inder [shell] -- *A quick finder of ALL things, made easy*
  - `$ f ip '(todo|fixme)'` Find either tag inside a 'python' filetype below '.' (disregarding case by default)
  - `$ f d -c bin$` Count the number of dirs that end in 'bin'
  - `$ f cf -Ip run` Find a 'C' filetype containing 'run' without highlighting and exact case
  
## 2. (me) [shell] -- *Print information on user/pc/etc*
  - `$ me` Show information about yourself
  
## 3. (conv)ert [python3] -- *Show all common number bases for an input and/or its en/decoding*
  - `$ conv 0x30` Shows all bases and encodings for hex number 0x30
  
## 4. (lat)itude & (lon)gitude [python3] -- *Show all formats of Lat/Lon*
  - `$ latlon 3.333` Converts 3.333deg to all other forms
  
## 5. (line) select [shell] -- *Select a line from a pipe (counts from 0)*
  - `$ cat myfile | line 1` Select second line of myfile
  
## 6. (col)umn select [shell] -- *Select a column from a piped input (counts from 0)*
  - `$ echo -n 'a b c\nd e f' | line 1 | col 1` Select 'e'
  - `$ svn st | grep ^? | col 1 rm` Remove unknown files  
