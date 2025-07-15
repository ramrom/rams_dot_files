--*****************************************************************************************************
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> NEOVIM CONFIG <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--*****************************************************************************************************

--------------------------------------------------------------------------------------------------------
-------------------------------- SETTINGS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
vim.opt.backup = false                 -- no backup files
vim.opt.writebackup = false            -- only in case you don't want a backup file while editing
vim.opt.swapfile = false               -- no swap files

vim.opt.mouse=""                         -- turn off all mouse support by default

--- MAIN
vim.opt.autoread = true                         -- reload file's buffer if file was changed externally
vim.opt.splitbelow = true                       -- open new windows on bottom for horizontal, right for vertical
vim.opt.splitright = true                       -- open new windows on bottom for horizontal, right for vertical
vim.opt.wildmenu = true                         -- display command line's tab complete options as menu
vim.opt.wildmode = {'longest', 'list', 'full'}  -- complete longest common, list all matches, complete till next full match
vim.opt.wrap = true                             -- wrap lines longer than width to next line
vim.opt.linebreak = true                        -- avoid wrapping line in middle of a word
vim.opt.scrolloff = 2                           -- always show at least two line above or below the cursor
vim.opt.showcmd = true                          -- show commands i'm process of typing in status bar
vim.opt.number = true                           -- line numbers
vim.opt.updatetime = 1000                       -- default is 4000, used for CursorHold autocmds, swap file writing
vim.opt.backspace= {'indent' ,'eol', 'start'}   -- backspace like most wordprocessors in insert mode
vim.opt.display:append('lastline')              -- display lastline even if its super long
vim.opt.formatoptions:append('j')               -- Delete comment character when joining commented lines

---- SERACHING
vim.opt.hlsearch = true                         -- highlight search
vim.opt.incsearch = true               -- searching as you type (before hitting enter)
vim.opt.ignorecase = true              -- case-insensitive searches
vim.opt.smartcase = true               -- with ignorecase, search with all lowercase means INsensitive, any uppercase means sensitive

--- FOLDING
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false            -- dont fold everything when opening buffers

-- INDENTING
vim.opt.autoindent = true       -- indent on new line for inner scopes in code
vim.opt.shiftwidth=4            -- use 4 spaces for autoindent (cindent)
vim.opt.tabstop=4               -- space 4 columns when reading a <tab> char in file
vim.opt.softtabstop=4           -- complicated, see docs
vim.opt.expandtab = true        -- use spaces when tab is pressed

-- AUTO COMPLETION
vim.opt_global.completeopt = { "menu", "menuone", "noinsert", "noselect" }

-- NETRW
vim.g.netrw_liststyle = 3        -- tree style layout for netrw
-- TODO: per nvim-tree docs, it's highly reccomended to disable netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

--- STATUS LINE
vim.opt.ls=2                    -- line status, two lines for status and command
vim.opt.statusline=[[ %F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [POS=%04l,%04v][%p%%]\ ]]

--- TRAILING SPACES
vim.opt.list = true
vim.opt.listchars = {tab = '»_', trail = '.'}
vim.cmd.highlight('WhiteSpace', 'ctermfg=8 guifg=DimGrey')

-- disable editorconfig file support (https://neovim.io/doc/user/editorconfig.html)
vim.g.editorconfig = false

-- if terminal size changes (e.g. resizing tmux pane vim lives in) automatically resize the vim windows
vim.api.nvim_create_autocmd('VimResized',
    { pattern='*', command = 'wincmd =', desc = 'force window resize when vim resizes'})

-- use ripgrep for default vi grep
if vim.fn.executable('rg') == 1 then vim.opt.grepprg='rg --vimgrep --follow' end

-- highlight lines yanked
vim.api.nvim_create_autocmd('TextYankPost', { pattern = '*',
    callback = function() vim.highlight.on_yank {higroup="IncSearch", on_visual=false, timeout=150} end
})

-- disable autocommenting on o and O in normal
vim.api.nvim_create_autocmd('FileType', { pattern = '*', command ='setlocal formatoptions-=o' })

-- any file name starting with Jenkinsfile should be groovy
vim.filetype.add({ pattern = { ['Jenkinsfile.*'] = 'groovy' } })
-- vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, { pattern = 'Jenkinsfile*', command = 'set filetype=groovy' })

-- use indent folding on scala files b/c treesitter sucks at it
vim.api.nvim_create_autocmd({ 'FileType' }, { pattern = 'scala', command = 'set foldmethod=indent' })

-- for jsonc format, which supports commenting, this will highlight comments
-- NOTE: using `callback` with a function doesn work, but `command` does
vim.api.nvim_create_autocmd('FileType', {
    -- pattern = 'json', callback = function() vim.cmd.syntax([[match Comment +\/\/.\+$+]]) end
    pattern = 'json', command = [[match Comment +\/\/.\+$+]]
})

--------------------------------------------------------------------------------------------------------
-------------------------------- FUNCTIONS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
vim.api.nvim_create_user_command(
    'SilentRedraw',
    [[execute ':silent !'.<q-args> | execute ':redraw!' ]],
    {bang = true, nargs = "*" }
)

---------------------------- NAV MODE (HARPOON, TABBBUF, QUICKFIX) --------------------
MainNavKeyMode = "bufnav"

ToggleMainNavKeys = function(togglemode)
    local function setTabBuf()
        vim.keymap.set("n", "<leader>f", TabBufNavForward, { desc = "tab/buf navigate forward" })
        vim.keymap.set("n", "<leader>d", TabBufNavBackward, { desc = "tab/buf navigate backward" })
        -- vim.keymap.set("n", "<C-l>", "<C-w>l")
        -- vim.keymap.set("n", "<C-h>", "<C-w>h")
        -- vim.keymap.set("n", "<C-j>", "<C-w>j")
        -- vim.keymap.set("n", "<C-k>", "<C-w>k")
        print("tab/buf nav mode activated")
    end

    local function setHarpoon()
        local harpoon = require("harpoon")
        vim.keymap.set("n", "<leader>d", function() harpoon:list():prev() end, {desc = "harpoon prev"})
        vim.keymap.set("n", "<leader>f", function() harpoon:list():next() end, {desc = "harpoon next"})
        -- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
        -- vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
        -- vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
        -- vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
        print("Harpoon mode activated! 𐃆 ")
    end

    local function setQuickList()
        vim.keymap.set("n", "<leader>d", "<cmd>:cn<CR>", {desc = "harpoon prev"})
        vim.keymap.set("n", "<leader>f", "<cmd>:cp<CR>", {desc = "harpoon next"})
        print("quickfix mode activated")
    end

    if (togglemode == "harpoon") then
        if (MainNavKeyMode ~= "harpoon") then MainNavKeyMode = "harpoon" else MainNavKeyMode = "tab-buf" end
    else
        if (MainNavKeyMode ~= "quickfix") then MainNavKeyMode = "quickfix" else MainNavKeyMode = "tab-buf" end
    end

    if (MainNavKeyMode == "harpoon") then
        setHarpoon()
    elseif (MainNavKeyMode == "quickfix") then
        setQuickList()
    else
        setTabBuf()
    end

end

-- if there is one tab, move forward buffer, otherwise forward tabs
TabBufNavForward = function()
    local tabinfo = vim.fn.gettabinfo()
    if #tabinfo == 1 then vim.cmd(':bn!') else vim.cmd(':tabn') end
end

-- if there is one tab, move back buffer, otherwise back tabs
TabBufNavBackward = function()
    local tabinfo = vim.fn.gettabinfo()
    if #tabinfo == 1 then vim.cmd(':bp!') else vim.cmd(':tabprevious') end
end

-------------------------------------------------------

-- close tabs and windows if more than one of either, otherwise closes buffers until one left and then quit vim
-- NOTE: aug'23 - for one tab, the #tabinfo[1]['windows'] returns more than one window id, when there is only one window...
    -- removed it and just use buffer num, with only one tab `:bd` will close a window properly
TabBufQuit = function()
    local tabinfo = vim.fn.gettabinfo()
    if #tabinfo == 1 then
        local bufnum = #vim.fn.getbufinfo({buflisted = 1})
        if bufnum == 1 then vim.cmd(':q') else vim.cmd(':bd') end
    else
        vim.cmd(':q')
    end
end

-- cycle between line 80, 120, and no colorcolumn
CycleColorColumn = function()
    if vim.o.colorcolumn == "121" then vim.o.colorcolumn = "81"
    elseif vim.o.colorcolumn == '81' then vim.o.colorcolumn = ''
    else vim.o.colorcolumn = '121' end
end

ChangeDefinedSession = function()
    vim.g.DefinedSessionName = vim.fn.input("Session Name: ", vim.g.DefinedSessionName)
end

SaveDefinedSession = function()
    if vim.fn.exists(vim.g.DefinedSessionName) ~= 0 then
        vim.g.DefinedSessionName = vim.fn.input("Session Name: ", "MyCurrentVimSession.vim")
    end

    vim.opt.sessionoptions:append('globals')    -- mksession wont save global vars by default
    vim.cmd(":mksession! " .. vim.g.DefinedSessionName)
    print("Saved session: ",vim.g.DefinedSessionName)
end

ToggleLineWrap = function()
    if vim.o.wrap then
        vim.opt.wrap = false
        print("line wrap off")
    else
        vim.opt.wrap = true
        print("line wrap on")
    end
end

ToggleFoldMethod = function()
    if vim.o.foldmethod == "indent" then
        vim.o.foldmethod="expr"
        vim.o.foldexpr="nvim_treesitter#foldexpr()"
        print("fold method: treesitter expression")
    else
        vim.o.foldmethod="indent"
        vim.o.foldexpr=""
        print("fold method: indent")
    end
end

