-- NEOVIM CONFIG

-------- PLUGINS -------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- print(lazypath)
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    'tpope/vim-fugitive',       -- git-vim synergy
    { 'tpope/vim-fugitive' },
    'junegunn/fzf',
    { 'junegunn/fzf', run = ":call fzf#install()"  },
    'nvim-lualine/lualine.nvim',
    { 'nvim-lualine/lualine.nvim' },
    'joshdick/onedark.vim',
    { 'joshdick/onedark.vim' },
})

-------- SETTINGS -----------
vim.g.onedark_termcolors=256
vim.g.onedark_terminal_italics=1
vim.cmd('autocmd ColorScheme onedark call onedark#extend_highlight("Normal", { "bg": { "cterm": "000" } })')
vim.cmd('colorscheme onedark')
vim.cmd('hi clear Search')

------- MAPS -----------------------
vim.g.mapleader = " "
