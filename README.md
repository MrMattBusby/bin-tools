# bin-tools

Bash tools & scripts helpful for your Linux environment.

## Usage 

1. Fork repo
2. Softlink this repository to ~/bin
3. Ensure ~/bin is in your env's $PATH

- Or pick and choose which scripts to use individually

## Help 

- For individual help/usage, perform `$ <command> -h`, or `$ head -2 <command>`

## Content Highlights

- col -- (Col)umn select -- shell
  + Select a column from a piped input (counts from 0)
  + `$ echo -n 'a b c\nd e f' | line 1 | col 1` Select 'e'
  + `$ svn st | grep ^? | col 1 rm` Remove unknown files
- conv -- (Conv)ert -- python3
  + Show all common number bases for an input and/or its en/decoding
  + `$ conv 0x30` Shows all bases and encodings for hex number 0x30
- dgrep -- (D)escriptor (GREP)
  + File Descriptor GREP
  + `$ dgrep myfile` Search for processes that have myfile open
- eq -- (Eq)uals -- shell
  + Evaluate input using python
  + `$ eq 4+8/3` Perform simple math
  + `$ eq 'sin(pi/2.)'` Perform complex math
- f -- (F)inder -- shell
  + A quick finder
  + `$ f ip '(todo|fixme)'` Find either tag inside a 'python' filetype below '.' (disregarding case by default)
  + `$ f d -c bin$` Count the number of dirs that end in 'bin'
  + `$ f cf -Ip run` Find a 'C' filetype containing 'run' without highlighting and exact case
- inc -- (Inc)rementer -- python
  + Replace placeholder indices using a python-style incrementer
  + ` $ echo "var[##];\nvar[##]" | inc -2::2` Echoes string with indices -2, 0
  + ` $ echo "var[_XX_][_XX_];\nvar[_XX_][_XX_]" | inc | inc idx` Echoes string with outer indices incremented 0, 1, .. and inner array all replaced with "idx"
  + ` :'<,'>!inc 3::3` From VIM, increments and replaces selection by 3, starting with 3
- latlon -- (Lat)itude (Lon)gitude Converter -- python
  + Convert any lat/lon format to all other formats, including a google map link
  + `$ latlon +33.22n, 121332212 West` Lookup other formats
- line -- (Line) select -- shell
  + Select a line from a pipe (counts from 0)
  + `$ cat myfile | line 1` Select second line of myfile
- me -- (Me) -- shell
  + Print information on user/pc/etc
  + `$ me` Show information about yourself
- newest -- (Newest) files -- shell
  + Find newly modified files
  + `$ newest` List newest files
- pep8 -- (PEP8) Formatter -- shell
  + Format a Python file
  + `$ pep8 myfile` Format myfile and create backup .myfile.orig
- swapnames -- (Swap)s (names) -- shell
  + Swapes two filenames
  + `$ swapnames filename1 dir/filename2` Swaps two end filenames
- transpose -- (Transpose) -- python
  + Transpose standard input, mainly for use with Vim
  + `$ echo "1 2 3\n1 2 3" | transpose` Transpose data
  + `:'<,'>!transpose` Transpose selection
- vim -- (VIM) Sanitizer -- python
  + Sanitize inputs to VIM. Uses standard library
  + `$ vim somefolder/somefile.c:100://Blah` Open somefile.c, go to line 100
  + `$ vim "somefolder/somefile.c:100:// Foo Bar" "somefolder/other file.c*"` Open somefile.c and other file.c*
  + `$ vim <(grep -Rn Foobar *)` Open all files that contain "Foobar"
- wiki -- (Wiki)pedia -- shell
  + Wikipedia a phrase
  + `$ wiki Hello World` Wikipedia this prase

