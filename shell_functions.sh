# shell functions
#TODO: get method 2/3 or all of them working
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
        # LINUX: `ps -p $$ -o cmd=`
        # OSX: `ps -p $$ -o command=` # i will get "-zsh" so need to remove "-" char
    # METHOD 3: echo $SHELL (when i start bourne(sh) from a zsh in osx, it's still zsh
}

# return 0 if all are defined, spit out error with exit 1 if one is not
function cmds_defined() {
    for cmd in "$@"; do
        command -v $cmd > /dev/null || { echo "$cmd no defined!" && return 1; }
    done
}

function search_alias_func() {
    # calling $(list_funcs) in cmd substitution removes new lines, and IFS= trick gives me "cmd too long" error
    if [ $(detect_shell) = "zsh" ]; then
        local func_cmd="functions"; [ -n "$funcname" ]  && func_cmd='print -l ${(ok)functions}'
        local alias_cmd="alias"; [ -n "$aliasname" ]  && alias_cmd='alias | cut -d= -f1'
        { eval $alias_cmd; eval $func_cmd; } | grep "$1"
    else # Assuming BASH
        # NOTE: set prints much more than defined functions, like env vars
        local func_cmd="set"; [ -n "$funcname" ]  && func_cmd="typeset -F | awk '{print \$3;}'"
        { eval $alias_cmd; eval $func_cmd; } | grep "$1"
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

# TODO: /bin/sh in osx does not like the printf's
function debug_vars() {
    local spacing="\n"; [ -n "$tab" ] && spacing=";    "

    for arg in "$@"; do
        local var_value=$(eval "echo \$${arg}")

        if [ -z "$var_value" ]; then
            local msg=$(und=1 ansi256 "DEBUG:")" Variable "$(fg=yellow ansi256 "$arg")
            local msg2=$(fg=brightred ansi256 " is undefined!")"${spacing}"
            printf "$msg$msg2"
        else
            local msg=$(und=1 ansi256 "DEBUG:")" Variable $(fg=yellow ansi256 $arg)"
            local msg2=" = "$(fg=brightgreen ansi256 $var_value)"${spacing}"
            printf "$msg$msg2"
        fi
    done
    [ -n "$tab" ] && echo
}

# TODO: finish, script to pp all headers and body and have programatic access to status code, other header values, and body
function httpie_all() {
    local url=$1
    local method=GET
    local body_file=/tmp/httpie_body

    # gets 3 digit status code with ansi color chars:
        # local headers=$(http -v -do $body_file --pretty all http://api.icndb.com/jokes/random 2>&1)
        # echo $headers | grep "HTTP.*\d\d\d" | grep -o "\d\d\d"

    local headers=$(http -v -do $body_file $method $url 2>&1)
    local http_status=$(echo $headers | grep "^HTTP" | cut -d ' ' -f 2)
    echo $headers; echo
    echo "STATUS CODE IS: $http_status"; echo
    jq . $body_file || echo $(fg=brightred ansi256 "$body_file NOT VALID JSON") && cat $body_file
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

# fuzzy move many files to dest dir, handles spaces in paths and git moves, tested with zsh and bash
# NOTE: zsh give "bad math expression" on first for loop, bash works; when i rebooted it works, maybe shell opt?
function fmv() {
    local IFS=$'\n'
    local files=($(fzf))
    echo "$(tput setaf 2)FILES TO BE MOVED:$(tput sgr0)"
    for i in ${files[@]}; do echo "    $(tput setaf 3)$i"; done
    local dest=$(fd --type d | fzf --no-multi)
    [ -z "$dest" ] && return 1
    local mvcmd="mv"; git rev-parse --git-dir > /dev/null 2>&1 && mvcmd="git mv"
    for i in ${files[@]}; do eval "$mvcmd $i $dest"; done
    echo "$(tput setaf 2)FILES MOVED TO DIR: $(tput setaf 6)$dest$(tput sgr0)"
}

# ripgrep and fzf+preview, preserving rg match color in preview (by using rg for preview too)
function rgf() {
    [ ! "$#" -gt 0 ] && echo "Need a string to search for!" && return 1
    local rgdir=$RG_DIR; [ -z $rgdir ] && rgdir="."
    local rgheight=$RG_H; [ -z $rgheight ] && rgheight="50"
    # rg -tscala -g '!it/' -g '!test/' --files-with-matches --no-messages "$1" | fzf --preview \
    rg "$RG_FILTER" --files-with-matches --no-messages "$1" "$rgdir" | fzf --preview \
        "rg \"$RG_FILTER\" --ignore-case --pretty --context 10 '$1' {}" --height ${rgheight}%
        # "rg -tscala -g '!it/' -g '!test/' --ignore-case --pretty --context 10 '$1' {}" --height ${rgheight}%
        # "rg --ignore-case --pretty --context 10 '$1' {}"
}

#TODO: fix, "unrecognized file type: scala -g '!it/' -g '!test/'", rgfst works fine
function rgfs() { RG_FILTER="-tscala -g '!it/' -g '!test/'" rgf $1; }
function rgfst() { RG_FILTER="-tscala" rgf $1; }

# actual regex on full path, e.g. ".*go$" (any # of chars, ending literal go)
function findgrepp() { find . -type f -regex $1 -exec grep $2; }

# last component of pathname, pattern not regex, e.g. ("*go")
function findgrep() { find . -type f -name $1 -exec grep $2; }

# go docs with syntax highlighting!
function batgod() { go doc $@ | bat -l go; }

function batsh() {
    local definition_cmd=which
    [ $(detect_shell) = "bash" ] && definition_cmd=type
    $definition_cmd $@ | bat -l sh
}

# e.g. "Some Title (2000) [1080p] [FOO]"
function file_rename() {
    local f=$(echo "$1" | sed 's/ /-/g' | sed 's/\./_/g')
    local charsbeforefirstparen=$(echo "$f" | rg -o  "([^\(].*)\(.*$" -r '$1' --color never)
    local charsafterfirstparen=$(echo "$f" | rg -o  "[^\(].*(\(.*$)" -r '$1' --color never)
    local a=$(echo $charsbeforefirstparen | sed 's/-/_/g')
    local a=$(echo $a | sed 's/.$/-/')
    # local b=$(echo $charsafterfirstparen | sed 's/[()\[]//g')  # sed fails literal \] in [] char class
    local b=$(echo $charsafterfirstparen | tr -d "()[]")
    echo $a$b
}

# e.g. "Some.Title.2000.1080p.[FOO].mp4"
function file_rename2() {
    local charsbeforeyear=$(echo "$1" | rg -o "(.*)\.\d{4}\..*" -r '$1' --color never)
    local charsafteryear=$(echo "$1" | rg -o ".*(\.\d{4}\..*)" -r '$1' --color never)

    charsbeforeyear=$(echo $charsbeforeyear | sed 's/\./_/g')

    charsafteryear=$(echo $charsafteryear | sed -E 's/(\[.*)\.(.*\])/\1_\2/g')
    charsafteryear=$(echo $charsafteryear | tr -d "()[]")
    charsafteryear=$(echo $charsafteryear | sed 's/\./-/g')            # replace all dots with dash
    charsafteryear=$(echo $charsafteryear | sed -E 's/-(.{3})$/\.\1/') # except keep last file extention dot
    echo $charsbeforeyear$charsafteryear
}

function file_rename_all() {
    for f in *; do
        local rename=$(file_rename $f)
        if [ -z "$rename" ]; then
            echo "ERROR: file $f, has no parentheses"
        elif [ -n "$forreal" ]; then
            # echo $f
            echo "mv $f $rename"
        else
            echo $rename
        fi
    done
}

function display_notif() {
    if [ `uname` = "Darwin" ]; then
        osascript -e 'display notification "hi!" with title "my title" subtitle "a subtitle"'
    else  # really for ubuntu
        notify-send -i face-wink "a title" "hi!"
    fi
}

# filter for dubydir, color by order of magnitude (Byte/Kibibyte/Mibibyte/Gibibyte)
# TODO: du buffers, doing `stdbuf -o 0 -e 0 du -sh * | grep` still buffers :(
function dubydircolor() {
    dubydir | \
    while read line; do
        local size=$(echo "$line" | awk '{print $1}' | grep --colour=never -o ".$")
        case "$size" in
            B) echo "$(fg=8 ansi256 "$line")" ;;
            K) echo "$(fg=28 ansi256 "$line")" ;;
            M) echo "$(fg=208 ansi256 "$line")" ;;
            G) echo "$(bg=1 fg=3 ansi256 "$line")" ;;
        esac
    done
}

