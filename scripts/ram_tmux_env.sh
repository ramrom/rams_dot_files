#!/bin/bash

# horsize=`tput cols`    # how to obtain width/columns of terminal window/pane
# vertsize=`tput lines`   # how to obtain height/rows of terminal window/pane
SESSION_NAME=ram
DOTFILE=~/rams_dot_files
GDRIVE=~/"Google Drive"

tmux has-session -t $SESSION_NAME
[ $? == 0 ] && echo "$(tput setaf 1) $SESSION_NAME session already exists!" && exit 1

tmux new-session -d -s $SESSION_NAME -c "$GDRIVE"
tmux select-pane -T 'admin'
tmux split-window -h -c "$GDRIVE"
tmux select-pane -T 'admin'

tmux new-window -t $SESSION_NAME:1 -n 'admin' -c "$DOTFILE"
tmux split-window -h -c "$DOTFILE"
tmux select-pane -T 'admin'

tmux new-window -t $SESSION_NAME:2 -n 'admin'
tmux split-window -h
tmux select-pane -T 'admin'

tmux select-window -t $SESSION_NAME:0
tmux -2 attach-session -t $SESSION_NAME
