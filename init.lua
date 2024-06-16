--*****************************************************************************************************
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> NEOVIM CONFIG <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--*****************************************************************************************************

--------------------------------------------------------------------------------------------------------
-------------------------------- SETTINGS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
vim.opt.backup = false                 -- no backup files
vim.opt.writebackup = false            -- only in case you don't want a backup file while editing
vim.opt.swapfile = false               -- no swap files

-- per nvim-tree docs, it's highly reccomended to disable netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.opt.mouse=null                     -- turn off all mouse support by default

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

--- STATUS LINE
vim.opt.ls=2                    -- line status, two lines for status and command
vim.opt.statusline=[[ %F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [POS=%04l,%04v][%p%%]\ ]]

-- if terminal size changes (e.g. resizing tmux pane vim lives in) automatically resize the vim windows
vim.api.nvim_create_autocmd('VimResized', 
    { pattern='*', command = 'wincmd =', desc = 'force window resize when vim resizes'})

--- TRAILING SPACES
vim.opt.list = true
vim.opt.listchars = {tab = '»_', trail = '.'}
vim.cmd.highlight('WhiteSpace', 'ctermfg=8 guifg=DimGrey')

-- disable editorconfig file support (https://neovim.io/doc/user/editorconfig.html)
vim.g.editorconfig = false

-- use ripgrep for default vi grep
if vim.fn.executable('rg') == 1 then vim.opt.grepprg='rg --vimgrep --follow' end

-- layout of files and dir in netrw file explorer
vim.g.netrw_liststyle = 3

-- highlight lines yanked
vim.api.nvim_create_autocmd('TextYankPost', { pattern = '*', 
    callback = function() vim.highlight.on_yank {higroup="IncSearch", on_visual=false, timeout=150} end
})

-- for jsonc format, which supports commenting, this will highlight comments
-- FIXME may'23: not working, code in .vimrc not working either
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'json', callback = function() vim.cmd.syntax([[match Comment +\/\/.\+$+]]) end
})

-- any file name starting with Jenkinsfile should be groovy
vim.filetype.add({ pattern = { ['Jenkinsfile.*'] = 'groovy' } })
-- vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, { pattern = 'Jenkinsfile*', command = 'set filetype=groovy' })

-- use indent folding on scala files b/c treesitter sucks at it
vim.api.nvim_create_autocmd({ 'FileType' }, { pattern = 'scala', command = 'set foldmethod=indent' })

-- disable autocommenting on o and O in normal
vim.api.nvim_create_autocmd('FileType', { pattern = '*', command ='setlocal formatoptions-=o' })

--------------------------------------------------------------------------------------------------------
-------------------------------- FUNCTIONS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
vim.api.nvim_create_user_command(
    'SilentRedraw',
    [[execute ':silent !'.<q-args> | execute ':redraw!' ]],
    {bang = true, nargs = "*" }
)

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

SaveDefinedSession = function()
    if vim.fn.exists(vim.g.DefinedSessionName) ~= 0 then
        vim.g.DefinedSessionName = vim.fn.input("Session Name: ", "MyCurrentVimSession.vim")
    end

    vim.opt.sessionoptions:append('globals')    -- mksession wont save global vars by default
    vim.cmd(":mksession! " .. vim.g.DefinedSessionName)
    print("Saved session: ",vim.g.DefinedSessionName)
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

ToggleIndentBlankLine = function()
    if IndentBlankLineEnabled then
        require("ibl").update { enabled = false }
    else
        require("ibl").update { enabled = true }
    end
    IndentBlankLineEnabled = not IndentBlankLineEnabled
end

-- NOTE jun'23, v0.9.1: https://neovim.io/doc/user/lsp.html#lsp-log has vim.lsp.log.get_filename(), but this method doesnt exist
-- NOTE jun'23: still see logs in vim LspLog tab even if metal.log file(verified with cat) is cleared...
ClearLspLog = function()
    local logpath = vim.lsp.get_log_path()
    vim.cmd(':SilentRedraw cat /dev/null > ' .. logpath)
    vim.cmd(':SilentRedraw cat /dev/null > .metals/metals.log')
end

CycleNvimTreeSortBy = function()
    if NvimTreeConfig.sort_by == 'name' then
        NvimTreeConfig.sort_by = 'extension'
        print("nvim-tree: sorting by extension")
    elseif NvimTreeConfig.sort_by == 'extension' then
        NvimTreeConfig.sort_by = 'modification_time'
        print("nvim-tree: sorting by modification time")
    else
        NvimTreeConfig.sort_by = 'name'
        print("nvim-tree: sorting by name")
    end

    require('nvim-tree').setup(NvimTreeConfig)
    vim.cmd 'NvimTreeFindFileToggle'
end

NvimTreeDynamicWidthEnabled = true

ToggleNvimTreeDynamicWidth = function()
    if NvimTreeDynamicWidthEnabled then
        NvimTreeConfig.view = { width = { min = 30, max = 30, padding = 1 } }
    else
        NvimTreeConfig.view = { width = { min = 10, max = 50, padding = 1 } }
    end

    NvimTreeDynamicWidthEnabled = not NvimTreeDynamicWidthEnabled
    require('nvim-tree').setup(NvimTreeConfig)
    vim.cmd 'NvimTreeFindFileToggle'
