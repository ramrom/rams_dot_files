#!/bin/bash
tmux new-session -d -s EBenv
tmux split-window -h
tmux new-window -t EBenv:1 -n admin
tmux split-window -h 'sudo htop'
tmux new-window -t EBenv:2 -n irb
tmux send-keys 'pf && be rails c' C-m
tmux split-window -h
tmux new-window -t EBenv:3 -n DB
tmux send-keys 'cd ~/RamsEnovaEnvFiles/pg_queries && psql' C-m
tmux split-window -v 
tmux resize-pane -D 16
tmux send-keys 'cd ~/RamsEnovaEnvFiles/pg_queries && vi temp.sql' C-m
tmux new-window -t EBenv:4 -n DB
tmux send-keys 'cd ~/RamsEnovaEnvFiles/pg_queries' C-m
tmux split-window -v
tmux resize-pane -D 16
tmux send-keys 'cd ~/RamsEnovaEnvFiles/pg_queries' C-m
tmux new-window -t EBenv:5 -n logs
tmux send-keys 'pf && ebtailpfs' C-m
tmux split-window -v
tmux send-keys 'iden && tail -f log/development.log' C-m
tmux split-window -h
tmux send-keys 'portal && tail -f log/development.log' C-m
tmux new-window -t EBenv:6 -n code
tmux send-keys 'pf' C-m
tmux split-window -h
tmux new-window -t EBenv:7 -n code
tmux split-window -h
tmux new-window -t EBenv:8 -n code
tmux split-window -h
tmux new-window -t EBenv:9 -n code
tmux split-window -h
tmux new-window -t EBenv:10 -n code
tmux send-keys 'helios && ./helios' C-m
tmux split-window -h
tmux new-window -t EBenv:11 -n code
tmux send-keys 'wud && vi -S doc.vim' C-m
tmux split-window -h
tmux send-keys 'wud' C-m
tmux new-window -t EBenv:12 -n code
tmux split-window -h
tmux new-window -t EBenv:13 -n code
tmux split-window -h
tmux new-window -t EBenv:14 -n code
tmux split-window -h
tmux new-window -t EBenv:15 -n code
tmux split-window -h


tmux select-window -t EBenv:1
# tmux select-pane -t EBenv:1.1  # Not Working :(
tmux -2 attach-session -t EBenv
