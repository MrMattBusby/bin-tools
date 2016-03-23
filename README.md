# bin-tools
Bash tools/scripts helpful to have in your Linux environment.

### Usage 
1. `$ ln -s [any script cloned/forked from this repo] ~/bin`
  - E.g. $ for each in $(find [path to bin-tools] -maxdepth 1 -type f -executable) ; do ln -sf "$each" ; done
2. Ensure ~bin is in your env's $PATH

### Contents

####$ f -- (F)inder -- shell

A quick finder script. Finds a file quickly, or finds something within a given filetype. Uses find, xargs, egrep.

`$ f ip '(todo|fixme)'` Find either tag inside a 'python' filetype below '.' (disregarding case by default).

`$ f d -c bin$` Count the number of dirs that end in 'bin'.

`$ f cf -Ip run` Find a 'C' filetype containing 'run' without highlighting and disregarding case.

####$ eq -- (Eq)uals -- shell

Evaluate input using python (meant for math functions). Uses python, and anything in ~/.pythonrc, if it exists.

`$ eq 4+8/3` Perform simple math.

`$ eq 'sin(pi/2.)'` Perform complex math.

`$ eq 'import os;os.system("sudo su -")'` Do other stuff you shouldn't but could.

####inc -- (Inc)rementer -- python

Replace placeholder indices using a python-style incrementer. Uses python builtins.

` $ echo "var[##];\nvar[##]" | inc -2::2` Echoes string with indices -2, 0.

` $ echo "var[_XX_][_XX_];\nvar[_XX_][_XX_]" | inc | inc idx` Echoes string with outer indices incremented 0, 1, .. and inner array all replaced with "idx".

` :'<,'>!inc 3::3` From VIM, increments and replaces selection by 3, starting with 3.

####swapnames -- (Swap)s (names) -- shell

Swapes two filenames. Uses bash builtins.

`$ swapnames filename1 dir/filename2` Swaps two end filenames.

`$ swapnames dir/dir1 otherdir/dir2` Swaps two end directory names.

`$ swapnames dir/dir1 otherdir/filename2` Swaps a file and dir name (why?).

####vim -- (VIM) Sanitizer -- python

Sanitize inputs to VIM. Uses standard library.

`$ vim somefolder/somefile.c:100://Blah` Open somefile.c, go to line 100.

`$ vim "somefolder/somefile.c:100:// Foo Bar" "somefolder/other file.c*"` Open somefile.c and other file.c*.

`$ vim <(grep -Rn Foobar *)` Open all files that contain "Foobar".

####cats -- Con(cat)enate(s) -- shell

Concatenate multiple file with an informational header (attr's, sums, etc). Uses a variety of shell tools.

`$ cats filename` Cat "filename" with an info header.

`$ cats file1 file2` Cat multiple files one after the others, each prefaced with a header.

`$ echo -n "passwrod" | cats` Echoes the string through cats printing an informational header.

####lc -- (L)ist (c)ontents -- shell

List the contents of a directory broken into all/dirs/files/links/sizes, differentiating those hidden. Uses find.

`$ lc` List contents of current directory.

`$ lc ../bin` List contents of given directory.

####newest -- (Newest) files -- shell

Find newly modified files.

`$ newest` List newest files

####mktags -- (M)a(k) (tags) file -- shell

Create tags file using exuberant ctags and cscope.

`$ mktags` Make the tags and cscope file

####setcolors -- (Set colors) -- shell

Exports names for environment color definitions, sourced from .bashrc. Uses nothing.

`$ source setcolors` Set terminal colors utilized in .bashrc.

### Notes
* Each file has its own helpfile, generally accessible with `bin-tools $ head [cmd]` or `$ [cmd] -h`.