ToggleGitSignsHighlight = function()
    vim.cmd(':Gitsigns toggle_linehl')
    vim.cmd(':Gitsigns toggle_word_diff')
    vim.cmd(':Gitsigns toggle_current_line_blame')
end

GitAddCommitMarkdownStuff = function()
    -- NOTE: oct'24 - uv.cwd lowercased a letter (`S` to `s`) in path, just comparing lower case path for both as workaround
    local is_notes_dir = string.lower(vim.uv.cwd()) == (vim.env.MY_NOTES_DIR and string.lower(vim.env.MY_NOTES_DIR))
    local is_work_dir = string.lower(vim.uv.cwd()) == (vim.env.MY_WORK_DIR and string.lower(vim.env.MY_WORK_DIR))

    if (is_notes_dir or is_work_dir) then
        if vim.bo.filetype == "markdown" then
            vim.cmd(':w')
            vim.cmd([[:SilentRedraw git add . && git commit -m 'added stuff']])
        else
            print("Not a markdown file!, wont add all and commit")
        end
    else
        print("current working dir not the notes dir! returning")
    end
end

ToggleIndentBlankLine = function()
    if IndentBlankLineEnabled then
        require("ibl").update { enabled = false }
    else
        require("ibl").update { enabled = true }
    end
    IndentBlankLineEnabled = not IndentBlankLineEnabled
end

-- NOTE jun'24 - https://neovim.io/doc/user/lsp.html#lsp-log , has vim.lsp.log.get_filename(), seems to return same as get_log_path
-- NOTE jun'23 - still see logs in vim LspLog tab even if metal.log file(verified with cat) is cleared...
ClearLspLog = function()
    local logpath = vim.lsp.get_log_path()
    vim.cmd(':SilentRedraw cat /dev/null > ' .. logpath)
    vim.cmd(':SilentRedraw cat /dev/null > .metals/metals.log')
end

CycleNvimTreeSortBy = function()
    if NvimTreeConfig.sort.sorter == 'name' then
        NvimTreeConfig.sort.sorter = 'extension'
        print("nvim-tree: sorting by extension")
    elseif NvimTreeConfig.sort.sorter == 'extension' then
        NvimTreeConfig.sort.sorter = 'modification_time'
        print("nvim-tree: sorting by modification time")
    else
        NvimTreeConfig.sort.sorter = 'name'
        print("nvim-tree: sorting by name")
    end

    require('nvim-tree').setup(NvimTreeConfig)
    vim.cmd 'NvimTreeFindFileToggle'
end

NvimTreeDynamicWidthEnabled = true

ToggleNvimTreeDynamicWidth = function()
    if NvimTreeDynamicWidthEnabled then
        require("nvim-tree.api").tree.resize({ width = { min = 30, max = 30, padding = 1 }})
        print("DISABLE nvim-tree dynamic width (setting min=30 max=30)")
    else
        require("nvim-tree.api").tree.resize({ width = { min = 10, max = -1, padding = 1 }})
        print("ENABLE nvim-tree dynamic width (setting min=10 max=-1(unbounded))")
    end

    NvimTreeDynamicWidthEnabled = not NvimTreeDynamicWidthEnabled
end


AutoPairEnabled = true

ToggleAutoPair = function()
    if AutoPairEnabled then
        require('nvim-autopairs').disable();
        AutoPairEnabled = false
        print("autopair disabled")
    else
        require('nvim-autopairs').enable();
        AutoPairEnabled = true
        print("autopair enabled")
    end
end

DisplayDiagVirtualText = true

ToggleLSPDiagnosticsVirtualText = function()
    DisplayDiagVirtualText = not DisplayDiagVirtualText
    if DisplayDiagVirtualText then
        vim.diagnostic.config({ virtual_text = true, })
        print("enabling diagnostic virtual text")
    else
        vim.diagnostic.config({ virtual_text = false, })
        print("disabling diagnostic virtual text")
    end
end

AutoAutoCompleteEnabled = false

-- https://www.reddit.com/r/neovim/comments/rh0ohq/nvimcmp_temporarily_disable_autocompletion/
function ToggleAutoAutoComplete()
    local cmp = require('cmp')
    AutoAutoCompleteEnabled = not AutoAutoCompleteEnabled

    if AutoAutoCompleteEnabled then
        cmp.setup({ completion = { autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged } } })
        print('Autocomplete always display ON')
    else
        cmp.setup({ completion = { autocomplete = false } })
        print('Autocomplete always display OFF')
    end
end

-- "Enabled" here means enabled = true and cond = true
-- usage: name of plugin that lazy UI shows
    -- e.g.: LazyPluginEnabled('lualine.nvim') or could be LazyPluginENabled('fzf') ...
LazyPluginEnabled = function(name)
    local l = require('lazy.core.config')
    if l.plugins[name] == nil then return false end  -- if enabled = false, plugin entry here wont be defined
    if l.plugins[name].cond == false then return false else return true end
end

LazyPluginLoaded = function(name)
    if not LazyPluginEnabled(name) then return false end
    return require("lazy.core.config").plugins[name]._.loaded ~= nil
end

-- NOTE: lazy.vim, if enabled = true module exists, and if cond = false it's not loaded
    -- need to set lazy's config for plugins cond to true before you can require it
-- NOTE: vimscript plugins wont have a lua module (aka no `require` invocation), e.g. fzf.vim
-- usage: e.g. Lua.moduleExists('lualine')  , generally without the extension
function moduleExists(name)
    if package.loaded[name] then
        return true
    else
        -- Package.Searchers was renamed from Loaders in lua5.2, have support for both
        ---@diagnostic disable-next-line: deprecated
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                -- luacheck: ignore
                -- luacheck complains about package.preload being read-only
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

-- print msg with vim-notify, if not loaded/available use regular print
function trynotify(msg, loglevel, opts)
    local opts = opts or {}
    local success, notif = pcall(require,'notify')      -- if notify isnt available use regular print
    if success then notif(msg, loglevel, opts) else print(msg) end  -- want notify msg with lowest timeout
end


----------------------------------- RUN IN TMUX PANE -----------------------------------------------------
TmuxPaneRunner = {}
TmuxPaneRunner.activePane = nil
TmuxPaneRunner.clearPaneBeforeRun = true

TmuxPaneRunner.selectPane = function()
    -- display pane index in tmux window
    vim.fn.system({'tmux', 'display-panes' })

    -- prompt input for pane index
    local pane_selection = vim.fn.input("Pane Number: ")

    -- retrieve pane list of pane indexes and titles
    local panes = {}
    require('plenary.job'):new({
        command = 'tmux',
        args = { 'list-panes', '-F', '#{pane_index},#{pane_title}' },
        -- cwd = '/usr/bin',
        -- env = { PATH = vim.env.PATH },
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                print("failure: tmux list-panes return_val not zero!")
            end
            -- vim.cmd(':echo "hi"')  -- will fail, vim.cmd cant be run in lua loop callback
            panes = j:result()
        end,
    }):sync()       -- do start() for async

    pane_selection = tonumber(pane_selection) -- user input is always string

    if pane_selection ~= nil and pane_selection < #panes then  -- nil if convert to number failed
        print("ActiveTmuxRunnerPane set to: " .. pane_selection)
        TmuxPaneRunner.activePane = pane_selection
    else
        print("pane number " .. pane_selection .. " not found!")
    end
end

-- if set, clear the runner pane before command is run
TmuxPaneRunner.toggleClearOnRun = function()
    TmuxPaneRunner.clearPaneBeforeRun = not TmuxPaneRunner.clearPaneBeforeRun
    print("ClearActiveTmuxRunnerPane: " .. tostring(TmuxPaneRunner.clearPaneBeforeRun))
end


-- TODO: maybe add logic to set default pane, look for pane with no child processes (see tmux-open-pane script)
TmuxPaneRunner.paneRun = function(cmd)
    if TmuxPaneRunner.activePane == nil then
        trynotify('ActiveTmuxRunnerPane is nil', "error", { title = "error" })
    else
        if TmuxPaneRunner.clearPaneBeforeRun then
            vim.fn.system({'tmux', 'send-keys', '-t', TmuxPaneRunner.activePane, 'clear', 'C-m'})
        end
        vim.fn.system({'tmux', 'send-keys', '-t', TmuxPaneRunner.activePane, cmd, 'C-m'})
    end
end

TmuxPaneRunner.run = function(arg)
    local curftype = vim.bo.filetype
    if arg == "exe" then
        if curftype == "rust" then
            TmuxPaneRunner.paneRun("cargo run")
        elseif curftype == 'go' then
            TmuxPaneRunner.paneRun("go run ".. vim.fn.expand("%"))
        elseif curftype == 'c' then
            TmuxPaneRunner.paneRun("gcc " .. vim.fn.expand("%") .. ' && ./a.out')
        elseif curftype == 'scala' then
            -- TmuxPaneRunner.paneRun("scala ".. vim.fn.expand("%"))
            TmuxPaneRunner.paneRun("sbt run")
        elseif curftype == 'java' then
            TmuxPaneRunner.paneRun("java-ramrom")
        else
            trynotify("filetype " .. curftype .. " undefined for execute action", "error", { title = "error" })
        end
    elseif arg == 'test' then
        if curftype == "rust" then
            TmuxPaneRunner.paneRun('cargo test')
        elseif curftype == 'go' then
            TmuxPaneRunner.paneRun("go test ".. vim.fn.expand("%"))
        else
            trynotify("filetype " .. curftype .. " undefined for test action", "error", { title = "error" })
        end
    elseif arg == 'build' then
        if curftype == "rust" then
            TmuxPaneRunner.paneRun('cargo build')
        elseif curftype == 'go' then
            TmuxPaneRunner.paneRun("go build ".. vim.fn.expand("%"))
        elseif curftype == 'c' then
            TmuxPaneRunner.paneRun("gcc ".. vim.fn.expand("%"))
        else
            trynotify("filetype " .. curftype .. " undefined for build action", "error", { title = "error" })
        end
    else
       trynotify("undefined action: " .. arg, "error", { title = "error" })
    end
