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
alias lahl='ls -alh'
alias lrt='ls -lrt'
alias killalljobs='kill $(jobs -p)'  #TODO: fix for zsh
alias ifschar='printf "%q\n" "$IFS"'
alias rd='cd ~/rams_dot_files'
alias tp='cd ~/tmp'
alias dubydir='du -sh * 2>/dev/null'  # throw away errors, permission failure messages
alias findlargefiles='find . -type f -size +1G -exec du -h {} \;'  # osx works
alias findlargefiles2='sudo find -X . -type f -size +1M | xargs du -h' # osx sorta works
alias ch_date='sudo date --set 1998-11-02'
alias httpv='http -v'
alias httpcn='httpv http://api.icndb.com/jokes/random'
alias weather='http wttr.in'
alias ctag_create='ctags -R --exclude=*log --exclude=*.js --exclude=*.html --exclude=dbs --exclude=*.vim *'
alias lsoftcplisten='lsof -iTCP -sTCP:LISTEN'
# didnt work for FUSE filemount dir.., but `lsof | grep foodir` found it
alias lsofregfiles='lsof /'     # search from root, will only query DIR and REG files
alias netcatlisten9001='nc -l 127.0.0.1 9001' #listen on 9001
alias tmxhor='tmux select-layout even-horizontal'
alias clt='clear && tmux clear-history'
# alias exit='echo $(tput setaf 1)use ctrl-d!!!!$(tput sgr0)'
alias batt='bat --color never -pp'  # no color, -pp is plain (no header or line nums) and no pager, so cat...
alias batman="MANPAGER=\"sh -c 'col -bx | bat -l man -p'\" man"
alias ssf='source ~/rams_dot_files/shell_functions.sh'
alias saf='search_alias_func'
alias safn='aliasname=1 funcname=1 search_alias_func'

# backup and mount
alias rsyncprog='rsync -avzh --progress'               # -a archive sets -t preserve timestamps for checking changes
alias rsyncchecksum='rsync -vzh --checksum --progress' #uses checksum for checking changes
alias rysncdryrun='rsync -rv --size-only --dry-run /my/source/ /my/dest/ > diff.out'
alias smbcl='smbclient //192.168.1.1/Backups -U admin'
alias osxfusentfs='sudo /usr/local/bin/ntfs-3g /dev/disk2s1 /Volumes/rambackupfourtb -olocal -oallow_other'
alias mntcifssmb='sudo mount -t cifs //192.168.1.1/Backups ~/smbhd -o username=dude,password=werd'
alias mntntfslinux='sudo mount -t ntfs -o nls=utf8,umask=0222 /dev/sdb1 /media/windows'
alias mntosxsamba='mount_smbfs //admin@192.168.1.1/Backups mynfs'

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
    alias netstatip='sudo netstat -lpnut'
    alias iorealtime='iostat -x -d 1'      #show ext stats, device util, every 1 second'
    alias psx='ps auxf'
    alias psxfull='ps auxhfww'
    alias fd='fdfind'  # fd is some file management bin, but i dont plan to install it
else  # assuming Darwin here
    alias oc='open -a "Google Chrome"'
    alias oam='open -a "Activity Monitor"'
    alias osy='open -a "System Preferences"'
    alias ote='open -a "TextEdit"'
    alias osp='open -a Spotify'
    alias os='open -a Slack'
    alias ow='open -a Whatsapp'
    alias iorealtime='iostat -w 1'      #show ext stats, device util, every 1 second'
    alias psx='ps auxh'
    alias gl="cd ~/Google\ Drive/Lists"
    alias gr="cd ~/Google\ Drive/Rally"
    alias vcrypt='/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text'
fi

# GIT
alias g='git'
alias gp='git pull'
alias gu='git push'
alias gs='git status'
alias gd='git diff'
alias gdw='git diff --color-words'
alias gdd='git -c core.pager="delta --dark" diff'
alias gbranchclean='git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'
# alias gpsm='git pull --recurse-submodules'
# alias gsubp='git submodule foreach git pull origin master'


# GREP and RG (ripgrep) and FZF
alias f="fzf"
alias grep='grep --colour=always'
alias rgst='rg -tscala'
alias rgs="rg -tscala -g '!it/' -g '!test/'"
alias fp="fzf --preview 'bat --style=numbers --color=always {} | head -500'"
alias fph="fzf --preview 'bat --style=numbers --color=always {} | head -500' --height 100%"
alias fe="export | fzf"
alias fs="saf | fzf"
alias fsn="safn | fzf"
# TODO: sourcing aliases works, but calling the alias after fails
# alias fsp='safn | fzf --preview "source ~/rams_dot_files/shell_aliases.sh; source ~/rams_dot_files/shell_functions.sh; \
alias fsp='safn | fzf --preview "source ~/rams_dot_files/shell_aliases.sh; ssf; \
           which {} | bat --style=numbers --color=always -l bash"'

# Go
alias gosr='cd ~/go/src'
alias gosrghub='cd ~/go/src/github.com'
alias gosrstdlib='cd ~/go/src/github.com/golang/go'

#POSTGRES
alias lpsql='PAGER=$(psql_pager) /usr/local/Cellar/libpq/12.2_1/bin/psql'
alias psqlless='PAGER=less LESS="-iMSx4 -FX" psql'
#alias psqlvim='PAGER=~/vimpager.sh psql'
alias watchdbsizes="watch 'psql -c \"SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;\" -d postgres'"
alias getdbsizes='psql -c "SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;" -d postgres'
alias postgrecon='sudo -u postgres psql'
