# SHELL SCRIPT CHEAT SHEET
# history of /bin/sh and shells: https://unix.stackexchange.com/questions/145522/what-does-it-mean-to-be-sh-compatible
# good references: https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html
# ZSH:
    # feature overview: https://github.com/hmml/awesome-zsh
    # zsh dot files: https://apple.stackexchange.com/questions/388622/zsh-zprofile-zshrc-zlogin-what-goes-where
        # order of load: .zshenv → .zprofile → .zshrc → .zlogin → .zlogout

# DASH (ubuntu 16 and newer use it, it's faster than bash)
# read https://wiki.ubuntu.com/DashAsBinSh

# bash shell expansion order (for zsh too i think)
# https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_04.html
# korn shell but insightful: https://docstore.mik.ua/orelly/unix/ksh/ch07_03.htm

# Bash (and AFAIK zsh)
    # good bash ref: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html#The-Set-Builtin
set -e # exit script/shell if any command returns with non-zero
set -x # Print commands and args as they are executed.
set +x # remove x, bash is backwards
echo $- #query all set options on in shell
setopt # query all set shell options in ZSH

# KEYBINDINGS
# readline lib used by bash and zsh. lets you choose vi or emacs mode
# good ref on ZLE (zsh line editor):  ZLE (zsh line editor): http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
bind -P     # bash print out all key bindinds, for sh too
bindkey     # for zsh

# bind ^g to run foo function
function foofunc() { echo hi; }
zle -N foofunc
bindkey '^g' foofunc

# NOTE: these clobber ctrl-n, ctrl-p (for cmd history), ctrl-r (history fuzzy search)
bindkey -v  # zsh vi mode
set -o vi   # bash vi mode

# command line navigation (zsh and bash defaults)
# ctrl-s - linux pauses output to screen
# ctrl-l - clear screen
# ctrl-a - goto beg of line
# ctrl-e - goto end of line
# ctrl-b - go back one space
# ctrl-f - go forward one space
# ctrl-k - delete line after cursor (cut to clipboard)
# ctrl-u - delete line before cursor (cut to cliboard)
# ctrl w - delete word before curosr (cut to clipboard)
# ctrl y - paste what was cut
# ctrl-h - delete last char, VIM insert mode and command too!
# ctrl-[ - escape
# ctrl-i - tab
# ctrl-j / ctrl-m - begin new line, VIM insert mode too!
# ctrl-p - go back one command in the history
# ctrl-n - go forward one command in the history
# ctrl-r - fuzzy search command history
# ctrl-7 - undo
# ctrl-8 - backward delete char

# send EOF to stdin, bash/zsh/sh interpret as exit shell
# if not at 1st char in prompt, delete char in front of it (forward delete)
# Ctrl-d

# LINE EDITING MODE
set -o vi    # set zsh to use vi mode, emacs is default
# zsh, if vi mode is used, will need to bindkey some nice line editing keys that are missing
bindkey  # alone will print out all keybindings
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^B' backward-char
bindkey '^F' forward-char
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^r' history-incremental-search-backward
export KEYTIMEOUT=1  # mode change delay, default is 4 (.4 seconds), this will make delay .1 second

# ZSH autocomplete
/usr/share/zsh/5.3/functions # osx dir of autocompletions (zsh ver 5.7.1 for catalina)

### EXECUTION ENVIRONENT
# non-interactive shells, like when running a shell script
    # aliases are not expanded
    # bashrc or zshrc are not run
    # only exported variabled are inherited, regular shell variables are not
source fooscript    # run script in current shell, zsh, bash works too
. fooscript         # bash cononical way to source, doesnt work in zsh
. ./fooscript       # force execute, executes even if file perm doesnt have execute, works in bash and zsh
\foo                # execute foo ignoring any aliases called foo

# FC, edit last command in editor and execute, also list old commands
# change default editor with FCEDIT env var
fc
# to cancel execution(when in vi) type :cq in command mode (quit with error)

