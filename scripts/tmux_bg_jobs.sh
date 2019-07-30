#!/bin/bash

# TODO: i source this func file and "typeset -F | wc -l", much less # of funcs than in file...
#source ~/rams_dot_files/.bash_functions
#typeset -F | wc -l

pane_pids=$(tmux list-panes -F "#{pane_pid}")
for pane_pid in $pane_pids; do
    # -P returns child PIDs of given PID, pgrep returns 1 exit code if no children found
    child_procs=$(pgrep -P $pane_pid)
    for child in $child_procs; do
        # a ps status without a "+" should mean it's running in the background
        if [ ! $(ps -o stat= $child | grep -E "\+") ]; then 
            echo BJOBS
        fi
    done
done