end

----------------------------------------------------------------------------------------------------------
---------------------------------- PLUGIN CONFIG ----------------------------------------------------------
------------------------------------- -------------------------------------------------------------------

---- ONE DARK PRO: https://github.com/olimorris/onedarkpro.nvim
local LoadOneDarkProConfig = function()
    require("onedarkpro").setup({
        highlights = {
            htmlLink = { fg = '#61afef', underline = true },

            -- treesitter uses these group names for markdown headers
            ['@markup.heading.1.markdown'] = { fg = "#FF0000", underline = true },
            ['@markup.heading.2.markdown'] = { fg = "#FF0000", underline = true },
            ['@markup.heading.3.markdown'] = { fg = "#EE596f" },
            ['@markup.heading.4.markdown'] = { fg = "#ef596f" },
            ['@markup.heading.5.markdown'] = { fg = "#ef596f" },
            ['@markup.heading.6.markdown'] = { fg = "#ef596f" },

            Search = { underline = true, italic = true, reverse = true },
        }
    })
    vim.cmd.colorscheme("onedark_dark")
end

----------------------------- HARPOON --------------------------------------------------

LoadHarpoon = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>ka", function() harpoon:list():add() end, { desc = "harpoon add"})
    vim.keymap.set("n", "<leader>ks", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc = "harpoon quickmenu"})

    vim.keymap.set("n", "<leader>kd", function() harpoon:list():prev() end, {desc = "harpoon prev"})
    vim.keymap.set("n", "<leader>kf", function() harpoon:list():next() end, {desc = "harpoon next"})

    vim.keymap.set("n", "<leader>kq", function() harpoon:list():select(1) end, {desc ="harpoon list 1"})
    vim.keymap.set("n", "<leader>kw", function() harpoon:list():select(2) end, {desc ="harpoon list 2"})
    vim.keymap.set("n", "<leader>ke", function() harpoon:list():select(3) end, {desc ="harpoon list 3"})
    vim.keymap.set("n", "<leader>kr", function() harpoon:list():select(4) end, {desc ="harpoon list 4"})

    -- NOTE: this actually leaves a blank line in harpon file, better to use quick menu and `dd`
    vim.keymap.set("n", "<leader>kx", function() harpoon:list():remove() end, {desc = "harpoon delete"}) 
end

----------------------------- TELESCOPE 🔭 --------------------------------------------------
LoadTelescope = function()
    require('telescope').setup{
        defaults = {
            scroll_strategy = "limit",
            preview = {
                filesize_limit = 2,  -- NOTE: oct'24 - floats round up, so 1.01 rounds up to 2, so 1.9MB file will preview
            },
            mappings = {
                -- default: ctrl u/d scroll on preview, ctrl n/p next/prev selection, ctrl k/j not mapped
                i = {
                    ["<F1>"] = "which_key",
                    ["<C-l>"] = {"<Esc>", type = "command" },
                    ['<esc>'] = require('telescope.actions').close,
                    -- ["<C-k>"] = false,   -- not working, maybe just remove this from base insert mode
                    ['<c-u>'] = require('telescope.actions').results_scrolling_up,
                    ['<c-d>'] = require('telescope.actions').results_scrolling_down,
                    ['<c-p>'] = require('telescope.actions').preview_scrolling_up,
                    ['<c-n>'] = require('telescope.actions').preview_scrolling_down,
                    ['<c-j>'] = require('telescope.actions').move_selection_next,
                    ['<c-k>'] = require('telescope.actions').move_selection_previous,
                }
            }
        },
    }

    -- README: https://github.com/nvim-telescope/telescope-fzf-native.nvim
    -- oct'24 - failing b/c fzf-native's `make` command failed, i had to remove/readd pluging from lazy spec for `make` to trigger
    require('telescope').load_extension('fzf')
    -- mostly used b/c noice UI popups dont always show up still
    if not vim.env.NO_NOICE then
        -- require("telescope").load_extension("ui-select")
    end
end

LoadTelescopeEmoji = function()
    require("telescope").load_extension("emoji")
end
----------------------------- FZF LUA --------------------------------------------------
LoadFzfLua = function()
    local help_menu_key = "<C-w><C-w>"
    require'fzf-lua'.setup {
        files = {
             fd_opts = [[--color=never --type f --type l --hidden --no-ignore --exclude .git]],
        },
        -- NOTE: bat previewer doesnt support toggle-preview-cw and cww (rotations)
        winopts = { preview = { default = "bat" },
            title = "NOTE: " .. help_menu_key .." for help menu", 
            title_pos = "center" },
        previewers = {
            bat = { cmd = vim.loop.os_uname().sysname == "Darwin" and "bat" or "batcat" } },
        keymap = {
            -- NOTE: f3, f4 get disabled, but ctrl-a/ctrl-e dont....
            fzf = {
                -- ["ctrl-n"]    = "preview-page-down",  -- unneeded, does fzflua load my FZF_DEFAULT_OPTS?
                -- ["ctrl-p"]    = "preview-page-up",    -- same
                ["ctrl-d"]    = "half-page-down",
                ["ctrl-u"]    = "half-page-up",
                ["f3"]        = "toggle-preview-wrap",
                ["f4"]        = "toggle-preview",
            },
            -- NOTE: c-w based movement for windows in tab disabled when fzflua term window is open anyway
            -- FIXME: oct'24 - f5/f6 defaults don't work, and dont show up as options in help menu either...
            builtin = {
                [help_menu_key]       = "toggle-help",
                ["<F1>"]              = "toggle-help",
                ["<c-w><c-f>"]        = "toggle-fullscreen",
                ["<F2>"]              = "toggle-fullscreen",
                ["<F5>"]              = "toggle-preview-ccw",
                -- ["<c-w><c-e>"]        = "toggle-preview-cw",   -- this map didnt work
                ["<F6>"]              = "toggle-preview-cw",
            }
        }
    }
    -- require('fzf-lua').register_ui_select()
end

----------------------------- Rhubarb --------------------------------------------------
LoadRhubarb = function()
    vim.keymap.set('n', '<leader>gc', '<cmd>:GBrowse!<CR>', { desc = 'copy gh repo to clipboard' })
    vim.keymap.set('v', '<leader>gc', [[:'<,'>GBrowse!<CR>]], { desc = 'copy gh repo to clipboard' })
    vim.keymap.set('n', '<leader>go', '<cmd>:GBrowse<CR>', { desc = 'open gh repo file in browser' })
    vim.keymap.set('v', '<leader>go', [[:'<,'>GBrowse<CR>]], { desc = 'open gh repo file in browser'})
end

