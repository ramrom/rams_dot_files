#!/bin/sh

if [ "$(uname)" = "Darwin" ]; then
    df -h | grep disk2 > /dev/null && echo "DISK2-MOUNT"
fi
