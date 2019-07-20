#!/bin/bash

# horsize=`tput cols`    # how to obtain width/columns of terminal window/pane
# vertsize=`tput lines`   # how to obtain height/rows of terminal window/pane
SESSION_NAME=ram
GDRIVE=~/"Google Drive"

tmux new-session -d -s $SESSION_NAME
tmux select-pane -T 'admin'
tmux split-window -h -c "$GDRIVE"
tmux select-pane -T 'admin'

tmux new-window -t $SESSION_NAME:1 -n 'admin' -c "$GDRIVE"
tmux split-window -h
tmux select-pane -T 'admin'

tmux new-window -t $SESSION_NAME:2 -n 'admin' -c "$GDRIVE"
tmux split-window -h
tmux select-pane -T 'admin'

tmux select-window -t $SESSION_NAME:0
tmux -2 attach-session -t $SESSION_NAME
