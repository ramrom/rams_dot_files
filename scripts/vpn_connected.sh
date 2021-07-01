#!/bin/sh

if [ "$(uname)" = "Darwin" ]; then
    ifconfig | grep "^utun0.*<UP" && echo "VPN"
fi