---------------------------------- GIT SIGNS ----------------------------------------------
LoadGitSigns = function()
    require('gitsigns').setup{
        signs = {
            add          = { text = '+' },
            change       = { text = '!' },
            delete       = { text = '_', show_count = true },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        linehl = false,
        numhl = false,
        word_diff = false,
    }
end

--------------------------------- LUALINE -------------------------------------------------------
MyCustomLuaLineFlags = function()
    if not DisplayDiagVirtualText then return [[ VTXTOFF ]] else return "" end
end

LuaTabLineTabIndicator = function() return "tabs" end
LuaTabLineBufferIndicator = function() return "buffers" end

LuaLineTabComponentConfig = {
    'tabs',
    mode = 2,
    use_mode_colors = true,
    max_length = vim.o.columns,

    fmt = function(name, context)
        -- Show + if buffer is modified in tab
        local buflist = vim.fn.tabpagebuflist(context.tabnr)
        local winnr = vim.fn.tabpagewinnr(context.tabnr)
        local bufnr = buflist[winnr]
        local mod = vim.fn.getbufvar(bufnr, '&mod')

        return name .. (mod == 1 and ' +' or '')
    end
}

LuaLineBufferComponentConfig = { 'buffers', show_modified_status = true, mode = 4 }

LuaLineBufferDimComponentConfig = {
    'buffers',
    show_modified_status = true,
    mode = 4,
    buffers_color = { inactive = { fg = 'grey', bg = 'black' }, active = 'grey', },
}

UpdateLuaLineTabLine = function(args)
    local tabinfo = vim.fn.gettabinfo()
    -- print("number of tabs: " .. #tabinfo)
    if #tabinfo == 1 then
        local config = require('lualine').get_config()
        config.tabline.lualine_a = { { LuaTabLineBufferIndicator, color = { fg = 207, bg = 016 } }, LuaLineBufferComponentConfig }
        -- config.tabline.lualine_a = { LuaLineBufferComponentConfig }
        config.tabline.lualine_z = { }
        require('lualine').setup(config)
        -- require('lualine').refresh({ scope = 'tabpage', place = { 'tabline' } }) -- doesnt work
    -- if number of tabs is 3, then closing goes to 2, open to 4, no need to do a costly update (same logic if num tabs > 3)
    elseif #tabinfo == 2 or (#tabinfo > 2 and args == true) then
        local config = require('lualine').get_config()
        LuaLineTabComponentConfig['max_length'] = vim.o.columns -- update incase vim size changed
        config.tabline.lualine_a = { { LuaTabLineTabIndicator, color = { fg = 099, bg = 016 } } , LuaLineTabComponentConfig }
        config.tabline.lualine_z = { LuaLineBufferDimComponentConfig }
        require('lualine').setup(config)
        -- require('lualine').refresh({ scope = 'tabpage', place = { 'tabline' } })  -- doesnt work
    end
end

LoadLuaLine = function()
    require('lualine').setup {
        options = {
            icons_enabled = false,
            {'branch', icon = 'ᛘ'},
            theme = 'onedark',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = {'branch', 'diff', 'lsp_status', 'diagnostics'},
            -- lualine_b = { { 'branch', icons_enabled = true, {'branch', icon = 'ᛘ'} }, 'diff', 'diagnostics' },
            lualine_c = {
                { 'filename', file_status = true, path = 1 },
                { MyCustomLuaLineFlags, color = { fg = 001, bg = 022 } }
            },
            lualine_x = {'filetype', 'encoding', 'fileformat'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {   -- inactive section means inactive windows
            lualine_c = {'filename'},
            lualine_x = {'location'},
        },
        tabline = {
            lualine_a = { { LuaTabLineBufferIndicator, color = { fg = 207, bg = 016 } }, LuaLineBufferComponentConfig }
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }

    -- update tabline when tabs are created or closed
    vim.api.nvim_create_autocmd({ 'TabNew', 'TabClosed' }, { callback = UpdateLuaLineTabLine, })

    -- if terminal size changes (e.g. resizing tmux pane vim lives in) automatically resize the vim windows
    vim.api.nvim_create_autocmd('VimResized', { pattern='*', callback = function() UpdateLuaLineTabLine(true) end,
          desc = 'force lualine udpate when vim resizes'})
end

---------------------- WHICH-KEY CONFIG -------------------------------
-- LoadWhichKey = function() require("which-key").add(WhichKeyOpts) end
WhichKeyOpts = {
    preset = "modern",
    spec = {
        { "g",  group = "LSP + more"},
        { "gl", group = "LSP conf cmds" },
        { "gw", group = "LSP diagnostics" },
        { "gk", group = "DAP stuff" },
        { "<leader>l", group = "LSP fzf search" },
        { "<leader>a", group = "smart run/execute" },
        { "<leader>c", group = "cheatsheets+notes" },
        { "<leader>g", group = "git/github stuff" },
        { "<leader>e", group = "fzf grepping" },
        { "<leader>w", group = "misc config" },
        { "<leader>k", group = "harpoon 𐃆" },
        { "<leader>u", group = "unicode" }
    }
}

---------------------- NVIM-TREE CONFIG -------------------------------

NvimTreeConfig = {
    on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.del('n', '<C-e>', { buffer = bufnr })  -- remove open-in-place, want scroll up by one line
    end,
    sort = { sorter = "name" },
    renderer = { full_name = true }, -- if highlighted item's full path is longer than nvim window width, render into next window
    view = { width = { min = 10, max = 50, padding = 1 }, },
    filters = { git_ignored = false },   -- show gitignored files
}

LoadNvimTree = function() require("nvim-tree").setup(NvimTreeConfig) end

---------------------- TREE-SITTER CONFIG -------------------------------
-- NOTE: is TS is disabled for a buffer, old vim regex highlighting turns on
-- vim.cmd(':syntax off') 

LoadTreeSitter = function()
    -- require("nvim-treesitter.install").prefer_git = true
    require('nvim-treesitter.configs').setup {
        ensure_installed = "all",   -- A list of parser names, or "all"
        ignore_install = { "ipkg" },
        sync_install = false,       -- Install parsers synchronously (only applied to `ensure_installed`)

        highlight = {
            enable = true,     -- `false` will disable the whole extension
            -- NOTE: parsers names are not the filetype name. (for `tex` filetype, include `latex`, as this is the name of the parser)
            -- NOTE: oct2024 - tested on 36MB json file, opening file took ~35sec, with OR without disabling TS and vim-regex
            disable = function(lang, buf)
                local max_filesize = 20 * 1024 * 1024 -- 20 MB 
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = 'gn',
                node_incremental = '<TAB>',
                -- node_decremental = '<S-TAB>',
                node_decremental = '<c-k>',
                scope_incremental = '<CR>',
            },
        },
    }

    -- june'23 treesitter supports groovy, but wont fold on Jenkinsfiles
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'groovy',
        callback = function()
            vim.opt_local.foldmethod="indent"
            vim.opt_local.foldexpr=""
        end
    })

    -- hightlight hyperlinks that are in regular paragraph/text regions in markdown files
    -- jun'24: placing this autocmd outside this loadtreesitter func fails, autocommand runs but vim.cmd.syntax doesnt do anything...
        -- might be similar to the json comment autocommand issue, i switched from callback to command and it worked
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        desc = 'highlight hyperlinks in regular paragraph/text of markdown',
        callback = function()
            vim.cmd.highlight("link mkdInlineURL htmlLink")
            vim.cmd.syntax([[match mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*/]])
        end,
    })

    vim.opt.foldmethod='expr'
    vim.opt.foldexpr='nvim_treesitter#foldexpr()'
end

------------------------- NOICE -----------------------------------------------
LoadNoice = function()
    require('noice').setup {
        views = { split = { enter = true } },
        presets = {
            bottom_search = false, -- use a classic bottom cmdline for search
            -- command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        routes = {
          { filter = { event = "msg_show", min_height = 20 }, view = "split", },
          { filter = { event = "msg_show", find = "Saved session: " }, view = "mini", },
          { filter = { event = "msg_show", find = "B written" }, view = "mini", },
          { filter = { event = "msg_show", find = " change; before" }, view = "mini", },
          { filter = { find = "E162" }, view = "mini", },       -- no write since last change error
          { filter = { find = "E37" }, view = "mini", },       -- no write since last change error
        },
    }

    -- FIXME: apr'24 - get this working
    vim.keymap.set("c", "<S-Enter>", function()
        require("noice").redirect(vim.fn.getcmdline())
    end, { desc = "Redirect Cmdline" })
end

------------------------- COPILOT OPTS -----------------------------------------------
LoadCopilot = function()
    vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false
    })
    vim.g.copilot_no_tab_map = true
end

CoPilotChatOpts = {
    mappings = {
        reset = {
            normal = '<C-k>',
            insert = '<C-k>'
        }
    }
}

------------------------- FLASH -----------------------------------------------
FlashOpts = {
    modes = {
        search = { enabled = false }   -- dont add flash keys for regular search
    }
}

FlashKeyDefinitions = {
    {
        "s",
        mode = { "n", "x", "o" },
        -- match only beg of words
        function()
            require("flash").jump({
              search = {
                mode = function(str)
                  return "\\<" .. str
                end,
              },
            })
        end,
        desc = "Flash",
    },
    -- visual select fast based on treesitter objects
    -- FIXME: can remote , then flash treesitter combo
        -- but "y""s" sequence conflicts with vim-surround
    {
        "S",
        mode = { "n", "o", "x" },
        function()
            require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
    },
    -- remote key, do an op and return to original cursor location
    -- e.g. `yrfa$` - yank remote letter f, (say sel 'a'), to end of line
    {
        "r",
        mode = "o",
        function()
            require("flash").remote()
        end,
        desc = "Remote Flash",
    },
    {
        "<c-s>",            -- toggle off this flash search in search mode
        mode = { "c" },     -- search `/` or `?` falls under command mode
        function()
            require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
    },
}

------------------------- INDENT BLANKLINE -----------------------------------------------
LoadIndentBlankLine = function()
    IndentBlankLineEnabled = false
    require("ibl").setup {
        whitespace = { remove_blankline_trail = false },
        enabled = IndentBlankLineEnabled,
    }
end

------------------------------- LUASNIP -----------------------------------------------------------
LoadLuaSnip = function()
    require("luasnip.loaders.from_vscode").lazy_load()
end

--------------------- TABOUT --------------------------------
LoadTabOut = function()
    require('tabout').setup {
        tabkey = '<C-s>', -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = '<C-d>', -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = false, -- if the tabkey is used in a completion pum
        tabouts = {
            { open = "'", close = "'" },
            { open = '"', close = '"' },
            { open = '`', close = '`' },
            { open = '(', close = ')' },
            { open = '[', close = ']' },
            { open = '{', close = '}' }
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {} -- tabout will ignore these filetypes
    }
end


----------------- AUTOPAIR ----------------------------------
LoadAutoPair = function()
    require('nvim-autopairs').setup({ map_c_h = true }) -- Map the <C-h> key to delete a pair
    local Rule = require('nvim-autopairs.rule')
    require('nvim-autopairs').add_rule(Rule("<",">","rust"))
end


--------------------------------------------------------------------------------------------------------
-------------------------------- LSP CONFIG ----------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        SetLSPKeymaps()
        vim.opt.signcolumn="yes:2" -- static 2 columns, at least one for signify and one for lsp diags
    end,
})

-- NOTE: vim.env.FOO will be `nil` if env var isnt set, not `nil` = `true`, if set and a string not `someval` is `false`
LSPAutoStartEnable = not vim.env.NO_LSP_AUTOSTART
-- print("autostart: " .. tostring(LSPAutoStartEnable))

-------------------------------- NVIM-CMP -------------------------------------------
LoadAutoComplete = function()
    local cmp = require('cmp')
    local initial_auto_completion = false   -- dont show autocomplete menu be default

    if AutoAutoCompleteEnabled then
        initial_auto_completion =  { require('cmp.types').cmp.TriggerEvent.TextChanged }
    end

    cmp.setup {
        completion = { autocomplete = initial_auto_completion, },
        experimental = { ghost_text = true },    -- show virtual text of what the current autocompletion selection would look like
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-k>'] = cmp.mapping.select_prev_item(),     -- ctrl-k/j are nicer to hit that ctrl-n/p
            ['<C-j>'] = cmp.mapping.select_next_item(),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
            ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
            -- C-b (back) C-f (forward) for snippet placeholder navigation.
            ['<C-e>'] = cmp.mapping.abort(),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
        }),
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'path' },
            { name = 'buffer' },
            { name = 'luasnip' },
        },
        -- see https://www.reddit.com/r/neovim/comments/14k7pbc/what_is_the_nvimcmp_comparatorsorting_you_are/
        sorting = {
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,

                -- from https://github.com/lukas-reineke/cmp-under-comparator
                function(entry1, entry2)
                    local _, entry1_under = entry1.completion_item.label:find "^_+"
                    local _, entry2_under = entry2.completion_item.label:find "^_+"
                    entry1_under = entry1_under or 0
                    entry2_under = entry2_under or 0
                    if entry1_under > entry2_under then
                        return false
                    elseif entry1_under < entry2_under then
                        return true
                    end
                end,

                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },

        formatting = {
            format = require('lspkind').cmp_format({
                mode = "symbol_text",
                menu = ({
                    buffer = "[Buffer]",
                    path = "[Path]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[Latex]",
                })
            }),
        },
    }
