---------------------------------------------------------------------------
----------- SIMPLE INIT.LUA -----------------------------------------------
------------------------------------------------------------------------------

-- NOTE: intended for hosts with older nvims (like raspian)

------------------------- SETTINGS ---------------------------------

-------- GENERAL
vim.opt.splitbelow = true                       -- open new windows on bottom for horizontal, right for vertical
vim.opt.splitright = true                       -- open new windows on bottom for horizontal, right for vertical
vim.opt.wildmenu = true                         -- display command line's tab complete options as menu
vim.opt.wildmode = {'longest', 'list', 'full'}  -- complete longest common, list all matches, complete till next full match
vim.opt.wrap = true                             -- wrap lines longer than width to next line
vim.opt.linebreak = true                        -- avoid wrapping line in middle of a word
vim.opt.scrolloff = 1                           -- always show at least one line above or below the cursor
vim.opt.showcmd = true                          -- show commands i'm process of typing in status bar
vim.opt.number = true                           -- line numbers
vim.opt.updatetime = 1000                       -- default is 4000, used for CursorHold autocmds, swap file writing
vim.opt.backspace= {'indent' ,'eol', 'start'}   -- backspace like most wordprocessors in insert mode
vim.opt.display:append('lastline')              -- display lastline even if its super long
vim.opt.formatoptions:append('j')               -- Delete comment character when joining commented lines

--- FOLDING
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false            -- dont fold everything when opening buffers

-- INDENTING
vim.opt.autoindent = true       -- indent on new line for inner scopes in code
vim.opt.shiftwidth=4            -- use 4 spaces for autoindent (cindent)
vim.opt.tabstop=4               -- space 4 columns when reading a <tab> char in file
vim.opt.softtabstop=4           -- complicated, see docs
vim.opt.expandtab = true        -- use spaces when tab is pressed

---- SERACHING
vim.opt.hlsearch = true                         -- highlight search
vim.opt.incsearch = true               -- searching as you type (before hitting enter)
vim.opt.ignorecase = true              -- case-insensitive searches
vim.opt.smartcase = true               -- with ignorecase, search with all lowercase means INsensitive, any uppercase means sensitive

-- AUTO COMPLETION
vim.opt_global.completeopt = { "menu", "menuone", "noinsert", "noselect" }

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

-- disable autocommenting on o and O in normal
vim.api.nvim_create_autocmd('FileType', { pattern = '*', command ='setlocal formatoptions-=o' })

vim.opt.listchars = {tab = '»_', trail = '.'}

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
TabBufQuit = function()
    local tabinfo = vim.fn.gettabinfo()
    if #tabinfo == 1 and #tabinfo[1]['windows'] == 1 then
        if #vim.fn.getbufinfo({buflisted = 1}) == 1 then vim.cmd(':q') else vim.cmd(':bd') end
    else
        vim.cmd(':q')
    end
end


---- ONE DARK PRO: https://github.com/olimorris/onedarkpro.nvim ----------------------------------
local LoadOneDarkProConfig = function()
    require("onedarkpro").setup()
    vim.cmd.colorscheme("onedark_dark")
end

