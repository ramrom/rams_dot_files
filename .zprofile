# TODO: FIX ME

function parse_git_branch() {
  branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
  if [ "HEAD" = "$branch" ]; then
    echo "(no branch)"
  else
    echo "$branch"
  fi
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

  local git_branch=`parse_git_branch`

  PS1=""

  # display icon if last command succeeded or failed
  #if [[ $exit_code -eq 0 ]]; then
  #    PS1="${PS1}${green}√${reset} "      # Add green for success
  #else
  #    PS1="${PS1}${red}˟${exit_code}${reset} "    # Add green for success
  #fi

  PS1="${PS1}${yellow}${bold}%n"
  PS1="${PS1}${reset}${bold}@"
  PS1="${PS1}${yellow}%m "
  PS1="${PS1}${blue}("
  PS1="${PS1}${reset}${cyan}%~"
  PS1="${PS1}${bold}${blue})"
  PS1="${PS1} <${reset}${magenta}${git_branch}"
  PS1="${PS1}${bold}${blue}>${reset}"

  #PS1="${PS1}"$'\n'"$ "
  echo "${PS1}"$'\n'"$ "
}

PROMPT=$(build_my_prompt)
