#/bin/bash
black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
blue_on_yellow=`tput setaf 4; tput setab 3`
bold=`tput bold`
dim=`tput dim`
und=`tput smul`
remove_und=`tput rmul`
reset=`tput sgr0`

# ANSI supports italics, bold, underline, strikethrough
# https://askubuntu.com/questions/528928/how-to-do-underline-bold-italic-strikethrough-color-background-and-size-i
ansi()          { echo -e "\e[${1}m${*:2}\e[0m"; }
bold()          { ansi 1 "$@"; }
italic()        { ansi 3 "$@"; }
underline()     { ansi 4 "$@"; }
strikethrough() { ansi 9 "$@"; }
red()           { ansi 31 "$@"; }


echo "${yellow}${bold}BOLD AND YELLOW...${reset}"

txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset


# ANSI sequence: 48;5 for background, 38;5 for foreground, then color number
# below gives me a light orange on tan
echo -e "\033[48;5;95;38;5;214mhello world\033[0m"

lor_on_tan="\033[48;5;95;38;5;214m"
echo -e $lor_on_tan orange on tan $(tput sgr0) normal

function colorgrid( )
{
    iter=16
    while [ $iter -lt 52 ]
    do
        second=$[$iter+36]
        third=$[$second+36]
        four=$[$third+36]
        five=$[$four+36]
        six=$[$five+36]
        seven=$[$six+36]
        if [ $seven -gt 250 ];then seven=$[$seven-251]; fi

        echo -en "\033[38;5;${iter}m█ "
        printf "%03d" $iter
        echo -en "   \033[38;5;${second}m█ "
        printf "%03d" $second
        echo -en "   \033[38;5;${third}m█ "
        printf "%03d" $third
        echo -en "   \033[38;5;${four}m█ "
        printf "%03d" $four
        echo -en "   \033[38;5;${five}m█ "
        printf "%03d" $five
        echo -en "   \033[38;5;${six}m█ "
        printf "%03d" $six
        echo -en "   \033[38;5;${seven}m█ "
        printf "%03d" $seven

        iter=$[$iter+1]
        printf '\r\n'
    done
}

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

