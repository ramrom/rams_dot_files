function kyle_get_prod_dump() {
#!/usr/bin/env zsh
  appname=$1
  if [[ $appname != "identity" && $appname != "portfolio" ]]; then
    echo "Usage: $0 {identity,portfolio}"
    exit 1
  fi

  path=(/usr/local/opt/postgresql-9.1/bin $path)
  timestamp=$(date '+%Y-%m-%d__%H:%M:%S')
  filename="${appname}-snapshot-${timestamp}.pgdump"

  pg_dump --verbose -Fc -U smittapalli -h proddb-${appname}.netcredit.com \
  --exclude-schema pgq_ext \
  --exclude-schema londiste \
  --exclude-schema pgq_node \
  --exclude-schema identity_reporting \
  --exclude-schema _identity_reporting \
  --exclude-schema portfolio_reporting \
  --exclude-schema _portfolio_reporting \
  ${appname}_prod_nc > ~/netcredit/dbs/${filename}
}

function get_prod_dump_old() {
  pushd .
  cd ~/netcredit/dbs
  pg_dump -U smittapalli -h proddb-${1}.netcredit.com ${1}_prod_nc --exclude-schema=pgq_node --exclude-schema=londiste --exclude-schema=pgq_ext > ${1}_prod_snapshot_`date +%m_%d_%Y`.sql
  popd > /dev/null
}

function load_prod_dump() {
  psql -c "drop database ${1}_prod_snapshot_`date +%m_%d_%Y`" -d postgres
  psql -c "create database ${1}_prod_snapshot_`date +%m_%d_%Y`" -d postgres
  pg_restore --jobs=4 -d ${1}_prod_snapshot_`date +%m_%d_%Y` ${1}_prod_snapshot_`date +%m_%d_%Y`.pgdump
}

# Aliases
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

# Memcached, Redis
alias memcachestop='sudo /etc/init.d/memcached stop'
alias memcachestart='sudo /etc/init.d/memcached start'
alias memcacherestart='sudo /etc/init.d/memcached restart'

alias startredis='/usr/local/bin/redis-server'

# Logs
alias tailpuma='cd ~/Library/Logs && tail -f puma-dev.log'
alias pumastatus='http -v localhost/status Host:puma-dev'
