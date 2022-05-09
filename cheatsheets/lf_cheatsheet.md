# LF Cheatsheet
- "list files", TUI file explorer in golang (like ranger)
- docs: https://pkg.go.dev/github.com/gokcehan/lf
- lfrc example: https://github.com/gokcehan/lf/blob/master/etc/lfrc.example

- type `:` to run a lf command
- type `!` run shell command and show output and wait
- type `%` to run a shell command (pipe)
- type `&` to run a shell command in background

## BINDINGS
- w         open interactive $SHELL
- e         edit item with $EDITOR
- i         open with $PAGER
- <space>   toggle mark on item
- v         invert the marking in current dir
- u         unmark all
- c         clear cut/yank selections
- y         yank
- d         cut
- p         paste
- r         rename file
- t         tag a file
- m         create a bookmark
- '         load a bookmark
- unix                     windows
- cmd open &$OPENER "$f"   cmd open &%OPENER% %f%
- map e $$EDITOR "$f"      map e $%EDITOR% %f%
- map i $$PAGER "$f"       map i !%PAGER% %f%
- map w $$SHELL            map w $%SHELL%
- The following additional keybindings are provided by default:

- map zh set hidden!
- map zr set reverse!
- map zn set info
- map zs set info size
- map zt set info time
- map za set info size:time

- map sn :set sortby natural; set info
- map ss :set sortby size; set info size
- map st :set sortby time; set info time
- map sa :set sortby atime; set info atime
- map sc :set sortby ctime; set info ctime
- map se :set sortby ext; set info
- map gh cd ~
- map <space> :toggle; down
