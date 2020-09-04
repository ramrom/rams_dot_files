# SHELL SCRIPT CHEAT SHEET
# good references: https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html
# good zsh feature overview: https://github.com/hmml/awesome-zsh

# Bash (and AFAIK zsh)
set -e # exit script/shell if any command returns with non-zero
set -x # Print commands and args as they are executed.
set +x # remove x, bash is backwards
echo $- #query all set options on in shell

# KEYBINDINGS
# good ref on ZLE (zsh line editor):  ZLE (zsh line editor): http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
bind -P     # bash print out all key bindinds, for sh too
bindkey     # for zsh

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

###### FUNCTIONS
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

####### VARIABLES
# bash/zsh and bsd/gnu sh support local scoped variables in a function
# - https://stackoverflow.com/questions/18597697/posix-compliant-way-to-scope-variables-to-a-function-in-a-shell-script
local foo=1   # only hold value in scope of current function and called function, once func finishes local var is removed
              # if a called function also decluares a `local foo=3`, then it and it's downstream func calls will use 3
foo=1         # shell variable, so persists even when function exits

export FOO=1  # environment variable, subshells inhert these variables
FOO=1         # shell variable,       same as "set"ing, subshells dont inherit these

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

# SPECIAL VARIABLES
# bash/zsh/sh all seem to define these shell variables
# these are not env vars, and not exported to child processes
LINES   # horizontal size of viewport
COLUMNS # vertical size of viewport

echo $$ # print PID of current shell process
echo $? # print exit code of last command

# splat argument that expands to all command-line arguments seperated by spaces
# note: $0 is not passed in $@
echo $@
echo "$@" # usually want this to avoid misparsing args containing spaces/wildcards

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

# IF else syntax
if [ "a" = "a" ]; then
    echo "hi"
elif [ "b" = "b" ]; then
    echo "word"
else
    echo "hi"
fi


# technically proper POSIX doesnt do arrays but osx's /bin/sh supports this
array=(1 two thre)
echo ${array[1]}  # ref 2nd element in array, in this case this prints "two"
for i in "${array[@]}"
do
    echo $i
done

# bash IFS field split will see 3 items
string="foo bar baz"
for i in $string
do
    echo $i
done


###### LOOPS
# bash
for run in {1..10}; do echo "hello"; done

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

# command line substitution field splitting
#   bash field splits by default, zsh doesnt (need to set an shell option)
#   IFS  var determines chars to use as delimter for splitting
#   https://stackoverflow.com/questions/41320199/ifs-in-zsh-behave-differently-than-bash
#   https://unix.stackexchange.com/questions/26661/what-is-word-splitting-why-is-it-important-in-shell-programming
#   https://unix.stackexchange.com/questions/164508/why-do-newline-characters-get-lost-when-using-command-substitution
IFS=
A=$(env)
echo $A | grep "something"
# OR (double quoting var also prevents field splitting)
A=$(env)
echo "$A" | grep "something"

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
command -v foo  # zsh/bash/osx-bourne/ubuntu-borne: prints name if func/builtin/keyword, path if bin/file, short alias def
command -V foo  # prints more info: is it alias, shell func, builtin or bin/script file
                # zsh prints it's source path where it's defined, bash prints the definition itself

# TYPE is shell builtin, made for bourne shell, but not in POSIX standard
# ubuntu /bin/sh is limited, osx /bin/sh is good
type foo        # prints "type" (alias/function/file(bin)/builtin/keyword) and def of alias/func, path of file
type -t foo     # prints just alias/function/file/builtin, nothing (exit code 1) if not found
                    # bash supports it, osx /bin/sh supports it
                    # zsh and ubuntu /bin/sh does NOT support -t
type -a foo     # dislay all info, including all hits. if foo was alias and 2 bins, would show all 3 in precedent order

# WHICH is bin, will return path of bin, exit non-zero otherwise
which foo
which -a foo     # return all paths of bins matching foo in PATH

bash "==" is lexical comparison vs "=" is numerical comparison

####### CONDITIONALS
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

# USER INPUT
echo ""; printf "Hit any key: "; read resultsinput   # resultsinptu will have string user entered after hitting enter

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
