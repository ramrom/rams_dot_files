# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
#umask 022

# include .bashrc if it exists
[ -f ~/.bashrc ] && . ~/.bashrc

function parse_git_branch() {
  branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
  if [ "HEAD" = "$branch" ]; then
    echo "(no branch)"
  else
    echo "$branch"
  fi
}

function set_ps1_hostname() {
    # [ -z "${PS1_HOSTNAME}" ] && PS1_HOSTNAME="$(tput setaf 3)$(tput bold)\h"
    [ -z "${BASH_PS1_HOSTNAME}" ] && BASH_PS1_HOSTNAME="$(bld=1 fg=003 ansicolor "\h")"
    echo $BASH_PS1_HOSTNAME
}

function ansicolor() {
    local maybebld="";          [ -n "$bld" ] && maybebld="\033[1m"
    local lfg=007;              [ -n "$fg" ] && lfg=$fg
    echo -e "${maybebld}\033[48;5;016;38;5;${lfg}m${1}\033[0m"
}

function build_my_prompt() {
  local exit_code="$?" # store current exit code

  local git_branch=`parse_git_branch`
  local ps1_hostname=$(set_ps1_hostname)

  PS1=""

  # TODO: display icon if last command succeeded or failed
  #if [[ $exit_code -eq 0 ]]; then
  #    PS1="${PS1}${green}√${reset} "      # Add green for success
  #else
  #    PS1="${PS1}${red}˟${exit_code}${reset} "    # Add green for success
  #fi

  PS1="${PS1}$(fg=003 ansicolor "\u")"                # 3 - yellow, user
  PS1="${PS1}$(bld=1 ansicolor "@")"
  PS1="${PS1}${ps1_hostname} "                      # hostname with color from env
  PS1="${PS1}$(bld=1 fg=004 ansicolor "[")"         # 4 - blue
  PS1="${PS1}$(fg=002 ansicolor "$(date '+%Y-%m-%d %H:%M:%S')")"
  PS1="${PS1}$(bld=1 fg=004 ansicolor "] (")"
  PS1="${PS1}$(fg=006 ansicolor "\w")"                # 6 -cyan, working dir
  PS1="${PS1}$(bld=1 fg=004 ansicolor ") <")"
  PS1="${PS1}$(fg=005 ansicolor "${git_branch}")"     # 5 - magenta, git branch
  PS1="${PS1}$(bld=1 fg=004 ansicolor ">")"

  PS1="${PS1}\n$ "
}

PROMPT_COMMAND='build_my_prompt'

#old set my prompt
# PS1='\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
