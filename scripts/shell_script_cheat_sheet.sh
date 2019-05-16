# SHELL SCRIPT CHEAT SHEET

# PP with python: json.tool will indent/format, no colorization tho
cat /etc/hosts | python -m json.tool

# redirect stderr to out
cat 2>&1 blah

# Bash index/slicing on string 
A="foobar"
S=${A:0:3} # => "foo", so chars from index 0 to 2 (not 3!)

echo ${#S} # prints length of S, so will echo 3
S=${A:1:${#A}-1}  # will print "fooba", omitted the last char

# union of two stdouts into one, note each command is run sequentially, so if one (e.g. tail -f) doesn't end then next will never run
{ head a; tail b; } | grep "foo"  # same as running "cat a b"

# printf for may newlines
printf "${A}\n\n"

# from https://superuser.com/questions/380772/removing-ansi-color-codes-from-text-stream, perl does not remove the tab/indent formatting
echo "$(tput setaf 3)yellow" | perl -pe 's/\x1b\[[0-9;]*[mG]//g'

# awk script to colorize
tail -f $1 | awk \
    -v reset=$(tput sgr0) -v yel=$(tput setaf 3)
    {f=0}
    (/Join/ && f==0) {print yel $0 reset;f=1; fflush()}   # fflush force flush to stdout, important if this is piped into another cmd
    /HTTPie/ {print bblue $0 reset;f=1; fflush()}
    /io\.Abs[a-z]*C/ {print mag bold $0 reset;f=1; fflush()}
    f==0 { print $0; fflush() }
'
