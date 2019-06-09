"Sreeram's VI RC

""""""""" VUNDLE PLUGIN MANAGEMENT"""""""""""""""""""""""""""""""""""
set nocompatible                    " be iMproved, required
filetype off                        " required
set rtp+=~/.vim/bundle/Vundle.vim   " set the runtime path to include Vundle and initialize
call vundle#begin()
Plugin 'gmarik/Vundle.vim'          " let Vundle manage Vundle, required
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

"Plugin 'dracula/vim'  dracula theme
"https://github.com/morhetz/gruvbox

call vundle#end()            " required
filetype plugin indent on    " required
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on					"syntax highlighting
set t_Co=256
colorscheme ir_black
set number					" line numbers
set hlsearch  				" highlight search
set incsearch				" incremental search

" Status Line
set ls=2					" line status, two lines for status and command
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ 
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [POS=%04l,%04v][%p%%]\

set nobackup                                    " no backup files
set nowritebackup                               " only in case you don't want a backup file while editing
set noswapfile                                  " no swap files
"set backupdir=~/.vim,~/.tmp/,~/tmp,/tmp

set autoindent                                  " indent on new line for inner scopes in code
set shiftwidth=4                                " use 4 spaces for autoindent (cindent)
set tabstop=4                                   " space 4 columns when reading a <tab> char in file
set softtabstop=4                               " complicated, see docs
set expandtab                                   " use spaces when tab is pressed


"TODO: experiment with autoreloading buffers when they are outdated
set autoread
"au FocusGained,BufEnter * :silent! !
"au CursorHold * checktime


" TODO: this should copy into system clipbard, not working as of 5/5/19 on OSX
set clipboard=unnamed


"Mappings
let mapleader = ","				"set metakey for vim shortcuts
inoremap jk  <Esc>
cnoremap jk  <Esc>

map <leader>t :tabnew<CR>
map gb :tabprevious<CR>

map <leader>e :Explore<CR>
map <leader>w <C-w>w
map <Leader>c :s/^/#/<CR>
map <Leader>u :s/^#//<CR>
map <leader>n :NERDTreeToggle<CR>
map <leader>x :set number!<CR>
map <leader>p :vsplit<CR><leader>w
map <leader>h :split<CR><leader>w
map <leader>s :mksession! ~/MyCurrentVimSession<CR>

" This next line will open a ctag in a new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

"set list
"set listchars=tab:>-,trail:.  			"when spacing/tabbing show temp chars
"set colorcolumn=81

"vim73 thinks *.md is modula2, markdown files also have this extension
autocmd BufNewFile,BufRead *.md set filetype=markdown
" robot.vim syntax file obtained from https://github.com/seeamkhan/robotframework-vim
autocmd BufNewFile,BufRead *.robot set filetype=robot

" ignore compiled scala/java files, added so CtrlP will ignore these files
set wildignore+=*/target/*


"""""""""""""""""Airline"""""""""""""""""""""""""""""""""""
"let g:airline_theme='luna'
let g:airline_theme='bubblegum'
"let g:airline_solarized_bg='dark'
"let g:airline_powerline_fonts = 1 " TODO: this needs instal https://github.com/powerline/fonts

let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'    " 'unique_tail_improved' to show shorted path
let g:airline#extensions#tabline#tab_nr_type = 1


"""""""""""""""""""CTRLP Fuzzyfinder"""""""""""""""""""""""
map <leader>f :CtrlP 
let g:ctrlp_max_files = 20000
let g:ctrlp_max_height = 20
let g:ctrlp_dotfiles = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
  \ 'file': '\.exe$\|\.so$\|\.dll$',
  \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
  \ }
