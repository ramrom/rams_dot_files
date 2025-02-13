# ZSHRC

#### HISTORY #######
setopt histignoredups    # don't put duplicate lines in the history.
setopt histreduceblanks  # remove superfluous blanks before recording entry
# setopt incappendhistory  # appends to histfile immediately, not on shell exit
setopt histignorespace   # dont record entry starting with space
HISTFILE=~/.zsh_history
HISTSIZE=1000           # number of entries to keep in memory
SAVEHIST=$HISTSIZE      # number of entries to write to history file


# NOTE: Open ctrl keys for use: ctrl-g, ctrl-s, ctrl-q
# TODO: similar to .bashrc do i need PS1 check for the remote connection non-interactive case?

setopt NO_NOMATCH       # turn off zsh globbing, particularly `[]` (brackets)

# `ls /foo/bar<C-w>` only kills 'bar'
autoload -U select-word-style

setopt auto_cd          # autochange dirs: no need to type `cd` before dir

setopt sh_word_split    # use IFS word splitting

# oct2022: tmux on osx runs path_helper(from /etc/profile) which messus up path entries
    # see https://superuser.com/questions/544989/does-tmux-sort-the-path-variable
    # oct2024 - turned off and back on, ctags broke(i want homebrew one, not one in /usr/bin/)
# this workaround fixes this issue
if [ "$(uname)" = "Darwin" -a -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi

export FCEDIT=nvim      # set fc(command history editor) to vim

export EDITOR=nvim
export OPENER=xdg-open; [ $(uname) = "Darwin" ] && OPENER=open

bindkey -s '^o' 'nvim\n'   # set ctrl-o to open neovim

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
FD_BIN="fd"
[ `uname` = "Linux" ] && FD_BIN="fdfind"

##### FZF #######
export FZF_DEFAULT_COMMAND="$FD_BIN --type f --follow --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--no-mouse --height 50% --reverse --multi --inline-info \
       --bind 'ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-n:preview-page-down,ctrl-p:preview-page-up'"
export FZF_COMPLETION_TRIGGER='**'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_CTRL_T_COMMAND="$FD_BIN"
# TODO: option-c doesnt do anything in osx
export FZF_ALT_C_COMMAND="$FD_BIN--type d"
unset FD_BIN

function load_or_err() {
    if [ -f "$1" ]; then . $1; else echo "$(tput setaf 1)$1 not found$(tput sgr0)"; fi
}

# load_or_err ~/rams_dot_files/shell_core_tools.sh
load_or_err ~/rams_dot_files/shell_aliases.sh
load_or_err ~/rams_dot_files/shell_functions.sh

load_or_err ~/.fzf.zsh   # "**" autocompletion and alt-c/ctrl-r/ctrl-t

# fzf over command history, hijacks ctrl-r
load_or_err ~/src/fzf-tab/fzf-tab.plugin.zsh

# export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11

# if dir exists and isn't already in PATH, then append it
function append_dir_to_path() {
    local dir=$1
    [ -d "$dir" ] && echo "$PATH" | grep -v "$dir:\|$dir$" > /dev/null && export PATH="$dir":"${PATH}"
    unset dir
}

append_dir_to_path ~/bin    # includes user's private bin if it exists and it's not already in PATH

append_dir_to_path ~/node_modules/.bin  # local install of npm bins

[ "$(uname)" = "Linux" ] && append_dir_to_path ~/.local/bin  # ubuntu has python stuff in ~/.local

[ "$(uname)" = "Darwin" ] && append_dir_to_path /opt/homebrew/bin  # aug2022, homebrew bins are here, not /usr/local/bin/
[ "$(uname)" = "Darwin" ] && append_dir_to_path /opt/homebrew/sbin
[ "$(uname)" = "Darwin" ] && append_dir_to_path ~/.docker/bin # oct2023, 1st party docker cli bins are here (jul'24 not colima)
[ "$(uname)" = "Darwin" ] && append_dir_to_path /Applications/Docker.app/Contents/Resources/bin/

#export DISPLAY='localhost:10.0'

# set go vars if go bin exists/installed
if [ $(command -v go) ]; then
    export GOPATH=~/go
    export GOBIN=${GOPATH}/bin
fi

### RUST
# set rust PATH if rustc compiler is installed via https://www.rust-lang.org/tools/install
[ -x ~/.cargo/bin/rustc ] && append_dir_to_path "$HOME/.cargo/bin"
# [ -x /opt/homebrew/bin/rustc ] && append_dir_to_path "$HOME/.cargo/bin"   # use this for a brew install

# added zsh completions for rust (cargo and rustup) here
fpath+=~/.zfunc

# execute local settings
[ -x ~/.local_shell_settings ] && . ~/.local_shell_settings

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
