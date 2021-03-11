# shell functions

# TODO: dash doesnt like something in shell_function.sh (nov11 2020)
#TODO: get method 2/3 or all of them working
#FIXME; ubuntu dash wont have either defined
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
        # LINUX: $(ps -p $$ -o cmd=)
        # OSX: $(ps -p $$ -o command=) # i will get "-zsh" so need to remove "-" char
    # METHOD 3: echo $SHELL (when i start bourne(sh) from a zsh in osx, it's still zsh
}

# return 0 if all are defined, spit out error with exit 1 if one is not
function cmds_defined() {
    caller_msg=""; [ -n "$caller" ] && caller_msg="caller: $caller -- "
    for cmd in "$@"; do
        command -v $cmd > /dev/null || { echo >&2 "${caller_msg}${cmd} not defined!" && return 1; }
    done
}

function require_vars() {
    caller_msg=""; [ -n "$caller" ] && caller_msg="caller: $caller -- "
    local vars_required=0
    for arg in "$@"; do
        local var_value=$(eval "echo \$${arg}")

        if [ -z "$var_value" ]; then
            vars_required=1
            [ -z "$quiet" ] && \
                echo "${caller_msg}RLY-ERROR: Variable "$(ansi256 -f yellow "$arg")" is required!" >&2
        fi
    done
    [ "$vars_required" = "1" ] && return 1
    return 0
}

# TODO: /bin/sh in osx does not like the printf's
function debug_vars() {
    local spacing="\n"; [ -n "$tab" ] && spacing=";    "

    if [ -n "$caller" ]; then
        echo $(ansi256 -f cyan "Calling func/script: ")$(ansi256 -f cyan -e "$caller") >&2
    fi
    for arg in "$@"; do
        local var_value=$(eval "echo \$${arg}")

        local msg=$(ansi256 -u "DEBUG:")" Variable "$(ansi256 -f yellow "$arg")
        if [ -z "$var_value" ]; then
            local msg2=$(ansi256 -f brightred " is undefined or null!")"${spacing}"
            printf "$msg$msg2" >&2
        else
            local msg2=" = "$(ansi256 -f brightgreen $var_value)"${spacing}"
            printf "$msg$msg2" >&2
        fi
    done
    [ -n "$tab" ] && echo
}

# given port number return if grep of if ssh is listening on it
# polipo used to create HTTP proxy to a SOCKS proxy (scab does this, and authn e2e tests too)
function find_listening_ports() {
    local process_type=ssh; [ -n "$polipo" ] && process_type=polipo
    ports="$(lsof -nP -iTCP -sTCP:LISTEN)"
    # space occurs after last digit, so match full number (e.g. otherwise 313 matches on 3131)
    echo "$ports" | grep "$1 " > /dev/null | grep $process_type > /dev/null
}

# FIXME: osx/sh(detect_shell says bash) doesnt print "alias " prefix for alias names
# bash, print_type says aliases are undefined
function print_alias_funcs_scripts() {
    # calling $(list_funcs) in cmd substitution removes new lines, and IFS= trick gives me "cmd too long" error
    if [ $(detect_shell) = "zsh" ]; then
        local func_cmd="functions"; [ -n "$funcname" ]  && func_cmd='print -l ${(ok)functions}'
        local alias_cmd="alias"; [ -n "$aliasname" ]  && alias_cmd='alias | cut -d= -f1'
        local executables=$(hash | cut -d= -f1)
        { eval $alias_cmd; eval $func_cmd; echo "$executables"; } | grep "$1"
    else # Assuming BASH
        # NOTE: set prints much more than defined functions, like env vars
        local func_cmd="set"; [ -n "$funcname" ]  && func_cmd="typeset -F | awk '{print \$3;}'"
        local alias_cmd="alias | cut -c 7-"; [ -n "$aliasname" ]  && alias_cmd='alias | cut -d= -f1 | cut -c 7-'
        local executables=$(compgen -c)
        { eval $alias_cmd; eval $func_cmd; echo "$executables"; } | grep "$1"
    fi
}

function rrc() {
    if [ $(detect_shell) = "zsh" ]; then
        source ~/.zprofile && source ~/.zshrc
    else  # Assumes BASH
        source ~/.bash_profile && source ~/.bashrc
    fi
}

# introspect if command is alias or function or script
function print_type() {
    local type="function"
    command -v "$1" | grep "^\/" > /dev/null && type=executable
    command -v "$1" | grep "^alias " > /dev/null && type=alias
    command -v "$1" > /dev/null || type=undefined
    # handle special case when executable is in current dir, command -v wont work
    [ -x "$1" ] && type=executable
    echo $type
}

