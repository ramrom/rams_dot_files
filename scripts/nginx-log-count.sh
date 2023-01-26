#!/bin/sh

# count # of log lines in the last x minutes

# error log format:     `2023/01/25 15:37:07`
# access log format:    `45.93.16.27 - - [25/Jan/2023:19:04:51 -0600]`

usage () { echo 'Usage: nginx-log-count [ -h(help) ] [ -v(verbose) ] [ -e(error log) ]'; }

interval=300  # default to 5minutes
LOG_TYPE=access
log_file=/var/log/nginx/access.log

while getopts 'hev' x; do
    case $x in
        h) usage && exit 1 ;;
        v) VERBOSE=1 ;;
        e) LOG_TYPE="error" ;;
        *) usage && exit 1 ;;
    esac
done
shift $(($OPTIND - 1))

[ "$LOG_TYPE" = "error" ] && log_file="/var/log/nginx/error.log"

num_lines=$(cat $log_file | wc -l)
[ -n "$VERBOSE" ] && echo "num lines in log file:  ${num_lines}"

month=$(date '+%b')
day=$(date '+%d')
hour=$(date '+%H')  # 24 hour format

if [ "$LOG_TYPE" = "error" ]; then
    latest_log_dt=$(tail -1 ${log_file} | awk '{print $1" "$2}')
else
    # TODO: how to deal with timezone
    latest_log_dt=$(tail -1 ${log_file} | awk '{print $4}' | cut -c 2-)
fi

[ -n "$VERBOSE" ] && echo "last log timestamp: $latest_log_dt"

diff=$(( $(date +%s) - $(date +%s -d"$latest_log_dt") ))

line_step_size=20
echo $diff
