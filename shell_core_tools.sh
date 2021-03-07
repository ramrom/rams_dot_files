#!/bin/sh
# CORE SHELL TOOLS

# return 0 if all are defined, spit out error with exit 1 if one is not
#TODO: get method 2/3 or all of them working
detect_shell () {
    # METHOD 1:
    if [ -n "$BASH_VERSION" ]; then
        echo "bash"
    elif [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    else
        txt="NOT BASH OR ZSH!"; msg="\033[38;5;1m${txt}\033[0m"
        echo "$msg" && return 1
    fi
    # METHOD 2: use ps
        # LINUX: $(ps -p $$ -o cmd=)
        # OSX: $(ps -p $$ -o command=) # i will get "-zsh" so need to remove "-" char
    # METHOD 3: echo $SHELL (when i start bourne(sh) from a zsh in osx, it's still zsh
}

cmds_defined () {
    for cmd in "$@"; do
        command -v $cmd > /dev/null || { echo "$cmd not defined!" && return 1; }
    done
}

require_vars () {
    local vars_required=0
    for arg in "$@"; do
        local var_value=$(eval "echo \$${arg}")

        if [ -z "$var_value" ]; then
            vars_required=1
            output="\033[38;5;3m${arg}\033[0m"
            [ -z "$quiet" ] && echo "RLY-ERROR: Variable "$output" is required!"
        fi
    done
    [ "$vars_required" = "1" ] && return 1
    return 0
}

# TODO: /bin/sh in osx does not like the printf's
debug_vars () {
    local spacing="\n"; [ -n "$tab" ] && spacing=";    "

    if [ -n "$caller" ]; then
        txt="Calling func/script: "; txt="\033[38;5;6m${txt}\033[0m"
        txt2="\033[1m\033[38;5;6m${caller}\033[0m"
        echo "${txt}${txt2}" >&2
    fi
    for arg in "$@"; do
        local var_value=$(eval "echo \$${arg}")

        msg="\033[38;5;1m${arg}\033[0m"
        if [ -z "$var_value" ]; then
            txt=" is undefined or null!"; msg2="\033[38;5;9m${txt}\033[0m""${spacing}"
            printf "$msg$msg2" >&2
        else
            msg2=" = ""\033[38;5;10m${var_value}\033[0m""${spacing}"
            printf "${msg}${msg2}" >&2
        fi
    done
    [ -n "$tab" ] && echo
}
