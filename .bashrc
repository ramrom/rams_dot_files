# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Colorize ls
if [ `uname` == "Darwin" ]; then
  LSCOLORS='GxFxCxDxBxegedabagaced'
  export LSCOLORS
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# enable programmable completion for git
if [ -f ~/.git_completion.sh ]; then
    . ~/.git_completion.sh
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

if [ -f ~/.lessfilter ]; then
    export LESS='-R'
    export LESSOPEN='|~/.lessfilter %s'
fi

# For PSQL colorization
GREEN=`echo -e '\033[0;32m'`
NOCOLOR=`echo -e '\033[0m'`
export PAGER="sed \"s/^\(([0-9]\+ [rows]\+)\)/$GREEN\1$NOCOLOR/;s/^\(-\[\ RECORD\ [0-9]\+\ \][-+]\+\)/$GREEN\1$NOCOLOR/;s/|/$GREEN|$NOCOLOR/g;s/^\([-+]\+\)/$GREEN\1$NOCOLOR/\" 2>/dev/null"

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11
export GOPATH=~/go
export GOBIN=${GOBIN}/bin

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

#export DISPLAY='localhost:10.0'
