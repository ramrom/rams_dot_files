# VIM
- good resource on learning vim: http://vimcasts.org
- great resource: https://devhints.io/vimscript
- `:version`  - get version and features compiled

- so $VIMRUNTIME/syntax/hitest.vim
- c-x before c-n autocomplete search only in current file
- c-x c-f find file at current path, c-x c-] use tags
- <c-w>f - goto filename undercursor in new window
- <c-w>gf - in new tab
- 100G or 100gg - goes to line 100 like :100<CR> in command
- "120gg3yy -  yank lines 20-23 into reg 1
- :20,23y a<CR> - without moving cursor into reg a
- :7pu a<CR> - paste reg a under line 7
-     -  yank from mark a to cursor: y'a
- :cd <dir> - change vims current working dir
- :read ~/foo     - insert contents of file foo
- :read !jq . foo - can take stdout of shell cmd
- :iunmap jk - unmap jk insert mapping
- :earlier 10min - time travel!, go back to buffer state 10 minutes ago
    - :later 1hr - go forward 1 hour
- `:set filetype=json` - manually set filetype to json

## NEOVIM
- nvim-lua-guide: https://github.com/nanotee/nvim-lua-guide
- sept2020 good video on why lua is great and a great choice for neovim: https://www.youtube.com/watch?v=IP3J56sKtn0
- 2019 video on why nvim is awesome by core maintainer: https://www.youtube.com/watch?v=Bt-vmPC_-Ho
- decent blog on vimscript and lua config: https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
- plenary.nvim - a set of lua libs (uses coroutines via libuv) used by other neovim plugins
- coc.vim - supports vim and neovim, but it's beefy, mar2022 it's **DEPRECATED**, nvim-metals is successor
- neovim-lsp - neovim's built in lsp client, written in lua
- nvim-metals - full metals plugin that uses nvim's builtin lsp client
    - doesnt work with nnvim-lspconfig: https://github.com/scalameta/nvim-metals/discussions/93
- nvim-lspconfig - a plugin with common client configs for langauges, CONFLICTS with nvim-metals
- nvim-dap - plugin to support debug adapter protocol
### LUA
- print a val: `:lua =foo.myvar`
- CONFIG STUFF
    - vimscript, sourcing lua code: `lua require('some-lua-code')`
    - source a vimscript file: `vim.cmd 'source ~/.config/nvim/keymaps.vim'`
    - o is general settings: `vim.o.background = 'light'`
    - use space as a the leader key: `vim.g.mapleader = ' '`
    - set a env var value: `vim.env.FZF_DEFAULT_OPTS = '--layout=reverse'`


## PLUGINS

### VIM-PLUG
- `Plug 'foouser/some-plugin', { 'commit': 'cd5267d2d708e908dbd668c7de74e1325eb1e1da' }`
    - can specify a commit hash version of a plugin

### FZF
Rg            - ripgrep dynamic fuzzy search with bat preview!
Files, ctrl-v - opens in new vert split
Files, ctrl-x - opens in new horizontal split
Files, ctrl-t - opens in new tab
:Files ../    - invoke on parent dir (can specify base path as first arg)
GFiles!?    - git modified files in full screen
Lines       - search lines in open buffers
BCommits    - commit hist for current buffer
FZF-MRU:
    - does MRU for local sessions, other vim session no affectd

### VIM-FUGITIVE
- cheats: https://gist.github.com/mikaelz/38600d22b716b39b031165cd6d201a67
Gedit HEAD~3:%  - git show HEAD~3:<current file>
G               - git status
    s - stage, u - unstage, = - toggle diff of file
G diff          - git diff
G blame         - sidepane with git blame
G log %         - git log <current file>
    `:cnext`, `:cprevious`,
    `:cfirst` and `:clast`
    :0Glog      - logs only that change current file

### VIM-SURROUND
- https://github.com/tpope/vim-surround

### NERDTree
?   - toggle quickhelp
m   - bring up menu to move/rename/delete
q   - close nerdtree
A   - toggle zooming the nerdtree window
r/R - refresh dir/refresh tree root
I   - toggle showing hidden files
F   - toggle showing file nodes
NERDTreeFind - no args, show file for buf in tree
go - open file but stay in nerdtree
i/gi - open in new split/new split stay cursor
s/gs - open in new/ vert split
x - close current dir
p - jump to parent node of selected node
P - jump to tree root
K/J - jmp to first/last child node of current node's parent
C - make selected dir node the new root node

