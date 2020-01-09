# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
#umask 022

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

function parse_git_branch {
  branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
  if [ "HEAD" = "$branch" ]; then
    echo "(no branch)"
  else
    echo "$branch"
  fi
}

# TODO: tput, especially using reset, does wierd things to prompt, should use direct ANSI codes/sequences
# https://apple.stackexchange.com/questions/256449/iterm2-cursor-doesnt-return-to-line-beginning
function build_my_prompt {
  local bold=`tput bold`
  local reset=`tput sgr0`
  local black=`tput setaf 0`
  local yellow=`tput setaf 3`
  local blue=`tput setaf 4`
  local magenta=`tput setaf 5`
  local cyan=`tput setaf 6`

  local git_branch=`parse_git_branch`

  PS1="${yellow}${bold}\u"
  PS1="${PS1}${reset}${bold}@"
  PS1="${PS1}${yellow}\h "
  PS1="${PS1}${blue}("
  PS1="${PS1}${reset}${cyan}\w"
  PS1="${PS1}${bold}${blue})"
  PS1="${PS1} <${reset}${magenta}${git_branch}"
  PS1="${PS1}${bold}${blue}>${reset}"

  PS1="${PS1}\n$ "
}

#old set my prompt
# PS1='\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    PROMPT_COMMAND='build_my_prompt'
    ;;
esac

