"Sreeram's VI RC

""""""""" VIM PLUG MANAGEMENT"""""""""""""""""""""""""""""""""""
" Install vim-plug if we don't already have it
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

if empty($VIM_SIMPLE)
    "TODO: find one of these that's better than ir_black
    Plug 'rafi/awesome-vim-colorschemes'

    Plug 'scrooloose/nerdtree'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tmux-plugins/vim-tmux-focus-events'  "used to get autoread to work below
    Plug 'chrisbra/unicode.vim'   " unicode helper
    Plug 'tpope/vim-commentary'   " smart code commenting
endif

if has('nvim')
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
endif

" plug#end automatically runs filetype plugin indent on and syntax enable
call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"syntax on					"syntax highlighting
set t_Co=256
colorscheme ir_black

set foldmethod=syntax
set nofoldenable

set showcmd                 " show commands i'm process of typing in status bar
set number					" line numbers
set hlsearch  				" highlight search
set ignorecase              " searches are case insensitive
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

"""""""" Reloading buffers changed outside of vim session """""""""""""""""
function RamAutoRead()
    "au FocusGained,BufEnter * :silent! !
    set autoread

    " autoread alone doesn't really work, triggers on external commands
        " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
        " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif

    " Notification after file change (https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread)
    autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
endfunction

if empty($NO_AUTOREAD) | call RamAutoRead() | endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -nargs=1 SilentRedraw execute ':silent !'.<q-args> | execute ':redraw!'

" TODO: this should copy into system clipbard, not working as of 5/5/19 on OSX
set clipboard=unnamed


"Mappings
let mapleader = ","				"set metakey for vim shortcuts
inoremap jk  <Esc>
"cnoremap jk  <Esc>

"Tabs
noremap <leader>t :tabnew<CR>
"gb easier to type than gT
noremap gb :tabprevious<CR>
noremap <leader>f :bn<CR>
noremap <leader>d :bp<CR>

" TODO: think off adding these if i use vim windows more
" ctrl-l refreshes screen, ctrl-h backspace, ctrl-j down one line
"noremap <C-l> <C-w>l
"noremap <C-h> <C-w>h
"noremap <C-j> <C-w>j
"noremap <C-k> <C-w>k

noremap <leader>e :Explore<CR>
noremap <leader>w <C-w>w
noremap <leader>g :w<CR>:SilentRedraw git add . && git commit -m 'added stuff'<CR>
norema <leader>n :NERDTreeToggle<CR>
noremap <leader>x :set number!<CR>
noremap <leader>p :vsplit<CR><leader>w
noremap <leader>h :split<CR><leader>w
noremap <leader>s :mksession! ~/MyCurrentVimSession<CR>

" This next line will open a ctag in a new tab
noremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

"Quickly switch between up to 9 vimtabs
let i=0
while i<10
  exe 'map g'.i.' :tabn '.i.'<CR>'
  let i+=1
endwhile

"set list
"set listchars=tab:>-,trail:.  			"when spacing/tabbing show temp chars
"set colorcolumn=81

" for jsonc format, which supports commenting, this will highlight comments
autocmd FileType json syntax match Comment +\/\/.\+$+

"vim73 thinks *.md is modula2, markdown files also have this extension
autocmd BufNewFile,BufRead *.md set filetype=markdown
" robot.vim syntax file obtained from https://github.com/seeamkhan/robotframework-vim
autocmd BufNewFile,BufRead *.robot set filetype=robot

" ignore compiled scala/java files, added so CtrlP will ignore these files
set wildignore+=*/target/*

" let netrw file explorer use nerdtree-like expansion on dirs
let g:netrw_liststyle = 3
" let g:netrw_winsize = 25


""""" The Silver Searcher """"""""""""""""""
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif


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
let g:ctrlp_max_files = 20000
let g:ctrlp_max_height = 20
let g:ctrlp_dotfiles = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
  \ 'file': '\.exe$\|\.so$\|\.dll$',
  \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
  \ }