### NVIM-BQF
- shows preview window of current item in prefix window for nvim
- `zf` will open a fzf prompt to fuzzy search quickfix items
    - `ctrl-t` and x/v will open in new tab or vert/hor split

### Tree-sitter (nvim)
- parses files by language and creates ASTs
    - can query AST: smarter syntax highlighting (better than vim's regex), better formatting(e.g. `=`), better folding, etc
    - parsing is restricted to just file, so LSPs will be way more accurate, but LSPs generally slower, treesitter is fast async c code
- good article on it https://teknologiumum.com/posts/introductory-to-treesitter
    - it links to this good watch: https://www.youtube.com/watch?v=Jes3bD6P0To

### Other Plugins
- vim-gh-line
    - blob-view: <leader>gh
    - blame-view: <leader>gb
    - repo-view: <leader>go
- Tabular
    - `:Tabularize /| `
        - autodetect lines above and below and align on `|` char
    - ` :'<,'>Tabularize /| `
        - visually selected area will align by `|` char
        - can accept any regex, not just simpe chars like `|`
    - ` :'<,'>Tabularize /:\zs `
        - \z is lookforward, align by the space char after the `:` char
- CtrlP
    - ctrl-r toggle regex, ctrl-f/ctrl-b cycle mru/buffer/file


- ga -> show character encoding under cursor
- insert mode, ctrl-v, 3-digit ascii code e.g. 050 = "2"
- utf, type "u2713" => ✓, for > 4digits, "U1F30D" => 🌍

- vi -p foo bar, open file foo and bar in tabs
- :vsp or :vs filename, open file in vertical split
- :sp filename, horizontal split

:mkview foo  - vimscript that saves view(tab) state
:source foo  - load a view

- NEAT: visual select, then :sort to sort alphabetically
- TIP: once a buffer autoreloads, you can still undo



### STARTING VIM
vim -u somevimrc - specify a vimrc file (otherwise ~/.vimrc)
vim -u NONE     - start without running vimrc
vim -S sess.vim - load sess.vim session file
vim foo bar     - foo and bar buffers
vim -o  foo bar - foo and bar in diff windows
vim -p  foo bar - foo and bar in diff tabs
vim -V  foo     - verbose output
    - has many level, see `:help vbs`

### LOGS / MESSAGES
- `:messages` - in command mode will show list of runtime messages
- `:echo errmsg` - shows last error message
- `vim -V9myVim.log` - start vim at debug level 9 and write logs to `myVim.log`

### HELP
:h index.txt basically has comprehensive default mappings
:help shell<Tab> - tab complete a help topic
:helpgrep pattern - find all help docs matchin g`pattern`
:h sometopic | only   - help in single window
:help i_^N, what does ctrl-n do in insert mode
:h normal-index  - normal default mappings
:h insert-index  - insert default mappings
:h ex-cmd-index  - command and ex mode

### OPTIONS:
:set lazyredraw - for macros dont redraw screen, faster replay

## EX MODE:
Q - in normal mode will go into ex model, neovim doesnt have it
`visual` -exit ex mode
vi - short for visual


## COMMAND MODE
- run two commands in one line with `|`
    - `:echo "hi" | echo "hi again"`
C-h - delete last char
C-w - delete last word
C-b - goto beg of line
C-e - goto end of line
C-f - command-line-window, edit as if in insert/normal
      then can yank old command history
      in insert of cur line, write command and hit enter
- record command line output to file
    - `:redir > foofile`, then `:somecommandthatoutputs`, `:anothercommndthatoupts`, then `:redir end`
bd 3, closes buffer # 3
:command - spit out all usr defined commands
    - fzf's Command to fuzzy search em!
:hi  - spit out all highlighting rules
:hi clear - reset highlighting
:syntax - spits out current syntax rules
    - force set syntax highlight to ruby: `set syntax=ruby`
- `:echo $SOME_ENV_VAR` - output value of a environment variable
- `:filter *pattern* let g:`
    - works on `let`, `set`, `map`, `hi` and `fun`
    - **NOT** `syn` or `autocmd` though...
- `verbose filter *Diff* hi`  - all Diff highlight rules and sources
:verbose nmap <C-j>  - plugin/custom mapping normal C-j
:verbose set fo?
    - will show fo(formatoptions)
    - verbose to tell u what last set it
:scriptnames  - show vim source files loaded
:args   - show arg list that vim was invoked with
:help keyword - open help for keyword
:saveas file - save file as
:close - close current window
:new    - open new window and new buffer
:e #    - open last opened file
:@:     - run the last command run


## INSERT MODE
Esc - exit insert mode
C-[ - exit insert mode (most sysmtes, htting esc is this char)
C-C - exit insert mode, dont trigger autocommands
C-T - insert shiftwidth of indent
C-I - same as Tab
C-D - un-indent current line by shiftwidth
C-J - begin new line
C-M - begin new line
C-H - delete last character
C-W - delete word before cursor
C-U - delete all chars on current line up to cursor
C-O - execute command return to insert mode
C-N - next match in autocomplete
C-P - last match in autocomplete
C-X - subcommand mode used with autocomplete stuff
C-G k - move cursor up one
C-G j - move cursor down one
C-R i - insert from reg i
C-L - when insertmode on, go to normal mode
C-K - enter char with digraph, e.g. ñ or ë
C-Y - insert char above the cursor
C-E - insert char below the cursor
C-Q - same as C-V, but some terms kill its usage, ctrl flow
C-S - (docs) like C-V, deals with control flow
C-V - insert next non-digit literally, e.g. unicode deq
C-A - insert previously inserted text
C-F - when ! precedes key, reindent?
C-Z - should suspend vim
C-B - used to toggle revins, now disabled


## NORMAL MODE:
i - insert before the cursor
I - insert at the beginning of the line
a - insert (append) after the cursor
A - insert (append) at the end of the line
o - append (open) a new line below the current line
O - append (open) a new line above the current line
s - delete character and substitute text
S - delete line and substitute text (same as cc)
ea - insert (append) at the end of the word
K - open man page for word under the cursor
Q - enter ex mode
q: - enter command mode window for history of command mode commands
q/ - enter command mode window editor for history of searches
q? -  like q/ but reverse direction like the ? normal command
C-Z - suspend process
C-K - enter digraph
C-L - clear and redraw screen
C-A - add [count] to # of alpha char at or after cursor
C-X - sub [count] to # of alpha char at or after cursor
C-G - print file, line location, file status
C-S - pause flow ctrl, terminal accepts input, no output
C-Q - start block-visual, some terminals stty start signal
C-] - open tag in new buffer
C-^ - open last editted file
. - repeat last change, doesn't include motions(e.g. h/j/k/l) or commands that dont make changes

### G commands (normal mode)
gf   - edit filename undercursor
gx   - osx invokes file handler "open",
        opens urls, images, files, videos
        nvim good, vim fails on urls but files/imgs ok
        nvim and vim work fine for all in ubunutu
gj/gk - go down/up one viewport line
g0/g$ - go beg/end of viewport line
gq   - make one big line over multiple viewport lines as seperate lines
gd   - goto variable/fucntion declaration
gy   - goto type definition
g;   - jump back to last edit point
g,   - jump back to newer edit point
gv   - reselect the last visually selected text
gi   - go to last cursor position in insert mode


## CURSOR MOVEMENT
<enter> - move cursor to beginning of next line
C-h - move cursor left
C-j - move cursor down
C-n - move cursor down
C-m - move cursor down and to first non-blank char
h - move cursor left
j - move cursor down
k - move cursor up
l - move cursor right
H - move to top of screen
M - move to middle of screen
L - move to bottom of screen
10L - move to 10th line from the bottom
5H - move to 5th line from the top
30% - go to line that is 30% from the top
w - jump forwards to the start of a word
W - jump forwards to the start of a word
    (words can contain punctuation)
e - jump forwards to the end of a word
E - jump forwards to the end of a word
    (words can contain punctuation)
b - jump backwards to the start of a word
B - jump backwards to the start of a word
    (words can contain punctuation)
% - move to matching character
    (default supported pairs: '()', '{}', '[]'
    - use <code>:h matchpairs</code> in vim for more info)
0 - jump to the start of the line
^ - jump to the first non-blank character of the line
_ - jump to the first non-blank character of the line
$ - jump to the end of the line
g_ - jump to the last non-blank character of the line
gg - go to the first line of the document
gi - if left insert mode, go back to where u were in insert
G - go to the last line of the document
5G - go to line 5
fx - jump to next occurrence of character x
3fx - jump to 3rd occurence of char x
tx - jump to before next occurrence of character x
Fx - jump to previous occurence of character x
Tx - jump to after previous occurence of character x
; - repeat previous f, t, F or T movement
, - repeat previous f, t, F or T movement, backwards
} - jump to next paragraph (or function/block, when editing code)
{ - jump to previous paragraph (or function/block, when editing code)
( - back a sentence
) - forward a sentence
[] - backward to prev }
][ - forward to prev }
zz - center cursor on screen
zt - cursor on top of screen
zb - cursor on bottom screen
C-e - move screen down one line (without moving cursor)
C-y - move screen up one line (without moving cursor)
C-b - move back one full screen
C-f - move forward one full screen
C-d - move forward 1/2 a screen
C-u - move back 1/2 a screen
C-i - go to newer cursor position in jump list
C-o - go to older cursor position in jump list
C-t - go back one in tag stack
- Tip Prefix a cursor movement command with a number to repeat it.
    For example, 4j moves down 4 lines.

