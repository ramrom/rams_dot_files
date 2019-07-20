#!/bin/bash

# horsize=`tput cols`    # how to obtain width/columns of terminal window/pane
# vertsize=`tput lines`   # how to obtain height/rows of terminal window/pane

tmux new-session -d -s ram
tmux select-pane -T 'admin'
tmux split-window -h
tmux select-pane -T 'admin'

tmux new-window -t ram:1 -n 'admin'
tmux split-window -h
tmux select-pane -T 'admin'

tmux new-window -t ram:2 -n 'admin'
tmux split-window -h
tmux select-pane -T 'admin'
