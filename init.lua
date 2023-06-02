-- NEOVIM CONFIG

-- ISSUES
    -- cant get leader y/p to copy/paste to + buffer
    -- get listchars opt working
    -- cyclecolorcol func

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
    'tpope/vim-fugitive',
    { 'nvim-tree/nvim-tree.lua', config = function() require("nvim-tree").setup() end },
    -- 'nvim-tree/nvim-web-devicons',
    'tpope/vim-commentary',
    'tpope/vim-surround',
    'tpope/vim-repeat',
    'ruanyl/vim-gh-line',       -- generate github url links from current file
    { 'junegunn/fzf', run = ":call fzf#install()" },
    'junegunn/fzf.vim',
    'pbogut/fzf-mru.vim',       -- fzf.vim is missing a most recently used file search
    'nvim-lualine/lualine.nvim',
    'chrisbra/unicode.vim',     -- unicode helper
    'lewis6991/gitsigns.nvim',
    { 'joshdick/onedark.vim', priority = 1000 },
    'godlygeek/tabular',
    { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end },
    'preservim/vim-markdown',
    -- { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { 'nvim-treesitter/nvim-treesitter',
        build = function() require("nvim-treesitter.install").update({ with_sync = true }) end },
    'nvim-lua/plenary.nvim',

    ----- LSP STUFF
    { 'scalameta/nvim-metals',
        ft = { 'scala', 'sbt' }, dependencies = { "nvim-lua/plenary.nvim" } },
    'mfussenegger/nvim-dap',
    'neovim/nvim-lspconfig',
    { 'kevinhwang91/nvim-bqf', ft = 'qf' },
    'j-hui/fidget.nvim',
    'hrsh7th/nvim-cmp',
    { 'hrsh7th/cmp-nvim-lsp', dependencies = { 'hrsh7th/nvim-cmp' } },
    { 'hrsh7th/cmp-buffer', dependencies = { 'hrsh7th/nvim-cmp' } },
    { 'hrsh7th/cmp-path', dependencies = { 'hrsh7th/nvim-cmp' } },
    'lukas-reineke/indent-blankline.nvim',
    'glacambre/firenvim',
        cond = not not vim.g.started_by_firenvim,
        build = function()
            require("lazy").load({ plugins = "firenvim", wait = true })
            vim.fn["firenvim#install"](0)
        end,
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
vim.cmd.highlight({'clear','Search'})   -- will set custom search highlight below

--- MAIN
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
vim.opt.updatetime = 1000                       -- default is 4000, used for CursorHold autocmds, swap file writing
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
vim.opt.listchars = {tab = '»_', trail = '.'}

vim.opt.grepprg='rg --vimgrep --follow'

-- for jsonc format, which supports commenting, this will highlight comments
-- #FIXME may'23: not working, code in .vimrc not working either
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'json', callback = function() vim.cmd.syntax([[match Comment +\/\/.\+$+]]) end
})

-- any file name starting with Jenkinsfile should be groovy
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, { pattern = 'Jenkinsfile*', command = 'set filetype=groovy' })

-- disable autocommenting on o and O in normal
vim.api.nvim_create_autocmd('FileType', { pattern = '*', command ='setlocal formatoptions-=o' })
--------------------------------------------------------------------------------------------------------
-------------------------------- FUNCTIONS --------------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
-- vim.api.nvim_create_user_command(
--     'SilentRedraw',
--     vim.execute(':silent !'.<q-args> | execute ':redraw!')
-- )

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

CycleColorColumn = function()
    if vim.opt.colorcolumn == "121" then vim.opt.colorcolumn = "81"
    elseif vim.opt.colorcolumn == '81' then vim.opt.colorcolumn = ''
    else vim.opt.colorcolumn = '121' end
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

------ WINDOW RESIZE AND MOVE
local default_opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Left>", ":vertical resize +1<CR>", default_opts)
vim.keymap.set("n", "<Right>", ":vertical resize -1<CR>", default_opts)
vim.keymap.set("n", "<Up>", ":resize -1<CR>", default_opts)
vim.keymap.set("n", "<Down>", ":resize +1<CR>", default_opts)

vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("i", "<C-l>", "<Esc>")
vim.keymap.set("i", "<C-k>", "<C-o>:w<cr>")
vim.keymap.set("n", "<leader>f", TabBufNavForward)
vim.keymap.set("n", "<leader>d", TabBufNavBackward)
vim.keymap.set("n", "<leader>t", "<cmd>:tabnew<CR>")
vim.keymap.set("n", "<leader>z", "<cmd>:tabnew %<CR>")
vim.keymap.set("n", "<leader>q", TabBufQuit, { desc = "smart quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>:q!<CR>")
vim.keymap.set("n", "<leader><leader>q", "<cmd>:qa<CR>")
vim.keymap.set("n", "<leader>s", "<cmd>:w<CR>")
vim.keymap.set("n", "<leader>e", "<cmd>:Explore<CR>")
vim.keymap.set('n', '<leader>v', ':vsplit<CR><leader>w')
vim.keymap.set('n', '<leader>h', ':split<CR><leader>w')
vim.keymap.set("n", "<leader>y", "\"+y")
-- vim.keymap.set("n", "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>p", [["+p]])
vim.keymap.set("n", "<leader>j", "<cmd>:noh<CR>")

vim.keymap.set('n', '<leader>;', '<cmd>:Commands<cr>')
vim.keymap.set('n', '<leader><leader>h', '<cmd>:Helptags!<cr>')
vim.keymap.set('n', '<leader>r', '<cmd>:History:<cr>')
vim.keymap.set('n', '<leader>o', '<cmd>:Files<CR>')
vim.keymap.set('n', '<leader>O', '<cmd>:Files!<CR>')
vim.keymap.set('n', '<leader>b', '<cmd>:Buffers<CR>')
vim.keymap.set('n', '<leader>B', '<cmd>:Buffers!<CR>')
vim.keymap.set('n', '<leader>x', '<cmd>:Rg<CR>')
vim.keymap.set('n', '<leader>X', '<cmd>:Rg!<CR>')
vim.keymap.set('n', '<leader>i', '<cmd>:FZFMru<CR>')

vim.keymap.set({'n', 'x'}, '<leader>k', '%', { desc = "go to matching pair" })

vim.keymap.set('n', '<leader>N', '<cmd>:NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>n', '<cmd>:NvimTreeFindFileToggle<CR>')

vim.keymap.set('n', '<leader>l', '<cmd>:Lines<CR>')
vim.keymap.set('n', '<leader>L', '<cmd>:Lines!<CR>')

vim.keymap.set('n', '<leader>cc', [[:Maps!<cr> space ]])
vim.keymap.set('n', '<leader>cm', '<cmd>:Maps!<CR>')
vim.keymap.set('n', '<leader>cg', '<cmd>:map g<CR>')
vim.keymap.set('n', '<leader><leader>c', '<cmd>:Files ~/rams_dot_files/cheatsheets/<cr>')
vim.keymap.set('n', '<leader>cl', '<cmd>:Files $MY_NOTES_DIR<cr>')
vim.keymap.set('n', '<leader>cw', '<cmd>:Files $MY_WORK_DIR<cr>')
vim.keymap.set('n', '<leader>cA', '<cmd>:vsplit ~/tmp/scratch.md<cr>')
vim.keymap.set('n', '<leader>ca', '<cmd>:tabnew ~/tmp/scratch.md<cr>')
vim.keymap.set('n', '<leader>co', '<cmd>:Files ~<cr>')

vim.keymap.set('n', '<leader>gi', '<cmd>:IndentBlanklineToggle<cr>')
vim.keymap.set('n', '<leader>gm', '<cmd>:MarkdownPreviewToggle<cr>')
vim.keymap.set('n', '<leader>gn', '<cmd>:set number!<cr>')
vim.keymap.set('n', '<leader>go', CycleColorColumn)

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


-------- indent blankline -------------
vim.g.indent_blankline_enabled=0
--require("indent_blankline").setup {
--    show_end_of_line = true,
--    show_current_context = true,
--    show_current_context_start = true,

--    -- show_end_of_line = true,
--    -- char = "",
--    -- char_highlight_list = {
--    --     "IndentBlanklineIndent1",
--    --     "IndentBlanklineIndent2",
--    -- },
--    -- space_char_highlight_list = {
--    --     "IndentBlanklineIndent1",
--    --     "IndentBlanklineIndent2",
--    -- },
--    show_trailing_blankline_indent = false,
--    --char_highlight_list = {
--    --    "IndentBlanklineIndent1",
--    --    "IndentBlanklineIndent2",
--    --    "IndentBlanklineIndent3",
--    --    "IndentBlanklineIndent4",
--    --    "IndentBlanklineIndent5",
--    --    "IndentBlanklineIndent6",
--    --},
--}

--------------------------------------------------------------------------------------------------------
-------------------------------- LSP CONFIG ----------------------------------------------------------
----------------------------------- -------------------------------------------------------------------
LSPDiagnosticsEnabled = true

ToggleLSPdiagnostics = function()
    LSPDiagnosticsEnabled = not LSPDiagnosticsEnabled
    if LSPDiagnosticsEnabled then
        vim.diagnostic.enable()
        print("LSP diagnostics enabled")
    else
        vim.diagnostic.disable()
        print("LSP diagnostics disabled")
    end
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        ActivateAutoComplete()
        vim.opt.signcolumn="yes:2" -- static 2 columns, at least one for signify and one for lsp diags
    end,
})

ActivateAutoComplete = function()
    if Lua.moduleExists('cmp') then
        local cmp = require 'cmp'
        cmp.setup {
            completion = { autocomplete = false, },   -- dont show autocomplete menu be default
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
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
                -- ['<Tab>'] = cmp.mapping(function(fallback)
                -- ['<C-n>'] = cmp.mapping(function(fallback)
                --     if cmp.visible() then
                --         cmp.select_next_item()
                --     elseif luasnip.expand_or_jumpable() then
                --         luasnip.expand_or_jump()
                --     else
                --         fallback()
                --     end
                -- end, { 'i', 's' }),
                -- -- ['<S-Tab>'] = cmp.mapping(function(fallback)
                -- ['<C-p>'] = cmp.mapping(function(fallback)
                --     if cmp.visible() then
                --         cmp.select_prev_item()
                --     elseif luasnip.jumpable(-1) then
                --         luasnip.jump(-1)
                --     else
                --         fallback()
                --     end
                -- end, { 'i', 's' }),
            }),
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'cmp_buffer' },
            },
        }
    end
end

end
