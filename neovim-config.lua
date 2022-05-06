--------- NEOVIM LUA CONFIG ------

-- source a vimscript file
-- vim.cmd 'source ~/.config/nvim/keymaps.vim'

-- o is general settings
-- vim.o.background = 'light'

-- use space as a the leader key
-- vim.g.mapleader = ' '

-- set a env var value
-- vim.env.FZF_DEFAULT_OPTS = '--layout=reverse'

if vim.fn.has('nvim-0.7') == 1 then
  print('we got neovim 0.7')
end

-- metals stuff
metals_config = require("metals").bare_config()

metals_config.settings = {
  showImplicitArguments = true,
  showInferredType = true
}

metals_config.init_options.statusBarProvider = "on"

metals_config.capabilities = capabilities

vim.cmd([[augroup lsp]])
vim.cmd([[autocmd!]])
vim.cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
vim.cmd([[autocmd FileType java,scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
vim.cmd([[augroup end]])

-- set wildignore+=*/.metals/*,*/.bloop/*,*/.bsp/*

-- set shortmess-=F      " Ensure audocmd works for filetype
-- set shortmess+=c      " Avoid showing extra message when using completion

-- pgar keybindings LSP key bindings
-- nnoremap <silent> K           <cmd>lua vim.lsp.buf.hover()<CR>
-- nnoremap <silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
-- nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
-- nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
-- nnoremap <silent> gds         <cmd>lua vim.lsp.buf.document_symbol()<CR>
-- nnoremap <silent> gws         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
-- nnoremap <silent> <leader>D   <cmd>lua vim.lsp.buf.type_definition()<CR>
-- nnoremap <silent> <leader>rn  <cmd>lua vim.lsp.buf.rename()<CR>
-- nnoremap <silent> <leader>ca  <cmd>lua vim.lsp.buf.code_action()<CR>
-- nnoremap <silent> <leader>q   <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
-- nnoremap <silent> <leader>e   <cmd>lua vim.lsp.diagnostic.open_float()<CR>
-- nnoremap <silent> [c          <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
-- nnoremap <silent> ]c          <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>

-- for telescope
-- nnoremap <leader>fm <cmd>Telescope metals commands<cr>

