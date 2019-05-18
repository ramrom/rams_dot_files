#Bash functions

function bsixfour_dec() {
    ruby -e '
        require "base64"
        puts ""
        puts Base64.decode64(ARGV[0])
    ' "$@"
}

function fullpath() {
    ruby -e '
        $stdin.each_line { |path| puts File.expand_path path }  if ARGV.empty?
        ARGV.each { |path| puts File.expand_path path }         unless ARGV.empty?
    ' "$@"
}

function filenamediff() {
    diff <(cd $1; find . -type f) <(cd $2; find . -type f)
}

function f_findfilesbysize() {
    sudo find "$1" -type f -size +"$2" | xargs du -sh
}

function tabname {
    printf "\e]1;$1\a"
}

function winname {
    printf "\e]2;$1\a"
}

function tmuxclrallhist {
    tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index}" \
        | xargs -I PANE tmux clear-history -t PANE
}

# GIT
f_getbranchname()
{
    git branch | grep "*" | awk '{print $2}'
}

# DB
function terminate_db_connections() {
    psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${1}' AND pid <> pg_backend_pid()" -d postgres
}

# OTHER
function parse_comma_delim_error() {
    local str="File.write(\"${1}\", File.read(\"${1}\").split(',').join(\"\\n\"))"
    ruby -e "$str"
}

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
