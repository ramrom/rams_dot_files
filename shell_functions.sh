#shell functions
function search_alias_func() {
    if [ $(detect_shell) = "zsh" ]; then
        # "-l" newlines, "o" orders, "k" keynames (so func names only), "functions" is a associative array in zsh of funcs
        local get_functions='print -l ${(ok)functions}'
    else  # Assumes BASH
        local get_functions='typeset -F'
    fi
    { alias; eval $get_functions; } | grep "$1"
    # { alias; typeset -F; } | grep "$1"
}

function display_notif() {
    if [ `uname` = "Darwin" ]; then
        osascript -e 'display notification "hi!" with title "my title" subtitle "a subtitle"'
    else  # really for ubuntu
        notify-send -i face-wink "a title" "hi!"
    fi
}

#TODO: get method 2 working
function detect_shell() {
    # METHOD 1: use ps
        # LINUX: `ps -p $$ -o cmd=`, OSX: `ps -p $$ -o command=`
    # METHOD 2:
    if [ -n "$BASH_VERSION" ]; then
        echo "bash"
    elif [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    else
        echo "$(tput setaf 1)NOT BASH OR ZSH!$(tput sgr0)"
    fi
}

# https://apple.stackexchange.com/questions/305901/open-a-new-browser-window-from-terminal
function chrome_open() {
    open -a "Google Chrome" $1
    #e.g. `open -a "Google Chrome" https://www.reddit.com`
}

function chrome_cookies() {
    local chrome_cookie_db=$HOME/'Library/Application Support/Google/Chrome/Default/Cookies'
    sqlite3 "$chrome_cookie_db" "SELECT * FROM cookies WHERE host_key LIKE \"%$1%\";"
}

function del_chrome_cookies() {
    local chrome_cookie_db=$HOME/'Library/Application Support/Google/Chrome/Default/Cookies'
    sqlite3 "$chrome_cookie_db" "DELETE FROM cookies WHERE host_key LIKE \"%$1%\";"
}

# TODO: WIP
function chrome_tabs_summary() {
    osascript -e 'tell application "Google Chrome" to get URL of tab 1 of window 1'
    osascript -e 'tell application "Google Chrome" to get title of tab 1 of window 1'
    #osascript -e 'tell application "Google Chrome" to get {URL,title} of tab 1 of window 1'

    #open -a "Google Chrome" http://stackoverflow.com http://wikipedia.org  # opening urls in chrome
    #open in new chrome window, see: https://apple.stackexchange.com/questions/305901/open-a-new-browser-window-from-terminal
    # open -na "Google Chrome" --args --new-window "https://georgegarside.com"
}

function spotify_toggle_play() {
    osascript -e 'using terms from application "Spotify"
                      if player state of application "Spotify" is paused then
                          tell application "Spotify" to play
                      else
                          tell application "Spotify" to pause
                      end if
                  end using terms from'
}


# TMUX
function tmuxclrhist {
    tmux list-panes -F "#{session_name}:#{window_index}.#{pane_index}" \
        | xargs -I PANE sh -c 'tmux send-keys -t PANE "clear" C-m; tmux clear-history -t PANE'
}

function tmuxclrallhist {
    tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index}" \
        | xargs -I PANE tmux clear-history -t PANE
}

# TODO: WIP, want to print each pane and it's background jobs
function tmux_pane_bg_jobs() {
    cat /dev/null > /tmp/tmux_pane_bg_jobs
    tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index}" \
        | xargs -I PANE tmux run-shell -t PANE PN=PANE; "echo ${PN}:$(whoami) >> /tmp/tmux_pane_bg_jobs"
}

# doesnt work with sh(3.2)
function filenamediff() {
    diff <(cd $1; find . -type f) <(cd $2; find . -type f)
}

function f_findfilesbysize() {
    sudo find "$1" -type f -size +"$2" | xargs du -sh
}

function tabname { printf "\e]1;$1\a"; }

function winname { printf "\e]2;$1\a"; }

# GIT
f_getbranchname() { git branch | grep "*" | awk '{print $2}'; }

function git_ctag_update() {
    if [ -f tags ]; then
        if [ -d .git ]; then
            local commit=$(git rev-parse HEAD)
            if [ -f ctag_git_ver ]; then
                if [ "$(cat ctag_git_ver)" != "$commit" ]; then
                    echo ${commit} > ctag_git_ver
                    ctag_create
                fi
            else
                echo ${commit} > ctag_git_ver
                ctag_create
            fi
        else
            ctag_create
        fi
    else
        ctag_create
    fi
}

# DB
function terminate_db_connections() {
    psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${1}' AND pid <> pg_backend_pid()" -d postgres
}

#TODO: not really working
function psql_pager() {
    #YELLOW=`echo -e '\033[1;33m'`
    #LIGHT_CYAN=`echo -e '\033[1;36m'`
    GREEN=`echo -e '\033[0;32m'`
    NOCOLOR=`echo -e '\033[0m'`
    echo "sed \"s/^\(([0-9]\+ [rows]\+)\)/$GREEN\1$NOCOLOR/;s/^\(-\[\ RECORD\ [0-9]\+\ \][-+]\+\)/$GREEN\1$NOCOLOR/;s/|/$GREEN|$NOCOLOR/g;s/^\([-+]\+\)/$GREEN\1$NOCOLOR/\" 2>/dev/null"

    #PAGER="sed \"s/\([[:space:]]\+[0-9.\-]\+\)$/${LIGHT_CYAN}\1$NOCOLOR/;"
    #PAGER+="s/\([[:space:]]\+[0-9.\-]\+[[:space:]]\)/${LIGHT_CYAN}\1$NOCOLOR/g;"
    #PAGER+="s/|/$YELLOW|$NOCOLOR/g;s/^\([-+]\+\)/$YELLOW\1$NOCOLOR/\" 2>/dev/null"
    #export PAGER
}

function ruby_base64_dec() {
    ruby -e '
        require "base64"
        puts ""
        puts Base64.decode64(ARGV[0])
    ' "$@"
}

function ryamltojson() {
    ruby -e 'require "yaml"; require "json"
        puts YAML.load_file(ARGV[0]).to_json
    ' "$@"
}

function parse_comma_delim_error() {
    local str="File.write(\"${1}\", File.read(\"${1}\").split(',').join(\"\\n\"))"
    ruby -e "$str"
}

function fullpath() {
    ruby -e '
        $stdin.each_line { |path| puts File.expand_path path }  if ARGV.empty?
        ARGV.each { |path| puts File.expand_path path }         unless ARGV.empty?
    ' "$@"
}

function colorgrid() {
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
