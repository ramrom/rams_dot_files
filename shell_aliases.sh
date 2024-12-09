### SHELL ALIASES

# VI
alias vdiff='nvim -d'

# LS
alias la='ls -A'
alias ll='ls -hl'
alias lal='ls -hal'     # -l long format, -h human readable
alias lail='ls -hail'    # -i for inode value
alias lrt='ls -lrt'     # sort by mod time, -r reverse order

# CD
alias rd='cd ~/rams_dot_files'
alias docs='cd ~/Documents'
alias down='cd ~/Downloads'
alias repos='cd ~/src'
alias tp='cd ~/tmp'

# LSOF
alias printlsoftcplisten='lsof -nP -iTCP -sTCP:LISTEN'
alias printlsofudplisten='lsof -nP -iUDP'
# didn't work for FUSE filemount dir.., but `lsof | grep foodir` found it
alias lsofregfiles='lsof /'     # search from root, will only query DIR and REG files

# TMUX
alias ta='tmux attach'
alias tms='tmux-statusctl'
alias clt='clear && tmux clear-history'

# BAT
alias b='bat'
alias bm='batman'
alias batt='bat --color never -pp'  # no color, -pp is plain (no header or line nums) and no pager, so cat...

# XH
alias xhv='xh -v'
alias xhcn='xhv --verify no https://api.chucknorris.io/jokes/random'  # need no-verify when on work vpn

# SHELL STUFF
alias raf='source ~/rams_dot_files/shell_aliases.sh && source ~/rams_dot_files/shell_functions.sh'
alias rf='source ~/rams_dot_files/shell_functions.sh'
alias paf='print_alias_funcs_scripts'
alias pafn='aliasname=1 funcname=1 print_alias_funcs_scripts'

# BACKUP AND MOUNT
alias rsyncl='rsync -Hhav --progress --delete'  # preserve hardlinks, archive, verbose, human-readable
alias rsync_smb='rsync -Hhvrl -goD --progress --delete' # p(perms) and t(modtime) preserves fail to rsync to smbv1

# SUDO neat trick, running aliases as sudo fails as root doesnt have them defined
# bash only looks for the first word to alias expand, so if it's an alias it expands subsequent words
alias sudo='sudo '

# OTHER
alias cpu_total_util='ps -A -o %cpu | awk '\''{s+=$1} END {print s "%"}'\' # loops over all procs, sums the cpu consumption
alias ifschar='printf "%q\n" "$IFS"'
alias findlargefiles='find . -type f -size +1G -exec du -h {} \;'  # osx works
alias findlargefiles2='sudo find -X . -type f -size +1M | xargs du -h' # osx sorta works
alias killalljobs='kill $(jobs -p)'  #TODO: fix for zsh
alias ctag_create='ctags -R --exclude=*log --exclude=*.js --exclude=*.html --exclude=dbs --exclude=*.vim *'
alias nvmetemp='sudo nvme smart-log /dev/nvme0n1 | grep temp'
alias kn='k9s'   # k9s is a TUI for kubernetes
alias cald='calcurse-caldav'
alias cala='calcurse -d 30'


if [ "$TERM" != "dumb" ]; then
    if [ "$(uname)" = "Linux" ]; then
        eval "$(dircolors -b)"
        alias ls='ls --color=auto -F'
        alias rgrep='rgrep --color=auto'
        alias egrep='egrep --color=auto'
    else  # assuming Darwin here
        alias ls='ls -CFG'
    fi
else
    echo "TERMINAL IS DUMB!, not setting some color aliases"
fi

if [ "$(uname)" = "Linux" ]; then
    alias fd='fdfind'  # fd is some file management bin, but i dont plan to install it
    alias bat='batcat'
    alias open='xdg-open'
    alias batman="MANPAGER=\"sh -c 'col -bx | batcat -l man -p'\" man"
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    alias smd='systemctl'
    alias bt='bluetoothctl'
    alias cpu_top_procs_watch="watch -n 1 'ps -eo pcpu,user,command | sort -k 1 -r | head -10'"
    alias psx='ps auxhf'
    alias psxfull='ps auxhfww'
    alias netstatip='sudo netstat -lpnut'
    alias iorealtime='iostat -x -d 1'      #show ext stats, device util, every 1 second'
    alias dfl='df -khT | grep -v loop | grep -v tmpfs' # grep out loop and tmpfs in ubuntu
    alias mountdev='mount | grep "/dev"'
    alias blkidnoloop='sudo blkid | grep -v loop'
    alias vcrypt='veracrypt'
    alias trashsize='du -hs ~/.local/share/Trash'
    alias sbw='sudo ~/.cargo/bin/bandwhich -n' # TODO: see issue 166 to fix dns resolver, for now -n no resolve
    alias tmr='transmission-remote'
    alias tmd='transmission-daemon'
    alias printgnomekeys='gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys'
    alias fapti='fapt -i'
    alias printbluetoothconnected='bluetoothctl devices Connected'