---------------------- TREE-SITTER CONFIG -------------------------------
-- NOTE: if TS is disabled for a buffer, old vim regex highlighting turns on
LoadTreeSitterV12 = function()
    require('nvim-treesitter').install('all')  -- NOTE: run this first time vim install, or :TSInstall all

    local is_largefile = function(buf)
        local max_filesize = 20 * 1024 * 1024 -- 20 MB 
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end

    -- TODO: feb'26 - maybe check out https://github.com/Corn207/ts-query-loader.nvim plugin instead
        -- or use https://github.com/xaaha/dev-env/blob/main/nvim/.config/nvim/lua/xaaha/plugins/lsp-nvim-treesitter.lua
    vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(event)
            if vim.bo.filetype == 'notify' then return end
            if vim.bo.filetype == 'noice' then return end
            if vim.bo.filetype == 'fzf' then return end

            if os.time() > 1772860228 + 60*60*24*365 then trynotify("TREESITTER CHECK CSV!", "warn") end -- after ~ mar6-27
            if vim.bo.filetype == 'csv' then return end  -- mar26 - syn highlight colorizes columns, treesitter doesnt

            -- print(vim.treesitter.language.get_lang(event.match) or event.match)


            local buf_num = event.buf
            if is_largefile(buf_num) then 
                local filename = vim.api.nvim_buf_get_name(0)
                print(filename .. " is too large, treesitter bypassed") 
                return
            end

            local ok, _ = pcall(vim.treesitter.start)
            if ok then
                vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.wo[0][0].foldmethod = 'expr'

                -- TODO: skip if filetype = groovy, b/c Jenkinsfiles dont work well
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"


                --------------------- INCREMENTAL SELECTION ----------------------
                -- NOTE: old keymap: `gn` init, `<TAB>` node increment, `<c-k>` node decrement, '<CR>' scope increment
                -- TODO: jan'26 - maybe use flash for it https://github.com/folke/flash.nvim
                vim.keymap.set({ 'x' }, '<leader>d', function()
                    require 'vim.treesitter._select'.select_prev(vim.v.count1)
                end, { desc = 'Select previous node' })

                vim.keymap.set({ 'x' }, '<leader>f', function()
                    require 'vim.treesitter._select'.select_next(vim.v.count1)
                end, { desc = 'Select next node' })

                vim.keymap.set({ "n", "x", "o" }, "<TAB>", function()
                    if vim.treesitter.get_parser(nil, nil, { error = false }) then
                        require("vim.treesitter._select").select_parent(vim.v.count1)
                    else
                        vim.lsp.buf.selection_range(vim.v.count1)
                    end
                end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

                vim.keymap.set({ "n", "x", "o" }, "<C-k>", function()
                    if vim.treesitter.get_parser(nil, nil, { error = false }) then
                        require("vim.treesitter._select").select_child(vim.v.count1)
                    else
                        vim.lsp.buf.selection_range(-vim.v.count1)
                    end
                end, { desc = "Select child treesitter node or inner incremental lsp selections" })

            end
        end,
    })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        desc = 'highlight hyperlinks in regular paragraph/text of markdown',
        callback = function()
            vim.cmd.highlight("link mkdInlineURL htmlLink")
            vim.cmd.syntax([[match mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*/]])
        end,
    })
end

LoadTreeSitter = function()
    require'nvim-treesitter.configs'.setup {
        ensure_installed = "all",   -- A list of parser names, or "all"
        sync_install = false,       -- Install parsers synchronously (only applied to `ensure_installed`)

        highlight = {
            enable = true,     -- `false` will isable the whole extension

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- additional_vim_regex_highlighting = { "markdown" },
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = 'gn',
                node_incremental = '<TAB>',
                node_decremental = '<S-TAB>',
                scope_incremental = '<CR>',
            },
        },
    }

    vim.opt.foldmethod='expr'
    vim.opt.foldexpr='nvim_treesitter#foldexpr()'
end

----------------------------- FZF LUA --------------------------------------------------
LoadFzfLua = function()
    local help_menu_key = "<C-w><C-w>"
    local rotate_preview_key = "<C-w><C-e>"
    require'fzf-lua'.setup {
        files = {
             fd_opts = [[--color=never --type f --type l --hidden --exclude .git --exclude target]],
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
                -- ["ctrl-d"]    = "half-page-down",     -- sept'25 - same
                -- ["ctrl-u"]    = "half-page-up",       -- same
                ["f3"]        = "toggle-preview-wrap",
            },
            -- NOTE: c-w based movement for windows in tab disabled when fzflua term window is open anyway
            -- FIXME: oct'24 - f5/f6 defaults don't work, and dont show up as options in help menu either...
            builtin = {
                [help_menu_key]         = "toggle-help",
                ["<F1>"]                = "toggle-help",
                ["<c-w><c-f>"]          = "toggle-fullscreen",
                ["<F2>"]                = "toggle-fullscreen",
                ["<F5>"]                = "toggle-preview-ccw",
                [rotate_preview_key]    = "toggle-preview-cw",
                ["<F6>"]                = "toggle-preview-cw",
            }
        }
    }
    -- require('fzf-lua').register_ui_select()
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

