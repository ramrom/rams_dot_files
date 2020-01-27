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

function rrc() {
    if [ $(detect_shell) = "zsh" ]; then
        source ~/.zprofile && source ~/.zshrc
    else  # Assumes BASH
        source ~/.bash_profile && source ~/.bashrc
    fi
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
    # METHOD 1:
    if [ -n "$BASH_VERSION" ]; then
        echo "bash"
    elif [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    else
        echo "$(tput setaf 1)NOT BASH OR ZSH!$(tput sgr0)"
    fi
    # METHOD 2: use ps
        # LINUX: `ps -p $$ -o cmd=`, OSX: `ps -p $$ -o command=`
}

# TODO: finish
function sensor_data() {
    # needed for newlines: https://unix.stackexchange.com/questions/164508/why-do-newline-characters-get-lost-when-using-command-substitution
    local IFS=
    local s=$(sensors)
    echo $s | grep -E "CPU Temperature"
    echo $s | grep -E "CPU Fan"
}

function tmux_winlist() {
    #echo "#[align=left range=left #{status-left-style}]#{T;=/#{status-left-length}:status-left}#[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#{T:window-status-format}#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{window-status-current-style},default},#{window-status-current-style},#{window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#{T:window-status-current-format}#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}#[nolist align=right range=right #{status-right-style}]#{T;=/#{status-right-length}:status-right}#[norange default]"
    echo "#[norange default]#[list=on]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#{T:window-status-format}#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{window-status-current-style},default},#{window-status-current-style},#{window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#{T:window-status-current-format}#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}#[nolist]"
    # need #[nolist] at the end here to let next items align
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
    else
        echo "tmux ver < 2.9, using basic one line status format"
        tmux set status on
        # tmux set-window-option window-status-format '#[fg=colour244]#I:#W#[fg=grey]#F'
        # tmux set-window-option window-status-current-format '#[fg=brightgreen]#I:#W'
        #eval "$cmd set status-left \"$left\""
        #eval "$cmd set status-right \"$right\""
    fi
}

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
