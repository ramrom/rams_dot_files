# TMUX
- good cheatsheet: https://tmuxcheatsheet.com/
- good list of plugins/tech around it: https://github.com/rothgar/awesome-tmux
- in copymode
    - space starts selection(or reset it), enter to end/copy it
    - esc cancels selection, still in copy mode
- ctrl-] to paste clipboard
- tmux new session is 80x25:
    - https://www.reddit.com/r/tmux/comments/7i9dd2/tmux_resizepane_sizes_are_wrong_after_updating_to/
- tmux set -u option   - will unset that option
- tmux @foo are called user options
- tmux set status-left "#(executable #{@foo})"
    - pass tmux var @foo as arg to executable
- #(blah) is execute every time, $(blah) is single sub
- tmux set -qg @foo "something"
    - -g makes this global to all sessions
- tmux has buffers (like vim registers), when u copy in copy mode it goes in buffer
    - `tmux list-buffers` will show content of buffers
- tmux info - get detailed info about terminal capabilities
- tmux list-keys
    - show keybindings
    - NOTE: 3.1 and above, "?" does not show all keybindings...
- 2 methods to multi-key bindings: https://stackoverflow.com/questions/25294283/bindings-with-key-sequences
- change to a preset layout: `tmux select-layout even-horizontal`
- any program running in a pane will be a child process of that panes' PID

## COMMANDS
```tmux
# new window takes a manual shell command to run, zsh -f will start zsh shell with no rc files loaded
tmux new-window zsh -f
```

## RUNNING SHELL COMMAND ON A TMUX HOOK
- `tmux set-hook pane-focus-out 'run-shell "echo hi >> ~/foo"'`
- expanded using FORAMTS before execution
- can use -b to run in background

## SHOW OPTS
```sh
tmux show -s    # show server options
tmux show       # show session options
tmux show -g    # show global session options
tmux showw      # show window options
tmux showw -g   # show global window options
tmux show -p    # show pane options
```

## DISPLAY MENU
- `tmux display-menu -x S foomenu a "display-message hello" bar b "display-message world"`
    - will display 2 item menu, hit "a" or "b" as valid inputs

## CLIENTS
- `tmux list-clients -t some_session`      # show clients
- prefix + D                               # show client list, and basically detach the rest
- `tmux switch-client -t some_session`     # attach current client to a session

good resource on condition version checks in tmux conf file:
- https://stackoverflow.com/questions/35016458/how-to-write-if-statement-in-tmux-conf-to-set-different-options-for-different-t
    - it also details the changes, breaking changes, with increasing versions

## KEYBINDINGS
- parsing syntax: (see docs) - semilcolon is command seperator
    - binding with multiple commands needs a `\;`, an escaped semicolon to seperate 2 commands
- prefix + ?  - show the default key bindings
- prefix + S  - swap windows
- prefix + y  - swap panes
- prefix + D  - disconnect clients
- prefix + ! - promote current active pane to become a window
