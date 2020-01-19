alias svi='vim -u ~/.vimrc_simple'
alias ssvi='vim -u NONE'
alias vina='NO_AUTOREAD=1 vi'
alias ls='ls -CF'
alias ll='ls -l'
alias la='ls -A'
alias lal='ls -al'
alias lahl='ls -alh'
alias lrt='ls -lrt'
alias grep='grep --colour=always'
alias killalljobs='kill $(jobs -p)'
alias fxg='find . -type f | xargs grep'
alias dubydir='du -sh *'
alias findlargefiles='sudo find -X . -type f -size +1M | xargs du -sh'
alias rrc='source ~/.bash_profile && source ~/.bashrc'
alias ch_date='sudo date --set 1998-11-02'
alias httpv='http -v'
alias httpcn='httpv http://api.icndb.com/jokes/random'
alias ctag_create='ctags -R --exclude=*log --exclude=*.js --exclude=*.html --exclude=dbs --exclude=*.vim *'
alias list_functions='typeset -F'
alias lsoftcplisten='lsof -iTCP -sTCP:LISTEN'
alias netcatlisten9001='nc -l 127.0.0.1 9001' #listen on 9001
alias osxfusentfs='sudo /usr/local/bin/ntfs-3g /dev/disk2s1 /Volumes/rambackupfourtb -olocal -oallow_other'
alias rsyncprog='rsync -avzh --progress'               # -a archive sets -t preserve timestamps for checking changes
alias rsyncchecksum='rsync -vzh --checksum --progress' #uses checksum for checking changes
alias rysncdryrun='rsync -rv --size-only --dry-run /my/source/ /my/dest/ > diff.out'
alias smbcl='smbclient //192.168.1.1/Backups -U admin'
alias mntcifssmb='sudo mount -t cifs //192.168.1.1/Backups ~/smbhd -o username=dude,password=werd'
alias mntntfslinux='sudo mount -t ntfs -o nls=utf8,umask=0222 /dev/sdb1 /media/windows'
alias mntosxsamba='mount_smbfs //admin@192.168.1.1/Backups mynfs'
alias vcrypt='/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text'

alias nvmetemp='sudo nvme smart-log /dev/nvme0n1 | grep temp'

# neat trick, running aliases as sudo fails as root doesnt have them defined
# bash only looks for first word to alias expand, but if word is alias, it expands subsequent words
alias sudo='sudo '

if [ "$TERM" != "dumb" ]; then
    #TODO: zsh doesnt like == here
    if [ `uname` == "Linux" ]; then
        eval "`dircolors -b`"
        alias ls='ls --color=auto'
        alias rgrep='rgrep --color=auto'
        alias egrep='egrep --color=auto'
        alias netstatip='sudo netstat -lpnut'
        alias iorealtime='iostat -x -d 1'      #show ext stats, device util, every 1 second'
        alias psx='ps auxf'
        alias psxfull='ps auxhfww'
    else  # assuming Darwin here
        alias iorealtime='iostat -w 1'      #show ext stats, device util, every 1 second'
        alias psx='ps auxh'
        alias ls='ls -CFG'
        alias gl="cd ~/Google\ Drive/Lists"
        alias gr="cd ~/Google\ Drive/Rally"
    fi
fi
# Logs
# alias tailpuma='cd ~/Library/Logs && tail -f puma-dev.log'
# alias pumastatus='http -v localhost/status Host:puma-dev'

# GIT
alias gp='git pull'
alias gpsm='git pull --recurse-submodules'
alias gsubp='git submodule foreach git pull origin master'
alias gs='git status'
alias gd='git diff'
alias gitconfigs='echo ""; git config --system --list; echo ""; git config --global --list; echo ""; git config --local --list'
alias gbranchclean='git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'
alias gaddallcmt="git add . && pgit commit -m 'added stuff!'"

# ACK
# TODO: Maybe replace ack aliases with using .ackrc
if [ `uname` = "Linux" ]; then
  alias ack='ack-grep'
fi
#alias ackn='ack --ignore-dir=docs --ignore-dir=coverage --ignore-dir=tmp --ignore-dir=features --ignore-dir=spec --ignore-dir=exspec --ignore-file=match:/\.log$/ --ignore-file=match:/\.sql$/ --ignore-file=match:/tags/'
#alias acknt='ack --ignore-dir=docs --ignore-dir=coverage --ignore-dir=tmp --ignore-file=match:/\.log$/ --ignore-file=match:/\.sql$/ --ignore-file=match:/tags/'
alias acks='ack --ignore-dir=docs --ignore-dir=coverage --ignore-dir=tmp --ignore-dir=target --ignore-dir=test --ignore-file=match:/\.log$/ --ignore-file=match:/\.sql$/ --ignore-file=match:/tags/ --ignore-file=match:/\.xml$/ --ignore-file=match:/\.html$/ --ignore-file=match:/\.vim$/'
alias ackst='ack --ignore-dir=docs --ignore-dir=coverage --ignore-dir=tmp --ignore-dir=target --ignore-file=match:/\.log$/ --ignore-file=match:/\.sql$/ --ignore-file=match:/tags/ --ignore-file=match:/\.xml$/ --ignore-file=match:/\.html$/ --ignore-file=match:/\.vim$/'


#remote connections
alias rdpvision='rdesktop -u ramrom ramrom.hopto.org'
alias sshvision='ssh ramrom@192.168.1.102'
alias sshfsvortexB='sshfs RemoteUser@vortex:/cygdrive/b vortexB/ -oauto_cache,reconnect,defer_permissions'
alias fusemounts='mount -t fuse4x'

# Go
alias gosr='cd ~/go/src'
alias gosrghub='cd ~/go/src/github.com'
alias gosrstdlib='cd ~/go/src/github.com/golang/go'

# Ruby
alias be="bundle exec"
alias ber="bundle exec rspec"
alias bi="bundle install"

#POSTGRES
alias lpsql='PAGER=$(psql_pager) /usr/local/Cellar/libpq/11.3/bin/psql'
alias psqlless='PAGER=less LESS="-iMSx4 -FX" psql'
#alias psqlvim='PAGER=~/vimpager.sh psql'
#alias psqlp='PAGER=$(psql_pager) psql'
alias watchdbsizes="watch 'psql -c \"SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;\" -d postgres'"
alias getdbsizes='psql -c "SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;" -d postgres'
alias postgrecon='sudo -u postgres psql'
# alias pgstart="sudo /etc/init.d/postgresql start"
# alias pgstop="sudo /etc/init.d/postgresql stop"
# alias pgstopnow="sudo /etc/init.d/postgresql stop"
# alias pgrestart="sudo /etc/init.d/postgresql restart"
# if [ `uname` = "Darwin" ]; then
#   alias pgstart="pg_ctlcluster 9.4 main start"
#   alias pgstop="pg_ctlcluster 9.4 main stop"
#   alias pgstopfast="pg_ctlcluster 9.4 main stop -m fast"
#   alias pgrestart="pgstopfast && pgstart"
#
#   if [ `hostname` = "vex" ] || [ `hostname` = "vex.local" ] || [ `hostname` = "vex.enova.com" ]; then
#     alias pgstart="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/logfile start"
#     alias pgstop="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/logfile stop"
#     alias pgstopfast="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/logfile -m fast stop"
#   fi
# fi

# Memcached, Redis
# alias memcachestop='sudo /etc/init.d/memcached stop'
# alias memcachestart='sudo /etc/init.d/memcached start'
# alias memcacherestart='sudo /etc/init.d/memcached restart'

# alias startredis='/usr/local/bin/redis-server'
