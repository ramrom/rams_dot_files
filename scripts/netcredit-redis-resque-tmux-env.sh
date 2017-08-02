#!/bin/bash
tmux new-session -d -s NC-redisresq-env
 
tmux new-window -t NC-redisresq-env:0 -n 'admin'
tmux new-window -t NC-redisresq-env:1 -n 'admin'
tmux new-window -t NC-redisresq-env:2 -n 'account_home'
tmux new-window -t NC-redisresq-env:3 -n 'acquisition'
tmux new-window -t NC-redisresq-env:4 -n 'identity'
tmux new-window -t NC-redisresq-env:5 -n 'mef'
tmux new-window -t NC-redisresq-env:6 -n 'pgs'
tmux new-window -t NC-redisresq-env:7 -n 'portal'
tmux new-window -t NC-redisresq-env:8 -n 'portfolio'
tmux new-window -t NC-redisresq-env:9 -n 'postal_service'

tmux select-window -t NC-redisresq-env:0
tmux -2 attach-session -t NC-redisresq-env