## EDITING:
y - yank (copy) text
d - delete text
c - delete text and insert to change
~ - switch case
r - replace a single character
R - enter replace mode to repeatedly replace the character under the cursor
J - join line below to the current one with one space in between
gJ - join line below to the current one without space in between
gu - make selected text lower case
guu - make current line lower case
gU - make selected text upper case
gUU - make current line upper case
gwip - reflow paragraph
cc - change (replace) entire line
C - change (replace) to the end of the line
c$ - change (replace) to the end of the line
ciw - change (replace) entire word
vab - visual select all block
cw - change (replace) to the end of the word
& - repeat last substitution
xp - transpose two letters (delete and paste)
u - undo
U - undo all latest changes on one line
Ctrl + r - redo
> - shift text right
< - shift text left
= - autoindent selected text
=ip - autoindent inner paragraph
== - autoindent current line

### CUT AND PASTE
yy - yank (copy) a line
2yy - yank (copy) 2 lines
yw - yank (copy) the characters of the word from the cursor position
    to the start of the next word
y$ - yank (copy) to end of line
p - put (paste) the clipboard after cursor
P - put (paste) before cursor
dd - delete (cut) a line
2dd - delete (cut) 2 lines
dw - delete (cut) the characters of the word from the cursor position
     to the start of the next word
