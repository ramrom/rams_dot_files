#!/bin/bash
# put this script in the share/git-core/templates/hooks dir for global git
MAX_OFFSET="0.01"
TIMEDIFF=`ntpdate -q -u time.apple.com | head -n 1 | awk '{print $6}'`
TIMEDIFF=`echo ${TIMEDIFF%?}`

IS_IT_OFF='false'
IS_IT_OFF=`ruby -e 'puts "true" if ARGV[0].to_f.abs >= ARGV[1].to_f.abs' $TIMEDIFF $MAX_OFFSET`

if [ "$IS_IT_OFF" == "true" ]; then
  echo "git commit hook: sys clock is off by $TIMEDIFF, max allowed: $MAX_OFFSET"
  exit 1
fi 

exit 0
