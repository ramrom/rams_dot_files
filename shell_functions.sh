# shell functions

# TODO: dash doesnt like something in shell_function.sh (nov11 2020)
# TODO: get method 2/3 or all of them working
# FIXME; ubuntu dash wont have either defined
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

# function wrapper for ff script, if fzf output starts with "cd " then cd to dir, scripts cant change parent process working dir
function ff() {
    local result=$(~/bin/ff -w "$@")
    [ "$(echo "$result" | awk '{print $1}')" == "cd" ] && eval "$result" && return
    echo "$result" | grep -E '^vi|^nvi' > /dev/null && eval "$result" && return
    echo $result
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

# FIXME: aliases fail to preview in ubuntu/bash
    # fzf --preview "alias foo='echo hi'; foo"  ---- FAILS, WHY????
# fuzzy search aliases and functions, with previews for some sources
# FIXME: aliases and funcs are double printing in bash
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

function ffgs() {
    git rev-parse HEAD > /dev/null 2>&1 || { echo "not git repo" && return 1; }
    git -c color.status=always status --short |
    fzf --height 50% --border -m --ansi --nth 2..,.. \
        --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
    cut -c4- | sed 's/.* -> //'
}

# fzf query is the rg pattern to filter on, this is what the Rg comamnd in vim#fzf plugin does
# TODO: add fzf --expect and optionally edit file if expect given
# TODO: add preview for more context
function frgd() {  # frg p(phony)
    INITIAL_QUERY=""
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
        fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --ansi --phony --query "$INITIAL_QUERY" \
        --height=50% --layout=reverse
}

function ffgset() {
    [ ! "$(uname)" = "Linux" ] && { echo "gnome is for linux" && return 1; }
    local schema=$(gsettings list-schemas | fzf +m)
    gsettings list-recursively "$schema"
}

# actual regex on full path, e.g. ".*go$" (any # of chars, ending literal go)
function findgrepp() { find . -type f -regex $1 -exec grep $2 ; }
# last component of pathname, pattern not regex, e.g. ("*go")
function findgrep() { find . -type f -name $1 -exec grep $2 ; }

# needs psx alias
function psxg() { psx | grep $1 | grep -v grep; }

# go docs with syntax highlighting!
function batgod() { go doc $@ | bat -l go; }

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
    # echo $cputemp | sed 's/+//g' | grep --color=never -Eo '^[0-9]+'
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

################################################################################
#############                  TMUX                   ##########################
################################################################################

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

function gitrebaserelbranch() {
    rel_branch=master
    git branch --no-color | grep "main" > /dev/null && rel_branch=main
    local curbranch=$(getbranchname); [ "$curbranch" = "$rel_branch" ] && echo "on $rel_branch" && return 1
    git fetch -a || { echo "failed to fetch from remotes!" && return 1; }
    git checkout "$rel_branch"
    git pull
    git checkout "$curbranch"
    git rebase "$rel_branch"
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
    gsettings set org.gnome.desktop.peripherals.keyboard repeat true
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
