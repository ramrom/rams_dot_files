#!/bin/bash

# setopt NO_NOMATCH  #needed if this was zsh

# TODO: tput cols x lines with tput reports 80 x 25, the default, in reality i have it set to 135
# NOTE: could call `tmux list-windows -t session_name`, and extract the dimenisons
# tmux set status-format[1] "#[align=left,fg=red]#(tput cols; tput lines)"

# TODO: separate tmux funcs in this file into seperate scripts and source here
source ~/rams_dot_files/shell_functions.sh

# s=$(tmux display-message -p '#S')
# tmux list-windows -F "#{window_width}" -t $s 2>&1
# width=$(tmux list-windows -F "#{window_width}" 2>&1 | head -n 1)

# 2520 is least common multiple of all integers from 1-10
counter=$(tmux show -v @status-bar-interval-counter)
tmux set -q @status-bar-interval-counter $(( ($counter + 1) % 2520 ))

# foo=$(tmux_render_timer_bar eggs)
cpu=$(tmux_percent_usage_color $(uptime_loadave))
status_line1="Uptime 1min %%:$cpu"
if [ "$(uname)" == "Linux" ]; then
    s=$(sensors)
    cputmp=$(echo "$s" | grep -E "CPU Temperature" | awk '{print $3;}') # | grep --color=never -Eoi '[0-9]+.[0-9]+'
    cpufan=$(echo "$s" | grep -E "CPU Fan" | awk '{print $3;}') # | grep --color=never -Eoi '[0-9]+.[0-9]+'
    status_line1="$status_line1  CPU-Temp: #[fg=green]$cputmp#[default]  CPU-Fan: #[fg=green]$cpufan#[default]"
fi
tmux set status-format[1] "$status_line1"

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
