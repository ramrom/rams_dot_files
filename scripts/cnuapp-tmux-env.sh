#!/bin/bash
tmux new-session -d -s CNUAPPenv
 
tmux new-window -t CNUAPPenv:1 -n 'admin'
tmux new-window -t CNUAPPenv:2 -n 'admin'
tmux new-window -t CNUAPPenv:3 -n 'irb'
tmux new-window -t CNUAPPenv:4 -n 'psql'
tmux new-window -t CNUAPPenv:5 -n 'logs'
tmux new-window -t CNUAPPenv:6 -n 'code'
tmux new-window -t CNUAPPenv:7 -n 'code'
tmux new-window -t CNUAPPenv:8 -n 'code'
tmux new-window -t CNUAPPenv:9 -n 'code'

tmux select-window -t CNUAPPenv:1
tmux -2 attach-session -t CNUAPPenv