end

---------------- BFQ ---------------------------------------
LoadBQF = function()
    require('bqf').setup({
        auto_enable = true,
        auto_resize_height = true, -- highly recommended enable
        preview = {
            win_height = 24,
            win_vheight = 12,
            delay_syntax = 80,
            -- border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
            should_preview_cb = function(bufnr, qwinid)
                local ret = true
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                local fsize = vim.fn.getfsize(bufname)
                if fsize > 100 * 1024 then
                    -- skip file size greater than 100k
                    ret = false
                elseif bufname:match('^fugitive://') then
                    -- skip fugitive buffer
                    ret = false
                end
                return ret
            end
        },
    })
end

------------------- SCALA METALS -----------------------------
--- verify java is 21
ValidateJavaVersion = function(javaVersion)
    local true_java = vim.fn.resolve(vim.env.JAVA_HOME)  -- follow symbolic links, sdkman sets JAVA_HOME to symlink to real java
    print("JAVA_HOME: " .. true_java)
    if (not string.find(true_java, "java/" .. javaVersion .. "%.")) then
        return false
    end
    return true
end

-- NOTE: sept2024 - needs java 11 or 17 by OpenJDK or Oracle
LoadScalaMetals = function()
    metals_config = require("metals").bare_config()

    local is17 = ValidateJavaVersion("17")
    local is11 = ValidateJavaVersion("11")
    if (not (is17 or is11)) then print("DID NOT DETECT JAVA " .. "17 or 11" .. " in JAVA_HOME, aborting loading metals"); return end

    metals_config.settings = {
        -- NOTE: per one metals log, scala 2.13.6 last metals support 1.3.0, but fails when i try no compliaton :(
        -- serverVersion = '0.11.10',  -- logs say scala 2.13.1 is last supported by 0.11.10
        -- javaHome = vim.env.HOME .. "/.sdkman/candidates/java/8.0.345-zulu",
        verboseCompilation = true,
        inlayHints = {
            showImplicitArguments = { enable = true },
            showImplicitConversionsAndClasses = { enable = true },
            showInferredType = { enable = true },
        }
    }

    metals_config.init_options.statusBarProvider = "off"

    -- metals_config.capabilities = capabilities
    metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Autocmd that will actually be in charging of starting the whole thing
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
            require("metals").initialize_or_attach(metals_config)
        end,
        group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    })

    vim.opt_global.shortmess:remove('F')   -- Ensure autocmd works for filetype
    vim.opt_global.shortmess:append('c')   -- Avoid showing extra message when using completion

    -- for telescope
    -- vim.keymap.set('n', '<leader>fm', '<cmd>Telescope metals commands<cr>')

    metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
        SetMetalsKeymaps()
    end
end

------------------------ DAP ------------------
LoadDAP = function()
    local dap = require("dap")
    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
            --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
            runType = "runOrTestFile",
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
            runType = "testTarget",
        },
      },
    }
end

----------------- LUA LSP ----------------------------
-- TODO: neovim lspconfig setup - https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
LoadLuaLSP = function()
    require'lspconfig'.lua_ls.setup{}
end


---------------- RUST LSP ---------------------------
-- config: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#rust_analyzer
LoadRustLSP = function()
    require('lspconfig').rust_analyzer.setup({
        autostart = LSPAutoStartEnable,
        settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true
                },
            }
        }
    })
end

------------ GOLANG gopls LSP ----------------------
LoadGolangLSP = function()
    require'lspconfig'.gopls.setup{
        autostart = LSPAutoStartEnable,
        cmd = {"gopls", "serve"},
        filetypes = {"go", "gomod", "gotmpl" },
        root_dir = require("lspconfig/util").root_pattern("go.mod", ".git"),
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
        single_file_support = true
    }

    -- golang DAP
    -- lua require('dap-go').setup()
end

-------------- JAVA JDTLS ---------------------------
ValidateJavaInstallDirs = function(JavaInstalls)
    local result = 0
    for i,v in ipairs(JavaInstalls) do
        local res = vim.fn.isdirectory(vim.fn.expand(v.path))
        if (res == 0) then
            print("Java install ".. v.name .. "at path: ".. v.path .. " does not exist!")
            result = 1
        end
    end
    return result
end

-- jdtls lang server requires java 21, make sure JAVA_HOME of shell is set to java21
LoadJDTLSServer = function()
    local JavaInstalls = {
        {
            name = "JavaSE-1.8",
            path = "~/.sdkman/candidates/java/8.0.345-zulu"
        },
        {
            name = "JavaSE-11",
            path = "~/.sdkman/candidates/java/11.0.16.1-tem"
        },
        {
            name = "JavaSE-17",
            path = "~/.sdkman/candidates/java/17.0.6-tem"
        },
        {
            name = "JavaSE-21",
            path = "~/.sdkman/candidates/java/21.0.2-tem"
        },
    }

    if (ValidateJavaInstallDirs(JavaInstalls) == 1) then
        -- sept'24 - TODO: tried `echoerr` and it fails, see https://github.com/neovim/neovim/issues/13928 , err_writeln below fails too
        -- vim.api.nvim_err_writeln("-\nAborting loading JDTLS server, missing java installs")
        print("-\nAborting loading JDTLS server, missing java installs")
        return
    end

    local config = {
        autostart = LSPAutoStartEnable,
        -- OSX brew jdtls formula exists, on linux downloaded compiled bin and symlinked to ~/bin
        -- cmd = { vim.loop.os_uname().sysname == "Darwin" and '/opt/homebrew/bin/jdtls' or vim.env.HOME .. '/bin/jdtls' },
        cmd = { vim.env.HOME .. '/bin/jdtls' },
        root_dir = vim.fs.root(0, {".git", "mvnw", "gradlew", "pom.xml"}),
        settings = {
            java = {
                -- `name` must match a value in enum ExecutionEnvironment
                -- see https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line
                configuration = { runtimes = JavaInstalls }
            }
        }
    }

    require('jdtls').start_or_attach(config)

    -- NOTE: jun'24 - README says create a ftplugin java.lua file for this, but this is the same and it works
        -- previously i didnt have this and goto def was not working
    vim.api.nvim_create_autocmd("Filetype", {
        pattern = "java",
        callback = function() require("jdtls").start_or_attach(config) end,
    })
end

---------------- GROOVY LSP -------------------------------------
-- neovim lspconfig: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#groovyls
LoadGroovyLSP = function()
    require('lspconfig').groovyls.setup{
        autostart = LSPAutoStartEnable,
        cmd = { "java", "-jar", vim.env.HOME .. "/bin/groovy-language-server-all.jar" },
    }
end


------------- KOTLIN LSP -------------------------------------
-- lang server - https://github.com/fwcd/kotlin-language-server

-- NOTE: mar2024 - brew install needed JVM 21 installed for the server to start
-- NOTE: a `kls_database.db` file and `bin` dir at root are created for metadata, should add to gitignore
LoadKotlinLSP = function()
    -- if (not ValidateKotlinJavaDep()) then return end
    require('lspconfig').kotlin_language_server.setup{
        autostart = LSPAutoStartEnable,
        -- cmd = { "kotlin-language-server" },
        cmd = { "kotlin-language-server-java21" },  -- use a binstub that sets JAVA_HOME to java21 version, then launch LSP
        filetypes = { "kotlin", "kt" },
        root_dir = require("lspconfig/util").root_pattern("settings.gradle", "settings.gradle.kts")
    }
end

----------------- RUBY LSP ---------------------------------------
-- lang server - https://shopify.github.io/ruby-lsp/
-- TODO: also check out rails LSP: https://github.com/Shopify/ruby-lsp-rails
LoadRubyLSP = function()
    require('lspconfig').ruby_lsp.setup{
        -- below are default opts

        -- cmd = { "ruby-lsp" },
        -- filetypes = { "ruby" },
        -- init_options = { formatter = "auto" },
        -- root_patterns = { "Gemfile", ".git" },
        -- single_file_support = true,
    }
end

-----------BUILTIN LSPCONFIGS ---------------------

LoadLSPConfig = function()
    -- LoadLuaLSP()
    -- LoadRubyLSP()
    LoadRustLSP()
    LoadGolangLSP()
    LoadKotlinLSP()
    LoadGroovyLSP()
    -- vim.api.nvim_create_autocmd("VimEnter", { callback = function() print("hi") end, })

    ClearLspLog()
    -- level 0-5, TRACE=0, 5=OFF
    if (vim.env.LSP_LL) then
        vim.lsp.set_log_level(tonumber(vim.env.LSP_LL));
        print("log level set to: ".. vim.lsp.log.get_level());
    end
end

--------------------------------------------------------------------------------------------------------
-------------------------------- KEYMAPS --------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
vim.g.mapleader = " "

