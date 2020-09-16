# TODO: FIX ME

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
    [ -z "${PS1_HOSTNAME}" ] && PS1_HOSTNAME="$(tput setaf 3)$(tput bold)%m"
    echo $PS1_HOSTNAME
}

function ansi256() {
    local maybebld="";          [ -n "$bld" ] && maybebld="\033[1m"
    local lfg=007;              [ -n "$fg" ] && lfg=$fg
    echo -e "${maybebld}\033[48;5;016;38;5;${lfg}m"
}

# TODO: tput, especially using reset, does wierd things to prompt, should use direct ANSI codes/sequences
# https://apple.stackexchange.com/questions/256449/iterm2-cursor-doesnt-return-to-line-beginning
function build_my_prompt() {
    local exit_code="$?" # store current exit code

    local bold=$(echo -e "\033[1m")
    local reset=$(echo -e "\033[0m")
    local yellow=$(fg=003 ansi256)
    local blue=$(fg=004 ansi256)
    local magenta=$(fg=005 ansi256)
    local cyan=$(fg=006 ansi256)

    # TODO: display icon if last command succeeded or failed
    #if [[ $exit_code -eq 0 ]]; then
    #    PROMPT="${PROMPT}${green}√${reset} "      # Add green for success
    #else
    #    PROMPT="${PROMPT}${red}˟${exit_code}${reset} "    # Add green for success
    #fi
    PROMPT=''

    PROMPT="${PROMPT}${yellow}%n"
    PROMPT="${PROMPT}${reset}${bold}@"
    PROMPT="${PROMPT}${reset}"'$(set_ps1_hostname)'" "
    PROMPT="${PROMPT}${bold}${blue}("
    PROMPT="${PROMPT}${reset}${cyan}%~"
    PROMPT="${PROMPT}${bold}${blue})"
    PROMPT="${PROMPT} <${reset}${magenta}"'$(parse_git_branch)'
    PROMPT="${PROMPT}${bold}${blue}>${reset}"

    # PROMPT="${PROMPT}$(fg=003 ansi256 "%n")"                # 3 - yellow, user
    # PROMPT="${PROMPT}$(bld=1 ansi256 "@")"
    # PROMPT="${PROMPT}"'$(set_ps1_hostname)'" "              # hostname with color from env
    # PROMPT="${PROMPT}$(bld=1 fg=004 ansi256 "(")"           # 4 - blue
    # PROMPT="${PROMPT}$(fg=006 ansi256 "%~")"                # 6 -cyan, working dir
    # PROMPT="${PROMPT}$(bld=1 fg=004 ansi256 ") <")"
    # PROMPT="${PROMPT}$(fg=005 ansi256 '$(parse_git_branch)')"     # 5 - magenta, git branch
    # PROMPT="${PROMPT}$(bld=1 fg=004 ansi256 ">")"

    echo "${PROMPT}"$'\n'"$ "
}

PROMPT=$(build_my_prompt)