alias bw='batwhich'
function batwhich() {
    local type=$(print_type "$1")
    case "$type" in
        function|alias)
            local defcmd=type; [ "$(detect_shell)" = "zsh" ] && defcmd="whence -f"
            eval $defcmd "$1" | bat --color=always -l sh ;;
        executable)
            local fullpath="command -v"; [ "$(detect_shell)" = "zsh" ] && fullpath="whence -c"
            bat --color=always "$(eval $fullpath "$1")" ;;
        *) echo "print_type returned $type for "$1", unhandled by $0!" ;;
    esac
}

function binlink() {
    # local fullpathcmd="command -v"; [ "$(detect_shell)" = "zsh" ] && fullpathcmd="whence -c"
    local fullpathcmd=realpath
    command -v "$1" > /dev/null || { echo "$1 invalid file"; return 1; }
    local fullpath=$(eval $fullpathcmd "$1")
    ln -s "$fullpath" ~/bin/$(basename "$1")
}

function vil() { vi -p $(cat $1); }
function viln() { vin -p $(cat $1); }

function fdisk_find() {
    [ -z "$1" ] && echo "arg for diskname needed!" && return 1
    [ $(uname) = "Linux" ] || { echo "only works on linux" && return 1; }
    local disks=$(sudo fdisk -l)
    local device=$(echo "$disks" | grep -B1 "$1" | grep -v "$1")
    echo $device | awk '{print $2}' | sed 's/.$//'
}

############# FZF ##############################

# fuzzy move many files to dest dir, handles spaces in paths and git moves, tested with zsh and bash
# NOTE: zsh give "bad math expression" on first for loop, bash works; when i rebooted it works, maybe shell opt?
# TODO: should i use arrays?, maybe just a string with IFS
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

# FIXME: aliases fail to preview in ubuntu/bash
    # fzf --preview "alias foo='echo hi'; foo"  ---- FAILS, WHY????
# fuzzy search aliases and functions, with previews for some sources
function fsn() {
    : "${fzf_pafn_preview_sources:="source ~/rams_dot_files/shell_functions.sh"}"
    aliasname=1 funcname=1 print_alias_funcs_scripts | fzf --preview "$fzf_pafn_preview_sources; batwhich {}" \
        --header='ctrl-y->pbcopy' \
        --bind 'ctrl-y:execute-silent(echo {} | pbcopy)+abort' \
        --preview-window=:wrap --preview-window right:70%
}

# TODO: reload of `ps -ef` fails but `ps` works
function fk() {
  FZF_DEFAULT_COMMAND='ps -ef' \
  fzf --bind 'ctrl-r:reload($FZF_DEFAULT_COMMAND)' \
      --header 'Press CTRL-R to reload' --header-lines=1 \
      --height=50% --layout=reverse
}

# like cd **, but with tree preview
function fcd() {
    cd $(fd --type d --hidden --exclude .git '.*' $1 | fzf --preview "tree -C {} | head -40")
}

function ffgt() {  # ff(fuzzy)g(git)t(tag)
    git rev-parse HEAD > /dev/null 2>&1 || { echo "not git repo" && return 1; }
    git tag --sort -version:refname | fzf --multi --preview-window right:80% \
        --preview 'git show --color=always {} | head -'$LINES
}

# TODO: add binding to checkout a branch
function ffgb() {
    git rev-parse HEAD > /dev/null 2>&1 || { echo "not git repo" && return 1; }
    local ht="100%"; [ -n "$half" ] && ht="50%"

    git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf --height $ht --border --ansi --multi --tac --preview-window right:70% \
        --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES  |
    sed 's/^..//' | cut -d' ' -f1 | sed 's#^remotes/##'
}

function ffgset() {
    [ ! "$(uname)" = "Linux" ] && { echo "gnome is for linux" && return 1; }
    local schema=$(gsettings list-schemas | fzf +m)
    gsettings list-recursively "$schema"
}

function ffgs() {
    git rev-parse HEAD > /dev/null 2>&1 || { echo "not git repo" && return 1; }
    git -c color.status=always status --short |
    fzf --height 50% --border -m --ansi --nth 2..,.. \
        --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
    cut -c4- | sed 's/.* -> //'
}

# TODO: add fzf --expect and optionally edit file if expect given
# TODO: add preview for more context
function frgp() {  # frg p(phony)
    INITIAL_QUERY=""
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
        fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --ansi --phony --query "$INITIAL_QUERY" \
        --height=50% --layout=reverse
}