####################### ANSI COLORS ###################
# colorize every 3rd line lighter background (assuming black background) to help readability
function colr_row() {
    while read line; do
      bg=237 ansi256 "$line"; read line; echo "$line"; read line; echo "$line"
    done
}

# pass noreset=1 and empty/no string to format external string
# TODO: validate fg and bg values, after ansi8 translation values must be numbers 1-250
function ansi256() {
    local maybereset="\033[0m"; [ -n "$noreset" ] && maybereset=""
    local lstrike="";           [ -n "$strike" ] && lstrike="\033[9m"
    local lbld="";              [ -n "$bld" ] && lbld="\033[1m"
    local lund="";              [ -n "$und" ] && lund="\033[4m"
    local lit="";               [ -n "$it" ] && lit="\033[3m"
    local lbg=016;              [ -n "$bg" ] && lbg=$(ansi8_name $bg)
    local lfg=007;              [ -n "$fg" ] && lfg=$(ansi8_name $fg)
    echo -e "${lbld}${lstrike}${lund}${lit}\033[48;5;${lbg};38;5;${lfg}m${1}${maybereset}"
}

function print_ansi256() {
    iter=16
    while [ $iter -lt 52 ]
    do
        second=$[$iter+36]; third=$[$second+36]; four=$[$third+36]
        five=$[$four+36];   six=$[$five+36];     seven=$[$six+36]

        if [ $seven -gt 250 ];then seven=$[$seven-251]; fi

        echo -en "\033[38;5;${iter}m█ ";        printf "%03d" $iter
        echo -en "   \033[38;5;${second}m█ ";   printf "%03d" $second
        echo -en "   \033[38;5;${third}m█ ";    printf "%03d" $third
        echo -en "   \033[38;5;${four}m█ ";     printf "%03d" $four
        echo -en "   \033[38;5;${five}m█ ";     printf "%03d" $five
        echo -en "   \033[38;5;${six}m█ ";      printf "%03d" $six
        echo -en "   \033[38;5;${seven}m█ ";    printf "%03d" $seven

        iter=$[$iter+1]
        printf '\r\n'
    done
}