D - delete (cut) to the end of the line
d$ - delete (cut) to the end of the line
x - delete (cut) character

## VISUAL MODE:
v - start visual mode, mark lines, then do a command (like y-yank)
V - start linewise visual mode
o - move to other end of marked area
Ctrl + v - start visual block mode
O - move to other corner of block
Esc - exit visual mode
vi} - visual select inner text of "{}" block
ctrl-va] - visual block select all text of "[]" block

## TEXT OBJECTS:
<number><operator/command><number><text object>
i = inner, a = all
word - a word, sentence - ends in punctation `./?/!`, paragraph - ends in newline
aw - word with surrounding whitespace
iw - word without surrounding whitespace
as - sentence
ip - inner paragraph
ab - a block with ()
ab - block within and including ()
aB - block within and including {}
ib - block within and not including ()
iB - block within and not including {}
at - all tag block
` <operator><a/i><"/'/(/)/{/}/[/]> ` - programming language text objects

## MOTION+OBJECTS:
v3ta - visual select up to the 3rd occurence of a
d2fn - delete up to 2nd occurence of n
c2aw - delete 2 full words and insert
c2w - delete from cursor current word, then next word, then insert

## REGISTERS:
- Registers stored in ~/.viminfo, loaded on next restart
- Register 0 contains he value of the last yank command.
:let @a=foo  - manually set reg a to something
:reg - show registers content
"xy - yank into register x
"xp - paste contents of register x
"+y - + reg goes to sys clipboard!
"*y - in linux * is primary selection
      contents of what u simply highlighted/selected