# r, builtin in zsh, basiscally replays the last command in history
ls
r   # will execute `ls`

# bash/posix/zsh: delete a function or a variable
unset foo

# make a variable or function unmodifiable
readonly foo=1
foo=2  # will error

#print all readonly variables
readonly

# https://unix.stackexchange.com/questions/168221/are-there-problems-with-hyphens-in-functions-aliases-and-executables
# hyphens aren't guarenteed to be cross-shell compatible :(
function foo-bar() {
    echo "POSIX makes ram sad"
}

####### VARIABLES #######
# MAX SIZE
    # see https://stackoverflow.com/questions/5076283/shell-variable-capacity
# SCOPES
# bash/zsh and bsd/gnu sh support local scoped variables in a function
# - https://stackoverflow.com/questions/18597697/posix-compliant-way-to-scope-variables-to-a-function-in-a-shell-script
local foo=1   # only hold value in scope of current function and called function, once func finishes local var is removed
              # if a called function also declares a `local foo=3`, then it and it's downstream func calls will use 3
foo=1         # shell variable, so persists even when function exits

export FOO=1  # environment variable, subshells inhert these variables
FOO=1         # shell variable,       same as "set"ing, subshells dont inherit these
# NOTE!! command substition subshells are different then a script run in a subshell, cmd subs duplicate shell and env vars
# for bash(and zsh from my tests): https://www.gnu.org/software/bash/manual/html_node/Command-Execution-Environment.html
FOO=1
BAR=$(echo "$FOO")
echo $BAR       # will print 1


# programatically create env variables
A=FOO
export BAR${A}="somestring"
echo $FOOBAR # will print somestring

# BASH get value of arbitrary variable
var1="this is the real value"
a="var1"
echo "${!a}" # outputs 'this is the real value'
# works everywhere
X=foo
Y=X
eval "Z=\$$Y"  # z will equal "foo"

#DEFAULT values, works in bash and zsh, (osx /bin/sh and ubunutu /bin/sh too)
FOO=${VARIABLE:-default}  # If variable not set or null, FOO changes value to "default"
FOO=${VARIABLE:=default}  # If variable not set or null, FOO AND VARIABLE changes value to "default"
# can use it for function args, this sets VARIABLE to DEFAULTVALUE if 1st arg isnt set
VARIABLE=${1:-$DEFAULTVALUE}
# if var is the same
VARIABLE="${VARIABLE:=DEFAULT_VALUE}"
: "${VARIABLE:=DEFAULT_VALUE}"          # colon operator, shorter and equivalent

# SPECIAL VARIABLES
# bash/zsh/sh all seem to define these shell variables
# these are not env vars, and not exported to child processes
LINES   # horizontal size of viewport
COLUMNS # vertical size of viewport
RANDOM  # contains a different random number every time u access it

echo $$ # print PID of current shell process
echo $? # print exit code of last command

# splat argument that expands to all command-line arguments seperated by spaces
# note: $0 is not passed in $@
# https://wiki.bash-hackers.org/scripting/posparams
echo $@   # is an array
echo "$@" # usually want this to avoid misparsing args containing spaces/wildcards
echo $*   # is a single string

# getopt, C bin that follows POSIX guidelines for arg parsing
getopt

# getopts, shell builtin like getopt, bourne shell got it in 1986. it's POSIX, available in ksh, zsh, and bash as well.
OPTIND=1  # if getopts is invoked in a shell function, this variable needs to be reset
while getopts 'abc:d:ef' x; do
    case $x in
        a) echo "a" ;;
        b) echo "b" ;;
        c) echo "c given $OPTARG" ;;
        d) echo "d given $OPTARG" ;;
        *) echo "not an opt" && exit 1 ;;
    esac
done
shift $(($OPTIND - 1))     # remaining is "$@"


# print recent history in bash/zsh
history

# zsh run cmd with no globbing
noglob http

# kill background job 1
kill %1

# redirect stderr to out
cat 2>&1 blah

# redirect stdout to stderr
>&2 echo "goes to error"

