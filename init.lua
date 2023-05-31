-- NEOVIM CONFIG
-- ISSUES
--- 1. fzf is not loading, dont see commands

-------- PLUGINS -------------------
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
    'junegunn/fzf', { 'junegunn/fzf', run = ":call fzf#install()"  },
    'nvim-lualine/lualine.nvim', { 'nvim-lualine/lualine.nvim' },
    'lewis6991/gitsigns.nvim', { 'lewis6991/gitsigns.nvim' },
    'joshdick/onedark.vim', { 'joshdick/onedark.vim' },
})

-------- SETTINGS -----------
vim.g.onedark_termcolors=256
vim.g.onedark_terminal_italics=1
vim.cmd('autocmd ColorScheme onedark call onedark#extend_highlight("Normal", { "bg": { "cterm": "000" } })')
vim.cmd.colorscheme('onedark')
vim.cmd.highlight({'clear','Search'})

------- FUNCS -----------------
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

-- close tabs and windows if more than one of either, otherwise closes buffers until none and then quit vim
TabBufQuit = function()
    local tabinfo = vim.fn.gettabinfo()
    if #tabinfo == 1 and #tabinfo[1]['windows'] == 1 then
        if #vim.fn.getbufinfo({buflisted = 1}) == 1 then vim.cmd(':q') else vim.cmd(':bd') end
    else
        vim.cmd(':q')
    end
end

------- MAPS -----------------------
vim.g.mapleader = " "

vim.keymap.set("i", "<C-l>", "<Esc>")
vim.keymap.set("i", "<C-k>", "<C-o>:w<cr>")
vim.keymap.set("n", "<leader>f", TabBufNavForward)
vim.keymap.set("n", "<leader>d", TabBufNavBackward)
vim.keymap.set("n", "<leader>t", "<cmd>:tabnew<CR>")
vim.keymap.set("n", "<leader>z", function() print("hi") end)
vim.keymap.set("n", "<leader>q", TabBufQuit)
vim.keymap.set("n", "<leader>Q", "<cmd>:q!<CR>")