else  # assuming Darwin here
    alias batman="MANPAGER=\"sh -c 'col -bx | bat -l man -p'\" man"
    alias lc='launchctl'
    alias psx='ps -hef'
    # alias top_cpu_procs_watch="watch -n 1 'ps -Ao pcpu,user,command -r | head -n 6'"
    alias cpu_top_procs_watch="viddy -n 1 'ps -Ao pcpu,user,command -r | head -n 6'"
    alias cpu_top_procs='ps -Ao pcpu,user,command -r | head -n 6'   # do command last so it string doesnt get truncated
    alias watch_istats='watch -n 1 -c istats all'
    alias oc='open -a "Google Chrome"'
    alias ow='open -a Whatsapp'
    alias os='open -a Slack'
    alias oam='open -a "Activity Monitor"'
    alias osy='open -a "System Preferences"'
    alias ote='open -a TextEdit'
    alias osp='open -a Spotify'
    alias odisc='open -a Discord'
    alias iorealtime='iostat -w 1'      #show ext stats, device util, every 1 second'
    alias sbw='sudo bandwhich'
    alias vcrypt='/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text'
    alias brew_leaf_deps="brew leaves | xargs brew deps --installed --for-each | \
        sed \"s/^.*:/$(tput setaf 4)&$(tput sgr0)/\""
fi

# GIT
alias g='git'
alias gp='git pull'
alias gu='git push'
alias gs='git status'
alias gdw='git diff --color-words'
alias gbranchclean='git branch --merged master | egrep -v "^\*|master" | xargs -n 1 git branch -d'
# alias gpsm='git pull --recurse-submodules'
# alias gsubp='git submodule foreach git pull origin master'

# DOCKER
alias d='docker'
alias sd='sudo docker'
alias ku='kubectl'

# RIPGREP, GREP
alias grep='grep --colour=always'
alias rg_hidden_nogit="rg -uu -g '!.git/'"
alias rgst='rg -tscala'
alias rgs="rg -tscala -g '!it/' -g '!test/' -g '!nrt/'"
alias frgs="frg -f \"-tscala -g '!it/' -g '!test/'\""
alias frgst='frg -f "-tscala"'

# FABRIC
alias fabe="cd ~/.config/fabric"

# FZF
alias fa='ff -d 1 -k'
alias fh='ff ~'
alias fhd='ff -t d ~'
alias ffd='ff -t d'
alias fnn="print_alias_funcs_scripts | fzf --height 100%"

# LUA
alias luar='lua -i ~/rams_dot_files/ram-lua-helpers.lua'

# GO
alias gosr='cd ~/go/src'
alias gosrghub='cd ~/go/src/github.com'
alias gosrstdlib='cd ~/go/src/github.com/golang/go'

# JAVA
alias jsv='jshell --feedback verbose'

# SDKMAN
alias java21='sdk use java 21.0.2-tem'
alias java17zulu='sdk use java 17.0.9.fx-zulu'
alias java17='sdk use java 17.0.6-tem'
alias java11='sdk use java 11.0.16.1-tem'
alias java8='sdk use java 8.0.345-zulu'

#POSTGRES
alias lpsql='PAGER=$(psql-pager) /usr/local/opt/libpq/bin/psql'
alias psqlless='PAGER=less LESS="-iMSx4 -FX" psql'
#alias psqlvim='PAGER=~/vimpager.sh psql'
alias watchdbsizes="watch 'psql -c \"SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;\" -d postgres'"
alias getdbsizes='psql -c "SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;" -d postgres'
alias postgrecon='sudo -u postgres psql'
