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

# programatically create env variables
A=FOO
export BAR${A}="somestring"
echo $FOOBAR # will print somestring

# tells a shell script to abort running subsequent statements if a statement exits with non-zero code
set -e

set -x # spit out each expanded statement to terminal before it's executed