---------------------- NVIM-TREE CONFIG -------------------------------
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


------------------------- MAPPINGS ---------------------------------
vim.g.mapleader = " "

vim.keymap.set("i", "<C-l>", "<Esc>")

vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

------ NAVIGATION
vim.keymap.set("n", "<leader>f", TabBufNavForward)
vim.keymap.set("n", "<leader>d", TabBufNavBackward)
vim.keymap.set("n", "<leader>t", "<cmd>:tabnew<CR>")
vim.keymap.set('n', '<leader>N', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeFindFileToggle<CR>')
vim.keymap.set('n', '<leader>wd', ToggleNvimTreeDynamicWidth, { desc = 'toggle nvim-tree width b/w dynamic and static size' })
vim.keymap.set('n', '<leader>wt', CycleNvimTreeSortBy, { desc = 'cycle nvim-tree sortby b/w name, mod time, and extension' })

---- SMART QUITTING
vim.keymap.set("n", "<leader>q", TabBufQuit, { desc = "smart quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>:q!<CR>")
vim.keymap.set("n", "<leader><leader>q", "<cmd>:qa<CR>")

------ SMART WRITING
vim.keymap.set("i", "<C-k>", "<C-o>:w<cr>", { desc = "write changes staying in insert"})
vim.keymap.set("n", "<leader>s", "<cmd>:w<CR>")

------- FZF
-- vim.keymap.set("n", "<leader>o", "<cmd>:Files<CR>")
vim.keymap.set('n', '<leader>o',function() require('fzf-lua').files() end, { desc = "fzf files" })
vim.keymap.set('n', '<leader>cm',function() require('fzf-lua').keymaps() end, { desc = "fzf key mappings" })
vim.keymap.set('n', '<leader>;',function() require('fzf-lua').commands() end, { desc = "fzf vim commands" })
vim.keymap.set('n', '<leader><leader>r',function() require('fzf-lua').command_history() end, { desc = "fzf command history" })
vim.keymap.set('n', '<leader><leader>c',function() require('fzf-lua').files({cwd='~/rams_dot_files/cheatsheets/'}) end,
    { desc = "fzf cheatsheet files" })

------ OTHER
vim.keymap.set('n', '<leader>r', 'q:', { desc = "command line history editor" })
vim.keymap.set("n", "<C-Space>", "<cmd>:Lazy<CR>")
vim.keymap.set("n", "<leader>j", "<cmd>:noh<CR>")
vim.keymap.set('n', '<leader>gT', [[ <cmd>:execute '%s/\s\+$//e' <cr> ]], { desc = "remove trailing whitespace"})


---------------------------- PLUGINS --------------------------------------
print("starting simple config init")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath, })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { 'nvim-treesitter/nvim-treesitter', branch = 'master', config = LoadTreeSitter, lazy = false,
        build = ":TSUpdate" },
        -- build = function() require("nvim-treesitter.install").update({ with_sync = true }) end },
    -- { 'nvim-treesitter/nvim-treesitter', config = LoadTreeSitterV12, cond = not vim.env.NO_TREESITTER,
    --     build = ":TSUpdate", lazy = false },
    { 'nvim-lualine/lualine.nvim', config = LoadLuaLine, event = 'VeryLazy' },
    { 'nvim-tree/nvim-tree.lua', config = LoadNvimTree, cmd = {"NvimTreeFindFileToggle", "NvimTreeToggle", "NvimTreeOpen"} },
    { 'nvim-treesitter/nvim-treesitter', config = LoadTreeSitter, cond = not vim.env.NO_TREESITTER,
        build = ":TSUpdate", lazy = false },
    { "olimorris/onedarkpro.nvim", lazy = false, config = LoadOneDarkProConfig, priority = 1000 },
    'tpope/vim-surround',
    'tpope/vim-repeat',
    { 'lewis6991/gitsigns.nvim', config = LoadGitSigns, event = "VeryLazy" },

    --- fuzzy find
    { 'ibhagwan/fzf-lua', config = LoadFzfLua, dependencies = { 'nvim-tree/nvim-web-devicons' }, event = 'VeryLazy' },
})

print("simple init config complete")
