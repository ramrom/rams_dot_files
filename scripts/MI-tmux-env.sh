#!/bin/bash
tmux new-session -d -s MIenv
 
tmux new-window -t MIenv:1 -n 'admin'
tmux new-window -t MIenv:2 -n 'irb'
tmux new-window -t MIenv:3 -n 'tlocDB'
tmux new-window -t MIenv:4 -n 'DB'
tmux new-window -t MIenv:5 -n 'logs'
tmux new-window -t MIenv:6 -n 'logs'
tmux new-window -t MIenv:7 -n 'code'
tmux new-window -t MIenv:8 -n 'code'
tmux new-window -t MIenv:9 -n 'code'

tmux select-window -t MIenv:0
tmux -2 attach-session -t MIenv
