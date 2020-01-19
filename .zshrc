# don't put duplicate lines in the history.
setopt histignoredups

# TODO: like .bashrc do i need PS1 check for the remote connection non-interactive case?

# autoload -Uz compinit && compinit

# Colorize ls
[ `uname` = "Darwin" ] && export LSCOLORS='GxFxCxDxBxegedabagaced'

function load_or_err() {
    if [ -f "$1" ]; then . $1; else echo "$(tput setaf 1)$1 not found$(tput sgr0)"; fi
}

# enable programmable completion for git
# TODO: causing "complete:13: command not found: compdef" errors
# load_or_err ~/

load_or_err ~/rams_dot_files/.shell_aliases.sh
load_or_err ~/rams_dot_files/.shell_functions.sh

# some funcs/aliases use github API token for hitting github API for user ramrom
[ ! -f ~/.ramrom_gittoken ] && echo "$(tput setaf 1)ERROR: $(tput sgr0)Did not find ~/.ramrom_gittoken"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

if [ -f ~/.lessfilter ]; then
    export LESS='-R'
    export LESSOPEN='|~/.lessfilter %s'
fi

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11

# GO STUFF
export GOPATH=~/go
export GOBIN=${GOBIN}/bin

# set PATH so it includes user's private bin if it exists
[ -d ~/bin ] && PATH=~/bin:"${PATH}"

#export DISPLAY='localhost:10.0'