end


AutoPairEnabled = true

ToggleAutoPair = function ()
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

-- FIXME: june25-23 doesn't really work, dont really need it tho, vtr plugin is pretty smart
SelectTmuxRunnerPane = function()
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
        local pane_name = 'vtr-run-pane' .. pane_selection
        vim.fn.system({ 'tmux', 'select-pane', '-t', pane_selection, '-T', pane_name })
        print("VtrCreatedRunnerPaneName set to: " .. pane_name)
        vim.g.VtrCreatedRunnerPaneName = pane_name
    else
        print("pane number " .. pane_selection .. " not found!")
    end
end

RunAction = function(arg)
    curftype = vim.bo.filetype
    if arg == "exe" then
        if curftype == "rust" then
            vim.cmd(':VtrSendCommandToRunner! cargo run')
        elseif curftype == 'go' then
            vim.cmd(":VtrSendCommandToRunner! go run ".. vim.fn.expand("%"))
        elseif curftype == 'c' then
            vim.cmd(":VtrSendCommandToRunner! gcc ".. vim.fn.expand("%") .. ' && ./a.out')
        elseif curftype == 'scala' then
            vim.cmd(":VtrSendCommandToRunner! scala ".. vim.fn.expand("%"))
        elseif curftype == 'java' then
            vim.cmd(":VtrSendCommandToRunner! java-ramrom")
        else
            print("filetype " .. curftype .. " undefined for execute action")
        end
    elseif arg == 'test' then
        if curftype == "rust" then
            vim.cmd(':VtrSendCommandToRunner! cargo test')
        elseif curftype == 'go' then
            vim.cmd(":VtrSendCommandToRunner! go test ".. vim.fn.expand("%"))
        else
            print("filetype " .. curftype .. " undefined for test action")
        end
    elseif arg == 'build' then
        if curftype == "rust" then
            vim.cmd(':VtrSendCommandToRunner! cargo build')
        elseif curftype == 'go' then
            vim.cmd(":VtrSendCommandToRunner! go build ".. vim.fn.expand("%"))
        elseif curftype == 'c' then
            vim.cmd(":VtrSendCommandToRunner! gcc ".. vim.fn.expand("%"))
        else
            print("filetype " .. curftype .. " undefined for build action")
        end
    else
        print("undefined action: " .. arg)
    end
end

----------------------------------------------------------------------------------------------------------
---------------------------------- PLUGIN CONFIG ----------------------------------------------------------
------------------------------------- -------------------------------------------------------------------

---------- NAVARASU ONE DARK COLORSCHEME -------------
-------- TODO: get full dark background to work
-------- TODO: treesitter markdown mostly works, H1/2/3/4/5/6 dont have diff colors
local LoadNavarasuOneDarkConfig = function()
    require('onedark').setup { style = 'darker' }
    vim.cmd('highlight Normal ctermbg=000')
    vim.cmd('highlight NonText ctermbg=000')
    require('onedark').load()
end

---- ONE DARK PRO: https://github.com/olimorris/onedarkpro.nvim
--- TODO: treesitter markdown: get hyperlinks to be blue+underlined (vim-markdown does this)
    -- may'24 vim-markdown uses this group for hyperlinks, try to get this working along with treesitter
    -- vim.cmd.syntax([[match mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*/]])
local LoadOneDarkProConfig = function()
    require("onedarkpro").setup({
        highlights = {
            -- vim-markdown uses html*, not markdown*
            htmlH1 = { fg = "#FF0000", underline = true },
            htmlH3 = { fg = "#ef596f" }, htmlH4 = { fg = "#ef596f" }, htmlH5 = { fg = "#ef596f" }, htmlH6 = { fg = "#ef596f" },
            htmlLink = { fg = '#61afef', underline = true },
            -- mkdInlineURL = { fg = '#61afef', underline = true },

            -- treesitter uses these group names for markdown headers
            ['@markup.heading.1.markdown'] = { fg = "#FF0000", underline = true },
            ['@markup.heading.2.markdown'] = { fg = "#FF0000", underline = true },
            ['@markup.heading.3.markdown'] = { fg = "#ef596f" },

            Search = { underline = true, italic = true, reverse = true },
        }
    })
    vim.cmd.colorscheme("onedark_dark")
end

----------------------------- FZF LUA --------------------------------------------------
LoadFzfLua = function()
    require'fzf-lua'.setup {
        -- NOTE: bat previewer doesnt support toggle-preview-cw and cww (rotations)
        winopts = { preview = { default = "bat" } },
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
            builtin = {
                ["<c-w><c-w>"]        = "toggle-help",
                ["<f1>"]              = "toggle-help",
                ["<c-w><c-f>"]        = "toggle-fullscreen",
                ["<f2>"]              = "toggle-fullscreen",
                ["<F5>"]              = "toggle-preview-ccw",
                ["<F6>"]              = "toggle-preview-cw",
            }
        }
    }
end

