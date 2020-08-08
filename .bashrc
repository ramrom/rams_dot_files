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

# TODO: use vi mode (press esc to go to normal), need to manually bind default keys still, like back/forward char
# set -o vi

# modify ls colors, ubuntu bash 4.4 doesnt need this for color on ls and tree
[ $(uname) = "Darwin" ] && export LSCOLORS='GxFxCxDxBxegedabagaced'
# TODO: how to get brew tree colors working, below LS_COLORS doesnt work
# [ `uname` = "Darwin" ] && export LS_COLORS='GxFxCxDxBxegedabagaced'

# apparently osx ps doesnt support this env var per man docs
if [ $(uname) = "Linux" ]; then
    export PS_FORMAT='pid,ppid,user,pri,ni,vsz,rss,pcpu,pmem,tty,stat,args'
fi

# Linux bin name for fd is fdfind
fdname="fd"
[ $(uname) = "Linux" ] && fdname="fdfind"

export FZF_DEFAULT_COMMAND="$fdname --type f --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info \
       --bind 'ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-n:preview-page-down,ctrl-p:preview-page-up'"
export FZF_COMPLETION_TRIGGER='**'
export FZF_CTRL_T_COMMAND="$fdname"
export FZF_ALT_C_COMMAND="$fdname --type d"
unset fdname

export RIPGREP_CONFIG_PATH=~/.ripgreprc

function load_or_err() {
    if [ -f "$1" ]; then . $1; else echo "$(tput setaf 1)$1 not found$(tput sgr0)"; fi
}

load_or_err ~/rams_dot_files/shell_aliases.sh
load_or_err ~/rams_dot_files/shell_functions.sh

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
load_or_err /etc/bash_completion

# enable git-completions for bash in ubuntu
load_or_err /usr/share/bash-completion/completions/git

# some funcs/aliases use github API token for hitting github API for user ramrom
[ ! -f ~/.ramrom_gittoken ] && echo "$(tput setaf 1)ERROR: $(tput sgr0)Did not find ~/.ramrom_gittoken"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

if [ -f ~/.lessfilter ]; then
    export LESS='-R'
    export LESSOPEN='|~/.lessfilter %s'
fi

# export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11

# GO STUFF
export GOPATH=~/go
export GOBIN=${GOBIN}/bin

# set PATH so it includes user's private bin if it exists
mybindir=~/bin
[ -d "$mybindir" ] && echo "$PATH" | grep -v "$mybindir:\|$mybindir$" > /dev/null && PATH="$mybindir":"${PATH}"
unset mybindir

# ubuntu has python stuff in ~/.local
mylocalpythondir=~/.local/bin
[ -d "$mylocalpythondir" ] && echo "$PATH" | grep -v "$mylocalpythondir:\|$mylocalpythondir$" > /dev/null \
    && PATH="$mylocalpythondir":"${PATH}"; unset mylocalpythondir

# execute local settings
[ -x ~/.local_shell_settings ] && . ~/.local_shell_settings

#export DISPLAY='localhost:10.0'