------------ NOTE: Prime open real estate for key -------------------
-- NORMAL MODE
    -- <leader> + ,/u/z/x/<0-9>
    -- <Leader><Leader>  (most open)
    -- <BS>
    -- c-q (same as c-v)
    -- c-s (pause ctrl flow)
    -- c-x (opposite of c-a, i clobber c-a for tmux meta)
    -- c-p currently i use for indent left, but i should just use <<
    -- c-n currently i use for indent right, but i should just use >>
    -- ;  - semicolon repeats last f/F motions
    -- ,  - in reverse direction
-- INSERT MODE
    -- c-v, c-q(same as c-v) c-space, c-y

-- TODO: i think this map is probably useful
-- vim.keymap.set("n", "<C-j>", "a<CR><Esc>k$")
-- NOTE: oct'24 - using <leader>k for harpoon for now
-- vim.keymap.set({'n', 'x'}, '<leader>k', '%', { desc = "go to matching pair" }) -- FIXME: doesnt work, only [](){}, not if/else/end

vim.keymap.set("i", "<C-l>", "<Esc>")   ---- BETTER ESCAPE
vim.keymap.set('n', '<leader>r', 'q:', { desc = "command line history editor" })
vim.keymap.set("n", "<leader>.", "<cmd>:@:<CR>", { desc = "repeat last command" })
vim.keymap.set("n", "<leader><leader>e", "<cmd>:Explore<CR>", { desc = "explore current dir" })
vim.keymap.set("n", "<leader><leader>l", "<cmd>:Lazy<CR>", { desc = "lazy.nvim plugin manager" })
vim.keymap.set("n", "<leader>j", "<cmd>:noh<CR>", { desc = 'remove search highlights' })
-- vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'remove search highlights' })
vim.keymap.set("n", "<C-Space>", "<cmd>:Lazy<CR>")

-- SMART RUN ACTIONS
vim.keymap.set("n", "<leader>ar", TmuxPaneRunner.selectPane, { desc = "set tmux pane runner" })
vim.keymap.set("n", "<leader>ac", TmuxPaneRunner.toggleClearOnRun, { desc = "toggle if runner pane is cleared before cmd execution" })
vim.keymap.set("n", "<leader>aa", function() TmuxPaneRunner.run('exe') end, { desc = "execute program" })
vim.keymap.set("n", "<leader>at", function() TmuxPaneRunner.run('test') end, { desc = "run tests" })
vim.keymap.set("n", "<leader>ab", function() TmuxPaneRunner.run('build') end, { desc = "build/compile program" })

------ WINDOW RESIZE/MOVE/CREATE
local default_opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Left>", ":vertical resize +1<CR>", default_opts)
vim.keymap.set("n", "<Right>", ":vertical resize -1<CR>", default_opts)
vim.keymap.set("n", "<Up>", ":resize -1<CR>", default_opts)
vim.keymap.set("n", "<Down>", ":resize +1<CR>", default_opts)
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set('n', '<leader>v', ':vsplit<CR><leader>w')
vim.keymap.set('n', '<leader>h', ':split<CR><leader>w')

------ TAB MOVE/NAV/CREATE
vim.keymap.set("n", "<leader>f", TabBufNavForward, { desc = "tab/buf navigate forward" })
vim.keymap.set("n", "<leader>d", TabBufNavBackward, { desc = "tab/buf navigate backward" })
vim.keymap.set("n", "<leader>m", ":tabm<Space>", { desc = "move tab" })
vim.keymap.set("n", "<leader>t", "<cmd>:tabnew<CR>", { desc = "create tab"} )
vim.keymap.set("n", "<leader><leader>T", "<cmd>:tabnew %<CR>", { desc = "duplicate split into new tab" })
vim.keymap.set("n", "<leader><leader>t", "<C-w>T", { desc = "move split to new tab" })
vim.keymap.set("n", "gb", "<cmd>:tabprevious<CR>")
-- Quickly switch between vimtab indexes 1 to 9
for i=0,9,1 do vim.keymap.set('n',"g"..i,"<cmd>:tabn "..i.."<CR>") end

