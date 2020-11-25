# VIM
alias vin='nvim'
alias vinmetals='VIM_METALS=1 vin'
alias svi='VIM_NOPLUG=1 vim'    # simple
alias ssvi='vim -u NONE'        # super simple
alias vina='VIM_NO_AUTOREAD=1 vi'

alias ..='cd ..'
alias ll='ls -l'
alias la='ls -A'
alias lal='ls -al'
alias lahl='ls -hal'
alias lail='ls -hail'
alias lrt='ls -lrt'
alias ifschar='printf "%q\n" "$IFS"'
alias rd='cd ~/rams_dot_files'
alias tp='cd ~/tmp'
alias dubydir='du -sh * 2>/dev/null'  # throw away errors, permission failure messages
alias lsoftcplisten='lsof -nP -iTCP -sTCP:LISTEN'
alias findlargefiles='find . -type f -size +1G -exec du -h {} \;'  # osx works
alias findlargefiles2='sudo find -X . -type f -size +1M | xargs du -h' # osx sorta works
alias lsofregfiles='lsof /'     # search from root, will only query DIR and REG files
alias killalljobs='kill $(jobs -p)'  #TODO: fix for zsh
# didnt work for FUSE filemount dir.., but `lsof | grep foodir` found it
alias tmxhor='tmux select-layout even-horizontal'
alias clt='clear && tmux clear-history'
alias batt='bat --color never -pp'  # no color, -pp is plain (no header or line nums) and no pager, so cat...
alias batman="MANPAGER=\"sh -c 'col -bx | bat -l man -p'\" man"
alias bm='batman'
alias tmr='transmission-remote'
alias httpv='http -v'
alias httpcn='httpv http://api.icndb.com/jokes/random'
alias weather='http --print=b wttr.in'
alias ctag_create='ctags -R --exclude=*log --exclude=*.js --exclude=*.html --exclude=dbs --exclude=*.vim *'

alias raf='source ~/rams_dot_files/shell_aliases.sh && source ~/rams_dot_files/shell_functions.sh'
alias rf='source ~/rams_dot_files/shell_functions.sh'
alias paf='print_alias_funcs_scripts'
alias pafn='aliasname=1 funcname=1 print_alias_funcs_scripts'

# backup and mount
alias smbcl='smbclient //192.168.1.1/Backups -U admin'
alias osxfusentfs='sudo /usr/local/bin/ntfs-3g /dev/disk2s1 /Volumes/rambackupfourtb -olocal -oallow_other'

alias nvmetemp='sudo nvme smart-log /dev/nvme0n1 | grep temp'

# neat trick, running aliases as sudo fails as root doesnt have them defined
# bash only looks for first word to alias expand, but if word is alias, it expands subsequent words
alias sudo='sudo '

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
    alias open='xdg-open'
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    alias smd='systemctl'
    alias watch_top_cpu="watch -n 1 'ps -eo pcpu,user,command | sort -k 1 -r | head -10'"
    alias psx='ps auxhf'
    alias psxfull='ps auxhfww'
    alias netstatip='sudo netstat -lpnut'
    alias iorealtime='iostat -x -d 1'      #show ext stats, device util, every 1 second'
    alias fd='fdfind'  # fd is some file management bin, but i dont plan to install it
    alias dubydir='du -sh .[!.]* * 2>/dev/null'  # throw away errors, permission failure messages
    alias dfl='df -khT | grep -v loop | grep -v tmpfs' # grep out loop and tmpfs in ubuntu
    alias mountdev='mount | grep "/dev"'
    alias vcrypt='veracrypt'
    alias trashsize='du -hs ~/.local/share/Trash'
    alias sbw='sudo ~/.cargo/bin/bandwhich'
    alias tmr='transmission-remote'
    alias tmd='transmission-daemon'
else  # assuming Darwin here
    alias lc='launchctl'
    alias psx='ps -hef'
    alias watch_top_cpu="watch -n 1 'ps -Ao pcpu,user,command -r | head -n 6'"
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
    alias gl="cd ~/Google\ Drive/Lists"
    alias gr="cd ~/Google\ Drive/Rally"
    alias sbw='sudo bandwhich'
    alias vcrypt='/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text'
    alias fbrew="brew search | fzf -m --preview 'brew info {}'"
    alias brew_leaf_deps="brew leaves | xargs brew deps --installed --for-each | \
        sed \"s/^.*:/$(tput setaf 4)&$(tput sgr0)/\""
fi

# GIT
alias g='git'
alias gp='git pull'
alias gu='git push'
alias gs='git status'
alias gd='git diff'
alias gdw='git diff --color-words'
alias gdd='git -c core.pager="delta --dark" diff'
alias gbranchclean='git branch --merged master | egrep -v "^\*|master" | xargs -n 1 git branch -d'
# alias gpsm='git pull --recurse-submodules'
# alias gsubp='git submodule foreach git pull origin master'


# FZF, RG (ripgrep), FD, GREP
alias fdh1='fd -H -d 1'
alias grep='grep --colour=always'
alias rgst='rg -tscala'
alias rgs="rg -tscala -g '!it/' -g '!test/'"
alias f="fzf"
alias fp="fzf --preview 'bat --style=numbers --color=always {} | head -500'"
alias fph="fzf --preview 'bat --style=numbers --color=always {} | head -500' --height 100%"
alias fv="export | fzf"
alias fs="saf | fzf"
# TODO: sourcing aliases works, but calling the alias after fails
# alias fsp='safn | fzf --preview "source ~/rams_dot_files/shell_aliases.sh; source ~/rams_dot_files/shell_functions.sh; \
alias fsp='safn | fzf --preview "source ~/rams_dot_files/shell_aliases.sh; ssf; \
           which {} | bat --style=numbers --color=always -l bash"'

# Go
alias gosr='cd ~/go/src'
alias gosrghub='cd ~/go/src/github.com'
alias gosrstdlib='cd ~/go/src/github.com/golang/go'

#POSTGRES
alias lpsql='PAGER=$(psql-pager) /usr/local/opt/libpq/bin/psql'
alias psqlless='PAGER=less LESS="-iMSx4 -FX" psql'
#alias psqlvim='PAGER=~/vimpager.sh psql'
alias watchdbsizes="watch 'psql -c \"SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;\" -d postgres'"
alias getdbsizes='psql -c "SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;" -d postgres'
alias postgrecon='sudo -u postgres psql'
