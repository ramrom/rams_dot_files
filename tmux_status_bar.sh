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
cpu=$(skip_verify=1 tmux_percent_usage_color $(uptime_loadave) "uptimeload")
status_line1="Uptime 1min:$cpu"
if [ "$(uname)" == "Linux" ]; then
    s=$(sensors)
    cpufan=$(echo "$s" | grep -E "CPU Fan" | awk '{print $3;}') # | grep --color=never -Eoi '[0-9]+.[0-9]+'
    cputemp=$(echo "$s" | grep -E "CPU Temperature" | awk '{print $3;}')
    cputemp_num=$(echo $cputemp | sed 's/+//g' | grep --color=never -Eo '^[0-9]+')
    cputemp_color=$(tmux_temp_color $cputemp_num)
    status_line1="$status_line1  CPU-Temp: #[fg=green]$cputemp_color#[default]C CPU-Fan: #[fg=green]$cpufan#[default] |"

    # GPU stats
    stats=$(linux_nvidia)
    gpu_temp=$(echo $stats | awk '{print $3}' | sed 's/.$//')
    gputemp_color=$(tmux_temp_color $gpu_temp)

    gpu_mem=$(echo $stats | awk '{print $9 $10 $11}')
    # gpu_mem_used=$(echo $stats | awk '{print $9}' | sed 's/...$//g')
    # gpu_mem_used_col="#[fg=colour111]$gpu_mem_used#[default]"
    # gpu_mem_total=$(echo $stats | awk '{print $11}' | sed 's/...$//g')
    # gpu_mem_total_col="#[fg=colour111]$gpu_mem_total#[default]"

    gpu_fan=$(echo $stats | awk '{print $2}' | sed 's/.$//g')
    gpu_fan_color=$(tmux_percent_usage_color $gpu_fan "gpu fan")

    gpu_util=$(echo $stats | awk '{print $13}' | sed 's/.$//')
    gpu_util_color=$(tmux_percent_usage_color $gpu_util "gpu util")

    gpu_legend_color=colour058
    status_line1="$status_line1 #[fg=$gpu_legend_color]GPU-Temp:#[default] #[fg=green]$gputemp_color#[default]C"
    status_line1="$status_line1 #[fg=$gpu_legend_color]GPU-Util:#[default]$gpu_util_color"
    status_line1="$status_line1 #[fg=$gpu_legend_color]GPU-Mem:#[default] $gpu_mem"
    status_line1="$status_line1 #[fg=$gpu_legend_color]GPU-Fan:#[default]$gpu_fan_color"
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
