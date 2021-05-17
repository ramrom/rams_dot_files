#!/bin/sh

if [ "$(uname)" = "Darwin" ]; then
    ifconfig | grep "^utun2.*<UP" && echo "VPN"
fi
