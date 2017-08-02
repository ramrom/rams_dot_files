#!/bin/bash

DB_NAME='merge_mef_portfolio'

pg_dump mef_development > /tmp/mef_development_tmp.txt
pg_dump netcredit_portfolio_development > /tmp/netcredit_portfolio_development_tmp.txt
psql -U postgres -c "DROP DATABASE $DB_NAME"
psql -U postgres -c "CREATE DATABASE $DB_NAME"
psql $DB_NAME < /tmp/mef_development_tmp.txt > /tmp/mergeoutput.log 2>&1
psql $DB_NAME < /tmp/netcredit_portfolio_development_tmp.txt >> /tmp/mergeoutput.log 2>&1
