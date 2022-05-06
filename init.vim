set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" lua require('neovim-config')


"""" NEOVIM LUA CONFIG

" older neovim versions dont support vim module and other things
if has('nvim-0.5.0')
lua << EOF
if vim.fn.has('nvim-0.7') == 1 then
    if vim.env.VIM_METALS then
        print("activate metals!")

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
    end
end
EOF
endif

" set shortmess-=F      " Ensure audocmd works for filetype
" set shortmess+=c      " Avoid showing extra message when using completion

" pgar keybindings LSP key bindings
" nnoremap <silent> K           <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> gds         <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gws         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
" nnoremap <silent> <leader>D   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> <leader>rn  <cmd>lua vim.lsp.buf.rename()<CR>
" nnoremap <silent> <leader>ca  <cmd>lua vim.lsp.buf.code_action()<CR>
" nnoremap <silent> <leader>q   <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
" nnoremap <silent> <leader>e   <cmd>lua vim.lsp.diagnostic.open_float()<CR>
" nnoremap <silent> [c          <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
" nnoremap <silent> ]c          <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>

" === Basic Completion Settings ===
" menu = use a popup menu to show possible completions
" menuone = show a menu even if there is only one match
" noinsert = do not insert text for a match until user selects one
" noselect = do not select a match from the menu automatically
" set completeopt=menu,menuone,noinsert,noselect

" Enable completions as you type.
" let g:completion_enable_auto_popup = 1

" for telescope
" nnoremap <leader>fm <cmd>Telescope metals commands<cr>
