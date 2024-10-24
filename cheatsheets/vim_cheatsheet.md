# VIM
- OG `vi` invented by bill joy in 1970s
- `vim` invented by Bram Moolenaar in 1988, `vim` kinda short for `Vi IMitation`
- good resource on learning vim - http://vimcasts.org
    - feb27-24 above line with `vim:` give error: `BufReadPost Autocommands for "*": Vim(append):Error executing lua callback`
- awesome cheatsheet: https://github.com/ibhagwan/vim-cheatsheet
- Vim9.0 introduces new version of VimL scripting language
    - 10x to 100x performance improvement, commands compiled into fast executable instructions
    - *NOT* totally backwards compatible with old VimL
- SHaDa - SHared Data file - remember things b/w sessions
    - command line hist, search string hist, marks, global vars, buffer list, non-empty registers, and more
- vim codebase is basically single-threaded and sychronous, core vim code can only run in main loop

## NEOVIM
- official neovim docs: https://neovim.io/doc/
- good config/starter for first time noevimmers: https://github.com/nvim-lua/kickstart.nvim
- 👍 key design decisions over vim
    - ⭐ lua over vimL as scripting language
    - ⭐ treesitter (replaces regex syntax groups)
    - ⭐ built-in LSP client (written in lua)
    - ⭐ de-coupled UI components
    - ⭐ msgpack RPC API
    - ⭐ libuv integration
