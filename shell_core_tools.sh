# CORE SHELL TOOLS

# return 0 if all are defined, spit out error with exit 1 if one is not
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
        # LINUX: $(ps -p $$ -o cmd=)
        # OSX: $(ps -p $$ -o command=) # i will get "-zsh" so need to remove "-" char
    # METHOD 3: echo $SHELL (when i start bourne(sh) from a zsh in osx, it's still zsh
}

function cmds_defined() {
    for cmd in "$@"; do
        command -v $cmd > /dev/null || { echo "$cmd not defined!" && return 1; }
    done
}

function require_vars() {
    local vars_required=0
    for arg in "$@"; do
        local var_value=$(eval "echo \$${arg}")

        if [ -z "$var_value" ]; then
            vars_required=1
            [ -z "$quiet" ] && echo "RLY-ERROR: Variable "$(fg=yellow ansi256 "$arg")" is required!"
        fi
    done
    [ "$vars_required" = "1" ] && return 1
    return 0
}

# TODO: /bin/sh in osx does not like the printf's
function debug_vars() {
    local spacing="\n"; [ -n "$tab" ] && spacing=";    "

    if [ -n "$caller" ]; then
        echo $(fg=cyan ansi256 "Calling func/script: ")$(fg=cyan bld=1 ansi256 "$caller") >&2
    fi
    for arg in "$@"; do
        local var_value=$(eval "echo \$${arg}")

        # local msg=$(und=1 ansi256 "DEBUG:")" Variable "$(fg=yellow ansi256 "$arg")
        local msg=$(tput setaf 1)
        if [ -z "$var_value" ]; then
            local msg2=$(fg=brightred ansi256 " is undefined or null!")"${spacing}"
            printf "$msg$msg2" >&2
        else
            local msg2=" = "$(fg=brightgreen ansi256 $var_value)"${spacing}"
            printf "$msg$msg2" >&2
        fi
    done
    [ -n "$tab" ] && echo
}
