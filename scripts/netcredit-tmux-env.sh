#!/bin/bash
tmux new-session -d -s NCenv
 
tmux new-window -t NCenv:0 -n 'admin'
tmux new-window -t NCenv:1 -n 'admin'
tmux new-window -t NCenv:2 -n 'irb'
tmux new-window -t NCenv:3 -n 'DB'
tmux new-window -t NCenv:4 -n 'DB'
tmux new-window -t NCenv:5 -n 'logs'
tmux new-window -t NCenv:6 -n 'code'
tmux new-window -t NCenv:7 -n 'code'
tmux new-window -t NCenv:8 -n 'code'
tmux new-window -t NCenv:9 -n 'code'
tmux new-window -t NCenv:10 -n 'code'

tmux select-window -t NCenv:0
tmux -2 attach-session -t NCenv
