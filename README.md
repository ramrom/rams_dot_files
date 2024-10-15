# RAMS DOT FILES
My dot files and scripts for Unix-like environments

## NEOVIM
- Lazy.nvim for plugin management
### PLUGINS
- lualine - statusline (replaces vim-airline)
- fzf.lua - fuzzy finding (replaces fzf.vim)
- nvim-tree - file/tree explorer (replaces NERDTree)
- treesitter - build AST of filetypes (tons of uses, replaces vim regex highlighting)
- onedarkpro - colorscheme
- git stuff
    - vim-fugitive
    - gitsigns - git intelligence (replaces vim-signify)
- LSP/code-intelligence
    - built-in client + nvim-lspconfig
    - auto-completion - nvim-cmp
    - snippets - LuaSnip
- which-key - great real time help menu of my keymaps
- noice - awesome new UI for neovim

## VIM
- june2023 - *deprecated* vim, all in on neovim, definitely not worth maintaining both
    - .vimrc around for the rare case I might use vim
- Vim Plug for plugin manager
### PLUGINS
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

## CORE TOOLS
- vim/neovim
- tmux
- rg
- fzf
- fd
- bat
