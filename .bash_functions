#Bash functions
function fullpath() {
      ruby -e '
        $stdin.each_line { |path| puts File.expand_path path }  if ARGV.empty?
        ARGV.each { |path| puts File.expand_path path }         unless ARGV.empty?
      ' "$@"
}

function filenamediff() {
  diff <(cd $1; find . -type f) <(cd $2; find . -type f)
}

function f_findfilesbysize() {
  sudo find "$1" -type f -size +"$2" | xargs du -sh
}

function tabname {
  printf "\e]1;$1\a"
}

function winname {
  printf "\e]2;$1\a"
}

# GIT
f_getbranchname()
{
  git branch | grep "*" | awk '{print $2}'
}

# POSTGRES
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

function terminate_db_connections() {
  psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${1}' AND pid <> pg_backend_pid()" -d postgres
}

# OTHER
function parse_comma_delim_error() {
  local str="File.write(\"${1}\", File.read(\"${1}\").split(',').join(\"\\n\"))"
  ruby -e "$str"
}