----------------------------- VIM-MARKDOWN --------------------------------------------------
LoadVimMarkdown = function()
    -- plasticboy-md: `ge` command will follow anchors in links (of the form file#anchor or #anchor)
    vim.g.vim_markdown_follow_anchor = 1
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_new_list_item_indent = 0
    vim.g.vim_markdown_edit_url_in = 'tab'
    vim.g.vim_markdown_anchorexpr = "substitute(v:anchor,'-',' ','g')"   -- customize the way to parse an anchor link
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

LuaLineTabComponentConfig = 
    {
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

LuaLineBufferDimComponentConfig = 
    {
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

-- if terminal size changes (e.g. resizing tmux pane vim lives in) automatically resize the vim windows
vim.api.nvim_create_autocmd('VimResized', { pattern='*', callback = function() UpdateLuaLineTabLine(true) end, 
      desc = 'force lualine udpate when vim resizes'})

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
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = {'mode' },
            lualine_b = {'branch', 'diff', 'diagnostics'},
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
end

---------------------- WHICH-KEY CONFIG -------------------------------
LoadWhichKey = function()
    local wk = require("which-key")

    -- prefix keys descs in popup menu for LSP related things
    wk.register( { g = { name = "LSP + more" } })
    wk.register( { l = { name = "LSP conf cmds" } }, { prefix = "g" } )
    wk.register( { w = { name = "LSP diagnostics" } }, { prefix = "g" } )
    wk.register( { k = { name = "DAP stuff" } }, { prefix = "g" } )
    wk.register( { l = { name = "LSP fzf search" } }, { prefix = "<leader>" } )

    -- other things
    wk.register( { a = { name = "smart run/execute" } }, { prefix = "<leader>" } )
    wk.register( { c = { name = "cheatsheets+notes" } }, { prefix = "<leader>" } )
    wk.register( { g = { name = "git/github stuff" } }, { prefix = "<leader>" } )
    wk.register( { e = { name = "fzf grepping" } }, { prefix = "<leader>" } )
    wk.register( { w = { name = "misc config" } }, { prefix = "<leader>" } )
    wk.register( { u = { name = "unicode" } }, { prefix = "<leader>" } )
end

---------------------- NVIM-TREE CONFIG -------------------------------
NvimTreeConfig = 
    { 
        on_attach = function(bufnr)
            local api = require('nvim-tree.api')

            local function opts(desc)
                return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.del('n', '<C-e>', { buffer = bufnr })  -- remove open-in-place, want scroll up by one line
        end,
        -- sort_by = 'extension',
        renderer = { full_name = true }, -- if highlighted item's full path is longer than nvim window width, render into next window
        -- FIXME: sept'23 - nvim-tree warns that padding settings is unkonwn option, looks correct per help page...
        view = { width = { min = 10, max = 40, padding = 1 }, },
        filters = { git_ignored = false },   -- show gitignored files
    }

LoadNvimTree = function() require("nvim-tree").setup(NvimTreeConfig) end

---------------------- TREE-SITTER CONFIG -------------------------------
LoadTreeSitter = function()
    -- only disable markdown if vim-markdown plugin is enabled
    local disabled_list = {}
    if LazyPluginEnabled('vim-markdown') then disabled_list = { "markdown" } end

    require('nvim-treesitter.configs').setup {
        ensure_installed = "all",   -- A list of parser names, or "all"
        sync_install = false,       -- Install parsers synchronously (only applied to `ensure_installed`)

        highlight = {
            enable = true,     -- `false` will disable the whole extension
            -- NOTE: names of the parsers and not the filetype. (for example if you want to
            -- disable highlighting for the `tex` filetype, you need to include `latex`, this is the name of the parser)
            disable = disabled_list,

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
          { filter = { event = "msg_show", find = "Saved session: " }, view = "mini", },
          { filter = { event = "msg_show", find = "B written" }, view = "mini", },
          { filter = { event = "msg_show", find = " change; before" }, view = "mini", },
          { filter = { find = "E162" }, view = "mini", },       -- no write since last change error
          { filter = { find = "E37" }, view = "mini", },       -- no write since last change error
                -- mini view will hide after short time, cmdline persists forever...
        },
    }

    -- FIXME: apr'24 - get this working
    vim.keymap.set("c", "<S-Enter>", function()
        require("noice").redirect(vim.fn.getcmdline())
    end, { desc = "Redirect Cmdline" })
end

------------------------- FLASH -----------------------------------------------
FlashOpts = 
    {
        modes = {
            search = { enabled = false }   -- dont add flash keys for regular search
        }
    }

FlashKeyDefinitions =
    {
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

--------------------------------------------------------------------------------------------------------
-------------------------------- LSP CONFIG ----------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        SetLSPKeymaps()
        vim.opt.signcolumn="yes:2" -- static 2 columns, at least one for signify and one for lsp diags
    end,
})


-------------------------------- NVIM-CMP -------------------------------------------
LoadAutoComplete = function()
    local cmp = require 'cmp'
    local initial_auto_completion = false;

    if AutoAutoCompleteEnabled then
        initial_auto_completion =  { require('cmp.types').cmp.TriggerEvent.TextChanged }
    else
        initial_auto_completion = false   -- dont show autocomplete menu be default
    end

    cmp.setup {
        completion = { autocomplete = initial_auto_completion, },
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
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
            { name = 'buffer' },
            { name = 'path' },
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
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[Latex]",
                })
            }),
        },
    }