# ripgrep and fzf+preview, preserving rg match color in preview (by using rg for preview too)
# NOTE: -e needed in case of empty RG_FITLER string, rg thinks empty string is pattern query
# TODO: add fzf --expect and optionally edit file if expect given
function frg() {
    [ ! "$#" -gt 0 ] && echo "Need a string to search for!" && return 1
    local rgdir=$RG_DIR; [ -z $rgdir ] && rgdir="."
    local rgheight=$RG_H; [ -z $rgheight ] && rgheight="50"

    local prev="rg $RG_FILTER --pretty --context 10 -e '$1' {}"
    local cmd="rg $RG_FILTER --files-with-matches --no-messages -e "$1" $rgdir |
        fzf --exit-0 --preview "eval $prev" \
        --height ${rgheight}% --header='ctrl-e->vim, ctrl-y->pbcopy, ctrl-space->cd' \
        --bind 'ctrl-y:execute-silent(echo {} | pbcopy)+abort' --expect='ctrl-e,ctrl-space'"
    local out=$(eval "$cmd")


    # rg -tscala -g '!it/' -g '!test/' --files-with-matches --no-messages "$1" | fzf --preview \
    # local out=$(rg $RG_FILTER --files-with-matches --no-messages -e "$1" $rgdir |
    #     fzf --exit-0 --preview "rg $RG_FILTER --pretty --context 10 -e '$1' {}" \
    #     --height ${rgheight}% --header='ctrl-e->vim, ctrl-y->pbcopy, ctrl-space->cd' \
    #     --bind 'ctrl-y:execute-silent(echo {} | pbcopy)+abort' --expect='ctrl-e,ctrl-space')
        # fzf --preview "rg --ignore-case --pretty --context 10 -e '$1' {}"
        # "rg -tscala -g '!it/' -g '!test/' --ignore-case --pretty --context 10 '$1' {}" --height ${rgheight}%


    key=$(echo "$out" | head -1)
    file=$(echo "$out" | tail -n+2)
    if [ -n "$file" -a $(echo "$file" | wc -l) -eq 1 -a "$key" = "ctrl-space" ]; then
        cd "$(dirname "$file")"
    elif [ -n "$file" -a "$key" = "ctrl-e" ]; then
        eval "${EDITOR:-vin} -p "$file""
    else
        echo "$file"
    fi
}

#TODO: fix, "unrecognized file type: scala -g '!it/' -g '!test/'", rgfst works fine
function rgfs() { RG_FILTER="-tscala -g '!it/' -g '!test/'" frg $1; }
function rgfst() { RG_FILTER="-tscala" frg $1; }

function fapt() {  # fuzzy apt
    local opts="--installed"; [ "$1" = "s" ] && unset opts
    apt list $opts | tail -n+2 | f --preview 'apt show $(awk "{print  $1}" <<< {} | cut -d "," -f1)'
}

function fsmd() { systemctl | fzf; }

# actual regex on full path, e.g. ".*go$" (any # of chars, ending literal go)
function findgrepp() { find . -type f -regex $1 -exec grep $2 ; }
# last component of pathname, pattern not regex, e.g. ("*go")
function findgrep() { find . -type f -name $1 -exec grep $2 ; }

# needs psx alias
function psxg() { psx | grep $1 | grep -v grep; }

# go docs with syntax highlighting!
function batgod() { go doc $@ | bat -l go; }

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

function find_mult_hardlink() {
    # using find(linux):       find . -links +1 -type f -name '*' -printf '%i %p\n' | sort
    [ -d "$1" ] || { echo "$1 not a directory!" && return 1; }
    if [ "$(uname)" = "Darwin" ]; then
        fd . -t f "$1" -x sh -c 'num=$(stat -f %l "{}"); (( "$num" > 1 )) && stat -f "%i %N" "{}" ' | sort -V
    else
        fd . -t f "$1" -x bash -c 'num=$(stat -c %h "{}"); (( "$num" > 1 )) && stat -c "%i %n" "{}" ' | sort -V
    fi
}

function yts_query() {
    http -do /tmp/yts_query https://yts.mx/ajax/search query=="$1"
    jq . /tmp/yts_query
}

function display_notif() {
    [ -z "$1" ] && echo "no message given!" && return 1
    if [ $(uname) = "Darwin" ]; then
        # osascript -e 'display notification "hi!" with title "my title" subtitle "a subtitle"'
        local script="display notification \"$1\""
        local title=${2:-notification}
        script=$script" with title \"$title\""
        osascript -e "$script"
    else  # really for ubuntu
        local title=${2:-notitle}
        notify-send -i face-wink "$title" "$1"
    fi
}

