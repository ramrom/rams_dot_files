#!/bin/sh

df -h | grep "$1" > /dev/null && echo "$2"
