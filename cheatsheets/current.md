# CURRENT CHEATS
https://devhints.io/  (great reference for all types for developers)

## TMUX
prefix + S  - swap windows
prefix + y  - swap panes
prefix + D  - disconnect clients

## VIM
TIP: once a buffer autoreloads, you can still undo
ctrl-f - command mode, edit as if in normal mode
ctrl-w - insert mode and command mode, delete last word
ctrl-u - insert mode and command mode, delete from beg line to cursor
ctrl-r<i> - insert mode, insert from reg i
_       - goto first nonblank char on line
==      - auto indent current line

## EMACS
c-x c-c to quit

## HYPERFINE:
hyperfine -i 'uptime | grep foo' 'uptime'
    - yells if non-zero exit code, use -i to ignore, in this case grep didnt find "foo" and returns non-zero
