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
