#!/bin/sh

exec 3>&1
exec 4>&1

# (tail -f file1|......) 1>&3

(for a in $(seq 1 5); do echo "a $a" && sleep 1; done) 1>&3 &
(for b in $(seq 1 5); do echo "b $b" && sleep 1; done) 1>&4
