#!/bin/bash
tmux new-session -d -s baseenv
 
tmux new-window -t baseenv:0 -n 'admin'
tmux new-window -t baseenv:1 -n 'admin'
tmux new-window -t baseenv:2 -n 'admin'
tmux new-window -t baseenv:3 -n 'admin'
tmux new-window -t baseenv:4 -n 'admin'

tmux select-window -t baseenv:0
tmux -2 attach-session -t baseenv
