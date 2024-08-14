#!/bin/sh

# ps ax -o command= | grep -E "^ssh\sjump" > /dev/null && echo SSHLSTN
lsof -iTCP -sTCP:LISTEN | grep ssh > /dev/null && echo SSHLSN
lsof -iTCP -sTCP:LISTEN | grep kubectl > /dev/null && echo K8LSN