# redir stderr and stdout to /dev/null
cat > /dev/null 2>&1 blah

# PIPES
# most commands line-buffer STDOUT if its goin to a terminal
# but if STDOUT goes to a pipe input, they will buffer more than a line (e.g. 4k bytes)
# grep buffers like this, tail used to but modern versions dont, echo does
tail -f foofile | grep foopattern | grep foo2
# force grep to line buffer
tail -f foofile | grep --line-buffered foopattern | grep foo2
# in perl inline scripts add `$|++` to line-buffer

# detect if STDOUT is terminal output
# if fd 1 (STDOUT) is not a terminal, good chance it's a pipe
[ -t 1 ] && echo "this is a terminal"

# IF else syntax
if [ "a" = "a" ]; then
    echo "hi"
elif [ "b" = "b" ]; then
    echo "word"
else
    echo "hi"
fi


###### LOOPS
# bash

# the "/" only matches dirs, so iterate through all dirs in current dir
# WARNING: if dir is empty then this iterates through one item, the literal "*/"
for d in */; do
    echo "$d"
done

# iterate through all files in curent dir, for bourne it does all files/dirs
for d in *; do
    echo "$d"
done

for run in {1..10}; do echo "hello"; done

# bourne shell doesnt support for loops, use the while loop
for (( i=1; i<=3; i++)); do
    echo $i
done

# break terminates for loop, so 4th and 5th iteration dont run, continue skips to next iteration so 1st iter skips echo
for (( i=0; i<5; i++)); do
    [ $i -eq 3 ] && break
    [ $i -eq 0 ] && continue
    echo $i
done

# POSIX/sh
i=1
while [ "$i" -ne 10 ]
do
    echo "$i"
    i=$((i + 1))
done

# read lines from file
while read p; do
  echo "$p"
done <foofile.txt

# case statements
case "$FOO" in
partialstring*|someother*)
    A=1
    ;;
*)
    A=3
    ;;
esac

# more compact, works in zsh/bash/sh
case "$BAR" in
    yar|gar) A=1 ;;
    far) B=2 ;;
esac

# also valid
case "$FOO" in
    bar) A=1 ;; baz) Z=1 ;; far) B=2 ;;
esac


##### ARRAYS
# bash and zsh support them. osx /bin/sh supports it
    # bash arrays index start from zero, zsh from one.....
# POSIX does not support arrays
array=(1 two three)

echo ${array[1]}  # ref 2nd element in array (bash, zsh this is 1st), in bash will print "two"

echo "${#array[@]}"    # echo array size

for i in ${array[@]}; do; echo $i; done   # bash, and zsh
for i in $array; do; echo $i; done        # zsh

# bash: parse a bunch of lines into array
IFS=$'\r\n' x=( $(cat somefile) )
IFS=$'\r\n' x=( $(printf "foo\nbar\nbaz\n") )    # x is array with 3 items


#####  IFS: string field splitting
#   bash field splits by default, zsh doesnt (need to set sh_word_split shell option)
#   IFS variable determines chars to use as delimter for splitting
#   https://stackoverflow.com/questions/41320199/ifs-in-zsh-behave-differently-than-bash
#   https://unix.stackexchange.com/questions/26661/what-is-word-splitting-why-is-it-important-in-shell-programming
#   https://unix.stackexchange.com/questions/164508/why-do-newline-characters-get-lost-when-using-command-substitution
IFS=
A=$(env)
echo $A | grep "something"
# OR (double quoting var also prevents field splitting)
A=$(env)
echo "$A" | grep "something"

# for loops, bash IFS field split will get 3 items, split because of space char
string="foo bar baz"
for i in $string; do
    echo $i
done

# ZSH, command expansions are always split, so if you didnt have sh_word_split on you could loop over a string like
string="foo bar baz"
for i in $(echo "$string"); do
    echo $i
done
# ZSH splitting can also happen when:
 # 1. calling splitting explicitly: `echo ${=var}`.
 # 3. Using read to split to a list of vars (or an array with `-A`).