# filter for dubydir, color by order of magnitude (Byte/Kibibyte/Mibibyte/Gibibyte)
# TODO: du buffers, doing $(stdbuf -o 0 -e 0 du -sh * | grep) still buffers :(
function dubydircolor() {
    dubydir | \
    while read line; do
        local size=$(echo "$line" | awk '{print $1}' | grep --colour=never -o ".$")
        case "$size" in
            B) ansi256 -f 8 "$line" ;;
            K) ansi256 -f 28 "$line" ;;
            M) ansi256 -f 208 "$line" ;;
            G) ansi256 -f 3 -b 1 "$line" ;;
        esac
    done
}

####################### ANSI COLORS ###################
# colorize every 3rd line lighter background (assuming black background) to help readability
function colr_row() {
    while read line; do
        if [ -z "$bold" ]; then
            ansi256 -b 237 "$line"; read line; echo "$line"; read line; echo "$line"
        else
            ansi256 -n "$line"; read line; echo "$line"; read line; echo "$line"
        fi
    done
}

#############################################################################

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

function toggle_bulb() {
    python3 -c 'import sys; import magichue; print(sys.argv[1]); l = magichue.Light(sys.argv[1]); \
        l.on = False if l.on else True
        ' $1
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

function chrome_save_state() { echo $(chrome-json-summary) > ~/Documents/chrome_tabs_backup.json; }
function chrome_restore() { chrome-json-restore ~/Documents/chrome_tabs_backup.json; }


#####################  SYSTEM DATA/HEALTH ####################################################

# TODO: finish this
# TODO: benchmark: 1) momoization and grep 2) dont memoize
# hyperfine aliases: https://github.com/sharkdp/hyperfine/issues/270
function sensor_data() {
    [ ! "$(uname)" = "Linux" ] && { echo "this is for linux sensors" && return 1; }

    local s=$(sensors)
    echo "$s" | grep -E "CPU Temperature" | awk '{print $3;}' # | grep --color=never -Eoi '[0-9]+.[0-9]+'
    echo "$s" | grep -E "CPU Fan"
}

function top_cpu_processes() {
    if [ $(uname) = "Darwin" ]; then
        # ps -Ao user,uid,command,pid,pcpu,tty -r | head -n 6   # -r sorts by cpu usage
        ps -Ao pcpu,user,command -r | head -n 6   # do command last so it string doesnt get truncated
        # TODO: parsing, if /Applications in string then get app name after /
    fi
}

function cpu_util() {
    # top -l 2 | grep -E "^CPU"  # very slow relatively speaking (-l doesnt work in linux)
    ps -A -o %cpu | awk '{s+=$1} END {print s "%"}'
}

# expects raw input from `sensors` command
function linux_cpu_temp() {
    sensor_data=$1
    cputemp=$(echo "$sensor_data" | grep -E "CPU Temperature" | awk '{print $3;}')
    echo $cputemp | sed 's/+//g' | grep --color=never -Eo '^[0-9]+'
}

# NOTE: hyperfine says nvidia-smi takes ~40ms, so refresh less frequent
function linux_nvidia() {
    cmds_defined nvidia-smi || return 1
    nvid=$(nvidia-smi)
    echo "$nvid" | sed -n '10p'   # the 10th line has most of the info we want
}
################################################################################
#############                  TMUX                   ##########################
################################################################################

alias tms='tmux-status'
function tmux_status_set_num_cpu() { tmux set -q "@tmux-status-num-cpu" $(sysctl -n hw.ncpu); }

# assuming celcius
function tmux_temp_color() {
    [ $1 -gt 80 ] && echo "#[bg=colour124,fg=colour231] $1 #[default]" && return 0
    [ $1 -gt 65 ] && echo "#[fg=colour198]$1#[default]" && return 0
    [ $1 -gt 55 ] && echo "#[fg=colour208]$1#[default]" && return 0
    [ $1 -gt 45 ] && echo "#[fg=colour190]$1#[default]" && return 0
    echo "#[fg=colour083]$1#[default]"
}

function tmux_percent_usage_color() {
    [ -z "$skip_verify" ] && { verify_percent $1 "$2" || return 1; }

    [ $1 -gt 95 ] && echo "#[bg=colour124,fg=colour231] $1 #[default]%%" && return 0
    [ $1 -gt 80 ] && echo "#[fg=colour198] $1#[default]%%" && return 0
    [ $1 -gt 40 ] && echo "#[fg=colour208] $1#[default]%%" && return 0
    [ $1 -gt 10 ] && echo "#[fg=colour190] $1#[default]%%" && return 0
    echo "#[fg=colour083] $1#[default]%%"
}

function verify_percent() {
    if [ -z $(echo $1 | grep -E "^[[:digit:]]*$") ]; then
        echo "$(tput setaf 1) val: $2: must be a positive integer!" && return 1
    fi
    [ $1 -lt 0 -o $1 -gt 100 ] && echo "$(tput setaf 1)val $2: must be between 0 and 100!" && return 1
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

function tmux_open_pane() {
    # for pane in $(tmux list-panes -F "#{pane_id};#{pane_pid}"); do  # works if no IFS splitting is on
    local panes=$(tmux list-panes -F "#{pane_id};#{pane_pid}")
    for pane in $panes; do
        local pane_id=$(echo $pane | cut -d ';' -f 1)
        local pane_pid=$(echo $pane | cut -d ';' -f 2)
        # echo $pane_id; echo $pane_pid
        pgrep -P $pane_pid > /dev/null || { echo $pane_id && return; } # if pane has no child processes return it
    done
    echo "NO-OPEN-PANES" && return 1
}

function tmux_run_in_pane() {
    local open_pane=$(tmux_open_pane)
    echo $open_pane | grep "NO-OPEN" && echo "No open panes" && return 1
    tmux send-keys -t $open_pane $1 Enter
}

######### GIT ####################
function gitfetchresetbranch() {
    local curbranch=$(getbranchname)
    git fetch -a || { echo "failed to fetch from remotes!" && return 1; }
    git reset --hard origin/$curbranch
}

function gitrebasemaster() {
    local curbranch=$(getbranchname); [ "$curbranch" = "master" ] && echo "on master" && return 1
    git fetch -a || { echo "failed to fetch from remotes!" && return 1; }
    git checkout master
    git pull
    git checkout $curbranch
    git rebase master
}

# delete branches that are already merged into another branch, master by default, delete locally and in remote
function gitclean() {
    local masterb=${1:-master}

    # FIXME: this line is creating a branch named "--merged"
    git branch –-merged $masterb | grep -v $masterb | cut -d/ -f2- | xargs -n 1 git push –delete origin

    git branch –-merged $masterb | grep -v $masterb | xargs -n 1 git branch -d
}

function getbranchname() { git branch | grep "*" | awk '{print $2}'; }

#####  DB  ############
function terminate_db_connections() {
    psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${1}' AND pid <> pg_backend_pid()" -d postgres
}

function ruby_base64_dec() { ruby -e 'require "base64"; puts Base64.decode64(ARGV[0])' "$@"; }

function ryamltojson() {
    ruby -e 'require "yaml"; require "json"; puts YAML.load_file(ARGV[0]).to_json' "$@"
}

function parse_comma_delim_error() {
    local str="File.write(\"${1}\", File.read(\"${1}\").split(',').join(\"\\n\"))"
    ruby -e "$str"
}

###### OTHER ###############

function weather() { http --print=b wttr.in/$1; }

# TODO: use next time ubuntu seemingly loses delay when i plug keyboard back in
function gsettings_set_keyboard() {
    [ "$(uname)" != "Linux" ] && echo "not linux" && return 1
    # gsettings set org.gnome.desktop.peripherals.keyboard repeat true
    gsettings set org.gnome.desktop.peripherals.keyboard delay 217
    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
    # gsettings set org.gnome.desktop.peripherals.keyboard remember-numlock-state true
    # gsettings set org.gnome.desktop.peripherals.keyboard numlock-state false
}


function f_findfilesbysize() { sudo find "$1" -type f -size +"$2" | xargs du -sh; }

function tabname { printf "\e]1;$1\a"; }
function winname { printf "\e]2;$1\a"; }

function fullpath() {
    ruby -e '
        $stdin.each_line { |path| puts File.expand_path path }  if ARGV.empty?
        ARGV.each { |path| puts File.expand_path path }         unless ARGV.empty?
    ' "$@"
}

# NOTE: can do PlugSnapshot in vim also
function vim_plug_ver() {
    pushd ~/.vim/plugged > /dev/null
    for dir in */; do
         pushd $dir > /dev/null
         echo "${dir}: $(git rev-parse HEAD)"
         popd > /dev/null
     done
     popd > /dev/null
}
