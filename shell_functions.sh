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

# given port number return if ssh(or polipo) is listening on it
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
    else # Assuming BASH
        # NOTE: set prints much more than defined functions, like env vars
        local func_cmd="set"; [ -n "$funcname" ]  && func_cmd="typeset -F | awk '{print \$3;}'"
        local alias_cmd="alias | cut -c 7-"; [ -n "$aliasname" ]  && alias_cmd='alias | cut -d= -f1 | cut -c 7-'
        local executables=$(compgen -c)
    fi
    { eval $alias_cmd; eval $func_cmd; echo "$executables"; } | grep "$1"
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
    BATBIN="bat"; [ $(uname) = "Linux" ] && BATBIN='batcat'
    case "$type" in
        function|alias)
            local defcmd=type; [ "$(detect_shell)" = "zsh" ] && defcmd="whence -f"
            eval $defcmd "$1" | $BATBIN --color=always -l sh ;;
        executable)
            local fullpath="command -v"; [ "$(detect_shell)" = "zsh" ] && fullpath="whence -c"
            $BATBIN --color=always "$(eval $fullpath "$1")" ;;
        *) echo "print_type returned $type for "$1", unhandled by $0!" ;;
    esac
}

# take a json array of 2-item arrays and column align print it, use '#' as delimiter
# NOTE: using `#` char to delimit fields in jq for column, so assuming no `#` in json values
function print_json_columnize() {
    [ -z "$1" ] && echo "arg for filename needed!" && return 1
    if [ -t 1 ]; then  # if it's not a terminal, assume a pipe, then dont colorize it
        jq  -r '.[] | .[0] + "#" + .[1]' $1 | column -t -s# | colr_row
    else
        jq  -r '.[] | .[0] + "#" + .[1]' $1 | column -t -s#
    fi
}

# use for json formatted file
function print_bitwarden_columize() {
    [ -z "$1" ] && echo "need arg for filename" && return 1
    jq '.items | .[] | .name + "," + .login.username + "," + .login.password' $1 | column -t -s,
}

function run_cmd_timestamp() {
    local start=$(date +%s)
    echo; echo $(ansi256 -f red -b green "_-----------------------")" $(date) "\
        $(ansi256 -f red -b green "_---------------------"); echo

    eval $*

    local end=$(date +%s)
    local elapsed=$((end - start))
    echo; echo $(ansi256 -f red -b green "_-----------------------")" Time elapsed: ${elapsed} "\
        $(ansi256 -f red -b green "_---------------------"); echo
}

# shell func wrapper that will change to current dir in lf when quitting
l () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
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

function vil() { v -p $(cat $1); }

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
# FIXME: aliases and funcs are double printing in bash
# fuzzy search aliases and functions, with previews for some sources
function fsn() {
    : "${fzf_pafn_preview_sources:="source ~/rams_dot_files/shell_functions.sh"}"
    aliasname=1 funcname=1 print_alias_funcs_scripts | fzf --height 100% --preview "$fzf_pafn_preview_sources; batwhich {}" \
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

# actual regex on full path, e.g. ".*go$" (any # of chars, ending literal go)
function findgrepp() { find . -type f -regex $1 -exec grep $2 ; }
# last component of pathname, pattern not regex, e.g. ("*go")
function findgrep() { find . -type f -name $1 -exec grep $2 ; }

# needs psx alias
function psxg() { psx | grep $1 | grep -v grep; }

# go docs with syntax highlighting!
function batgod() { go doc $@ | bat -l go; }

function yts_query() {
    xh -do /tmp/yts_query https://yts.mx/ajax/search query=="$1"
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

function yamltojson() {
    ruby -e 'require "yaml"; require "json"; puts YAML.load_file(ARGV[0]).to_json' "$@"
}

function csvtojson() {
    ruby -e 'require "csv"; require "json"; puts CSV.open(ARGV[0], headers: true).map { |x| x.to_h }.to_json' "$@"
}

###### OTHER ###############

function weather() { xh --print=b https://wttr.in/$1; }

# TODO: use next time ubuntu seemingly loses delay when i plug keyboard back in
function gsettings_set_keyboard() {
    [ "$(uname)" != "Linux" ] && echo "not linux" && return 1
    gsettings set org.gnome.desktop.peripherals.keyboard repeat false
    gsettings set org.gnome.desktop.peripherals.keyboard delay 217
    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
    gsettings set org.gnome.desktop.peripherals.keyboard repeat true
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
