#!/bin/sh

# setopt NO_NOMATCH  #needed if this was zsh

# TODO: tput cols x lines with tput reports 80 x 25, the default, in reality i have it set to 135
# tmux set status-format[1] "#[align=left,fg=red]#(tput cols; tput lines)"

#TODO: separate tmux funcs into seperate script of add here
source ~/rams_dot_files/shell_functions.sh

# s=$(tmux display-message -p '#S')
# tmux list-windows -F "#{window_width}" -t $s 2>&1
# width=$(tmux list-windows -F "#{window_width}" 2>&1 | head -n 1)

# 2520 is least common multiple of all integers from 1-10
counter=$(tmux show -v @status-bar-interval-counter)
tmux set -q @status-bar-interval-counter $(( ($counter + 1) % 2520 ))

foo=$(tmux_render_timer_bar eggs)
cpu=$(tmux_percent_usage_color $(cpu_usage))
tmux set status-format[1] "$foo    CPU-Usage:$cpu"

# if [ $(( $counter % 2 )) -eq 0 ]; then
#     tmux set status-format[1] "$(color=200 tmux_render_timer_bar eggs)"
#     # tmux set -a status-format[2] "*"
# fi

# if [ $(( $counter % 4 )) -eq 0 ]; then
#     tmux set -a status-format[3] "*"
# fi

# if [ $(( $counter % 8 )) -eq 0 ]; then
#     tmux set -a status-format[4] "*"
# fi
