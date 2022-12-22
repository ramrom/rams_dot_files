#/bin/sh

# $1 is dirpath to look for files
ls -al "$1" | grep "conflict" && echo "CLOUNDSYNC-CONFLICT"
