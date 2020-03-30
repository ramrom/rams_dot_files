# shell functions
#TODO: get method 2 working
function detect_shell() {
    # METHOD 1:
    if [ -n "$BASH_VERSION" ]; then
        echo "bash"
    elif [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    else
        echo "$(tput setaf 1)NOT BASH OR ZSH!$(tput sgr0)" && return 1
    fi
    # METHOD 2: use ps
        # LINUX: `ps -p $$ -o cmd=`, OSX: `ps -p $$ -o command=`
}

function search_alias_func() {
    # calling $(list_funcs) in cmd substitution removes new lines, and IFS= trick gives me "cmd too long" error
    if [ $(detect_shell) = "zsh" ]; then
        { alias; print -l ${(ok)functions}; } | grep "$1"
    else
        { alias; typeset -F; } | grep "$1"
    fi
}

function list_funcs() {
    if [ $(detect_shell) = "zsh" ]; then
        # "-l" newlines, "o" orders, "k" keynames (so func names only), "functions" is a associative array in zsh of funcs
        print -l ${(ok)functions}
    else  # Assumes BASH
        typeset -F
    fi
}

function rrc() {
    if [ $(detect_shell) = "zsh" ]; then
        source ~/.zprofile && source ~/.zshrc
    else  # Assumes BASH
        source ~/.bash_profile && source ~/.bashrc
    fi
}

function vil() { vi -p $(cat $1); }
function viln() { vin -p $(cat $1); }

function findgrep() {
    find . -type f -regex $1 | xargs grep $2
}

function ansi_fmt() { echo -e "\e[${1}m${*:2}\e[0m"; }
function italic() { ansi_fmt 3 "$@"; }

function display_notif() {
    if [ `uname` = "Darwin" ]; then
        osascript -e 'display notification "hi!" with title "my title" subtitle "a subtitle"'
    else  # really for ubuntu
        notify-send -i face-wink "a title" "hi!"
    fi
}

# TODO: finish this
function sensor_data() {
    # needed for newlines: https://unix.stackexchange.com/questions/164508/why-do-newline-characters-get-lost-when-using-command-substitution
    local IFS=
    local s=$(sensors)
    echo $s | grep -E "CPU Temperature" | awk '{print $3;}' | grep -oEi '[0-9]+.[0-9]+'
    echo $s | grep -E "CPU Fan"
}

function osx_set_volume() { sudo osascript -e "set Volume $1"; }   # 0 mute, 10 max
function osx_mute() { sudo osascript -e "set Volume 0"; }
function osx_get_volume() { sudo osascript -e 'get volume settings'; }

function osx_spotify_toggle_play() {
    osascript -e \
        'using terms from application "Spotify"
            if player state of application "Spotify" is paused then
                tell application "Spotify" to play
            else
                tell application "Spotify" to pause
            end if
        end using terms from'
}

############## CHROME #############################################
function chrome_cookies() {
    local chrome_cookie_db=$HOME/'Library/Application Support/Google/Chrome/Default/Cookies'
    sqlite3 "$chrome_cookie_db" "SELECT * FROM cookies WHERE host_key LIKE \"%$1%\";"
}

function del_chrome_cookies() {
    local chrome_cookie_db=$HOME/'Library/Application Support/Google/Chrome/Default/Cookies'
    sqlite3 "$chrome_cookie_db" "DELETE FROM cookies WHERE host_key LIKE \"%$1%\";"
}

function chrome_json_summary() {
    local wincount=$(osascript -e 'tell application "Google Chrome" to get number of windows')
    [ "$wincount" -eq 0 ] && echo "zero windows!" && return

    local json="["
    for (( i=1; i<=$wincount; i++)); do
        json="$json""["
        local cmd="osascript -e 'tell application \"Google Chrome\" to get number of tabs in window $i'"
        local tabcount=$(eval $cmd)
        for (( j=1; j<=$tabcount; j++)); do
            #osascript -e 'tell application "Google Chrome" to get {URL,title} of tab 1 of window 1'
            local cmd="osascript -e 'tell application \"Google Chrome\" to get URL of tab $j of window $i'"
            local url=$(eval $cmd)
            [ $j -eq $tabcount ] && json="$json\"$url\"" || json="$json\"$url\","
       done
       [ $i -eq $wincount ] && json="$json]" || json="$json],"
    done
    echo "$json]"
}

#open -a "Google Chrome" http://stackoverflow.com http://wikipedia.org  # opening urls in chrome
#open in new chrome window, see: https://apple.stackexchange.com/questions/305901/open-a-new-browser-window-from-terminal
function chrome_json_restore() {
    local wincount=$(echo $1 | jq '. | length')
    for (( i=0; i<$wincount; i++)); do
        local tabcount=$(echo $1 | jq --arg WINNUM $i '.[($WINNUM | tonumber)] | length')
        local cmd="open -na \"Google Chrome\" --args --new-window"
        #cmd="$cmd $(echo $1 | jq -r --arg WINNUM $i '.[($WINNUM | tonumber)] | join(" ")')" # "&" chars cause bg job
        for (( j=0; j<$tabcount; j++)); do
            cmd="$cmd $(echo $1 | jq --arg WINNUM $i --arg TABNUM $j '.[($WINNUM | tonumber)][($TABNUM | tonumber)]')"
        done
        eval $cmd
    done
}

function chrome_save_state() { echo $(chrome_json_summary) > ~/Documents/chrome_tabs_backup.json; }

function chrome_restore() { chrome_json_restore $(cat ~/Documents/chrome_tabs_backup.json); }

########## TMUX ##############################
function tmux_winlist() {
    #echo "#[align=left range=left #{status-left-style}]#{T;=/#{status-left-length}:status-left}#[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#{T:window-status-format}#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{window-status-current-style},default},#{window-status-current-style},#{window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#{T:window-status-current-format}#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}#[nolist align=right range=right #{status-right-style}]#{T;=/#{status-right-length}:status-right}#[norange default]"
    echo "#[norange default]#[list=on]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#{T:window-status-format}#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{window-status-current-style},default},#{window-status-current-style},#{window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#{T:window-status-current-format}#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}#[nolist]"
    # need #[nolist] at the end here to let next items align
}

function verify_percent() {
    if [ -z $(echo $1 | grep -E "^[[:digit:]]*$") ]; then
        echo "$(tput setaf 1)$2 must be a positive integer!" && return 1
    fi
    [ $1 -lt 0 -o $1 -gt 100 ] && echo "$(tput setaf 1)$2 must be between 0 and 100!" && return 1
    return 0
}

function local_bar_width() {
    #determine bar width, default to 100% of column width of viewport
    local percentage_of_window=100
    if [ -n "$1" ]; then
        verify_percent $1 "window width percentage" || return 1
        percentage_of_window=$1
    fi
    echo "$(tput cols) * $percentage_of_window / 100" | bc
}

function tmux_render_progress_bar() {
    verify_percent $2 "task percentage done" || return 1
    local text="$2%% $1"  # arg 1 is descriptive name like "egg timer"
    local text_size=${#text}; local bar_width=$3
    if [ $text_size -gt $bar_width ]; then
        echo "#[fg=brightyellow,bg=red]error: $1 > $bar_width chars!" && return 1
    fi

    local num_white_space=$(($bar_width - $text_size))
    for (( i=1; i<=$num_white_space; i++ )); do
        text+=" "
    done

    local col=21; [ -n "$color" ] && col=$color

    local completed_width=$(($bar_width * $2 / 100 ))
    text="${text:0:$completed_width}#[bg=colour237]${text:$completed_width:${#text}}"
    text="#[fg=brightwhite,bg=colour$col]$text"

    # for (( i=1; i<=$uncompleted_width; i++ )); do
    #     printf "-"
    # done
    echo "$text#[default]"
}

function tmux_delete_timer() { tmux set -u "@$1-start"; tmux set -u "@$1-duration"; }
function tmux_create_timer() { tmux set -q "@$1-start" $(date +%s); tmux set -q "@$1-duration" $2; }

# NOTE: default tmux status script shell is sh(3.2), it compresses white spaces into one
# TODO: diff format for secs and percent maybe?
function tmux_render_timer_bar() {
    local start=$(tmux show -v @$1-start)
    [ -z $start ] && echo "#[fg=brightred]$1 timer not found!" && return 1

    local now=$(date +%s)
    local duration=$(tmux show -v @$1-duration)
    local elapsed=$(( $now - $start ))
    local percent_done=$(( $elapsed * 100 / $duration ))
    # echo $percent_done

    if [ $percent_done -gt 100 ]; then
        local excess=$(( $elapsed - $duration ))
        local progbar=$(tmux_render_progress_bar \
            "⏰ $1 timer (${duration}s) - #[bg=red,underscore]!COMPLETED!#[bg=$color,nounderscore] ${excess}s ago" 100 100)
    else
        local progbar=$(tmux_render_progress_bar "⏰ $1 timer (${duration}s)" $percent_done 100)
    fi

    echo $progbar
}

function tmux_status_foo() {
    tmux set status 5
    tmux set status-interval 2

    # TODO: tput cols x lines with tput reports 80 x 25, the default, in reality i have it set to 135
    # tmux set status-format[1] "#[align=left,fg=red]#(tput cols; tput lines)"

    tmux set status-format[0] "#(~/rams_dot_files/tmux_status_bar.sh 2>&1)"
    # local progbar=$(tmux_progress_bar "foo timer" 10 100)
    # tmux set status-format[0] "$progbar"
    # tmux set status-format[1] "$(color=128 tmux_progress_bar "bar timer" 30 100)"
}

function tmux_status_reset() {
    tmux set -u status-format[0]
    tmux set -u status
    tmux set -u status-interval
    tmux set -u status-left; tmux set -u status-right
    tmux set -u status-format
}

function tmux_test_data() {
    numcpu=$(sysctl -n hw.ncpu)
    local usage=$(uptime | awk '{print $10}')
    echo $usage
    local au=$(($usage * 100 / $numcpu))
    local cpu="#[fg=brightyellow]cpuusage: $au"
    echo $cpu
}

function tmux_status() {
    #  https://stackoverflow.com/questions/35016458/how-to-write-if-statement-in-tmux-conf-to-set-different-options-for-different-t
    # 'tmux setenv -g TMUX_VERSION $(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
    ver=$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")  # need tmux 2.9 to set multi-line statuses
    echo $ver

    local tmux_mouse_mode="#[fg=brightyellow]#[bg=red]#{?mouse,MOUSEON,}#[default]"
    local tmux_sync_panes="#[fg=brightyellow]#[bg=red]#{?synchronize-panes,SYNCPANEON,}#[default]"
    local tmux_wind_bg_jobs="#[fg=brightyellow]#[bg=red]#(~/rams_dot_files/scripts/tmux_bg_jobs.sh)#[default]"
    local tmux_ssh_jmp="#[fg=brightyellow]#[bg=red]#(~/code/rally_ram_dot_files/tmux_ssh_jmp.sh)#[default]"

    local tmux_spotify="#[fg=colour208]#(osascript ~/rams_dot_files/scripts/spotify_song.scpt)"
    local tmux_host_datetime="#[fg=brightyellow]#{host} #[fg=brightwhite]%Y-%m-%d #[fg=brightwhite]%H:%M"

    local left="#[fg=cyan]#S ${tmux_mouse_mode} ${tmux_sync_panes} ${tmux_wind_bg_jobs} ${tmux_ssh_jmp}"
    local right="#[align=right]${tmux_spotify}   ${tmux_host_datetime}"
    if [ -n "$simple" ]; then
        left="#[fg=cyan]#S ${tmux_mouse_mode} ${tmux_sync_panes}"
        right="#[align=right]  ${tmux_host_datetime}"
    fi

    local cmd="tmux"
    [ $(detect_shell) = "zsh" ] && cmd="noglob tmux" # for zsh '[]' globbing

    if [ $(echo "$ver >= 2.9" | bc) -eq 1 ]; then
        echo "tmux ver >= 2.9, can use multi-line status"
        tmux set status on
        eval "$cmd set status-format[0] \"#[align=left]$left #[align=centre]$(tmux_winlist) #[align=right]$right\""
        #eval "$cmd set status-format[1] \"#(source ~/rams_dot_files/shell_functions.sh; tmux_test_data)\""
    else
        echo "tmux ver < 2.9, using basic one line status format"
        tmux set status on
        tmux set-window-option window-status-format '#[fg=colour244]#I:#W#[fg=grey]#F'
        tmux set-window-option window-status-current-format '#[fg=brightgreen]#I:#W'
        eval "$cmd set status-left \"$left\""
        eval "$cmd set status-right \"$right\""
    fi
}

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

######### GIT  ####################
function gitclean() {
    local masterb=master
    [ -n "$1" ]  && masterb=$1
    git branch –-merged $masterb | grep -v $masterb | cut -d/ -f2- | xargs -n 1 git push –delete origin
    git branch –-merged $masterb | grep -v $masterb | xargs -n 1 git branch -d
}

function gits() {
    [ -z "$GIT_SSH_SCRIPT_LOC" ] && echo "$(tput setaf 1)GIT_SSH_SCRIPT_LOC NOT SET!$(tput sgr0)" && return 1
    GIT_SSH=$GIT_SSH_SCRIPT_LOC git $*
}

f_getbranchname() { git branch | grep "*" | awk '{print $2}'; }

# TODO: WIP
function git_ctag_update() {
    [ ! -f tags ]  && ctag_create && return 0 || return 1
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
}

#####  DB  ############
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

# doesnt work with sh(3.2)
function filenamediff() {
    diff <(cd $1; find . -type f) <(cd $2; find . -type f)
}

function f_findfilesbysize() {
    sudo find "$1" -type f -size +"$2" | xargs du -sh
}

function tabname { printf "\e]1;$1\a"; }

function winname { printf "\e]2;$1\a"; }

function fullpath() {
    ruby -e '
        $stdin.each_line { |path| puts File.expand_path path }  if ARGV.empty?
        ARGV.each { |path| puts File.expand_path path }         unless ARGV.empty?
    ' "$@"
}

function vim_plug_ver() {
    pushd ~/.vim/plugged > /dev/null
    for dir in */; do
         pushd $dir > /dev/null
         echo "${dir}: $(git rev-parse HEAD)"
         popd > /dev/null
     done
     popd > /dev/null
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
