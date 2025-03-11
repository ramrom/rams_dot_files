---------------------------------------------------------------------------
----------- FIRENVIM SETTINGS -----------------------------------------------
------------------------------------------------------------------------------

-- firenvim binstub - $HOME/.local/share/firenvim/firenvim

---------------------------- PLUGINS --------------------------------------
print("firevim config init")
local lazypath = vim.fn.stdpath("data") .. "/firelazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath, })
end
vim.opt.rtp:prepend(lazypath)

---- ONE DARK PRO: https://github.com/olimorris/onedarkpro.nvim
local LoadOneDarkProConfig = function()
    require("onedarkpro").setup()
    vim.cmd.colorscheme("onedark_dark")
end

---------------------- TREE-SITTER CONFIG -------------------------------
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

---------------------- FIRENVIM CONFIG -------------------------------
LoadFireNvim = function()
    vim.g.firenvim_config = {
        globalSettings = { alt = "all" },
        localSettings = {
            [".*"] = {
                cmdline  = "neovim",
                content  = "text",
                priority = 0,
                selector = "textarea",
                -- takeover = "always"
                takeover = "never"
            }
        }
    }
end

require("lazy").setup({
    { 'nvim-treesitter/nvim-treesitter', config = LoadTreeSitter,
        build = function() require("nvim-treesitter.install").update({ with_sync = true }) end },
    { "olimorris/onedarkpro.nvim", lazy = false, config = LoadOneDarkProConfig, priority = 1000 },
    'tpope/vim-commentary',
    'tpope/vim-surround',
    'tpope/vim-repeat',

    --- fuzzy find
    { 'junegunn/fzf', run = ":call fzf#install()" },
    { 'junegunn/fzf.vim' },

    -- https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    { 'glacambre/firenvim',
        -- cond = not not vim.g.started_by_firenvim,  -- not not makes a nil false value, a non-nil value true
        config = LoadFireNvim,
        build = function()
            vim.fn["firenvim#install"](0)
        end 
    },
},
{
    -- seperate install location to keep sync for firenvim diff from regular neovim
    root = vim.fn.stdpath("data") .. "/firelazy",
    lockfile = vim.fn.stdpath("config") .. "/firenvim-lazy-lock.json",
})

------------------------- SETTINGS ---------------------------------

vim.api.nvim_create_autocmd('BufEnter', { pattern = 'github.com_*.txt', command = 'set filetype=markdown' })
vim.api.nvim_create_autocmd('BufEnter', { pattern = 'json.parser.online.fr_*.txt', command = 'set filetype=json' })

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


------------------------- MAPPINGS ---------------------------------
vim.g.mapleader = " "

vim.keymap.set("i", "<C-l>", "<Esc>")

vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("n", "<leader>o", "<cmd>:Files<CR>")

vim.keymap.set("n", "<leader>f", TabBufNavForward)
vim.keymap.set("n", "<leader>d", TabBufNavBackward)
vim.keymap.set("n", "<leader>t", "<cmd>:tabnew<CR>")

---- SMART QUITTING
vim.keymap.set("n", "<leader>q", TabBufQuit, { desc = "smart quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>:q!<CR>")
vim.keymap.set("n", "<leader><leader>q", "<cmd>:qa<CR>")

------ SMART WRITING
vim.keymap.set("i", "<C-k>", "<C-o>:w<cr>", { desc = "write changes staying in insert"})
vim.keymap.set("n", "<leader>s", "<cmd>:w<CR>")

vim.keymap.set("n", "<C-Space>", "<cmd>:Lazy<CR>")
vim.keymap.set("n", "<leader>j", "<cmd>:noh<CR>")
vim.keymap.set('n', '<leader>cm', '<cmd>:Maps!<CR>')
vim.keymap.set('n', '<leader>;', '<cmd>:Commands<cr>')
vim.keymap.set('n', '<leader>r', 'q:', { desc = "command line history editor" })
vim.keymap.set('n', '<leader><leader>r', '<cmd>:History:<cr>', { desc = "command history" })
vim.keymap.set('n', '<leader><leader>c', '<cmd>:Files ~/rams_dot_files/cheatsheets/<cr>')
vim.keymap.set('n', '<leader>gT', [[ <cmd>:execute '%s/\s\+$//e' <cr> ]], { desc = "remove trailing whitespace"})

print("firevim config complete")
