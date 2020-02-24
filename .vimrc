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

    "TODO: try these out
    " Plug 'tpop/vim-fugitive'        " git-vim synergy
    " Plug 'vim-syntastic/syntastic'  " syntax

    Plug 'scrooloose/nerdtree'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tmux-plugins/vim-tmux-focus-events'  "used to get autoread to work below
    Plug 'chrisbra/unicode.vim'     " unicode helper
    Plug 'tpope/vim-commentary'     " smart code commenting
    Plug 'mhinz/vim-signify'        " use sign col to show revision ctrl changed lines

    "Plug 'costallat/robotframework-vim'
    Plug 'mfukar/robotframework-vim'    "more recent, i think formed from costallet


    "NOTE:  osx brew vim 8.2 (with conceal) very slow to load, neovim much faster
    "TODO: indentLine displays `"` chars `|` or disspapear in json files...
    Plug 'Yggdroot/indentLine'    " visual guides to indentations for readability
    " Plug 'nathanaelkane/vim-indent-guides'  " alternates odd/even line colors, indentLine doesnt
endif

if has('nvim') && !empty($VIM_METALS)
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
endif

" plug#end automatically runs filetype plugin indent on and syntax enable
call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"syntax on                  "syntax highlighting
set t_Co=256
colorscheme ir_black

set nobackup                                    " no backup files
set nowritebackup                               " only in case you don't want a backup file while editing
set noswapfile                                  " no swap files
"set backupdir=~/.vim,~/.tmp/,~/tmp,/tmp

set wildmenu                " display command line's tab complete options as menu
set linebreak               " avoid wrapping line in middle of a word
" set tw=0                    " set textwidth to unlimited (e.g. vim uses tw=78 for .vim filetype and it's annoying)
set showcmd                 " show commands i'm process of typing in status bar
set number					" line numbers

set hlsearch  				" highlight search
highlight Search cterm=underline ctermbg=238
set incsearch				" incremental search

set foldmethod=indent
set nofoldenable

""" Status Line
set ls=2					" line status, two lines for status and command
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [POS=%04l,%04v][%p%%]\

""" Indent Options
set autoindent                                  " indent on new line for inner scopes in code
set shiftwidth=4                                " use 4 spaces for autoindent (cindent)
set tabstop=4                                   " space 4 columns when reading a <tab> char in file
set softtabstop=4                               " complicated, see docs
set expandtab                                   " use spaces when tab is pressed

" TODO: maybe find a good trailing char
" set list
" set listchars=tab:>-,trail:.              "display tab chars as '>-', trailing spaces as '.'

" set cursorline                              " highlight line cursor is on
" set cursorcolumn                            " highlight column cursor is on

" let &colorcolumn=join(range(81,999),",")  "highlight columns >80
highlight ColorColumn ctermbg=235

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

if empty($VIM_NO_AUTOREAD) | call RamAutoRead() | endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -nargs=1 SilentRedraw execute ':silent !'.<q-args> | execute ':redraw!'

function ToggleFoldMethod()
    "1 ? echo 'indent' : echo 'not indent'  "TODO: wtf vim, basic ternary errors
    if &foldmethod == "indent"
        set foldmethod=syntax
    else
        set foldmethod=indent
    endif
endfunction

"cycle between line 80, 120, and no colorcolumn
function CycleColorCol()
    if &colorcolumn == 81
        set colorcolumn=121
    elseif &colorcolumn == 121
        set colorcolumn=
    else
        set colorcolumn=81
    endif
endfunction

function ToggleDisplayTrailSpaces()
    " from https://vi.stackexchange.com/questions/4120/how-to-enable-disable-an-augroup-on-the-fly
    if !exists('#MyTrailSpaces#BufWinEnter')
        highlight ExtraWhitespace ctermbg=red guibg=red
        syntax match ExtraWhitespace /\s\+$/
        augroup MyTrailSpaces
            autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
            autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
            autocmd InsertLeave * match ExtraWhitespace /\s\+$/
            autocmd BufWinLeave * call clearmatches()
        augroup END
    else
        hi clear ExtraWhitespace
        autocmd! MyTrailSpaces
    endif
endfunction

call ToggleDisplayTrailSpaces()

"Mappings
let mapleader = ","				"set metakey for vim shortcuts

"way faster and easier way to hit escape, rarely hit jk successively in insert mode
inoremap jk  <Esc>

"Fast tab nav
noremap <leader>t :tabnew<CR>
"gb easier to type than gT
noremap gb :tabprevious<CR>

"Fast buffer nav
noremap <leader>f :bn<CR>
noremap <leader>d :bp<CR>

" TODO: think off adding these if i use vim windows more
" ctrl-l refreshes screen, ctrl-h backspace, ctrl-j down one line
"noremap <C-l> <C-w>l
"noremap <C-h> <C-w>h
"noremap <C-j> <C-w>j
"noremap <C-k> <C-w>k

noremap <leader>e :Explore<CR>
noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>w <C-w>w
noremap <leader>W <C-w>W
noremap <leader>p :vsplit<CR><leader>w
noremap <leader>h :split<CR><leader>w
noremap <leader>x :set number!<CR>
noremap <leader>gc :set ignorecase!<cr>:set ignorecase?<cr>
noremap <leader>gf :call ToggleFoldMethod()<cr>:set foldmethod?<cr>
noremap <leader>gt :call ToggleDisplayTrailSpaces()<cr>
noremap <leader>gI :IndentLinesToggle<cr>
noremap <leader>go :call CycleColorCol()<cr>
noremap <leader>gg :w<CR>:SilentRedraw git add . && git commit -m 'added stuff'<CR>
noremap <leader>gs :set spell!<cr>
" noremap <leader>s :mksession! ~/MyCurrentVimSession.vim<CR>

" turn off highlighting till next search
noremap <leader>s :noh<cr>

" This next line will open a ctag in a new tab
noremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

"Quickly switch between up to 9 vimtabs
for i in range(0,9) | exe 'map g'.i.' :tabn '.i.'<CR>' | endfor

" for jsonc format, which supports commenting, this will highlight comments
autocmd FileType json syntax match Comment +\/\/.\+$+

"vim73 thinks *.md is modula2, markdown files also have this extension
autocmd BufNewFile,BufRead *.md set filetype=markdown

" ignore compiled scala/java files, added so CtrlP will ignore these files
set wildignore+=*/target/*

" let netrw file explorer use nerdtree-like expansion on dirs
let g:netrw_liststyle = 3
" let g:netrw_winsize = 25

""""""""""""""" VIM-INDENT-GUIDES PLUGIN"""""""""""""""""""""""""""""""""""""""""
let g:indent_guides_guide_size = 1   " guide line is only one col wide
let g:indent_guides_start_level = 2  " start guide lines at 2nd level indent

" feb 2020: plugin uses black(000) for IndentGuidesOdd background=dark, ir_black uses 000 so... need custom
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=234
autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=236
" autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=017


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
