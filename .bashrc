# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# so .bashrc isn't run for non-interactive shells by default.
# this PS1 check is still useful b/c bashrc is still run for remote non-interactive, which i want to prevent
#   - see https://unix.stackexchange.com/questions/257571/why-does-bashrc-check-whether-the-current-shell-is-interactive
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Colorize ls
[ `uname` == "Darwin" ] && export LSCOLORS='GxFxCxDxBxegedabagaced'

function load_or_err() {
    if [ -f "$1" ]; then . $1; else echo "$(tput setaf 1)$1 not found$(tput sgr0)"; fi
}

# enable programmable completion for git
load_or_err ~/.git_completion.sh

load_or_err ~/rams_dot_files/.bash_aliases
load_or_err ~/rams_dot_files/.bash_functions

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
[ -f /etc/bash_completion ] && . /etc/bash_completion

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