function ansi8_name() {
    case "$1" in
        red) echo 1 ;; brightred) echo 9 ;;
        green) echo 2 ;; brightgreen) echo 10 ;;
        yellow) echo 3 ;; brightyellow) echo 11 ;;
        blue) echo 4 ;; brightblue) echo 12 ;;
        magenta) echo 5 ;; brightmagenta) echo 13 ;;
        cyan) echo 6 ;; brightcyan) echo 14 ;;
        white) echo 7 ;; brightwhite) echo 15 ;;
        black) echo 8 ;; brightblack) echo 16 ;;   # should really call it dark black, it's 100% black
        *) echo $1 ;;
    esac
}
#############################################################################

# TODO: finish this
# TODO: benchmark: 1) momoization and grep 2) dont memoize
# hyperfine aliases: https://github.com/sharkdp/hyperfine/issues/270
function sensor_data() {
    # needed for newlines: https://unix.stackexchange.com/questions/164508/why-do-newline-characters-get-lost-when-using-command-substitution
    local IFS=
    local s=$(sensors)
    echo $s | grep -E "CPU Temperature" | awk '{print $3;}' | grep -oEi '[0-9]+.[0-9]+'
    echo $s | grep -E "CPU Fan"
}

# https://n0tablog.wordpress.com/2009/02/09/controlling-vlc-via-rc-remote-control-interface-using-a-unix-domain-socket-and-no-programming/
# seek 100" - goto 100sec after start, "get_time" - current position in seconds since start
# "volume 250" - 250 is 100%, "volume" - return current volume, "volup 10"/"voldown 10" - up/down volume 10 steps
# "info" - codecs/frame-rate/resolution, "stats" - some metrics on data encoded/decoded
# ~/Library/Preferences/org.videolan.vlc/vlcrc contains the perferences config state, including where unix sock is located
# osx: bin to start vlc: /Applications/VLC.app/Contents/MacOS/VLC
function vlc_cli() {
    # [ "$(uname)" = "Darwin" -a $1 = "launch" ] && /Applications/VLC.app/Contents/MacOS/VLC
    local vlc_socks_loc=~/vlc.sock
    [ ! -S "$vlc_socks_loc" ] && echo "vlc socks file at $vlc_socks_loc not found!" && return 1
    echo $1 | nc -U $vlc_socks_loc
}