end

--------------------- TABOUT --------------------------------
LoadTabOut = function()
    require('tabout').setup {
        tabkey = '<C-e>', -- key to trigger tabout, set to an empty string to disable
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
AutoPairConfig = {
   map_c_h = true,  -- Map the <C-h> key to delete a pair
}

-- TODO: figure out how to run this only if the plugin is loaded
LoadAutoPair = function()
    local Rule = require('nvim-autopairs.rule')
    require('nvim-autopairs').add_rule(Rule("<",">","rust"))
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
LoadScalaMetals = function()
    metals_config = require("metals").bare_config()

    metals_config.settings = {
      -- jan'24 default metals version was 0.11.x
      --    see https://scalameta.org/metals/docs/editors/vim/  , 1.2.0 supported
      serverVersion = "1.3.0",
      showImplicitArguments = true,
      showImplicitConversionsAndClasses = true,
      showInferredType = true
    }

    metals_config.init_options.statusBarProvider = "on"

    metals_config.capabilities = capabilities
    -- metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Autocmd that will actually be in charging of starting the whole thing
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
            require("metals").initialize_or_attach(metals_config)
        end,
        group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    })

    vim.opt.shortmess:remove('F')   -- Ensure autocmd works for filetype
    vim.opt.shortmess:append('c')   -- Avoid showing extra message when using completion

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
-- TODO: neovim lspconfig setup - https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
LoadLuaLSP = function()
    require'lspconfig'.lua_ls.setup{}
end


