# don't put duplicate lines in the history.
setopt histignoredups

# TODO: similar to .bashrc do i need PS1 check for the remote connection non-interactive case?

# turn off zsh globbing, particularly `[]` (brackets)
setopt NO_NOMATCH

# autochange dirs: no need to type `cd` before dir
setopt auto_cd

# use IFS word splitting
setopt sh_word_split

# oct2022: tmux on osx runs path_helper(from /etc/profile) which messus up path entries
    # see https://superuser.com/questions/544989/does-tmux-sort-the-path-variable
# this workaround fixes this issue
if [ "$(uname)" = "Darwin" -a -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi

# set fc(command history editor) to vim
export FCEDIT=nvim

export EDITOR=nvim
export OPENER=xdg-open; [ $(uname) = "Darwin" ] && OPENER=open

# set ctrl-o to open neovim
bindkey -s '^o' 'v\n'

# Colorize
if [ $(uname) = "Darwin" ]; then
    # tree uses this per man docs
    export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"
    export LSCOLORS='GxFxCxDxBxegedabagaced'  # ls uses this per man docs
fi

# apparently osx ps doesnt support this env var per man docs
if [ `uname` = "Linux" ]; then
    export PS_FORMAT='pid,ppid,user,pri,ni,vsz,rss,pcpu,pmem,tty,stat,args'
fi

export RIPGREP_CONFIG_PATH=~/.ripgreprc

# follow symlink
# export FD_OPTIONS="--follow"

# Linux bin name for fd is fdfind
fdname="fd"
[ `uname` = "Linux" ] && fdname="fdfind"

##### FZF #######
export FZF_DEFAULT_COMMAND="$fdname --type f --follow --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--no-mouse --height 50% --reverse --multi --inline-info \
       --bind 'ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-n:preview-page-down,ctrl-p:preview-page-up'"
export FZF_COMPLETION_TRIGGER='**'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_T_COMMAND="$fdname"
# TODO: option-c doesnt do anything in osx
export FZF_ALT_C_COMMAND="$fdname --type d"
unset fdname

function load_or_err() {
    if [ -f "$1" ]; then . $1; else echo "$(tput setaf 1)$1 not found$(tput sgr0)"; fi
}

# load_or_err ~/rams_dot_files/shell_core_tools.sh
load_or_err ~/rams_dot_files/shell_aliases.sh
load_or_err ~/rams_dot_files/shell_functions.sh
load_or_err ~/.fzf.zsh   # "**" autocompletion and alt-c/ctrl-r/ctrl-t

# fzf over command history, hijacks ctrl-r
load_or_err ~/repos/fzf-tab/fzf-tab.plugin.zsh

# export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11

function append_dir_to_path() {
    local dir=$1
    [ -d "$dir" ] && echo "$PATH" | grep -v "$dir:\|$dir$" > /dev/null && export PATH="$dir":"${PATH}"
    unset dir
}

append_dir_to_path ~/bin    # includes user's private bin if it exists and it's not already in PATH

[ "$(uname)" = "Linux" ] && append_dir_to_path ~/.local/bin  # ubuntu has python stuff in ~/.local

[ "$(uname)" = "Darwin" ] && append_dir_to_path /opt/homebrew/bin  # aug2022, homebrew bins are here, not /usr/local/bin/

#export DISPLAY='localhost:10.0'

# set go vars if go bin exists/installed
if [ $(command -v go) ]; then
    export GOPATH=~/go
    export GOBIN=${GOPATH}/bin
fi

# set rust PATH if rustc compiler is installed
if [ "$(uname)" = "Linux" ]; then
    [ -x ~/.cargo/bin/rustc ] && append_dir_to_path "$HOME/.cargo/bin"
else  # assume osx, brew path in nov2022
    [ -x /opt/homebrew/bin/rustc ] && append_dir_to_path "$HOME/.cargo/bin"
fi

# execute local settings
[ -x ~/.local_shell_settings ] && . ~/.local_shell_settings

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