---- SMART QUITTING
vim.keymap.set("n", "<leader>q", TabBufQuit, { desc = "smart quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>:q!<CR>")
vim.keymap.set("n", "<leader><leader>q", "<cmd>:qa<CR>")

------ SMART WRITING
vim.keymap.set("i", "<C-k>", "<C-o>:w<cr>", { desc = "write changes staying in insert"})
vim.keymap.set("n", "<leader>s", "<cmd>:w<CR>")
vim.keymap.set('n', "<leader>S", SaveDefinedSession, { desc = "save defined session" })
vim.keymap.set('n', "<leader><C-S>", ChangeDefinedSession, { desc = "change defined session" })

---- COPY/PASTE to clipboard
vim.keymap.set({"n","v"}, "<leader>y", [["+y]])
vim.keymap.set({"n","v"}, "<leader>p", [["+p]])

--------- FASTER INDENT
vim.keymap.set('n', '<C-n>', '>>')
vim.keymap.set('n', '<C-p>', '<<')
vim.keymap.set('v', '<C-n>', '<S->>gv')
vim.keymap.set('v', '<C-p>', '<S-<>gv')

--- ADD NEWLINE AND STAY IN NORMAL
vim.keymap.set("n", "<C-g>", "o<Esc>")   -- C-g default is to print file name and other metadata

-- INSERT MODE NAVIGATION
vim.keymap.set("i", "<C-e>", "<C-o>$")   -- C-e default per nvim docs - does nothing
vim.keymap.set("i", "<C-a>", "<C-o>0")   -- C-a default per nvim docs - insert previously inserted text
vim.keymap.set("i", "<C-b>", "<C-o>h")   -- C-b default per nvim docs - does nothing
vim.keymap.set("i", "<C-f>", "<C-o>l")   -- C-f default per nvim docs - indenting for chars */!

--------- FZF ---------------------
vim.keymap.set('n', '<leader><leader>f', function() require('fzf-lua').builtin() end, { desc = "fzf lua meta finder" })
vim.keymap.set('n', '<leader>;',function() require('fzf-lua').commands() end, { desc = "fzf vim commands" })
vim.keymap.set('n', '<leader><leader>h',function() require('fzf-lua').help_tags() end, { desc = "fzf help tags" })
vim.keymap.set('n', '<leader><leader>r',function() require('fzf-lua').command_history() end, { desc = "fzf command history" })
vim.keymap.set('n', '<leader>b',function() require('fzf-lua').buffers() end, { desc = "fzf buffers" })
------ FZF FILES
vim.keymap.set('n', '<leader>O',function() require('telescope.builtin').find_files() end, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>o',function() require('fzf-lua').files() end, { desc = "fzf files" })
vim.keymap.set('n', '<leader><leader>o',function() require('fzf-lua').files({cwd='~/'}) end, { desc = "fzf files homedir" })
vim.keymap.set('n', '<leader>i',function() require('fzf-lua').oldfiles() end, { desc = "fzf lua oldfiles" })
------ FZF GREP
vim.keymap.set('n', '<leader>ef',function() require('fzf-lua').grep() end, { desc = "fzf grep (rg query, then fzf results)" })
vim.keymap.set('n', '<leader>el',function() require('fzf-lua').live_grep() end, { desc = "fzf live grep" })
vim.keymap.set('n', '<leader>ee',function() require('fzf-lua').grep_cword() end, { desc = "fzf cursor grep word" })
vim.keymap.set('n', '<leader>eE',function() require('fzf-lua').grep_cWORD() end, { desc = "fzf cursor grep cWORD" })
vim.keymap.set('n', '<leader>eo',function() require('fzf-lua').blines() end, { desc = "fzf current buffer lines" })
vim.keymap.set('n', '<leader>ei',function() require('fzf-lua').lines() end, { desc = "fzf all buffer lines" })
vim.keymap.set('n', '<leader>ec',function() require('fzf-lua').grep({cwd='~/rams_dot_files/cheatsheets/'}) end,
    { desc = "fzf grep cheatsheet dir" })
local str_grep_mydirs = function()
    local sr = vim.fn.input("Query: ")
    require('telescope.builtin').grep_string({ search = sr, search_dirs = {'~/rams_dot_files/cheatsheets', vim.env.MY_NOTES_DIR }})
end
vim.keymap.set('n', '<leader>ej', str_grep_mydirs, { desc = "fzf grep cheatsheet + notes dir" })
vim.keymap.set('n', '<leader>en',function() require('fzf-lua').grep({cwd=vim.env.MY_NOTES_DIR}) end, { desc = "fzf grep notes files" })
vim.keymap.set('n', '<leader>ew',function() require('fzf-lua').grep({cwd=vim.env.MY_WORK_DIR}) end, { desc = "fzf grep work files" })

--------- GIT STUFF
vim.keymap.set('n', '<leader><leader>g', '<cmd>G<CR>', { desc = 'G - fugitive panel' })
vim.keymap.set('n', '<leader>gl', function() require('fzf-lua').git_commits() end, { desc = "fzf git commits" })
vim.keymap.set('n', '<leader>gg', GitAddCommitMarkdownStuff, { desc = "git add all + commit" })
vim.keymap.set('n', '<leader>gb', function() require('fzf-lua').git_bcommits() end, { desc = "fzf buffer git commits" })
vim.keymap.set('n', '<leader>gs', function() require('fzf-lua').git_status() end, { desc = "fzf git status" })
vim.keymap.set('n', '<leader>gm', "<cmd>0Gclog<cr>", { desc = "fugitive buffer git log" })
vim.keymap.set('n', '<leader>gM', "<cmd>Gclog<cr>", { desc = "fugitive repo git log" })
vim.keymap.set('n', '<leader>ga', "<cmd>Git blame<cr>", { desc = "fugitive git blame" })
vim.keymap.set('n', '<leader>gS', '<cmd>Gitsigns toggle_signs<cr>')
vim.keymap.set('n', '<leader>gh', ToggleGitSignsHighlight, { desc = "toggle git signs highlighting"} )
-- FIXME: apr'24 - using the :tab command directly with Gvdiffsplit doesnt work right
    -- vim.keymap.set('n', '<leader>gd', '<cmd>:tab Gvdiffsplit<cr>', {desc = "diff from HEAD"})
-- FIXME: vim-markdown(treesitter works fine) for md files does not set foldmethod=diff, folds collapse
    -- sorta related https://github.com/tpope/vim-fugitive/issues/1911
vim.keymap.set('n', '<leader>gd', '<cmd>tab sb<cr><cmd>Gvdiffsplit<cr>', {desc = "diff from HEAD"})
vim.keymap.set('n', '<leader>gD', '<cmd>tab sb<cr><cmd>Gvdiffsplit master<cr>', {desc = "diff from master branch"})
vim.keymap.set('n', '<leader>gf', '<cmd>tab sb<cr><cmd>Gvdiffsplit HEAD^<cr>', {desc = "diff since last commit"})

---------- NVIM TREE
vim.keymap.set('n', '<leader>N', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeFindFileToggle<CR>')
vim.keymap.set('n', '<leader>wd', ToggleNvimTreeDynamicWidth, { desc = 'toggle nvim-tree width b/w dynamic and static size' })
vim.keymap.set('n', '<leader>wt', CycleNvimTreeSortBy, { desc = 'cycle nvim-tree sortby b/w name, mod time, and extension' })

---------- CHEATS + NOTES
vim.keymap.set('n', '<leader>cm',function() require('fzf-lua').keymaps() end, { desc = "fzf key mappings" })
vim.keymap.set('n', '<leader>ch',function() require('fzf-lua').help_tags() end, { desc = "fzf help tags" })
vim.keymap.set('n', '<leader>cc',function() require('fzf-lua').files({cwd='~/rams_dot_files/cheatsheets/'}) end,
    { desc = "fzf cheatsheet files" })
vim.keymap.set('n', '<leader><leader>c',function() require('fzf-lua').files({cwd='~/rams_dot_files/cheatsheets/'}) end,
    { desc = "fzf cheatsheet files" })
vim.keymap.set('n', '<leader>cn',function() require('fzf-lua').files({cwd=vim.env.MY_NOTES_DIR}) end, { desc = "fzf notes files" })
vim.keymap.set('n', '<leader>cw',function() require('fzf-lua').files({cwd=vim.env.MY_WORK_DIR}) end, { desc = "fzf work files" })
vim.keymap.set('n', '<leader>ca', '<cmd>tabnew $MY_WORK_TODO<cr>', { desc = "open work TODO in-progress in new tab"})
vim.keymap.set('n', '<leader>cS', '<cmd>vsplit ~/tmp/scratch.md<cr>')
vim.keymap.set('n', '<leader>cs', '<cmd>tabnew ~/tmp/scratch.md<cr>')
vim.keymap.set('n', '<leader>ci', '<cmd>Inspect<cr>', { desc = "treesitter Inspect" })

-------------- OTHER
vim.keymap.set("n", "<leader>wj", "<cmd>NoiceDismiss<CR>", { desc = "clear noice notifications on screen" })
vim.keymap.set("n", "<leader>wb", "<cmd>Tabularize/|<CR>", { desc = "tabularize (pipe delimiter)" })
vim.keymap.set("n", "<leader>wc", "<cmd>messages clear<CR>", { desc = "clear messages" })
vim.keymap.set('n', '<leader>wi', ToggleIndentBlankLine, { desc = "toggle indent blankline"})
vim.keymap.set('n', '<leader>wm', '<cmd>messages<cr>')
vim.keymap.set('n', '<leader>wn', '<cmd>Noice<cr>')
vim.keymap.set('n', '<leader>wM', '<cmd>MarkdownPreviewToggle<cr>')
vim.keymap.set('n', '<leader>wT', [[ <cmd>:execute '%s/\s\+$//e' <cr> ]], { desc = "remove trailing whitespace"})
vim.keymap.set('n', '<leader>ws', '<cmd>set number!<cr>')
vim.keymap.set('n', '<leader>ww', ToggleLineWrap, { desc = "toggle line wrap"})
vim.keymap.set('n', '<leader>wl', function() UpdateLuaLineTabLine(true) end, { desc = "update lualine tabline" })
vim.keymap.set('n', '<leader>wq', '<cmd>copen<cr>', { desc = "open quickfix list" })
vim.keymap.set("n", "<leader>wg", function() ToggleMainNavKeys("quickfix") end, { desc = "toggle quickfix mode" })
vim.keymap.set('n', '<leader>wf', ToggleFoldMethod, { desc = "toggle fold method" })
vim.keymap.set('n', '<leader>wo', CycleColorColumn, { desc = "cycle color column" } )
vim.keymap.set('n', '<leader>wp', ToggleAutoPair, { desc = "toggle autopair" } )
vim.keymap.set("n", "<leader>wa", ToggleAutoAutoComplete, { desc = "toggle always showing autocomplete menu when typing"})
vim.keymap.set('n', '<leader>wu', "<cmd>Telescope emoji<CR>", { desc = "telescope emoji" } )
vim.keymap.set("n", "<leader>wh", function() ToggleMainNavKeys("harpoon") end, { desc = "toggle harpoon mode" })
vim.keymap.set('n', [[<C-\>]], ':tab split<CR>:exec("tag ".expand("<cword>"))<CR>', {desc =" open a tag in a new tab"})

-- lsp keymaps start on lsp start, need this cmd if lsp isnt started obviously
vim.keymap.set("n", "gle", "<cmd>LspStart<CR>")

----------- CO-PILOT KEYBINDINGS --------------------------------------------
vim.keymap.set('n', '<leader>lc', '<cmd>CopilotChatToggle<cr>' , { desc = "copilot toggle chat window" })
vim.keymap.set('v', '<leader>le', "<cmd>'<,'> CopilotChatExplain<cr>" , { desc = "copilot explain current line range" })

----------- LSP KEYBINDINGS --------------------------------------------
-- many taken from https://github.com/scalameta/nvim-metals/discussions/39
SetLSPKeymaps = function()
    -- LSP CONFIGURATION COMMANDS
    vim.keymap.set("n", "gll", "<cmd>LspLog<CR>")
    vim.keymap.set("n", "glL", function() print('LOG PATH: ' .. vim.lsp.get_log_path()); vim.fn.setreg('+', vim.lsp.get_log_path()) end,
        { desc = "print log path and copy to sys clipboard" })
    vim.keymap.set("n", "glc", ClearLspLog, { desc = "clear lsp logs" })
    vim.keymap.set("n", "gli", "<cmd>LspInfo<CR>")
    vim.keymap.set("n", "glS", "<cmd>LspStop<CR>")
    vim.keymap.set("n", "glh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        {desc = "toggle inlay hints"})
    vim.keymap.set("n", "glt", ToggleLSPDiagnosticsVirtualText, { desc = "toggle diag virtual text" })

    -- ACTIONS
    vim.keymap.set("n", "gH", vim.lsp.codelens.run, { desc = "lsp codelens run" }) -- TODO: gH enters select mode
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "lsp code action" }) -- TODO: clobbers get ascii value of char
    vim.keymap.set("n", "gy", vim.lsp.buf.format, { desc = "lsp format"})
    vim.keymap.set("n", "gR", vim.lsp.buf.rename, { desc = "lsp rename"})

    -- ANALYSIS COMMANDS
    -- `tab split` will open in new tab, default is open in current tab, no opt for this natively
        -- see https://github.com/scalameta/nvim-metals/discussions/381
    vim.keymap.set("n", "gd", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>")
    vim.keymap.set("n", "gD", "<cmd>tab split | lua vim.lsp.buf.type_definition()<CR>")
    vim.keymap.set("n", "gT", vim.lsp.buf.typehierarchy)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover)  -- hitting key again will enter hover buffer
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "lsp signature help" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {desc = "lsp implementation" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "lsp references" })
    vim.keymap.set("n", "gwr", vim.lsp.buf.document_symbol, { desc = "lsp document symbol" })
    vim.keymap.set("n", "gws", vim.lsp.buf.workspace_symbol, { desc = "lsp workspace symbol" })
    vim.keymap.set("n", "gwd", vim.diagnostic.setqflist, { desc = "setqflist" }) -- all workspace diagnostics
    vim.keymap.set("n", "gwe", function() vim.diagnostic.setqflist({severity = "E"}) end) -- all workspace errors
    vim.keymap.set("n", "gww", function() vim.diagnostic.setqflist({severity = "W"}) end) -- all workspace warnings
    vim.keymap.set("n", "gwb", vim.diagnostic.setloclist, { desc = "set loc list" }) -- buffer diagnostics only
    vim.keymap.set("n", "[c", function() vim.diagnostic.goto_prev { wrap = false } end, { desc = "goto prev diagnostic" })
    vim.keymap.set("n", "]c", function() vim.diagnostic.goto_next { wrap = false } end, { desc = "goto next diagnostic" })
    vim.keymap.set('n', 'gq', function() vim.lsp.diagnostic.set_loclist() end, { desc = "set loclist" })
    vim.keymap.set('n', 'gz', function() vim.lsp.diagnostic.open_float() end, { desc = "open float " })
    -- vim.keymap.set('n', 'gz', vim.lsp.diagnostic.open_float)

    if LazyPluginEnabled('noice.nvim') then
        -- can scroll in lsp hover doc
        vim.keymap.set({"n", "i", "s"}, "<c-d>", function()
            if not require("noice.lsp").scroll(4) then
                return "<c-d>"
            end
        end, { silent = true, expr = true })

        vim.keymap.set({"n", "i", "s"}, "<c-u>", function()
            if not require("noice.lsp").scroll(-4) then
                return "<c-u>"
            end
        end, { silent = true, expr = true })
    end

    -- FZF SEARCH
    vim.keymap.set('n', '<leader>lr', function() require('fzf-lua').lsp_references() end, { desc = "refs" })
    vim.keymap.set('n', '<leader>li', function() require('fzf-lua').lsp_implementations() end, { desc = "implementations" })
    vim.keymap.set('n', '<leader>le', function() require('fzf-lua').lsp_declarations() end, { desc = "declarations" })
    vim.keymap.set('n', '<leader>lf', function() require('fzf-lua').lsp_definitions() end, { desc = "defs" })
    vim.keymap.set('n', '<leader>ld', function() require('fzf-lua').lsp_typedefs() end, { desc = "typedefs" })
    vim.keymap.set('n', '<leader>ll', function() require('fzf-lua').lsp_finder() end, { desc = "all lsp finder" })
    vim.keymap.set('n', '<leader>lw', function() require('fzf-lua').lsp_workspace_symbols() end, { desc = "workspace symbols" })
    vim.keymap.set('n', '<leader>ls', function() require('fzf-lua').lsp_document_symbols() end, { desc = "doc symbols" })

    ---- DAP COMMANDS
    vim.keymap.set("n", "gkc", function() require("dap").continue() end, { desc = "continue" })
    vim.keymap.set("n", "gkr", function() require("dap").repl.toggle() end, { desc = "toggle" })
    vim.keymap.set("n", "gkK", function() require"dap.ui.widgets".hover() end, { desc = "hover"})
    vim.keymap.set("n", "gkt", function() require"dap".toggle_breakpoint() end, { desc = "toggle breakpoint" })
    vim.keymap.set("n", "gkl", function() require"dap".run_last() end, { desc = "run last" })
    vim.keymap.set("n", "gkso", function() require"dap".step_over() end, { desc = "step over" })
    vim.keymap.set("n", "gksi", function() require"dap".step_into() end, { desc = "step into" })
end

SetMetalsKeymaps = function()
    vim.keymap.set("n", "gjd", "<cmd>MetalsGotoSuperMethod<CR>")
    vim.keymap.set("n", "gll", "<cmd>MetalsToggleLogs<CR>")
    vim.keymap.set("n", "gli", "<cmd>MetalsInfo<CR>")
    vim.keymap.set("n", "glI", "<cmd>MetalsRunDoctor<CR>")
    vim.keymap.set("n", "glst", "<cmd>MetalsStartServer<CR>")
    vim.keymap.set("n", "glo", "<cmd>MetalsOrganizeImports<CR>")
    vim.keymap.set("n", "gld", "<cmd>MetalsShowSemanticdbDetailed<CR>")
    -- NOTE: in the tree window hit 'r' to navigate to that item
    vim.keymap.set("n", "glT", function() require"metals.tvp".toggle_tree_view() end, { desc = "toggle tree view" })
    vim.keymap.set("n", "glr", function() require"metals.tvp".reveal_in_tree() end, { desc = "reveal in tree" })
    -- vim.keymap.set("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
end

--------------------------------------------------------------------------------------------------------
-------------------------------- PLUGINS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

if not vim.env.VIM_NOPLUG then
    require("lazy").setup({ spec = {
        'nvim-lua/plenary.nvim',
        { 'nvim-lualine/lualine.nvim', config = LoadLuaLine, event = 'VeryLazy' },
        { 'nvim-tree/nvim-tree.lua', config = LoadNvimTree, cmd = {"NvimTreeFindFileToggle", "NvimTreeToggle", "NvimTreeOpen"} },
        { 'nvim-treesitter/nvim-treesitter', config = LoadTreeSitter, cond = not vim.env.NO_TREESITTER,
            build = function() require("nvim-treesitter.install").update({ with_sync = true }) end },
        'nvim-tree/nvim-web-devicons',
        'tpope/vim-surround',
        'tpope/vim-repeat',
        {"aklt/plantuml-syntax", ft = 'plantuml' },
        -- "MeanderingProgrammer/render-markdown.nvim",  -- make markdown in syntax highlighting prettier in neovim

        --- COLORSCHEME
        { "olimorris/onedarkpro.nvim", lazy = false, config = LoadOneDarkProConfig, priority = 1000 },

        --- GIT
        { 'tpope/vim-fugitive', event = 'VeryLazy' },
        { 'tpope/vim-rhubarb', config = LoadRhubarb, dependencies = { 'tpope/vim-fugitive' }, event = 'VeryLazy' },
        { 'lewis6991/gitsigns.nvim', config = LoadGitSigns, event = "VeryLazy" },

        --- NAVIGATION
        { 'ThePrimeagen/harpoon', config = LoadHarpoon, branch = "harpoon2", dependencies = { 'nvim-lua/plenary.nvim'} },
        { 'ibhagwan/fzf-lua', config = LoadFzfLua, dependencies = { 'nvim-tree/nvim-web-devicons' }, event = 'VeryLazy' },

        --- TELESCOPE
        { 'nvim-telescope/telescope.nvim', config = LoadTelescope, event = 'VeryLazy', tag = '0.1.8',
            dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim' }, event = "VeryLazy" }, 
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', event = "VeryLazy" },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { "xiyaowong/telescope-emoji.nvim", config = LoadTelescopeEmoji, cmd = { "Telescope emoji" },
            dependencies = { 'nvim-telescope/telescope.nvim' } },

        -- MARKDOWN
        { "iamcco/markdown-preview.nvim",
            cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" }, ft = { "markdown" },
            build = function() vim.fn["mkdp#util#install"]() end,
        },

        ----- LSP STUFF
        { "CopilotC-Nvim/CopilotChat.nvim",
            dependencies = {
               { "github/copilot.vim", config = LoadCopilot }, -- or zbirenbaum/copilot.lua
               { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
            },
            build = "make tiktoken", -- Only on MacOS or Linux
            cond = not vim.env.NO_COPILOT, opts = CoPilotChatOpts,
        },
        { 'neovim/nvim-lspconfig', cond = not vim.env.NO_LSP, config = LoadLSPConfig, },
        { 'mfussenegger/nvim-dap', config = LoadDAP },
        -- 'leoluz/nvim-dap-go',
        { 'kevinhwang91/nvim-bqf', config = LoadBQF, ft = 'qf' },
        { 'mfussenegger/nvim-jdtls', ft = { 'java' }, config = LoadJDTLSServer, cond = not vim.env.NO_LSP },
        { 'scalameta/nvim-metals', cond = not vim.env.NO_LSP,
            config = LoadScalaMetals, ft = { 'scala', 'sbt' }, dependencies = { "nvim-lua/plenary.nvim" } },

        -- AUTOCOMPLETE
        { 'hrsh7th/nvim-cmp', config = LoadAutoComplete, event = 'InsertEnter', 
            dependencies = { 
                'hrsh7th/cmp-nvim-lsp',         -- LSP completions
                'hrsh7th/cmp-buffer',           -- complete words in buffers
                'hrsh7th/cmp-path',             -- complete filesystem paths
                'saadparwaiz1/cmp_luasnip',     -- be able to add luasnip as completion source for nvim-cmp
                'onsails/lspkind.nvim' }        -- show formatting info in autocomplete menu, icons and more source info
        },

        -- SNIPPETS
        { 'L3MON4D3/LuaSnip', config = LoadLuaSnip, event = 'VeryLazy', dependencies = { "rafamadriz/friendly-snippets" } },
        { "rafamadriz/friendly-snippets", event = 'VeryLazy' }, -- actual snippet library

        -- AUTOPAIR + TABOUT
        { 'windwp/nvim-autopairs', event = "InsertEnter", config = LoadAutoPair },
        { 'abecodes/tabout.nvim',
            lazy = false, config = LoadTabOut, cond = not vim.env.NO_TAB, priority = 1000,
            dependencies = { "nvim-treesitter/nvim-treesitter", },
            event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
        },

        -- OTHER
        { 'lukas-reineke/indent-blankline.nvim', config = LoadIndentBlankLine, event = 'VeryLazy' },
        { "folke/which-key.nvim", opts = WhichKeyOpts, event = "VeryLazy" },
        -- { "folke/noice.nvim", event = "VeryLazy", opts = { }, version = "4.4.7",
        { "folke/noice.nvim", event = "VeryLazy", opts = { },
            dependencies = {
                "MunifTanjim/nui.nvim", -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "rcarriga/nvim-notify", -- optional notification view, noice will default to mini(lower right corner messages) otherwise
            }, config = LoadNoice, cond = not vim.env.NO_NOICE, },
        { "folke/flash.nvim", event = "VeryLazy", keys = FlashKeyDefinitions, opts = FlashOpts, },
        { 'chrisbra/unicode.vim', event = "VeryLazy" },     -- unicode helper
        { 'godlygeek/tabular', event = "VeryLazy" },        -- format text into aligned tables
    } })
end

-- TODO: how to load after noice is loaded so i get pretty nvim-notify msg, can i hack into `VeryLazy` event somehow?
--       the 1sec timer works but is not as elegant as evented
if (vim.fn.filereadable(vim.fn.expand('~/.nvim_local.lua')) == 1) then
    -- vim.schedule(function() dofile(vim.fn.expand('~/.nvim_local.lua')) end)
    local loadLocal = function()
        trynotify("Loading ~/.nvim_local.lua", "info", { timeout = 0 , title = "info" })
        vim.schedule(function() dofile(vim.fn.expand('~/.nvim_local.lua')) end)
    end

    local timer = vim.uv.new_timer()
    timer:start(1000, 0, function () timer:stop(); timer:close(); loadLocal() end)
end
