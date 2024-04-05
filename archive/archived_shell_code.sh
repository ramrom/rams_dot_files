# POSTGRES
# get a proddump
path=(/usr/local/opt/postgresql-9.1/bin $path)
timestamp=$(date '+%Y-%m-%d__%H:%M:%S')
filename="${appname}-snapshot-${timestamp}.pgdump"

pg_dump --verbose -Fc -U foouser -h proddb-${appname}.foobar.com \
--exclude-schema pgq_ext \
--exclude-schema londiste \
--exclude-schema pgq_node \
${appname}_prod_nc > foodump

# load a prod dump
psql -c "drop database foo" -d postgres
psql -c "create database foo" -d postgres
pg_restore --jobs=4 -d foo foopgdump


# LESS
## make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

if [ -f ~/.lessfilter ]; then
    export LESS='-R'
    export LESSOPEN='|~/.lessfilter %s'
fi


# ALIASES
alias pgstart="sudo /etc/init.d/postgresql start"
alias pgstop="sudo /etc/init.d/postgresql stop"
alias pgstopnow="sudo /etc/init.d/postgresql stop"
alias pgrestart="sudo /etc/init.d/postgresql restart"
if [ `uname` = "Darwin" ]; then
  alias pgstart="pg_ctlcluster 9.4 main start"
  alias pgstop="pg_ctlcluster 9.4 main stop"
  alias pgstopfast="pg_ctlcluster 9.4 main stop -m fast"
  alias pgrestart="pgstopfast && pgstart"

  if [ `hostname` = "vex" ] || [ `hostname` = "vex.local" ] || [ `hostname` = "vex.enova.com" ]; then
    alias pgstart="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/logfile start"
    alias pgstop="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/logfile stop"
    alias pgstopfast="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/logfile -m fast stop"
  fi
fi

# RUBY
alias be="bundle exec"
alias ber="bundle exec rspec"
alias bi="bundle install"

# apr'24 - use readlink instead
function fullpath() {
    ruby -e '
        $stdin.each_line { |path| puts File.expand_path path }  if ARGV.empty?
        ARGV.each { |path| puts File.expand_path path }         unless ARGV.empty?
    ' "$@"
}

# BASHRC RUBY
if [ -d ~/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

CHRUBY_FILE=/usr/local/share/chruby/chruby.sh
if [ -f "$CHRUBY_FILE" ]; then
  source $CHRUBY_FILE
  source /usr/local/share/chruby/auto.sh
fi


# MEMCACHED, REDIS
alias memcachestop='sudo /etc/init.d/memcached stop'
alias memcachestart='sudo /etc/init.d/memcached start'
alias memcacherestart='sudo /etc/init.d/memcached restart'

alias startredis='/usr/local/bin/redis-server'


# LOGS
alias tailpuma='cd ~/Library/Logs && tail -f puma-dev.log'
alias pumastatus='http -v localhost/status Host:puma-dev'
