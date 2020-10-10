function parse_git_branch() {
    branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
    if [ "HEAD" = "$branch" ]; then
        echo "(no branch)"
    else
        echo "$branch"
    fi
}

# needed to make git/hostname function for cmd substitution in prompt
setopt prompt_subst

function set_ps1_hostname() {
    [ -z "${ZSH_PS1_HOSTNAME}" ] && ZSH_PS1_HOSTNAME="$(tput setaf 3)$(tput bold)%m"
    echo $ZSH_PS1_HOSTNAME
}

function build_my_prompt() {
    # local exit_code=$? # store current exit code

    local bold=$(echo -e "\033[1m")
    local reset=$(echo -e "\033[0m")
    local yellow=$(echo -e "\033[0;33m")
    local boldblue=$(echo -e "\033[1;34m")
    local magenta=$(echo -e "\033[0;35m")
    local cyan=$(echo -e "\033[0;36m")

    PROMPT=''
    # # TODO: display icon if last command succeeded or failed
    # if [[ $exit_code -eq 0 ]]; then
    #     PROMPT="${PROMPT}${green}√${reset} "      # Add green for success
    # else
    #     PROMPT="${PROMPT}${red}˟${exit_code}${reset} "    # Add green for success
    # fi

    PROMPT="${PROMPT}${yellow}%n"
    PROMPT="${PROMPT}${reset}${bold}@"
    PROMPT="${PROMPT}${reset}"'$(set_ps1_hostname)'" "
    PROMPT="${PROMPT}${boldblue}("
    PROMPT="${PROMPT}${reset}${cyan}%~"
    PROMPT="${PROMPT}${boldblue})"
    PROMPT="${PROMPT} <${reset}${magenta}"'$(parse_git_branch)'
    PROMPT="${PROMPT}${boldblue}>${reset}"

    echo "${PROMPT}"$'\n'"$ "
}

PROMPT=$(build_my_prompt)
