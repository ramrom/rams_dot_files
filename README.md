# Rams Dot Files

My dot files and scripts for Unix-like environments

## Vim
- Vim Plug for plugin manager
- neovim for better integration with coc and scala metals
    - init.vim just loads my vimrc, to maintain vim parity

### Plugins
- **FZF**
    - fzf-mru (fzf over most recently opened files)
- one-dark (inspired by atom colorscheme)
- vim-airline
- NERDtree
- vim-commentary (better than nerd-commentary)
- vim-fugitive
- vim-signify (better than gitgutter)
- indentLine
- vim-tmux-focus-events (to help make autoreload better)
- vim-gh-line
- vim-markdown
- nvim-treesitter (syntax highlighting, folding)
- LSP
    - vim and old neovim
        - coc (conqueror of completion), only used for old vim
    - modern neovim
        - native lsp client
        - nvim-lspconfig