"+p - paste from sys clipboard
"*p - paste from sys clipboard
- https://vim.fandom.com/wiki/Accessing_the_system_clipboard

## JUMP LIST:
things that add to jump list:
    - normal mode G
    - searching, / and ?, # and *, n and N
    - window size jumps: L M and H
    - text block jumps: ( ) { }

## Marks
:marks - list of marks
ma - set current position for mark A
`a - jump to position of mark A
y`a - yank text to position of mark A

## Macros:
qa - record macro a
q - stop recording macro
@a - run macro a
@@ - rerun last run macro

## Folds:
zo (open), zO (open all nested)
zc (close), zC (close all)
za (toggle), zA (toggle all)
zm fold one level, zM - close ALL folds
zr expand one level, zR - open ALL folds

## Exiting/Quitting:
:w - write (save) the file, but don't exit
:w !sudo tee % - write out the current file using sudo
:wq or :x or ZZ - write (save) and quit
:q - quit (fails if there are unsaved changes)
:q! or ZQ - quit and throw away unsaved changes
:wqa - write (save) and quit on all tabs
ZZ - same as :wq
:tabc - tabclose, close tab with all windows in it
:tabonly - close all other tabs
:1quit - quit win 1
:9quit quit win 9
:-quit :+quit   - quit prev/next win


## Search and replace
/\C  - force case-sensitive search, /\c opposite
:g/  - print line # and occurence of each search match
/pattern - search for pattern
?pattern - search backward for pattern
\vpattern - 'very magic' pattern: non-alphanumeric characters
    are interpreted as special regex symbols (no escaping needed)
n - repeat search in same direction
N - repeat search in opposite direction
# - reverse search for word under cursor
* - search for word under cursor
:%s/old/new/g - replace all old with new throughout file
:%s/old/new/gc - replace all old with new throughout file with confirmations
- * to search next occurence of word under cursor
- ? will search backward
[I - show all occurences of word under cursor
:noh - remove highlighting of search matches

## Search in multiple files:
:vimgrep /pattern/ {file} - search for pattern in multiple files
e.g. ` :vimgrep /foo/ **/* `
:cn - jump to the next match
:cp - jump to the previous match
:copen - open a window containing the list of matches

## Working with multiple files:
:e file - edit a file in a new buffer
:bnext or :bn - go to the next buffer
:bprev or :bp - go to the previous buffer
:bd - delete a buffer (close a file)
:ls - list all open buffers

## WINDOWS:
:sp file - open a file in a new buffer and split window
:vsp file - open a file in a new buffer and vertically split window
Ctrl + ws - split window
Ctrl + ww - switch windows
Ctrl + wq - quit a window
Ctrl + wv - split window vertically
Ctrl + wh - move cursor to the left window (vertical split)
Ctrl + wl - move cursor to the right window (vertical split)
Ctrl + wj - move cursor to the window below (horizontal split)
Ctrl + wk - move cursor to the window above (horizontal split)
ctrl + w_ - max height of window
ctrl + w| - max width of window
ctrl + w= - normalize all window sizes
ctrl + wR - swap top/bottom or left/right windows
ctrl + wT - break window out to new tab
ctrl + wo - close all windows except current one in tab


## TABS
:tabnew or :tabnew file - open a file in a new tab
Ctrl + wT - move the current split window into its own tab
gt or :tabnext or :tabn - move to the next tab
gT or :tabprev or :tabp - move to the previous tab
`#gt` - move to tab number #
:tabmove # - move current tab to the #th position (indexed from 0)
:tabclose or :tabc - close the current tab and all its windows
:tabonly or :tabo - close all tabs except for the current one
:tabdo command - run the command on all tabs (e.g. :tabdo q - closes all opened tabs)


## SPELLING:
- set spell
- set spelllang=es - set spell language to spanish
[s - previous spelling error
]s - next spelling error
]S/[S - next/prev major (non-regional) spelling error
z= - bring up autocorrect menu
zg - exclude word
zug - undo exclude adding word
zw - add to wrong word list
zuw - remove from wrong word list


## SCRIPTING
- checking existence of variable
    if exists('g:some_global_var') | echo "hi" | endif
