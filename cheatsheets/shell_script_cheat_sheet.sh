# SHELL SCRIPT CHEAT SHEET

# PP with python: json.tool will indent/format, no colorization tho
cat /etc/hosts | python -m json.tool

# redirect stderr to out
cat 2>&1 blah

# find a file recursive starting with current dir
find . -type f -name "*pattern*"

array=(1 two thre)
echo ${array[1]}  # ref 2nd element in array, in this case this prints "two"
for i in "${array[@]}"
do
    echo $i
done

###### LOOPS
# bash
for run in {1..10}; do echo "hello"; done

for (( i=1; i<=3; i++)); do
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

# split on ":" delimiter, each on newline
echo foo:bar:baz | tr : \\n

# command line substitution to preserve newline chars after field splitting
# see https://unix.stackexchange.com/questions/164508/why-do-newline-characters-get-lost-when-using-command-substitution
IFS=
A=$(env)
echo $A | grep "something"
# OR (double quoting the var)
A=$(env)
echo "$A" | grep "something"

# remove non-ascii chars
tr -cd '\11\12\15\40-\176' < file-with-binary-chars > clean-file

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

# union of two stdouts into one, note each command is run sequentially, so if one (e.g. tail -f) doesn't end then next will never run
{ head a; tail b; } | grep "foo"  # same as running "cat a b"

# printf for may newlines
printf "${A}\n\n"

# programatically create env variables
A=FOO
export BAR${A}="somestring"
echo $FOOBAR # will print somestring

"[" (the test command) is bash built-in and POSIX compatible, "[[" is bash specific

bash "==" is lexical comparison vs "=" is numerical comparison

echo $$ # print PID of current shell process
echo $? # print exit code of last command

set -e # shell script will abort running subsequent statements if a statement exits with non-zero code

set -x # spit out each expanded statement to terminal before it's executed

# ZSH
# compinit defines compdef
# autoload <keyword>, makes keyword a function and not a script to be autoloaded
############

# quick jp (JMESPath CLI tool) query
echo '{"foo":3,"bar":{"yar":"yo"}}' | jp -u bar.yar   # will spit out `yo` , -u strips double quotes

# jq pass in a regex as variable and filter out a json object with "id" field values that match the regex
func filt() {
    echo '[{"id":"/foo/"},{"id":"bar"}]' | jq -r --arg ENVR "^/$1/" '.[] | select(.id | test($ENVR))'
}