---------------- RUST LSP ---------------------------
-- config: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
LoadRustLSP = function()
    require'lspconfig'.rust_analyzer.setup({
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
-- jdtls lang server is a java17 app itself, make sure JAVA_HOME of shell is set to java17
LoadJDTLSServer = function()
    local config = {
        cmd = { '/opt/homebrew/bin/jdtls' },
        root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
        settings = {
            java = {
                configuration = {
                    runtimes = {
                        {
                            name = "JavaSE-11",
                            path = "/opt/homebrew/opt/openjdk@11",
                        },
                        {
                            name = "JavaSE-17",
                            path = "/opt/homebrew/opt/openjdk@17",
                        },
                    }
                }
            }
        }
    }
    require('jdtls').start_or_attach(config)
end
------------- KOTLIN-------------------------------------
-- https://github.com/fwcd/kotlin-language-server

-- NOTE: mar2024 - brew install needed JVM 21 installed for the server to start
LoadKotlinLSP = function()
    require'lspconfig'.kotlin_language_server.setup{
        cmd = { "kotlin-language-server" },
        filetypes = { "kotlin", "kt" },
        root_dir = require("lspconfig/util").root_pattern("settings.gradle")
    }
end

-- ruby-lsp - https://shopify.github.io/ruby-lsp/
-- TODO: also check out rails LSP: https://github.com/Shopify/ruby-lsp-rails
----------------- RUBY ---------------------------------------
LoadRubyLSP = function()
    require'lspconfig'.ruby_lsp.setup{ 
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
end

--------------------------------------------------------------------------------------------------------
-------------------------------- KEY MAPS --------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
vim.g.mapleader = " "

--- TODO: Prime open real estate for key remapping
    -- NORMAL MODE
        -- <leader> + ,/l/u/x/<0-9>
        -- <Leader><Leader>  (most open)
        -- <BS>
        -- c-g, c-s, c-q(same c-v), c-j(newline), c-k(digraph)
        -- c-x (opposite of c-a, i clobber c-a for tmux meta)
        -- ;  - semicolon repeats last f/F motions
        -- ,  - in reverse direction
    -- INSERT MODE
        -- c-b, c-v, c-s, c-space, c-y

-- TODO: i think this map is probably useful
-- vim.keymap.set("n", "<C-j>", "a<CR><Esc>k$")

vim.keymap.set("i", "<C-l>", "<Esc>")   ---- BETTER ESCAPE
vim.keymap.set({'n', 'x'}, '<leader>k', '%', { desc = "go to matching pair" }) -- FIXME: doesnt work, only [](){}, not if/else/end
vim.keymap.set('n', '<leader>r', 'q:', { desc = "command line history editor" })
vim.keymap.set("n", "<leader>.", "<cmd>:@:<CR>", { desc = "repeat last command" })
vim.keymap.set("n", "<leader><leader>e", "<cmd>:Explore<CR>")
vim.keymap.set("n", "<leader>j", "<cmd>:noh<CR>")

-- SMART RUN ACTIONS
vim.keymap.set("n", "<leader>aa", "<cmd>:lua RunAction('exe')<cr>", { desc = "execute program" })
vim.keymap.set("n", "<leader>ar", SelectTmuxRunnerPane, { desc = "set tmux pane runner" })
vim.keymap.set("n", "<leader>at", "<cmd>:lua RunAction('test')<cr>", { desc = "run tests" })
vim.keymap.set("n", "<leader>ab", "<cmd>:lua RunAction('build')<cr>", { desc = "build/compile program" })

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
vim.keymap.set("n", "<leader>m", ":tabm<Space>")
vim.keymap.set("n", "<leader>t", "<cmd>:tabnew<CR>")
vim.keymap.set("n", "<leader><leader>t", "<C-w>T")
vim.keymap.set("n", "<leader>z", "<cmd>:tabnew %<CR>")
vim.keymap.set("n", "gb", "<cmd>:tabprevious<CR>")

---- SMART QUITTING
vim.keymap.set("n", "<leader>q", TabBufQuit, { desc = "smart quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>:q!<CR>")
vim.keymap.set("n", "<leader><leader>q", "<cmd>:qa<CR>")

------ SMART WRITING
vim.keymap.set("i", "<C-k>", "<C-o>:w<cr>", { desc = "write changes staying in insert"})
vim.keymap.set("n", "<leader>s", "<cmd>:w<CR>")
vim.keymap.set('n', "<leader>S", SaveDefinedSession, { desc = "save defined session" })

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

-- GOTO END OF LINE IN INSERT MODE
vim.keymap.set("i", "<C-s>", "<C-o>$")   -- C-g default is to print file name and other metadata

--------- FZF ---------------------
vim.keymap.set('n', '<leader><leader>f', "<cmd>lua require('fzf-lua').builtin()<CR>", { desc = "fzf lua meta finder" })
vim.keymap.set('n', '<leader>;', "<cmd>lua require('fzf-lua').commands()<CR>", { desc = "fzf vim commands" })
vim.keymap.set('n', '<leader><leader>h', "<cmd>lua require('fzf-lua').help_tags()<CR>", { desc = "fzf help tags" })
vim.keymap.set('n', '<leader><leader>r', "<cmd>lua require('fzf-lua').command_history()<CR>", { desc = "fzf command history" })
vim.keymap.set('n', '<leader>b', "<cmd>lua require('fzf-lua').buffers()<CR>", { desc = "fzf buffers" })
------ FZF FILES
vim.keymap.set('n', '<leader>o', "<cmd>lua require('fzf-lua').files()<CR>", { desc = "fzf files" })
vim.keymap.set('n', '<leader><leader>o', "<cmd>lua require('fzf-lua').files({cwd='~/'})<CR>", { desc = "fzf files homedir" })
vim.keymap.set('n', '<leader>i', "<cmd>lua require('fzf-lua').oldfiles()<CR>", { desc = "fzf lua oldfiles" })
------ FZF GREP
vim.keymap.set('n', '<leader>ef', "<cmd>lua require('fzf-lua').grep()<CR>", { desc = "fzf grep (rg query, then fzf results)" })
vim.keymap.set('n', '<leader>el', "<cmd>lua require('fzf-lua').live_grep()<CR>", { desc = "fzf live grep" })
vim.keymap.set('n', '<leader>ee', "<cmd>lua require('fzf-lua').grep_cword()<CR>", { desc = "fzf cursor grep word" })
vim.keymap.set('n', '<leader>ew', "<cmd>lua require('fzf-lua').grep_cWORD()<CR>", { desc = "fzf cursor grep cWORD" })
vim.keymap.set('n', '<leader>eo', "<cmd>lua require('fzf-lua').blines()<CR>", { desc = "fzf current buffer lines" })
vim.keymap.set('n', '<leader>ei', "<cmd>lua require('fzf-lua').lines()<CR>", { desc = "fzf all buffer lines" })
vim.keymap.set('n', '<leader>ec', "<cmd>lua require('fzf-lua').grep({cwd='~/rams_dot_files/cheatsheets/'})<CR>", 
    { desc = "fzf grep cheatsheet dir" })

--------- GIT STUFF
vim.keymap.set('n', '<leader><leader>g', '<cmd>:G<CR>', { desc = 'G - fugitive panel' })
vim.keymap.set('n', '<leader>gm', "<cmd>lua require('fzf-lua').git_commits()<CR>", { desc = "fzf git commits" })
vim.keymap.set('n', '<leader>gb', "<cmd>lua require('fzf-lua').git_bcommits()<CR>", { desc = "fzf buffer git commits" })
vim.keymap.set('n', '<leader>gs', "<cmd>lua require('fzf-lua').git_status()<CR>", { desc = "fzf git status" })
vim.keymap.set('n', '<leader>gl', "<cmd>0Gclog<cr>", { desc = "fugitive buffer git log" })
vim.keymap.set('n', '<leader>gL', "<cmd>Gclog<cr>", { desc = "fugitive repo git log" })
vim.keymap.set('n', '<leader>ga', "<cmd>Git blame<cr>", { desc = "fugitive git blame" })
vim.keymap.set('n', '<leader>gS', '<cmd>:Gitsigns toggle_signs<cr>')
vim.keymap.set('n', '<leader>gh', '<cmd>:lua ToggleGitSignsHighlight()<cr>')
-- FIXME: apr'24 - using the :tab command directly with Gvdiffsplit doesnt work right
    -- vim.keymap.set('n', '<leader>gd', '<cmd>:tab Gvdiffsplit<cr>', {desc = "diff from HEAD"})
-- FIXME: vim-markdown(treesitter works fine) for md files does not set foldmethod=diff, folds collapse
    -- sorta related https://github.com/tpope/vim-fugitive/issues/1911
vim.keymap.set('n', '<leader>gd', '<cmd>:tab sb<cr><cmd>Gvdiffsplit<cr>', {desc = "diff from HEAD"})
vim.keymap.set('n', '<leader>gD', '<cmd>:tab sb<cr><cmd>Gvdiffsplit master<cr>', {desc = "diff from master branch"})
vim.keymap.set('n', '<leader>gf', '<cmd>:tab sb<cr><cmd>Gvdiffsplit HEAD^<cr>', {desc = "diff since last commit"})

---------- NVIM TREE
vim.keymap.set('n', '<leader>N', '<cmd>:NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>n', '<cmd>:NvimTreeFindFileToggle<CR>')
vim.keymap.set('n', '<leader>wt', ToggleNvimTreeDynamicWidth, { desc = 'toggle nvim-tree width b/w dynamic and static size' })
vim.keymap.set('n', '<leader>wu', CycleNvimTreeSortBy, { desc = 'cycle nvim-tree sortby b/w name, mod time, and extension' })

---------- CHEATS + NOTES
vim.keymap.set('n', '<leader>cm', "<cmd>lua require('fzf-lua').keymaps()<CR>", { desc = "fzf key mappings" })
vim.keymap.set('n', '<leader>ch', "<cmd>lua require('fzf-lua').help_tags()<CR>", { desc = "fzf help tags" })
vim.keymap.set('n', '<leader><leader>c', "<cmd>lua require('fzf-lua').files({cwd='~/rams_dot_files/cheatsheets/'})<CR>", 
    { desc = "fzf cheatsheet files" })
vim.keymap.set('n', '<leader>cn', "<cmd>lua require('fzf-lua').files({cwd=vim.env.MY_NOTES_DIR})<CR>", { desc = "fzf notes files" })
vim.keymap.set('n', '<leader>cw', "<cmd>lua require('fzf-lua').files({cwd=vim.env.MY_WORK_DIR})<CR>", { desc = "fzf work files" })
vim.keymap.set('n', '<leader>ca', '<cmd>:tabnew $MY_WORK_TODO<cr>', { desc = "open work TODO in-progress in new tab"})
vim.keymap.set('n', '<leader>cS', '<cmd>:vsplit ~/tmp/scratch.md<cr>')
vim.keymap.set('n', '<leader>cs', '<cmd>:tabnew ~/tmp/scratch.md<cr>')
vim.keymap.set('n', '<leader>ci', '<cmd>:Inspect<cr>')

-------------- OTHER
vim.keymap.set("n", "<C-Space>", "<cmd>:Lazy<CR>")
vim.keymap.set("n", "<leader>wj", "<cmd>:NoiceDismiss<CR>", { desc = "clear noice notifications on screen" })
vim.keymap.set("n", "<leader>wc", "<cmd>:messages clear<CR>", { desc = "clear messages" })
vim.keymap.set('n', '<leader>wi', '<cmd>:lua ToggleIndentBlankLine()<cr>')
vim.keymap.set('n', '<leader>wm', '<cmd>:messages<cr>')
vim.keymap.set('n', '<leader>wn', '<cmd>:Noice<cr>')
vim.keymap.set('n', '<leader>wM', '<cmd>:MarkdownPreviewToggle<cr>')
vim.keymap.set('n', '<leader>wT', [[ <cmd>:execute '%s/\s\+$//e' <cr> ]], { desc = "remove trailing whitespace"})
vim.keymap.set('n', '<leader>ws', '<cmd>:set number!<cr>')
vim.keymap.set('n', '<leader>wl', '<cmd>:lua UpdateLuaLineTabLine(true)<cr>')
vim.keymap.set('n', '<leader>wq', '<cmd>:copen<cr>', { desc = "open quickfix list" })
vim.keymap.set('n', '<leader>wf', ToggleFoldMethod, { desc = "toggle fold method" })
vim.keymap.set('n', '<leader>wo', CycleColorColumn, { desc = "cycle color column" } )
vim.keymap.set('n', '<leader>wa', ToggleAutoPair, { desc = "toggle autopair" } )
vim.keymap.set('n', [[<C-\>]], ':tab split<CR>:exec("tag ".expand("<cword>"))<CR>', {desc =" open a tag in a new tab"})

vim.api.nvim_create_autocmd(
    "Filetype",
    { pattern = 'markdown',
      callback = function()
        vim.keymap.set('n', '<leader>gg', 
            [[<cmd>:w<CR>:SilentRedraw git add . && git commit -m 'added stuff'<CR>]], { buffer = true })
      end,
})

-- Quickly switch between vimtab indexes 1 to 9
for i=0,9,1 do vim.keymap.set('n',"g"..i,"<cmd>:tabn "..i.."<CR>") end


----------- LSP KEYBINDINGS --------------------------------------------
-- many taken from https://github.com/scalameta/nvim-metals/discussions/39
SetLSPKeymaps = function()

    -- LSP CONFIGURATION COMMANDS
    vim.keymap.set("n", "gll", "<cmd>LspLog<CR>")
    vim.keymap.set("n", "glc", ClearLspLog, { desc = "clear lsp logs" })
    vim.keymap.set("n", "gli", "<cmd>LspInfo<CR>")
    vim.keymap.set("n", "glS", "<cmd>LspStop<CR>")
    vim.keymap.set("n", "gle", "<cmd>LspStart<CR>")
    vim.keymap.set("n", "glh", "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
        {desc = "toggle inlay hints"})
    vim.keymap.set("n", "glt", ToggleLSPDiagnosticsVirtualText, { desc = "toggle diag virtual text" })
    vim.keymap.set("n", "gla", ToggleAutoAutoComplete, { desc = "toggle always showing autocomplete menu when typing"})

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
    vim.keymap.set('n', 'K', vim.lsp.buf.hover)  -- hitting key again will enter hover buffer
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "lsp signature help" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {desc = "lsp implementation" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "lsp references" })
    vim.keymap.set("n", "gwr", vim.lsp.buf.document_symbol, { desc = "lsp document symbol" })
    vim.keymap.set("n", "gws", vim.lsp.buf.workspace_symbol, { desc = "lsp workspace symbol" })
    vim.keymap.set("n", "gwd", vim.diagnostic.setqflist, { desc = "setqflist" }) -- all workspace diagnostics
    vim.keymap.set("n", "gwe", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
    vim.keymap.set("n", "gww", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
    vim.keymap.set("n", "gwb", vim.diagnostic.setloclist, { desc = "set loc list" }) -- buffer diagnostics only
    vim.keymap.set("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
    vim.keymap.set("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")
    vim.keymap.set('n', 'gq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
    vim.keymap.set('n', 'gz', ' <cmd>lua vim.lsp.diagnostic.open_float()<CR>')

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
    vim.keymap.set('n', '<leader>lr', "<cmd>lua require('fzf-lua').lsp_references()<CR>", { desc = "refs" })
    vim.keymap.set('n', '<leader>li', "<cmd>lua require('fzf-lua').lsp_implementations()<CR>", { desc = "implementations" })
    vim.keymap.set('n', '<leader>le', "<cmd>lua require('fzf-lua').lsp_declarations()<CR>", { desc = "declarations" })
    vim.keymap.set('n', '<leader>lf', "<cmd>lua require('fzf-lua').lsp_definitions()<CR>", { desc = "defs" })
    vim.keymap.set('n', '<leader>ld', "<cmd>lua require('fzf-lua').lsp_typedefs()<CR>", { desc = "typedefs" })
    vim.keymap.set('n', '<leader>ll', "<cmd>lua require('fzf-lua').lsp_finder()<CR>", { desc = "all lsp finder" })
    vim.keymap.set('n', '<leader>lw', "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>", { desc = "workspace symbols" })
    vim.keymap.set('n', '<leader>ls', "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", { desc = "doc symbols" })

    ---- DAP COMMANDS
    vim.keymap.set("n", "gkc", [[<cmd>lua require"dap".continue()<CR>]])
    vim.keymap.set("n", "gkr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
    vim.keymap.set("n", "gkK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
    vim.keymap.set("n", "gkt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
    vim.keymap.set("n", "gkso", [[<cmd>lua require"dap".step_over()<CR>]])
    vim.keymap.set("n", "gksi", [[<cmd>lua require"dap".step_into()<CR>]])
    vim.keymap.set("n", "gkl", [[<cmd>lua require"dap".run_last()<CR>]])
end

SetMetalsKeymaps = function()
    vim.keymap.set("n", "gjd", "<cmd>MetalsGotoSuperMethod<CR>")
    vim.keymap.set("n", "gll", "<cmd>MetalsToggleLogs<CR>")
    vim.keymap.set("n", "gli", "<cmd>MetalsInfo<CR>")
    vim.keymap.set("n", "glst", "<cmd>MetalsStartServer<CR>")
    vim.keymap.set("n", "glo", "<cmd>MetalsOrganizeImports<CR>")
    vim.keymap.set("n", "gld", "<cmd>MetalsShowSemanticdbDetailed<CR>")
    -- NOTE: in the tree window hit 'r' to navigate to that item
    vim.keymap.set("n", "glT", '<cmd>lua require"metals.tvp".toggle_tree_view()<CR>')
    vim.keymap.set("n", "glr", '<cmd>lua require"metals.tvp".reveal_in_tree()<CR>')
    -- vim.keymap.set("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
end

--------------------------------------------------------------------------------------------------------
-------------------------------- PLUGINS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath, })
end
vim.opt.rtp:prepend(lazypath)

if not vim.env.VIM_NOPLUG then
    require("lazy").setup({
        'nvim-lua/plenary.nvim',
        { 'nvim-lualine/lualine.nvim', config = LoadLuaLine, event = 'VeryLazy' },
        { 'nvim-tree/nvim-tree.lua', config = LoadNvimTree, event = 'VeryLazy' },
        { 'nvim-treesitter/nvim-treesitter', config = LoadTreeSitter, cond = not vim.env.NO_TREESITTER,
            build = function() require("nvim-treesitter.install").update({ with_sync = true }) end },
        'nvim-tree/nvim-web-devicons',
        'tpope/vim-surround',
        'tpope/vim-repeat',

        --- COLORSCHEME
        -- { 'navarasu/onedark.nvim', lazy = false, config = LoadNavarasuOneDarkConfig },
        { "olimorris/onedarkpro.nvim", lazy = false, config = LoadOneDarkProConfig, priority = 1000 },

        --- GIT
        { 'tpope/vim-fugitive', event = 'VeryLazy' },
        { 'tpope/vim-rhubarb', -- GBrowse handler for github, open gh link in browser or copy to clipboard
                config = LoadRhubarb, dependencies = { 'tpope/vim-fugitive' } },
        { 'lewis6991/gitsigns.nvim', config = LoadGitSigns, event = "VeryLazy" },

        --- FUZZY FIND
        { 'ibhagwan/fzf-lua', config = LoadFzfLua, dependencies = { 'nvim-tree/nvim-web-devicons' }, event = 'VeryLazy' },

        -- MARKDOWN
        { "iamcco/markdown-preview.nvim", build = function() vim.fn["mkdp#util#install"]() end },
        { 'preservim/vim-markdown', enabled = not vim.env.NO_MARK, config = LoadVimMarkdown },

        ----- LSP STUFF
        { 'neovim/nvim-lspconfig', cond = not vim.env.NO_LSP, config = LoadLSPConfig, },
        { 'mfussenegger/nvim-dap', config = LoadDAP },
        -- 'leoluz/nvim-dap-go',
        { 'kevinhwang91/nvim-bqf', config = LoadBQF, ft = 'qf' },
        { 'mfussenegger/nvim-jdtls', ft = { 'java' }, config = LoadJDTLSServer },
        { 'scalameta/nvim-metals',
            cond = not vim.env.NO_LSP,
            config = LoadScalaMetals, ft = { 'scala', 'sbt' }, dependencies = { "nvim-lua/plenary.nvim" } },

        -- AUTOCOMPLETE
        { 'hrsh7th/nvim-cmp', config = LoadAutoComplete, event = 'VeryLazy',
            dependencies = { 'L3MON4D3/LuaSnip' } },
        { 'hrsh7th/cmp-nvim-lsp', dependencies = { 'hrsh7th/nvim-cmp' }, event = 'VeryLazy' }, -- LSP completions
        { 'hrsh7th/cmp-buffer', dependencies = { 'hrsh7th/nvim-cmp' }, event = 'VeryLazy' },  -- complete words in buffers
        { 'hrsh7th/cmp-path', dependencies = { 'hrsh7th/nvim-cmp' }, event = 'VeryLazy' },  -- complete filesystem paths
        { 'onsails/lspkind.nvim', event = 'VeryLazy' },     -- show formatting info in autocomplete menu, icons and more source info

        { 'windwp/nvim-autopairs', event = "InsertEnter", config = true, opts = AutoPairConfig },
        -- { 'windwp/nvim-autopairs', event = "InsertEnter", config = LoadAutoPair, opts = AutoPairConfig }, -- doesnt work
        { 'abecodes/tabout.nvim',
            lazy = false,
            config = LoadTabOut,
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
                -- "L3MON4D3/LuaSnip",
                -- "hrsh7th/nvim-cmp"
            },
            cond = not vim.env.NO_TAB,
            event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
            priority = 1000,
        },

        -- SNIPPETS
        { 'L3MON4D3/LuaSnip', config = LoadLuaSnip, event = 'VeryLazy', dependencies = { "rafamadriz/friendly-snippets" } },
        { 'saadparwaiz1/cmp_luasnip', event = 'VeryLazy' },     -- be able to add luasnip as completion source for nvim-cmp
        { "rafamadriz/friendly-snippets", event = 'VeryLazy' }, -- actual snippet library

        { 'lukas-reineke/indent-blankline.nvim', config = LoadIndentBlankLine, event = 'VeryLazy' },
        { "folke/which-key.nvim",
            event = "VeryLazy",
            init = function() vim.o.timeout = true vim.o.timeoutlen = 600 end,
            config = LoadWhichKey,
            opts = { }
        },
        { "folke/noice.nvim", event = "VeryLazy", opts = { },
            config = LoadNoice,
            cond = not vim.env.NO_NOICE,
            dependencies = {
                "MunifTanjim/nui.nvim", -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "rcarriga/nvim-notify", -- optional notification view, noice will default to mini(lower right corner messages) otherwise
            } 
        },
        { "folke/flash.nvim", event = "VeryLazy", keys = FlashKeyDefinitions, opts = FlashOpts, },
        'christoomey/vim-tmux-runner',

        { 'chrisbra/unicode.vim', event = "VeryLazy" },     -- unicode helper
        { 'godlygeek/tabular', event = "VeryLazy" },        -- format text into aligned tables
    })
end
