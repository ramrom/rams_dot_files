-- NEOVIM CONFIG

-- ISSUES
    -- cant get leader y/p to copy/paste to + buffer
    -- get listchars opt working

--------------------------------------------------------------------------------------------------------
-------------------------------- PLUGINS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- print(lazypath)
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath, })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    'tpope/vim-fugitive', { 'tpope/vim-fugitive' },
    'tpope/vim-commentary', { 'tpope/vim-commentary' },
    'tpope/vim-surround', { 'tpope/vim-surround' },
    'tpope/vim-repeat', { 'tpope/vim-repeat' },
    'junegunn/fzf', { 'junegunn/fzf', run = ":call fzf#install()" },
    'junegunn/fzf.vim', { 'junegunn/fzf.vim' },
    'nvim-lualine/lualine.nvim', { 'nvim-lualine/lualine.nvim' },
    'lewis6991/gitsigns.nvim', { 'lewis6991/gitsigns.nvim' },
    'joshdick/onedark.vim', { 'joshdick/onedark.vim' },
    'preservim/vim-markdown', { 'preservim/vim-markdown' },
    'nvim-treesitter/nvim-treesitter', { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
})

--------------------------------------------------------------------------------------------------------
-------------------------------- SETTINGS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
vim.opt.backup = false                 -- no backup files
vim.opt.writebackup = false            -- only in case you don't want a backup file while editing
vim.opt.swapfile = false               -- no swap files

vim.opt.mouse=null                     -- turn off all mouse support by default

----- COLOR -----
vim.g.onedark_termcolors=256
vim.g.onedark_terminal_italics=1
vim.cmd('autocmd ColorScheme onedark call onedark#extend_highlight("Normal", { "bg": { "cterm": "000" } })')
vim.cmd.colorscheme('onedark')
vim.cmd.highlight({'clear','Search'})

vim.opt.autoread = true                         -- reload file's buffer if file was changed externally
vim.opt.splitbelow = true                       -- open new windows on bottom for horizontal, right for vertical
vim.opt.splitright = true                       -- open new windows on bottom for horizontal, right for vertical
vim.opt.wildmenu = true                         -- display command line's tab complete options as menu
vim.opt.wildmode = {'longest', 'list', 'full'}  -- complete longest common, list all matches, complete till next full match
vim.opt.wrap = true                             -- wrap lines longer than width to next line
vim.opt.linebreak = true                        -- avoid wrapping line in middle of a word
vim.opt.scrolloff = 1                           -- always show at least one line above or below the cursor
vim.opt.showcmd = true                          -- show commands i'm process of typing in status bar
vim.opt.number = true                           -- line numbers
vim.opt.backspace= {'indent' ,'eol', 'start'}   -- backspace like most wordprocessors in insert mode
vim.opt.display:append('lastline')              -- display lastline even if its super long
vim.opt.formatoptions:append('j')               -- Delete comment character when joining commented lines

---- SERACHING
vim.opt.hlsearch = true                         -- highlight search
vim.cmd.highlight({'Search','cterm=italic,underline,inverse'})
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

--- DEFAULT STATUS LINE
vim.opt.ls=2                    -- line status, two lines for status and command
vim.opt.statusline=[[ %F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [POS=%04l,%04v][%p%%]\ ]]


--- TRAILING SPACES
vim.opt.list = true
-- vim.opt.listchars={tab = '_', trail = '.'}


--------------------------------------------------------------------------------------------------------
-------------------------------- FUNCTIONS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
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

local Lua = {}
function Lua.moduleExists(name)
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

--------------------------------------------------------------------------------------------------------
-------------------------------- MAPS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
vim.g.mapleader = " "

vim.keymap.set("i", "<C-l>", "<Esc>")
vim.keymap.set("i", "<C-k>", "<C-o>:w<cr>")
vim.keymap.set("n", "<leader>f", TabBufNavForward)
vim.keymap.set("n", "<leader>d", TabBufNavBackward)
vim.keymap.set("n", "<leader>t", "<cmd>:tabnew<CR>")
vim.keymap.set("n", "<leader>z", function() print("hi") end)
vim.keymap.set("n", "<leader>q", TabBufQuit)
vim.keymap.set("n", "<leader>Q", "<cmd>:q!<CR>")
vim.keymap.set("n", "<leader><leader>q", "<cmd>:qa<CR>")
vim.keymap.set("n", "<leader>e", "<cmd>:Explore<CR>")
vim.keymap.set("n", "<leader>y", "\"+y")
-- vim.keymap.set("n", "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>p", [["+p]])
vim.keymap.set("n", "<leader>j", "<cmd>:noh<CR>")

vim.keymap.set('n', '<leader>;', '<cmd>:Commands<cr>')
vim.keymap.set('n', '<leader>r', '<cmd>:History:<cr>')
vim.keymap.set('n', '<leader>n', '<cmd>:NERDTreeToggle<CR>')
vim.keymap.set('n', '<leader>N', '<cmd>:NERDTreeFind<CR>')
vim.keymap.set('n', '<leader>o', '<cmd>:Files<CR>')
vim.keymap.set('n', '<leader>O', '<cmd>:Files!<CR>')
vim.keymap.set('n', '<leader>b', '<cmd>:Buffers<CR>')
vim.keymap.set('n', '<leader>B', '<cmd>:Buffers!<CR>')
vim.keymap.set('n', '<leader>k', '<cmd>:Rg<CR>')
vim.keymap.set('n', '<leader>K', '<cmd>:Rg!<CR>')
vim.keymap.set('n', '<leader>i', '<cmd>:FZFMru<CR>')

vim.keymap.set('n', '<leader>ll', '<cmd>:Lines<CR>')
vim.keymap.set('n', '<leader>L', '<cmd>:Lines<CR>')
--------------------------------------------------------------------------------------------------------
-------------------------------- PLUGIN CONFIG ----------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
if vim.fn.has('nvim-0.8.0') == 1 then

if Lua.moduleExists('lualine') then
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
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            -- lualine_b = { { 'branch', icons_enabled = true, {'branch', icon = 'ᛘ'} }, 'diff', 'diagnostics' },
            lualine_c = { { 'filename', file_status = true, path = 1 } },
            lualine_x = {'filetype', 'encoding', 'fileformat'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {
            lualine_a = {
                {
                    'tabs',
                    mode = 2,
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
            },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {
                {
                    'buffers',
                    show_modified_status = true,
                    mode = 4,
                    buffers_color = {
                        inactive = { fg = 'grey', bg = 'black' },
                        active = 'grey',
                    },
                    },
                },
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }
end

---------------------- TREE-SITTER CONFIG -------------------------------
require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = "all",

    -- ignore_install = { "javascript", "rust" }, -- List of parsers to ignore installing (or "all")

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- oct2022: M1 macs have known issue for phpdoc: https://github.com/claytonrcarter/tree-sitter-phpdoc/issues/15
        -- see also https://www.reddit.com/r/neovim/comments/u3hj8p/treesitter_cant_install_phpdoc_on_m1_mac/
    ignore_install = { "phpdoc" },

    highlight = {
        -- `false` will disable the whole extension
         enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = { "markdown" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    },
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