# remove non-ascii chars, tr is bin that works on removing/replacing individual characters
tr -cd '\11\12\15\40-\176' < file-with-binary-chars > clean-file

#print char '=' 100 times
printf '=%.0s' {1..100}

# Bash index/slicing on string
A="foobar"
S=${A:0:3} # => "foo", so chars from index 0 to 2 (not 3!)

echo ${#S} # prints length of S, so will echo 3
S=${A:1:${#A}-1}  # will print "fooba", omitted the last char

# POSIX arithmetic expansion (http://mywiki.wooledge.org/ArithmeticExpression)
$((3+3)) # 6
$((3*3)) # 9
$((3**3)) # 27
$((3*3+4/10)) # 9
$((3%2)) # mod, 1
a=1; $((a++)) # increment a, a=2
let a="3+3" a+=4 # 10

# for float point math can use bc bin or awk
echo "3.1 * 4.5" | bc       # = 13.9
echo "11 * 3 / 4" | bc      # = 8, it rounds down for division

# for mult and division with integers in zsh/bash
$(( 3 * 4 / 10 ))   # rounds down to nearest int, so 1 here
$(( 10 % 3 ))  # returns 1, % is mod operator

# union of two stdouts into one, note each command is run sequentially, so if one (e.g. tail -f) doesn't end then next will never run
{ head a; tail b; } | grep "foo"  # same as running "cat a b"

# printf for may newlines
printf "${A}\n\n"

"[" (the test command) is bash built-in and POSIX compatible, "[[" is bash specific

####### INTROSPECTION
# COMMAND is shell built-in, this is POSIX standard
command foo             # will ignore any aliases or functions named foo, and run only bins/files
# -v option can let us test if command exists
# exit 1  not found, exit 0 found, prints info
# zsh, osx /bin/sh, bash
command -v foo  # zsh/bash/osx-bourne/ubuntu-dash: prints name if func/builtin/keyword, path if bin/file, short alias def
command -V foo  # prints more info: is it alias, shell func, builtin or bin/script file
                # zsh prints it's source path where it's defined, bash prints the definition itself

# TYPE is shell builtin, made for bourne shell, but not in POSIX standard
# ubuntu dash is limited, osx /bin/sh is good
type foo        # prints "type" (alias/function/file(bin)/builtin/keyword) and def of alias/func, path of file
type -t foo     # prints just alias/function/file/builtin, nothing (exit code 1) if not found
                    # bash supports it, osx /bin/sh supports it
                    # zsh and ubuntu /bin/sh does NOT support -t
type -a foo     # dislay all info, including all hits. if foo was alias and 2 bins, would show all 3 in precedent order

# WHENCE - this is zsh builtin idiom
# whence -f is equivalent to type in bash, will print func definition
whence -f foofunc
# whence -c will print full path to bin, like which
whence -c foobin

# WHICH is bin, will return path of bin, exit non-zero otherwise
# zsh will say if it's built-in/keyword/alias/bin/(prints out func def), bash only shows bins, other types return error
which foo
which -a foo     # return all paths of bins matching foo in PATH

# ZSH - rebuild hash table cache of commands/bins in PATH
hash    # print all hashed commands
hash -m "*foo*" # print only commands with foo somewhere in it
rehash
hash -r     # empty the hash table, adding -f will make it rebuild immediately

# VARIABLE INTROSPECTION
# see https://stackoverflow.com/questions/307503/whats-a-concise-way-to-check-that-environment-variables-are-set-in-a-unix-shell
# using parameter expansion, works in bash and zsh, `?` operator dates back to ver 7 unix and bourne shell
FOO=1
echo ${FOO?"not set"}       # will print 1 to stdout
echo ${BAR?"not set"}       # assuming BAR not set, will print "not set" to stderr
# with `:?`, verifies it is set AND non-empty, this operator more recent than "?", also POSIX
FOO=
echo ${FOO?"not set"}     # will print blank line to stdout
echo ${FOO:?"var is not set or empty"}    # will print "var is not set or empty" to stderr
# to prevent globbing and field splitting best practice is to double quote whole expression
echo "${FOO:?var is not set or empty}"

# declare shows if variable is exported, it's value
# zsh will show "typeset" for non-exported, "export" for exported, "no such var" if it doesnt exist
# bash shows "-x" for exported, "--" for non exporeted, "not found" if not set
foo=1
export bar=1
declare -p foo bar



####### CONDITIONALS
# https://linuxhint.com/bash_operator_examples/
bash "==" is lexical comparison vs "=" is numerical comparison

# number comparison
gt = greater than, lt = less than, eq = equal, le = less than or equal, ge, ne = not equal
[ 3 -gt 1 ] && echo hi   # will print hi
[ -3 -lt 0 ] && echo hi   # will print hi

# string comparison
[ "a" = "dude" ] && echo hi   # wont print hi
[ "z" != "x" ] && echo hi   # will print hi
[ "foo" = foo ] && echo hi   # will print hi
[ $FOO \> "dude" ] && echo hi  # if FOO's value is > "dude" print hi
[ -n $FOO ] && echo hi  # if FOO as length > 0, will print hi
[ -z $FOO ] && echo hi  # if FOO as length = 0, will print hi

# other conditionals
[ -f ~/foo ] && print hi  # if regular file ~/foo exists print hi
-d  # check if dir exists
-e  # check if "file" exists, works for dirs and reg files
-w  # is file writable
-x  # is file executable
-r  # is file readable
[ ~/foo -nt ~/bar ] && echo hi  # if foo is newer than bar, print hi

# other logical operators
[ 3 -eq 3 -o 1 -eq 2 ] && echo hi # if 3 = 3 or 1 eq 2, print hi
#same logically as above, EXCEPT if first conditions is true, second condition doesnt get run
[ 3 -eq 3 ] || [ 1 -eq 2 ] && echo hi
-a  # "and"
&&  # "and" like using "||"
[ -n $(echo $1 | grep -E "^\d*$") ] && echo hi # if $1's value is all digits then echo hi

true || echo foo && echo bar   # this will print dude
true || { echo foo && echo bar; }   # this wont print anything, braces make the two staements one


# USER INPUT (from keyboard really)
echo ""; printf "Hit any key: "; read resultsinput   # resultsinptu will have string user entered after hitting enter

# bash select menus, works in zsh too
# select menu goes to STDERR
# select works with IFS splittting too
PS3="choose an option: "
options=(foo bar baz)   # bash array
select menu in "${options[@]}";
do
    echo -e "you picked $menu ($REPLY)"   # REPLY var contains line read (number)
    break;
done

# FILES AND DIRS
# iterate just through all files in curent dir
for d in *; do
    echo $d
done
# iterate just through dirs in current dir, NOTE: edge case of no dirs, will have one interation with d="*/"
for d in */ ; do

# if there is a dir named "foo (bar) [baz]", to move it to "foobarbaz"
mv foo\ \(bar\)\ \[baz\] foobarbaz


### RANDOM
# sudo -S option reads password from stdin
echo somepassword | sudo -S ls

# ssh can take arg that is a complex command and run it remote and spit output locally
ssh foouser@192.168.1.1 'echo "hi" && cat somefile | grep dude'

# ZSH
# compinit defines compdef
# autoload <keyword>, makes keyword a function and not a script to be autoloaded
############

# PP with python: json.tool will indent/format, no colorization tho
cat /etc/hosts | python -m json.tool

# quick jp (JMESPath CLI tool) query
echo '{"foo":3,"bar":{"yar":"yo"}}' | jp -u bar.yar   # will spit out `yo` , -u strips double quotes

# jq pass in a regex as variable and filter out a json object with "id" field values that match the regex
func filt() {
    echo '[{"id":"/foo/"},{"id":"bar"}]' | jq -r --arg ENVR "^/$1/" '.[] | select(.id | test($ENVR))'
}
