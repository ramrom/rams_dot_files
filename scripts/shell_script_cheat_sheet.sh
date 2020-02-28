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
# OR
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

# from https://superuser.com/questions/380772/removing-ansi-color-codes-from-text-stream, perl does not remove the tab/indent formatting
echo "$(tput setaf 3)yellow" | perl -pe 's/\x1b\[[0-9;]*[mG]//g'

# awk script to colorize
tail -f $1 | awk \
    -v reset=$(tput sgr0) -v yel=$(tput setaf 3) '
    {f=0}
    (/Join/ && f==0) {print yel $0 reset;f=1; fflush()}   # fflush force flush to stdout, important if this is piped into another cmd
    /HTTPie/ {print "\033[31m" $0 "\033[0m", "dude"; f=1; fflush()}  # space b/w strings concats, comma adds a space
    /io\.Abs[a-z]*C/ {print yel $0 reset;f=1; fflush()}
    f==0 { print $0; fflush() }
'

# Perl script to colorize logs
function perl_log_color() {
    A=$(echo -e "\033[48;5;95;38;5;214m") # yay this worked, orange on tan, passing it in as a arg
    B=$(tput setaf 4)
    export TESTVAR=MYVAL
    export PVAR=1
    perl -nse '   # n for loop over each line, s for the cmd line var inputs, e for in-line compilation
        use Term::ANSIColor;
        print $Term::ANSIColor::VERSION . "\n";
        $r = color("reset"); $bbbr = color("bright_blue on_bright_red"); $b = color("ansi15");
        $ENV{"PVAR"} = $ENV{"PVAR"} + 1; print $ENV{"PVAR"} . "\n";
        print "environment var TESTVAR= " . $ENV{TESTVAR} . " foo arg= " . $foo . " baz arg= " . $baz . $r . " uncolor";
        s/(the )(foo)( the)/$1$bbbr$2$r$3/g;
        if (m/werd/) { s/(\[)(d.de)(\])/$1$bbbr$2$r$3/g }
        # if ($_ =~ m/the d.de/) { $_ =~ s/(d.d)/$bbbr$1$r/g } # equivalent to previous line
        elsif ($_ =~ m/bash/) { print color("bold grey23 on_ansi1"), "BASH", color("reset") }
        elsif ($_ =~ m/test/) { print colored("test", "blue"), "test", color("reset"), "\n" }
        $_ = color("green") . "PREFIX: " . color("reset") . $_;           # string concatenation
        print $_
        ' -- -foo="$A" -baz=bam
    #tail -f $1 | perl -pe 's/window/BLUBBER/g'
}

# quick jp (JMESPath CLI tool) query
echo '{"foo":3,"bar":{"yar":"yo"}}' | jp -u bar.yar   # will spit out `yo` , -u strips double quotes

# jq pass in a regex as variable and filter out a json object with "id" field values that match the regex
func filt() {
    echo '[{"id":"/foo/"},{"id":"bar"}]' | jq -r --arg ENVR "^/$1/" '.[] | select(.id | test($ENVR))'
}

### BREW
brew deps --tree httpie  # show deps of httpie in tree output

# show all formula that need this formula
brew uses httpie
brew uses --installed httpie # only formula installed that need this formula

# all brew formulas not depended by other brew formulas
brew leaves

# for each brew leaf formula: show flat list of deps for that formula
brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"

# removing packages deps of a uninstalled FORMULA that isn't a dep on something else
# from https://stackoverflow.com/questions/7323261/uninstall-remove-a-homebrew-package-including-all-its-dependencies)
`brew rm $(join <(brew leaves) <(brew deps FORMULA))`
