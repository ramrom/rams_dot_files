#Bash functions

function private_data() {
  echo $(cat ~/.creds/enova_creds | grep $1 | awk '{print $2}')
}

function apipfprod { http --auth-type=api-auth --auth=$(private_data portfolio_user):$(private_data portfolio_pass) $@; }
function apiidprod { http --auth-type=api-auth --auth=$(private_data identity_user):$(private_data identity_pass) $@; }
function apipgsprod { http --auth-type=api-auth --auth=$(private_data pgs_user):$(private_data pgs_pass) $@; }
function apipfprodpost { http --auth-type=api-auth --auth=$(private_data portfolio_user):$(private_data portfolio_pass) -f POST $@; }

function apidev { http --auth-type=api-auth --auth=dev:dev $@; }

function fullpath() {
      ruby -e '
        $stdin.each_line { |path| puts File.expand_path path }  if ARGV.empty?
        ARGV.each { |path| puts File.expand_path path }         unless ARGV.empty?
      ' "$@"
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

f_findpat()
{
  find . -type f | xargs 2>&1 grep $1 | grep -v "No such file or directory"
}

f_getbranchname()
{
  git branch | grep "*" | awk '{print $2}'
}

#netcredit

nc_db_rebuild()
{
  [ -z "$EIGHTBOXHOME" ] && EIGHTBOXHOME=netcredit
  pushd .
  pgrestart
  for i in account_home acquisition identity mef portal portfolio postal_service pgs helios leads
  do
    cd ~/$EIGHTBOXHOME/apps/$i
    echo "*** RESETTING DB for $i ***"
    be rake db:reset
    echo "*** MIGRATING DB for $i ***"
    be rake db:migrate 
    echo ""
  done
  cd ~/netcredit/apps/pgs
  echo "*** RESETTING, MIGRATING, AND SEEDING DB for test $i ***"
  RAILS_ENV=test_rebuild be rake db:reset
  RAILS_ENV=test_rebuild be rake db:migrate
  RAILS_ENV=test_rebuild be rake db:seed
  popd
}

nc_bundle_install()
{
  pushd .
  for i in account_home acquisition identity mef moriarty pgs portal portfolio postal_service helios leads
  do
    cd ~/netcredit/apps/$i
    bundle install
  done
  popd
}

nc_git_reset()
{
  pushd .
  for i in account_home acquisition identity mef moriarty pgs portal portfolio postal_service helios
  do
    echo "*** RESETTING GIT REPO FOR APP $i ***"
    cd ~/netcredit/apps/$i
    git reset --hard &
  done
  popd
}

nc_git_fetch()
{
  pushd .
  for i in account_home acquisition identity mef moriarty pgs portal portfolio postal_service helios leads colossus
  do
    echo " " 
    echo "*** FETCHING REPOS FOR APP $i ***"
    cd ~/netcredit/apps/$i
    git fetch --all &
  done
  popd
}

nc_git_force_checkout_branch()
{
  pushd .
  for i in account_home acquisition identity mef moriarty pgs portal portfolio postal_service
  do
    cd ~/netcredit/apps/$i
    echo "*** CHECKOUT OUT BRANCH NAME $1 ***"
    git checkout $1
  done
  popd
}

nc_git_update_current_branch()
{
  pushd .
  for i in account_home acquisition identity mef moriarty pgs portal portfolio postal_service helios leads
  do
    cd ~/netcredit/apps/$i
    BRANCH_NAME=`f_getbranchname`
    echo "*** MERGING REMOTE BRANCH $BRANCH_NAME FOR APP $i ***"
    git merge origin/$BRANCH_NAME
  done
  popd
}

nc_git_pull()
{
  pushd .
  for i in account_home acquisition identity mef moriarty pgs portal portfolio postal_service helios
  do
    echo "*** PULLING BRANCH FOR APP $i ***"
    cd ~/netcredit/apps/$i
    git pull
  done
  popd
}

nc_branch_names()
{
  pushd .
  echo "*** BRANCH NAMES: ***"
  for i in account_home acquisition identity mef moriarty pgs portal portfolio postal_service helios
  do
    cd ~/netcredit/apps/$i
    echo "$i: $(git branch | grep "*" | awk '{print $2}')"
  done
  popd
}

nc_clean_branches()
{
  
  pushd . > /dev/null
  for i in account_home acquisition identity mef moriarty pgs portal portfolio postal_service helios
  do
    cd ~/netcredit/apps/$i
    clean=$(git diff | wc -l)
    test $clean -ne 0 && echo $i NOT CLEAN WORKING DIRECTORY
  done
  cd ~/netcredit
  clean=$(git diff | wc -l)
  test $clean -ne 0 && echo netcredit base repo NOT CLEAN WORKING DIRECTORY
  cd ~/netcredit/tests/staging_tests
  clean=$(git diff | wc -l)
  test $clean -ne 0 && echo staging tests NOT CLEAN WORKING DIRECTORY
  popd > /dev/null
}

#ncj () {
#  pushd ~/netcredit/gems/nconjure >/dev/null
#  bundle exec bin/nconjure $@
#  popd >/dev/null
#}

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

function get_prod_dump() {
  pushd .
  cd ~/netcredit/dbs
  pg_dump -Fc -U smittapalli -h proddb-${1}.netcredit.com ${1}_prod_nc --exclude-schema=pgq_node --exclude-schema=londiste --exclude-schema=pgq_ext --exclude-schema=to_delete --exclude-schema=_nc_portal_reporting --exclude-schema=_portfolio_reporting --exclude-table=backfill_config --exclude-table=backfill_config_id_seq --exclude-table=bankruptcy_filing_statuses_bankruptcy_filing_status_id_seq > ${1}_prod_snapshot_`date +%m_%d_%Y`.pgdump
  popd > /dev/null
}

function load_prod_dump_old() {
  psql -c "drop database ${1}_prod_snapshot_`date +%m_%d_%Y`" -d postgres
  psql -c "create database ${1}_prod_snapshot_`date +%m_%d_%Y`" -d postgres
  psql -d ${1}_prod_snapshot_`date +%m_%d_%Y` < ${1}_prod_snapshot_`date +%m_%d_%Y`.sql
}

function load_prod_dump() {
  psql -c "drop database ${1}_prod_snapshot_`date +%m_%d_%Y`" -d postgres
  psql -c "create database ${1}_prod_snapshot_`date +%m_%d_%Y`" -d postgres
  pg_restore --jobs=4 -d ${1}_prod_snapshot_`date +%m_%d_%Y` ${1}_prod_snapshot_`date +%m_%d_%Y`.pgdump
}

function terminate_db_connections() {
  psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${1}' AND pid <> pg_backend_pid()" -d postgres
}

function staging_db() {
  psql -U netcredit_${1} -h netcredit-db-stg01.nut.cashnetusa.com
}

function tagncenv() {
  pushd .
  echo " ******* will tag in netcredit, netcredit/apps, netcredit/gems, and each app dir *******"
  cd ~/netcredit
  ctags -R --exclude=*log --exclude=*.js --exclude=*.html --exclude=dbs *
  cd ~/netcredit/apps
  ctags -R --exclude=*log --exclude=*.js --exclude=*.html --exclude=dbs *
  cd ~/netcredit/gems
  ctags -R --exclude=*log --exclude=*.js --exclude=*.html --exclude=dbs *
  for app in account_home acquisition identity mef moriarty pgs portal portfolio postal_service helios
  do
    cd ~/netcredit/apps/${app}
    ctags -R --exclude=*log --exclude=*.js --exclude=*.html *
  done
  popd > /dev/null
}

function movecoreapppowlink() {
  APP=$1
  APP_NUM=$2
  pushd .
  cd ~/.pow
  rm ${APP}.enova
  ln -s ~/8b/apps/${APP}${APP_NUM} ${APP}.enova
  popd > /dev/null
}

function movenetcreditapppowlink() {
  APP=$1
  APP_NUM=$2
  pushd .
  cd ~/.pow
  rm ${APP}.netcredit
  APPUNDERSCORED=$(echo ${APP} | sed -e 's/-/_/g')
  ln -s ~/8b/brands/netcredit/${APPUNDERSCORED}${APP_NUM} ${APP}.netcredit
  popd > /dev/null
}

function parse_comma_delim_error() {
  local str="File.write(\"${1}\", File.read(\"${1}\").split(',').join(\"\\n\"))"
  ruby -e "$str"
}