- sept2020 good video on why lua is good for neovim: https://www.youtube.com/watch?v=IP3J56sKtn0
    - by core nvim maintainer [TJ Devries](https://www.google.com/search?q=tj+devries)
- 2019 video on why nvim is awesome by core maintainer: https://www.youtube.com/watch?v=Bt-vmPC_-Ho
    - famous quote that inspired neovim from vim core dev
        > Q: How can the community ensure that the Vim project succeeds for the foreseeable future?
        > Keep me alive.            -  Bram Moolenaar
- decent blog on vimscript and lua config: https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
- good discussion on async/await and more sugar on concurrency in lua
    - https://github.com/neovim/neovim/issues/19624
- `vim.cmd` or `vim.api` can't really be done async
    - see https://www.reddit.com/r/neovim/comments/13kgl3f/how_can_i_run_a_vimcmd_asynchronously/
    - this is b/c these are wrappers around core vim code that inherently is synchronous on the main thread
    - if you tried to run this in `vim.loop`, it won't work (or in `plenary.job` which wraps libuv)
        - errors like `vimL function must not be called in a lua loop callback`
- for keymaps, mode definitions https://neovim.io/doc/user/map.html#map-overview
    - `i` insert, `n` normal, `v` visual+select, `x` visual, `o` operator pending, `c` command-line, `t` terminal, `s` select
- has API that is RPC with messagepack. thus can support server/client models
    - exposed via `vim.api` main docs: https://neovim.io/doc/user/api.html
- modern version use `libuv` for async IO and libuv itself can be multithreaded and supports the uses thread pools
    - see https://neovim.io/doc/user/luvref.html#_thread-pool-work-scheduling
    - can also more directly spawn threads: https://neovim.io/doc/user/luvref.html#_threading-and-synchronization-utilities
### VERSION HISTORY
- roadmap: https://neovim.io/roadmap/
- started in 2014 by Thiago Padilha, when his patch to enable multi-threading in vim was rejected
- 0.2 - added support for Lua 5.1
    - mostly b/c LuaJIT only supports 5.1, LuaJIT much faster than standard Lua compiler
    - externalize UI: tabline, popupmenu
- 0.3
    - externalize UI: cmdline, wildmenu
- 0.4
    - Lua standad modules, full scripting engine as replacement for VimL
        - particularly `vim` module introduced
    - `vim.loop` wraps the Lua binding(https://github.com/luvit/luv) for `libuv`(big C async IO lib, used by node.js)
    - externalize UI: multigrid, floating windows, messages
- 0.5
    - introduced built in LSP client (lua written ofcourse)
    - 2021 - jdevries on why it was built-in: https://www.youtube.com/watch?v=ArwDgvYEZYk&ab_channel=TJDeVries
        - doesnt have an autocompletion engine
    - added `init.lua` (versus old `init.vim`) for configuring editor
    - experimental [tree-sitter integration](https://neovim.io/doc/user/treesitter.html)
- 0.6 - unified diagnostics API
- 0.7 - more treesitter integration, global statusline, TUI: extended keys(ctrl-i vs tab, shift modifier)
- 0.8 - LSP improvements (v3.16 spec coverage, LspAttach)
    - treesitter API: use queries to define spellcheck regions
    - highlight groups can be treesitter captures like `@repeat` or `@conditional`, `TS` prefixed groups like `TSBoolean` deprecated
    - clickable statusline
    - iterators! - `vim.iter` gives us `filter` and `map` and more!
- 0.9 - TUI and remote UI
- 0.10 - built-in commenting(vim-commentary), LSP inlay hints 
    - comments: https://github.com/neovim/neovim/pull/28176
### LUA
- nvim-lua-guide: https://neovim.io/doc/user/lua-guide.html#lua-guide
- see [lua cheatsheet](lua_cheatsheet.mc) for core lua stuff
- vim settings
    - `vim.o` - settings options and is equivalent to VimL's `set`
        - set background `:lua vim.o.background = 'light'`
        - use space as a the leader key: `:lua vim.g.mapleader = ' '`
        - `:lua vim.opt.smarttab = true` equivalent to `:set smarttab`
        - `:lua =vim.opt.smarttab` similar to `:set smarttab?`
    - `vim.opt` - wrapper for `vim.o`
        - has `append`,`prepend`,`remove`, but to get value need to `get` e.g. `vim.opt.smarttab.get()`
    - `vim.opt_local` - equiv to VimL `setlocal`
    - `vim.opt_global` - equiv to VimL `setglobal`
    - `vim.wo` - set window-local 
    - `vim.bo` - set buffer-local 
- `vim.env` - envirionment variables, set a env var: `vim.env.FZF_DEFAULT_OPTS = '--layout=reverse'`
- `vim.g` - lua table that stores global variables for neovim environment
    - e.g. `vim.g.some_user_var = 'test'`, equiavlent in VimL - `let g:some_user_var = 'test'`
- `vim.cmd` - run an Ex command, doesnt output
    - e.g. `vim.cmd("colorscheme onedark")`
- `vim.api` - all lua->C, main api to control nvim using msgpack/RPC
    - main docs: https://neovim.io/doc/user/api.html
    - `vim.api.nvim_exec2` - run vimscript, can capture output
- `vim.json.decode` - decode a JSON encoded string into a lua object
- `vim.fn` - table exposes regular vimL functions 
    - all builtin functions: https://neovim.io/doc/user/builtin.html#builtin-functions)
    - e.g. `vim.fn.printf('hi from %s', 'dude'))`
    - `resolve` - will follow a symbolic linked file to origin
    - `expand` - do shell expansions so `~` will expand to full home dir path
        - `expand('<cword>')` - get word under cursor, `expand('<cWORD>')` - get full WORD(series of non-blank chars) under cursor
- `vim.lsp` - LSP stuff
- `vim.defer_fn(f, x)` - defer calling a function `f` after `x` seconds, `f` is `vim.schedule_wrap`'ed so can call `vim.api` functions
    - `vim.defer_fn(function() vim.uv.sleep(2000) end, 3000)` - in 3sec, schedule on main loop a func that sleeps for 2sec
- `vim.schedule_wrap(f)` - return a function that calls `f` with `vim.schedule`
- `vim.schedule(f)` - schedule a function `f` to be invoked later in main event loop
- `vim.uv` - neovim eventloop using libuv
    - good 4min TJDevries vid on async/libuv/main-loop misconception - https://www.youtube.com/watch?v=GToxQKi7LZg&ab_channel=TJDeVries
    - `vim.loop` renamed to `vim.uv` in 0.10.x
    - _NOTE_ can NOT directly call `vim.fn`/`vim.api`/`vim.cmd` functions in lua `uv` callbacks, done as a safety guard
        - call the functions wrapped in a `vim.schedule`, this is allowed as schedule will put it in the queue for main event loop
    - [timers](https://neovim.io/doc/user/luvref.html#uv_timer_t) - execute callback after x time and/or on interval 
        ```lua
        local timer = vim.uv.new_timer()
        timer:start(1000, 0, function () timer:stop(); timer:close(); print("1 second delayed message") end)
        ```
    - `vim.uv.sleep(2000)` - sleep for 2 sec on the current thread
        - _NOTE_ VimL `sleep` pauses main neovim thread, by default so will `vim.uv.sleep`, unless done from a different thread context
    - multi-threading
        - [threads](https://neovim.io/doc/user/luvref.html#luv-threading-and-synchronization-utilities) - follows pthread API mostly
            - `vim.uv.new_thread(f, threadargs...)` - spawn thread
                - pass in entry func `f`(or `string` of raw lua source code) and args for `f`
                - e.g. `entry=function(num) for i=1,num do z = i*i end; vim.uv.new_thread(entry, 1000)`
                - the `threadargs` can NOT be a table
            - _NOTE_ thread's entry func(closure) can't capture globals from calling thread
            - to pass data b/w threads, could use `us.async_send` to create a callback and pass handle to different thread
        - [thread pools](https://neovim.io/doc/user/luvref.html#_thread-pool-work-scheduling) are generally nicer
            - the `after_work_callback` func can access local tables
- print a val: `:lua =foo.myvar`, `:lua b=2; print(myvar)`
- print internals of a table (use `vim.inspect`) - `:lua b={key={1,2},key2="string"}; print(vim.inspect(b))`
- call lua function - `:lua somefunc()`
- sourcing external files
    - VimL `source`
        - vimscript file - `:source ~/.config/nvim/keymaps.vim`
        - lua file - `:source ~/foo.lua`, will run the lua code, `dofile` is essentially the same
    - VimL `luafile` - `:luafile mycode.lua` or `:luafile %` to execute current buffer
    - lua `require` - `:lua require('some-lua-code')`
        - _NOTE_ this is a lua `require`, so this caches in result in `package.loaded`, and uses lua PATH finding for source file
    - `dofile` - if you want to constantly change the same file and run the new code
        - e.g. in same dir as neovim session, create file `foo.lua` and in nvim run `lua dofile("foo.lua")`
- run external process
    - old VimL function - `vim.fn.jobstart` and `vim.fn.system` 
        - help docs say use `vim.system` instead, b/c `vim.fn.system` are always synchronous and will block the main thread
    - `vim.uv.spawn` - `vim.uv.spawn('ls', { args = { '-a', '-l' } })`
    - `vim.system`
        - uses `uv.spawn` under the hood and is simpler API
            - unlike `spawn` it will throw error if command can't be run
        - can be called syncronously(blocking main thread) by calling `wait`
        - neovim 0.10.x -> it's `vim.system`, pre 0.10.x - `vim.fn.system({'ls', '-a', '-l'})`
- get OS name
    - `:lua print(vim.loop.os_uname().sysname)`
    - `:lua if vim.fn.has('Linux') then print 'has linux' end`
- copy stuff to system clipboard progrmatically
    - `lua vim.fn.setreg('+', "foobar")` - the `+` register generally maps system clipboard

## PLUGINS
- good list of neovim plugins: https://github.com/rockerBOO/awesome-neovim
### PLENARY.NVIM 
- core set of neovim lua libs
- provides an async framework, it uses lua coroutines and libuv for async IO
    - main benefit is instead of arrowhead callback chaining API of `lib.uv`, it gives u a flat imperative async/await style
- `plenary.job` lets you run shell command in async job
    - `sync()` to block main thread, or `start()` for async/background
### LSP
- [coc.vim](https://github.com/neoclide/coc.nvim) - very mature project and full featured
    - written in typescript, mostly runs in a seperate node.js process
    - supports vim and neovim, it's beefy, was best LSP experience before nvim/lsp-client
- neovim-lsp - neovim's built in lsp client, written in lua
- nvim-lspconfig - a plugin with common client configs for langauges, CONFLICTS with nvim-metals (for scala)
    - LSP configs: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
- nvim-metals - full metals plugin that uses nvim's builtin lsp client
    - also see [metals section in cheatsheet](build_dependency_tools_cheatsheet.md)
    - doesnt work with nnvim-lspconfig: https://github.com/scalameta/nvim-metals/discussions/93
- nvim-dap - plugin to support debug adapter protocol
- nvim-cmp - autocompletion plugin, lua
    - comparators are advanced and need docs - https://github.com/hrsh7th/nvim-cmp/issues/883
        - offset comparator choose matches closer to beg of word
        - exact match comparator chooses exact matches (e.g. `word` matches `word` more than `wording`)
- fidget.nvim - show LSP progress in bottom right, noice.nvim does this too and honestly better
- ALE vs syntastic vs CoC
    - syntastic is synchronous and esp large files will cause pauses
    - ale is async and client for LSP
### PACKER.NVIM
- pure lua plugin manager
### LAZY.NVIM
- https://lazy.folke.io/
- pure lua plugin manager, newer and a bit faster than packer
- plugins can be configed to lazy load based on events and condtions
- `lazy-lock.json` file (generally in `~/.config/nvim/lazy-lock.json`) - has current version(branch/commit) of plugins installed
### VIM-PLUG
- `Plug 'foouser/some-plugin', { 'commit': 'cd5267d2d708e908dbd668c7de74e1325eb1e1da' }`
    - can specify a commit hash version of a plugin
### FZF.VIM
- Rg            - ripgrep dynamic fuzzy search with bat preview!
- Files, ctrl-v - opens in new vert split
- Files, ctrl-x - opens in new horizontal split
- Files, ctrl-t - opens in new tab
- :Files ../    - invoke on parent dir (can specify base path as first arg)
- GFiles!?    - git modified files in full screen
- Lines       - search lines in open buffers
- BCommits    - commit hist for current buffer
- FZF-MRU:
    - does MRU for local sessions, other vim session no affectd
### CTRLP
- really old fuzzy finder - https://github.com/ctrlpvim/ctrlp.vim
- ctrl-r toggle regex, ctrl-f/ctrl-b cycle mru/buffer/file
### FZF-LUA
- uses fzf but plugin written in lua, lots more pickers and features than fzf.vim
- multi-file selection (calling `files()` method) and hitting enter will send it to quickfix list
    - also: `ctrl-t` to tabs, `ctrl-v` to vert splits
- file search many root dirs: `lua require('fzf-lua').files({ cmd = "fd . dir1/sub1 dir2"  })`
### TELESCOPE.NVIM
- `?` toggle help in normal, `C-/` toggle help in insert
### HARPOON
- harpoon remembers file lists in every dir, and those are stored in `~/.local/share/nvim/harpoon/`
### VIM-FUGITIVE
- cheats: https://gist.github.com/mikaelz/38600d22b716b39b031165cd6d201a67
- Gedit HEAD~3:%  - git show HEAD~3:<current file>
- G               - git status
    - s - stage, u - unstage, = - toggle diff of file
    - ]c - move to next file and expand diff
- G diff          - git diff
- G blame         - sidepane with git blame
- G log %         - git log <current file>
- `:cnext`, `:cprevious`,
- `:cfirst` and `:clast`
- `:0Glog`      - logs only that change current file
### VIM-COMMENTARY
- `gcu` or `gcgc` - uncomment current and contiguous adjacent commented lines
- neovim 0.10 has built in commentary (from mini.vim maintainer), API very similar to vim-commentary regardless
### VIM-NOTIFY
- `require('notify')("This is an message")`   - green notification
- `require('notify')("This is an error message", "error")`   - red error notification
### FIRENVIM
- https://github.com/glacambre/firenvim
    - a similar project: https://github.com/fregante/GhostText
- INSTALLATION - SEPERATE INIT.LUA FILE
    - create `~/.config/myfirenvimdir/init.lua` and symlink it to dedicated firenvim `init.lua` file
    - export `NVIM_APPNAME=myfirenvimdir`
    - lazy will install plugins in `~/.local/share/myfirenvimdir/lazy` dir
    - launch nvim, config file should install firenvim with `firenvim#install()`
        - when this run it's configures the binstub `~/.local/share/firenvim/firenvim`
- `~/.local/share/firenvim/firenvim` - binstub that is called when firenvim plugin in browser activates
    - defines reading `NVIM_APPNAME`
    - launches nvim in headless mode, sets `g:started_by_firenvim`
- INSTALLATION - SHARED INIT.LUA FILE
    - use global var that gets set if firenvim was activated in browser 
    - e.g. `if not not vim.g.started_by_firenvim then ... end`
### VIM-SURROUND
- https://github.com/tpope/vim-surround
- `cs"'` - change surround `"` to `'`
- for txt `[blah]` -> `cs[<yar>]` - change surround `[` to `<yar>`/`</yar>` 
- for txt `<foo>bar</foo>` -> `cst"` - change surround tag(`<foo>` here) to `"`
- `ds[` - delete surround `[`
- `ysiw[` - select inner word and surround with `[`
### NVIM-TREE
- written in lua
- similar: plugin is NERDTree(vimscript), neo-tree(lua)
- `g?` - to list commands
- `ctrl-k` - show info on file(full path, size, access/mod/create datetime)
- `o` - open with window picker, if multiple windows open, select a labeled (e.g. "A" "B" "C" for 3windows) window
- `O` - open no window picker, in the main window
- `tab` - open("preview") - open in window but keep tree window as active window
- `q` - close (help menu, or nvim tree sidebar)
- `f`/`F` - filter / clear filer
- `E` - expand all
- `W` - collapse
### NOICE.NVIM
- awesome new UI components for neovim https://github.com/folke/noice.nvim
- uses nvim-notify for pretty floating notifications
- uses nui for other components including nicer cmdline
- `:Noice pick` - will pull up msgs/notifications in a fzf-lua or telescope picker window!
### NVIM-BQF
- shows preview window of current item in prefix window for nvim
- `zf` will open a fzf prompt to fuzzy search quickfix items
    - `ctrl-t` and x/v will open in new tab or vert/hor split
### NVIM-TREESITTER
- nvim plugin for [treesitter](./computer_science_cheatsheet.md) 
- makes installing parsers easy
- good article - https://thevaluable.dev/tree-sitter-neovim-overview/
- neovim 0.10 - `InspectTree` pops open window on right to see the whole syntax tree
- markdown parser used - https://github.com/tree-sitter-grammars/tree-sitter-markdown
- `TSBufDisable highlight` - turn off TS highlight for current buffer
    - *NOTE* 2024 -if treesitter highlight is off, then vim regex default turns on
    - see https://github.com/nvim-treesitter/nvim-treesitter/issues/2846
- `-` - set root node to parent dir of current root
- `c-]` - set root node to dir on cursor
### VIM-RHUBARB
- rhubarb has GBrowse handler for github, open gh link in browser or copy to clipboard
- used to use `vim-gh-line`, but rhubarb looks better
### FLASH.NVIM
- quickly jump to a word on screen, or quick select
- similar plugins: `vim-sneak,` `vim-easymotion`
### TABULAR
- `:Tabularize /|`
    - autodetect lines above and below and align on `|` char
- ` :'<,'>Tabularize /|`
    - visually selected area will align by `|` char
    - can accept any regex, not just simpe chars like `|`
- ` :'<,'>Tabularize /:\zs`
    - \z is lookforward, align by the space char after the `:` char
### UNICODE
- good plugin - https://github.com/chrisbra/unicode.vim


## STARTING VIM
- `vim -u somevimrc` - specify a vimrc file (otherwise ~/.vimrc)
    - `vim -u different_init.lua` - can also specify a different init.lua file
- `vim -u NONE`     - start without running vimrc
- `vim -S sess.vim` - load sess.vim session file
- `vim foo bar`     - foo and bar buffers
- `vim -e`          - start in Ex mode
- `vim -o  foo bar` - foo and bar in diff windows
- `vim -p  foo bar` - foo and bar in diff tabs
- `vim -R foo`      - read-only mode, all buffers opened will be read-only
- `vim -V  foo`     - verbose output
    - has many level, see `:help vbs`
- `vim --startuptime outputfile` - record startup time and record to file
- `vim -V9myVim.log` - start vim at debug level 9 and write logs to `myVim.log`
- :args   - show arg list that vim was invoked with
- neovim supports https://neovim.io/doc/user/editorconfig.html .editorconfig files
    - disable with `vim.g.editorconfig = false` in init file
- neovim will also read `NVIM_APPNAME` for relative dir to look for init file
    - `NVIM_APPNAME=foo` -> look for init in `$XDG_CONFIG/foo/` dir (versus `$XDG_CONFIG/nvim/`)

## EXITING / QUITTING / WRITING
- :w - write (save) the file, but don't exit
- :w !sudo tee % - write out the current file using sudo
- :wq or :x or ZZ - write (save) and quit
- :q - quit (fails if there are unsaved changes)
- :q! or ZQ - quit and throw away unsaved changes
- :wqa - write (save) and quit on all tabs
- ZZ - same as :wq
- :tabc - tabclose, close tab with all windows in it
- :tabonly - close all other tabs
- :1quit - quit win 1
- :9quit quit win 9
- :-quit :+quit   - quit prev/next win


## DIAGNOSTICS / INTROSPECT / DEFINITIONS
- `:version`  - get version and features compiled
- `:scriptnames` shows all scripts that were run, including plugin's scripts
- `:checkhealth` - neovim only, report on errors/warnings for all modules
- `:functions` - print list of defined functions
- `:command` - print list of defined commands
- `:Notifications` - neovim, print `notify` notifications (slightly different form messages)
    - e.g. `vim.notify('a notif')` will print a notification
- `:hi`  - spit out all highlighting rules
- `:hi clear` - reset highlighting
- `:syntax` - spits out current syntax rules
    - force set syntax highlight to ruby: `set syntax=ruby`
    - supports line range regions `:syntax region`
        - e.g. `:syntax region Green start=/\%20l/ end=/\%30l/` - define `Green` group from line 20-30
- `:echo $SOME_ENV_VAR` - output value of a environment variable
- `:filter *pattern* let g:`
    - works on `let`, `set`, `map`, `hi` and `fun`
    - **NOT** `syn` or `autocmd` though...
- `verbose filter *Diff* hi`  - all Diff highlight rules and sources
- `:verbose nmap <C-j>`  - plugin/custom mapping normal C-j
- `:verbose set fo?`
    - will show fo(formatoptions)
    - verbose to tell u what last set it
- `:autocmd` - print all autocmd definitions
    - `:autocmd BufEnter` - print just `BufEnter` autocmds
    - `:verbose autocmd` - verbose will show things like what code last set the autocmd
- `Inspect` - print info about all items at given position, with no args the cursor position
    - will show highlight group (by regular vim regex syntax or treesitter)
- `ga` -> show character encoding under cursor
    - can also call `:ascii` or `:as` at command line
- `:lua vim.fn.expand('%:p')` - print full path of current buffer regardless of CWD
- print runtime path: 
    - full info (big table) `lua print(vim.inspect(vim.opt.rtp))`
    - just the paths: `lua print(vim.inspect(vim.api.nvim_list_runtime_paths()))`
### LOGS / MESSAGES
- mar2024 - logs stored in `~/.local/state/nvim`
    - vim's regular `log`, but also `lsp.log`
- `:messages` - see history of runtime messages (usually shown in command window)
    - `:messages clear` will clear messages
    - fzf's Command to fuzzy search em!
- `:echo errmsg` - shows last error message


## VIMSCRIPT
- aka VimL
- nice cheatsheet: https://devhints.io/vimscript
- commands -> can only accept string arguments, no return value, used for UI, invoke: `:SomeCommand`
- functions -> can accept any type arg and return a value, to invoke `:call somefunc(var1,var2)`
- checking existence of variable
    if exists('g:some_global_var') | echo "hi" | endif

## MISC COMMANDS AND INFO
- so $VIMRUNTIME/syntax/hitest.vim
- 100G or 100gg - goes to line 100 like :100<CR> in command
- "120gg3yy -  yank lines 20-23 into reg 1
- :20,23y a<CR> - without moving cursor into reg a
- :7pu a<CR> - paste reg a under line 7
-     -  yank from mark a to cursor: y'a
- :cd <dir> - change vims current working dir
- :read ~/foo     - insert contents of file foo
- :read !jq . foo - can take stdout of shell cmd
- :iunmap jk - unmap jk insert mapping
- `:earlier 10min` - time travel!, go back to buffer state 10 minutes ago
    - `:later 1hr` - go forward 1 hour
- `:set filetype=json` - manually set filetype to json
- `:set lazyredraw` - for macros dont redraw screen, faster replay
- insert mode, ctrl-v, 3-digit ascii code e.g. 050 = "2"
- utf, type "u2713" => ✓, for > 4digits, "U1F30D" => 🌍
- :vsp or :vs filename, open file in vertical split
- :sp filename, horizontal split
- :mkview foo  - vimscript that saves view(tab) state
- :source foo  - load a view
- NEAT: visual select, then `:sort` to sort alphabetically
- TIP: once a buffer autoreloads, you can still undo
- `input` function can take user input and store in var


## HELP
- :help keyword - open help for keyword
- :h index.txt basically has comprehensive default mappings
- :help shell<Tab> - tab complete a help topic
- :helpgrep pattern - find all help docs matchin g`pattern`
- :h sometopic | only   - help in single window
- :help i_^N, what does ctrl-n do in insert mode
- :h normal-index  - normal default mappings
- :h insert-index  - insert default mappings
- :h ex-cmd-index  - command and ex mode

## QUICKFIX
- a special window for storing a list of lines for quick navigation
    - list of errors or warnings to traverse through and fix
    - `vimgrep` and `make` use it
- `copen` - open the quickfix window, `ccl`, `cclose` - close qf window
- `cnext`/`cprev` or `cn`/`cp` next-item/previous-item,  `cfirst`/`clast` - goto first/last item, `cc<N>` - goto Nth item
- `cdo` - run a Ex command for every item in the quickfix list
    - `:cdo s/foo/bar/gc` - rename `foo` to `bar` for all(`g`) and confirm each(`c`)
- `cexpr` - run a command and put output in qf list
    `:cexpr system('ls -al')` - would do `ls -al` in current dir and put output in qf list
    `:cexpr "foo\nbar\nyar` - can pass in string, uses newline for line seperator, so qf would have 3 lines in this case
- `caddexpr {expr}` - evaluate expression and add it to the quickfix
### LOCATION LIST
- is local to a window, QF list is global to whole vim session
- can have 5 location lists
- use `lvimgrep`, `lgrep`, `lhelpgrep` `lmake` to send to location list


## EX MODE
- AKA **COMMAND-LINE MODE**
- a shitty REPL to run Ex commands
    - essentiall Command-Line mode but you dont exit ex mode after running a command
- to enter Ex mode
    - vim - `Q` in normal
    - neovim - `gQ` in normal
- exiting
    `visual` - exit ex mode
    `vi` - short for visual

## COMMAND-LINE WINDOW
- has history of Ex commands run, can edit and rerun them
- can edit as if in insert/normal, super nice as you have vim motions available
- from normal mode: `q:` - edit command history, `q/` - edit search history, `q?` - serach history reverse
- from command mode: `ctrl-f` edit command history
- then can yank/edit/run old command history, edit and hit enter on command

## COMMAND MODE
- running shell commands
    - *NOTE* basically all these are synchronous and will block the vim session until done
    - `:!` - run a shell command, e.g. `:!echo hi`
    - `:silent !` run shell cmd silently, e.g. `:silent ! ls`
- run a command silently
    - `:silent!` - run shell command, suppress normal messgs (stdout-like), e.g. `:silent! ls`
    - `:silent!!` - run shell command, suppress all messgs (stdout + stderr), e.g. `:silent!! ls`
- run two commands in one line with `|`
    - `:echo "hi" | echo "hi again"`
- Keymaps
    - C-h - delete last char
    - C-w - delete last word
    - C-b - goto beg of line
    - C-e - goto end of line
    - C-f - enter command line window
- record command line output to file
    - `:redir > foofile`, then `:somecommandthatoutputs`, `:anothercommndthatoupts`, then `:redir end`
- bd 3, closes buffer # 3
- :saveas file - save file as
- :close - close current window
- :new    - open new window and new buffer
- :e #    - open last opened file
- :@:     - run the last command run


## INSERT MODE
Esc - exit insert mode
C-[ - exit insert mode (most systems, hitting esc is this char)
C-C - exit insert mode, dont trigger autocommands
C-I - same as Tab
C-T - insert shiftwidth of indent
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
    - C-x C-l - autocomplete menu on existing lines
    - C-x C-k - dictionary word completion
    - C-x C-f - file name completion
    - C-x C-] - tag completion
C-G k - move cursor up one
C-G j - move cursor down one
C-R i - insert from reg i
C-L - search backwards for line that starts with the same chars as in current line b4 cursor
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


## NORMAL MODE
i - insert before the cursor
I - insert at the beginning of the line
a - insert (append) after the cursor
A - insert (append) at the end of the line
o - append (open) a new line below the current line, goto insert mode
O - append (open) a new line above the current line, goto insert mode
s - delete character and substitute text
S - delete line and substitute text (same as cc)
ea - insert (append) at the end of the word
K - open man page for word under the cursor
Q - enter ex mode
q: - enter command mode window for history of command mode commands
q/ - enter command mode window editor for history of searches
q? -  like q/ but reverse direction like the ? normal command
C-K - enter digraph
C-L - clear and redraw screen
C-A - add [count] to # of alpha char at or after cursor
C-X - sub [count] to # of alpha char at or after cursor
C-G - print file, line location, file status
C-S - pause flow ctrl, terminal accepts input, no output
C-Q - start block-visual, some terminals stty start signal
C-V - enter block visual
C-W - prefix for various things including window resize and movement
C-Z - suspend process
C-] - open tag in new buffer
C-^ - open last editted file
. - repeat last change, doesn't include motions(e.g. h/j/k/l) or commands that dont make changes
- <c-w>f - goto filename undercursor in new window
- <c-w>gf - in new tab
### MOTIONS
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
    (words can contain punctuatio)
e - jump forwards to the end of a word
E - jump forwards to the end of a word
    (words can contain punctuation)
b - jump backwards to the start of a word
B - jump backwards to the start of a word
    (words can contain punctuation)
% - move to matching character (comes form matchit.vim, modern vims have it built in)
    (default supported pairs: '()', '{}', '[]'
    - use <code>:h matchpairs</code> in vim for more info)
0 - jump to the start of the line
| - jump to the start of the line
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
tx - jump to one char before next occurrence of character x
3tx - jump to one char b4 3rd occuurence of char x
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
]m / [m - next/prev method
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
### G COMMANDS (NORMAL MODE)
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
### EDITING
- y - yank (copy) text
    - yl - yank char to the right
- d - delete text
- c - delete text and insert to change
- ~ - toggle selected text between upper/lower case
- r - replace a single character
- R - enter replace mode to repeatedly replace the character under the cursor
- J - join line below to the current one with one space in between
- gJ - join line below to the current one without space in between
- gu - make selected text lower case
- guu - make current line lower case
- gU - make selected text upper case
- gUU - make current line upper case
- gwip - reflow paragraph
- cc - change (replace) entire line
- C - change (replace) to the end of the line
- c$ - change (replace) to the end of the line
- ciw - change (replace) entire word
- vab - visual select all block
- cw - change (replace) to the end of the word
- & - repeat last substitution
- xp - transpose two letters (delete and paste)
- u - undo
- U - undo all latest changes on one line
- Ctrl + r - redo
- `>` - shift text right
- `<` - shift text left
- = - autoindent selected text
- =ip - autoindent inner paragraph
- == - autoindent current line
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

## TEXT OBJECTS
- general pattern: <number><operator/command><number><text object>
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
### ACTION + OBJECTS
v3ta - visual select up to the 3rd occurence of a
d2fn - delete up to 2nd occurence of n
c2aw - delete 2 full words and insert
c2w - delete from cursor current word, then next word, then insert

## VISUAL MODE
v - start visual mode, mark lines, then do a command (like y-yank)
V - start linewise visual mode
C-v - start block visual
o - move to other end of marked area
O - move to other corner of block
Esc - exit visual mode
vi} - visual select inner text of "{}" block
ctrl-va] - visual block select all text of "[]" block

## SELECT MODE
- similar to visual mode, designed to be like regular GUI editors
- `gh` - select
- `gH` - select line
- `g<ctrl-h>` - select block

## REGISTERS
- Registers stored in ~/.viminfo, loaded on next restart
- Register 0 contains he value of the last yank command.
- :let @a=foo  - manually set reg a to something
- :reg - show registers content
- "xy - yank into register x
- "xp - paste contents of register x
- "+y - + reg goes to sys clipboard!
- "*y - in linux * is primary selection
-       contents of what u simply highlighted/selected
- "+p - paste from sys clipboard
- "*p - paste from sys clipboard
- https://vim.fandom.com/wiki/Accessing_the_system_clipboard
- `setreg('a', "dude")` - programattically set register `a` to value `dude`

## JUMP LIST
things that add to jump list:
    - normal mode G
    - searching, / and ?, # and *, n and N
    - window size jumps: L M and H
    - text block jumps: ( ) { }

## MARKS
- `A-Z` uppercase are global to files, `a-z` lower case are for local file, `0-9` set in shada file
    - lower case `a-z` marks lost if buffer removed from list
- `:marks` - list of marks
- `ma` - set current position for mark A
- `'a` - jump to position of mark A
- `y'a` - yank lines from current line to mark `a`

## MACROS
qa - record macro a
q - stop recording macro
@a - run macro a
@@ - rerun last run macro

## FOLDS
zo (open), zO (open all nested)
zc (close), zC (close all)
za (toggle), zA (toggle all)
zm fold one level, zM - close ALL folds
zr expand one level, zR - open ALL folds

## SEARCH
- /pattern - search for pattern
- ?pattern - search backward for pattern
- \vpattern - 'very magic' pattern: non-alphanumeric characters
-     are interpreted as special regex symbols (no escaping needed)
- n - repeat search in same direction
- N - repeat search in opposite direction
- `#` - reverse search for word under cursor
- * - search for next occurence of word under cursor
- [I - show all occurences of word under cursor
- /\C  - force case-sensitive search, /\c opposite
- :g/  - print line # and occurence of each search match
- `:noh` - remove highlighting of search matches
### SEARCH IN MULTIPLE FILES
- `:vimgrep /pattern/ {file}` - search for pattern in multiple files
    - e.g. ` :vimgrep /foo/ **/*`
- `:cn` - jump to the next match
- `:cp` - jump to the previous match
- `:copen` - open a window containing the list of matches
### SED
- find and replace
- visual-mode select -> :s/old/new - replace old with new in all visually selected lines
- `:s/old/new` - replace next `old` with `new` in current line
- `:s/old/new/g` - replace all `old` with `new` in current line
- `:%s/old/new/g` - replace all `old` with `new` throughout file
- `:%s/old/new/gc` - replace all `old` with `new` throughout file with confirmations


## WORKING WITH MULTIPLE FILES
:e file - edit a file in a new buffer
:bnext or :bn - go to the next buffer
:bprev or :bp - go to the previous buffer
:bd - delete a buffer (close a file)
:ls - list all open buffers

## WINDOWS
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


## SPELLING
- set spell
- set spelllang=es - set spell language to spanish
[s - previous spelling error
]s - next spelling error
]S/[S - next/prev major (non-regional) spelling error
z= - bring up autocorrect menu
zg - exclude word
    - for vim, in `.vim` folder, words are added in `spell/en.utf-8.add` file
    - for nvim base folder is `.config/nvim`
zug - undo exclude adding word
zw - add to wrong word list
zuw - remove from wrong word list
