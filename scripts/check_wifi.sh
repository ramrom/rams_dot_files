#!/bin/sh

# TODO: make faster, hyperfine has it run in 30ms
get_wifi_ssid () {
    if [ "$(uname)" = "Darwin" ]; then
        local wifi_info=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I)
        echo "$wifi_info" | awk -F: '/ SSID/{print $2}' | sed 's/ //g'
    fi
}

laptop_wifi_ssid=$(get_wifi_ssid)

[ "$laptop_wifi_ssid" = "jaala" ] && echo "BADWIFI"       # should use 5g
echo "$laptop_wifi_ssid" | grep "uest" && echo "BADWIFI"  # if on Guest network
