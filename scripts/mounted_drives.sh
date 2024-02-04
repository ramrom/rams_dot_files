#!/bin/sh

usage() { echo "Usage: mounted_drives.sh [ -h(help) ] [ -i(invert) ]"; } 

while getopts 'hi' x; do
    case $x in
        h) usage && exit 1 ;;
        i) INVERSE=1 ;;
        *) echo && usage && exit 1 ;;
    esac
done
shift $(($OPTIND - 1))

if [ -z "$INVERSE" ]; then
    df -h | grep "$1" > /dev/null && echo "$2"
else
    df -h | grep "$1" > /dev/null || echo "$2"
fi
