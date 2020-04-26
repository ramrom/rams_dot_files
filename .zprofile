# TODO: FIX ME

function parse_git_branch() {
    branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
    if [ "HEAD" = "$branch" ]; then
        echo "(no branch)"
    else
        echo "$branch"
    fi
}

# needed to make git function for cmd substitution in prompt
setopt prompt_subst

function set_ps1_hostname() {
    [ -z "${PS1_HOSTNAME}" ] && PS1_HOSTNAME="$(tput setaf 3)$(tput bold)%m"
    echo $PS1_HOSTNAME
}

# TODO: tput, especially using reset, does wierd things to prompt, should use direct ANSI codes/sequences
# https://apple.stackexchange.com/questions/256449/iterm2-cursor-doesnt-return-to-line-beginning
function build_my_prompt() {
    local exit_code="$?" # store current exit code

    local bold=`tput bold`
    local reset=`tput sgr0`
    local black=`tput setaf 0`
    local red=`tput setaf 1`
    local yellow=`tput setaf 3`
    local green=`tput setaf 2`
    local blue=`tput setaf 4`
    local magenta=`tput setaf 5`
    local cyan=`tput setaf 6`


    PROMPT=''
    # display icon if last command succeeded or failed
    #if [[ $exit_code -eq 0 ]]; then
    #    PROMPT="${PROMPT}${green}√${reset} "      # Add green for success
    #else
    #    PROMPT="${PROMPT}${red}˟${exit_code}${reset} "    # Add green for success
    #fi
    PROMPT="${PROMPT}${yellow}%n"
    PROMPT="${PROMPT}${reset}${bold}@"
    PROMPT="${PROMPT}${reset}"'$(set_ps1_hostname)'" "

    PROMPT="${PROMPT}${blue}${bold}("
    PROMPT="${PROMPT}${reset}${cyan}%~"
    PROMPT="${PROMPT}${bold}${blue})"
    PROMPT="${PROMPT} <${reset}${magenta}"'$(parse_git_branch)'
    PROMPT="${PROMPT}${bold}${blue}>${reset}"

    echo "${PROMPT}"$'\n'"$ "
}

PROMPT=$(build_my_prompt)
