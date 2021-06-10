#!/bin/sh

if [ "$(uname)" = "Darwin" ]; then
    df -h | grep "$1" > /dev/null && echo "$2"
fi