# TODO: oftentimes do nothing, peeps rec brew brightness tool
function osx_inc_brightness() { osascript -e 'tell application "System Events"' -e 'key code 144' -e ' end tell'; }
function osx_dec_brightness() { osascript -e 'tell application "System Events"' -e 'key code 145' -e ' end tell'; }

function osx_activate_slack() { osascript -e 'tell application "Slack" to activate'; }

function osx_mute() { osascript -e "set Volume 0"; }
function osx_set_volume() { osascript -e "set Volume $1"; }   # 0 mute, 10 max
function osx_get_volume() { osascript -e 'get volume settings'; }

function osx_spotify_dec_volume() {
    osascript -e 'tell application "Spotify"' -e 'set sound volume to (sound volume - 10)' -e 'end tell'
}

function osx_spotify_inc_volume() {
    osascript -e \
        'tell application "Spotify"
            if sound volume is less than 50 then
                set sound volume to (sound volume + 10)
            end if
        end tell'
}

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
    [ ! "$(uname)" = "Darwin" ] && >&2 echo "RLY-ERROR: chrome_json_summary needs applescript, only Darwin os" && return 1
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

################################################################################
#############                  TMUX                   ##########################
################################################################################

# set first line of tmux status for multi-line mode
function tmux_main_status() {
    #  https://stackoverflow.com/questions/35016458/how-to-write-if-statement-in-tmux-conf-to-set-different-options-for-different-t
    # 'tmux setenv -g TMUX_VERSION $(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
    ver=$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")  # need tmux 2.9 to set multi-line statuses

    local tmux_mouse_mode="#[fg=brightyellow]#[bg=red]#{?mouse,MOUSEON,}#[default]"
    local tmux_sync_panes="#[fg=brightyellow]#[bg=red]#{?synchronize-panes,SYNCPANEON,}#[default]"
    local tmux_wind_bg_jobs="#[fg=brightyellow]#[bg=red]#(~/rams_dot_files/scripts/tmux_bg_jobs.sh)#[default]"
    local tmux_ssh_jmp="#[fg=brightyellow]#[bg=red]#(~/code/rams_dot_files/scripts/tmux_ssh_listen.sh)#[default]"
    local tmux_mounted_drive="#[fg=brightyellow]#[bg=red]#(~/rams_dot_files/scripts/mounted_drives.sh)#[default]"
    local tmux_wifi_ssid="#[fg=brightyellow]#[bg=red]#(~/rams_dot_files/scripts/check_wifi.sh)#[default]"
    local tmux_vpn_on="#[fg=brightyellow]#[bg=red]#(~/rams_dot_files/scripts/vpn_connected.sh)#[default]"

    local tmux_spotify="#[fg=colour208]#(osascript ~/rams_dot_files/scripts/spotify_song.scpt)"
    local tmux_host_datetime="#[fg=brightyellow]#{host} #[fg=brightwhite]%Y-%m-%d #[fg=brightwhite]%H:%M"

    local left="#[fg=cyan]#S ${tmux_mouse_mode} ${tmux_sync_panes} ${tmux_wind_bg_jobs}\
 ${tmux_ssh_jmp} ${tmux_mounted_drive} ${tmux_wifi_ssid} ${tmux_vpn_on} "
    local right="#[align=right]${tmux_spotify}   ${tmux_host_datetime}"
    if [ -n "$simple" ]; then
        left="#[fg=cyan]#S ${tmux_mouse_mode} ${tmux_sync_panes}"
        right="#[align=right]  ${tmux_host_datetime}"
    fi

    # "#(~/rams_dot_files/tmux_status_bar.sh 2>&1)"
    local cmd="tmux"
    [ $(detect_shell) = "zsh" ] && cmd="noglob tmux" # for zsh '[]' globbing

    eval "$cmd set status-format[0] \"#(~/rams_dot_files/tmux_status_bar.sh 2>&1)"\
    "#[align=left]$left #[align=centre]$(tmux_default_winlist) #[align=right]$right\""
    #eval "$cmd set status-format[1] \"#(source ~/rams_dot_files/shell_functions.sh; tmux_test_data)\""
}

