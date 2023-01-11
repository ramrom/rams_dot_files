#/bin/sh

# takes a string pattern to grep and count events over a time period in linux auth.log

lastlog=$(tail -1 home-assistant.log)
# lastlog=$(tail -1 foo.log)
[ -z "$lastlog" ] && echo 0  # handle empty log file scenario

# home-assistant example log line
    # `2023-01-10 15:26:04.710 WARNING (MainThread) [homeassistant.helpers.entity] Update of media_player.un60f7100 is taking over 10 seconds`
timestamp=$(echo $lastlog | awk '{print $1" "$2}')

now=$(date +%s)
echo "lastlog: $lastlog"
echo "timestamp: $timestamp"
unixlog=$(echo $(date +%s -d"$timestamp"))
echo $(date -d @$(date +%s -d"$timestamp"))

echo ""
echo "unix now: $now"
echo "unix log: $unixlog"
echo "timediff: $(($now - $unixlog))"
