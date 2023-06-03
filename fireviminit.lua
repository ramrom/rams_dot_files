---------------------------------------------------------------------------
----------- FIRENVIM SETTINGS -----------------------------------------------
------------------------------------------------------------------------------

---------------------------- PLUGINS --------------------------------------
require("lazy").setup({
    'tpope/vim-commentary',
    'tpope/vim-surround',
    'tpope/vim-repeat',

    --- fuzzy find
    { 'junegunn/fzf', run = ":call fzf#install()" },
    { 'junegunn/fzf.vim' },

    'glacambre/firenvim',
        cond = not not vim.g.started_by_firenvim,  -- not not makes a nil false value, a non-nil value true
        build = function()
            require("lazy").load({ plugins = "firenvim", wait = true })
            vim.fn["firenvim#install"](0)
        end,
})

------------------------- SETTINGS ---------------------------------
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

vim.keymap.set("n", "<leader>f", TabBufNavForward)
vim.keymap.set("n", "<leader>d", TabBufNavBackward)

---- SMART QUITTING
vim.keymap.set("n", "<leader>q", TabBufQuit, { desc = "smart quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>:q!<CR>")
vim.keymap.set("n", "<leader><leader>q", "<cmd>:qa<CR>")

------ SMART WRITING
vim.keymap.set("i", "<C-k>", "<C-o>:w<cr>", { desc = "write changes staying in insert"})
vim.keymap.set("n", "<leader>s", "<cmd>:w<CR>")

vim.keymap.set("n", "<leader>j", "<cmd>:noh<CR>")
vim.keymap.set('n', '<leader>cm', '<cmd>:Maps!<CR>')
vim.keymap.set('n', '<leader>;', '<cmd>:Commands<cr>')
vim.keymap.set('n', '<leader>r', '<cmd>:History:<cr>', { desc = "command history" })
vim.keymap.set('n', '<leader><leader>c', '<cmd>:Files ~/rams_dot_files/cheatsheets/<cr>')
vim.keymap.set('n', '<leader>gT', [[ <cmd>:execute '%s/\s\+$//e' <cr> ]], { desc = "remove trailing whitespace"})