function tmux_default_winlist() {
    echo "#[norange default]#[list=on]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index}
        #{window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}},
        #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}},
        #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},
        #{!=:#{window-status-activity-style},default}},
        #{window-status-activity-style},}}]#{T:window-status-format}#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus
        #{?#{!=:#{window-status-current-style},default},#{window-status-current-style},#{window-status-style}}
        #{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}},#{window-status-last-style},}
        #{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}},#{window-status-bell-style},
        #{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}},
        #{window-status-activity-style},}}]#{T:window-status-current-format}#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}#[nolist]"
    # need #[nolist] at the end here to let next items align
}

alias tms='tmux_status'
function tmux_status() {
    ver=$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")  # need tmux 2.9 to set multi-line statuses
    [ $(echo "$ver < 2.9" | bc) -eq 1 ] && echo "$(tput setaf 1)multi-line status unsupported in version $ver!"
    [ "$1" = "off" ] && tmux_status_reset
    if [ "$1" = "on" ]; then
        tmux set status-interval 5
        tmux set status 2
        tmux_main_status        # set first line, which runs the master script
    fi
}

function tmux_status_reset() {
    tmux set -u status-format[0]
    tmux set -u status
    tmux set -u status-interval
    tmux set -u status-left; tmux set -u status-right
    tmux set -u status-format
}

# TODO: faster way to store data for status bar
# hyperfine 'grep --color=never foo bar | grep --color=never -Eo "[^:]*$"'
    # e.g. a foo file, each line has key value with ":" delim, e.g. "barkey:value" => has runs in 3ms
# the `tmux set -q` runs in 9ms
function tmux_status_set_num_cpu() { tmux set -q "@tmux-status-num-cpu" $(sysctl -n hw.ncpu); }

function top_cpu_processes() {
    if [ `uname` = "Darwin" ]; then
        # ps -Ao user,uid,command,pid,pcpu,tty -r | head -n 6   # -r sorts by cpu usage
        ps -Ao pcpu,user,command -r | head -n 6   # do command last so it string doesnt get truncated
        # TODO: parsing, if /Applications in string then get app name after /
    fi
}

# NOTE: with uptime based usage, can go >100%
function cpu_usage() {
    # uptime always uses d.dd format, so remove '.' will result in x100 integer

    local numcpu=$(sysctl -n hw.ncpu)  #osx
    local minave=$(uptime | grep --color=never -Eo ":\s[0-9]{1,2}\.[0-9]*" | cut -c 3- | tr -d .) #1min ave
    # local fifteenminave=$(uptime | grep --color=never -o "[0-9]{1,2}\.[0-9]*$" | tr -d .) #15min ave

    # TODO: need to cut space at end of line
    # local fiveminave=$(uptime | grep --color=never -o "[0-9]\s[0-9]\.[0-9]*\s" | cut -c 3- | tr -d .)

    local minavepercent=$(($minave / $numcpu))
    echo $minavepercent
}

function tmux_percent_usage_color() {
    # TODO: disabling for uptime based cpu usage, this can def go above 100%
    # verify_percent $1 "cpu percent usage" || return 1
    [ $1 -gt 95 ] && echo "#[bg=colour124,fg=colour231] $1 #[default]" && return 0
    [ $1 -gt 80 ] && echo "#[fg=colour198] $1%#[default]%%" && return 0
    [ $1 -gt 40 ] && echo "#[fg=colour208] $1%#[default]%%" && return 0
    [ $1 -gt 10 ] && echo "#[fg=colour190] $1%#[default]%%" && return 0
    echo "#[fg=colour083] $1 #[default]"
    # echo "$(fg=083 ansi256 "! $1 !")"
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

# ubuntu and osx uptime have diff format ofcourse
# $1 - timer name, $2 - percent (e.g. 50), $3 - bar width in chars
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

# NOTE: default tmux status script shell is sh(3.2)
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

    # NOTE: quotes needed to preserve spaces, otherwise sh/bash will interpret as args and compress
    echo "$progbar"
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

function getbranchname() { git branch | grep "*" | awk '{print $2}'; }

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
