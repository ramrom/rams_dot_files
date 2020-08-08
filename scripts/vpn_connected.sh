#!/bin/sh

if [ "$(uname)" = "Darwin" ]; then
    ifconfig | grep "^gpd0.*<UP" && echo "VPN"
fi
