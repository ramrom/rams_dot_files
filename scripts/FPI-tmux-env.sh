#!/bin/bash
tmux new-session -d -s FPIenv
 
tmux new-window -t FPIenv:1 -n 'admin'
tmux new-window -t FPIenv:2 -n 'irb'
tmux new-window -t FPIenv:3 -n 'tlocDB'
tmux new-window -t FPIenv:4 -n 'DB'
tmux new-window -t FPIenv:5 -n 'FPIserv'
tmux new-window -t FPIenv:6 -n 'tloclogs'
tmux new-window -t FPIenv:7 -n 'logs'
tmux new-window -t FPIenv:8 -n 'code'
tmux new-window -t FPIenv:9 -n 'code'

tmux select-window -t FPIenv:0
tmux -2 attach-session -t FPIenv
