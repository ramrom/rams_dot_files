# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
#umask 022

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

#the old prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

function parse_git_branch {
  branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
  if [ "HEAD" = "$branch" ]; then
    echo "(no branch)"
  else
    echo "$branch"
  fi
}
function build_my_prompt {
  #PS1='\[\033[01;33m\]\@ '
  local GRAY="\[\033[1;30m\]"
  local LIGHT_GRAY="\[\033[0;37m\]"
  local LIGHT_CYAN="\[\033[1;36m\]"
  local NO_COLOUR="\[\033[0m\]"
  PS1="\[\033[01;33m\]\u"
  PS1="${PS1}\[\033[00m\]@"
  PS1="${PS1}\[\033[1;33m\]\h"
  PS1="${PS1}\[\033[00m\]:"
  PS1="${PS1}\[\033[1;34m\]("
  #PS1="${PS1}\[\033[1;46m\]\[\033[1;34m\]\w"
  PS1="${PS1}\[\033[0;36m\]\w"
  PS1="${PS1}\[\033[1;34m\])"

  local git_branch=`parse_git_branch` 
  PS1="${PS1} \[\033[1;34m\]<"
  PS1="${PS1}\[\033[0;35m\]${git_branch}"
  PS1="${PS1}\[\033[1;34m\]>"
 
  PS1="${PS1}\n\[\033[00m\]\$ "
}
function build_my_promptv2 {
  local bold=`tput bold`
  local reset=`tput sgr0`
  local black=`tput setaf 0`
  local red=`tput setaf 1`
  local green=`tput setaf 2`
  local yellow=`tput setaf 3`
  local blue=`tput setaf 4`
  local magenta=`tput setaf 5`
  local cyan=`tput setaf 6`
  PS1="${yellow}\u"
  PS1="${PS1}${reset}${white}${bold}@"
  PS1="${PS1}${reset}${yellow}\h"
  PS1="${PS1}${cyan}${bold} (${reset}${cyan}\w${bold})"

  local git_branch=`parse_git_branch` 
  PS1="${PS1}${magenta}${bold} <${reset}${magenta}${git_branch}${bold}>"
 
  PS1="${PS1}\n${reset}${green}\$${reset} "
}
PROMPT_COMMAND='build_my_prompt'

#old set my prompt
#PS1='\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
