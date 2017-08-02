#!/bin/bash
echo
echo "}}}current: \$PWD ==>"`pwd -P`
echo '}}}    Soft Link ==> '`ls -l /export/web | egrep "^l" | cut -d " " -f1,15-`
echo
sleep 1
sudo sv s /var/service/*
sudo sv d /var/service/*
sleep 1
sudo /etc/init.d/memcached stop
sudo /etc/init.d/cron stop
sleep 1
ps auxfh | grep sv
sleep 2
sudo killall runsvdir
sudo killall runsv
sleep 2
sudo sv d /var/service/*
sleep 2
sudo sv s /var/service/*
sudo /etc/init.d/memcached start
sudo /etc/init.d/cron start
sleep 1
sudo sv u /var/service/space
sleep 1
sudo sv u /var/service/lsws
sleep 1
sudo sv u /var/service/*
sleep 1
sudo sv s /var/service/*
sudo ps -ef | grep memcached
