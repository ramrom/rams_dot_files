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
        command -v $cmd > /dev/null || { echo >&2 "${caller_msg}ERROR: $(ansi256 -f red ${cmd}) not defined!" && return 1; }
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
                echo "${caller_msg}ERROR: Variable "$(ansi256 -f red "$arg")" is required!" >&2
        fi
    done
    [ "$vars_required" = "1" ] && return 1
    return 0
}

# FIXME: /bin/sh in osx does not like the printf's
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

function print_mypath() { 
    local IFS=":"; 
    for p in $PATH; do
        echo $p
    done 
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

    # combine 3 comamands into one so i can grep on all 3
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
            eval $defcmd "$1" | $BATBIN --paging=never --color=always -l sh ;;
        executable)
            local fullpath="command -v"; [ "$(detect_shell)" = "zsh" ] && fullpath="whence -c"
            $BATBIN --paging=never --color=always "$(eval $fullpath "$1")" ;;
        *) echo "print_type returned $type for "$1", unhandled by $0!" ;;
    esac
}

function run_cmd_timestamp() {
    local start=$(date +%s)
    echo; echo $(ansi256 -f red -b green "_-----------------------")" $(date) "\
        $(ansi256 -f red -b green "_---------------------"); echo

    eval $*

    local end=$(date +%s)
    local elapsed=$((end - start))
    echo; echo $(ansi256 -f red -b green "_-----------------------")" Seconds elapsed: ${elapsed} "\
        $(ansi256 -f red -b green "_---------------------"); echo
}

# LF shell func wrapper that will change to current dir when quitting
function l() {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# given port number return if ssh(or polipo) is listening on it
# polipo used to create HTTP proxy to a SOCKS proxy
function print_ssh_listening_ports() {
    [ -z "$1" ] && echo "need 1st arg for port number" && return 1
    local process_type=ssh; [ -n "$polipo" ] && process_type=polipo
    ports="$(lsof -nP -iTCP -sTCP:LISTEN)"
    # space occurs after last digit, so match full number (e.g. otherwise 313 matches on 3131)
    echo "$ports" | grep "$1 " > /dev/null | grep $process_type > /dev/null
}

# use for json formatted file
function print_bitwarden_columize() {
    [ -z "$1" ] && echo "need arg for filename" && return 1
    jq -r '.items | .[] | .name + "," + .login.username + "," + .login.password' $1 | column -t -s,
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

# FF script function wrapper - if fzf output starts with "cd " then cd to dir, scripts cant change parent process working dir
function ff() {
    # source ~/bin/ff -w "$@"
    local result=$(~/bin/ff -w "$@")
    [ "$(echo "$result" | awk '{print $1}')" == "cd" ] && eval "$result" && return
    echo "$result" | grep -E '^vi|^nvi' > /dev/null && eval "$result" && return
    echo "$result"
}

# FIXME: aliases fail to preview in ubuntu/bash
    # fzf --preview "alias foo='echo hi'; foo"  ---- FAILS, WHY????
# FIXME: aliases and funcs are double printing in bash
# fuzzy search aliases and functions, with previews for some sources
function fn() {
    : "${fzf_pafn_preview_sources:="source ~/rams_dot_files/shell_functions.sh"}"
    aliasname=1 funcname=1 print_alias_funcs_scripts | fzf --height 100% --preview "$fzf_pafn_preview_sources; batwhich {}" \
        --header='ctrl-y->pbcopy' \
        --bind 'ctrl-y:execute-silent(echo {} | pbcopy)+abort' \
        --preview-window=:wrap --preview-window right:70%
}

function ffgt() {  # ff(fuzzy)g(git)t(tag)
    git rev-parse HEAD > /dev/null 2>&1 || { echo "not git repo" && return 1; }
    git tag --sort -version:refname | fzf --multi --preview-window right:80% \
        --preview 'git show --color=always {} | head -'$LINES
}

# LIVE GREP: fzf query is the rg pattern to filter on, this is what the Rg comamnd in vim#fzf plugin does
# TODO: add fzf --expect and optionally edit file if expect given
# TODO: add preview for more context
function frgl() {  # frg (live)
    INITIAL_QUERY=""
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
        fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --ansi --phony --query "$INITIAL_QUERY" \
        --height=50% --layout=reverse
}

# needs psx alias
function psxg() { psx | grep $1 | grep -v grep; }

# go docs with syntax highlighting!
function batgod() { go doc $@ | bat -l go; }

function yts_query() {
    xh -do /tmp/yts_query https://yts.mx/ajax/search query=="$1"
    jq . /tmp/yts_query
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

function tmux_run_in_pane() {
    local open_pane=$(tmux_open_pane)
    echo $open_pane | grep "NO-OPEN" && echo "No open panes" && return 1
    tmux send-keys -t $open_pane "$1" Enter
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

###### OTHER ###############
function yamltojson() {
    ruby -e 'require "yaml"; require "json"; puts YAML.load_file(ARGV[0]).to_json' "$@"
}

function csvtojson() {
    ruby -e 'require "csv"; require "json"; puts CSV.open(ARGV[0], headers: true).map { |x| x.to_h }.to_json' "$@"
}

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

function tabname { printf "\e]1;$1\a"; }
function winname { printf "\e]2;$1\a"; }
