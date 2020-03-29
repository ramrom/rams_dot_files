"Sreeram's VI RC

""""""""" VIM PLUG MANAGEMENT"""""""""""""""""""""""""""""""""""
if empty(glob('~/.vim/autoload/plug.vim'))
    echo "WARNING! VIM-PLUG NOT INSTALLED, SKIPPING LOADING PLUGINS, rerun with VIM_INSTALLPLUG set to install"
    " Install vim-plug if env var is set
    if !empty($VIM_INSTALLPLUG)
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
elseif empty($VIM_NOPLUG)
    call plug#begin('~/.vim/plugged')

    "TODO: find one of these that's better than ir_black
    " grubbox, dractula, molokai are decent, maybe abstract
    Plug 'rafi/awesome-vim-colorschemes'

    Plug 'tpope/vim-fugitive'        " git-vim synergy
    Plug 'scrooloose/nerdtree'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tmux-plugins/vim-tmux-focus-events'  "used to get autoread to work below
    Plug 'chrisbra/unicode.vim'     " unicode helper
    Plug 'tpope/vim-commentary'     " smart code commenting

    "sign col shows revision ctrl changed lines, internet say faster and better than gitgutter
    if has('nvim') || has('patch-8.0.902')
        Plug 'mhinz/vim-signify'
    else
        Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif

    "NOTE: will detect .txt files with `***` chars in first line as robot
    Plug 'mfukar/robotframework-vim'    "more recent, i think formed from costallet
    "Plug 'costallat/robotframework-vim'

    "NOTE:  osx brew vim 8.2 (with conceal) very slow to load, neovim much faster
    "TODO: indentLine displays `"` chars `|` or disspapear in json files...
    Plug 'Yggdroot/indentLine'    " visual guides to indentations for readability
    " Plug 'nathanaelkane/vim-indent-guides'  " alternates odd/even line colors, indentLine doesnt

    if has('nvim')
        Plug 'neoclide/coc.nvim', { 'branch': 'release' }
        "TODO: can enable coc by filetype
        " Plug 'neoclide/coc.nvim', {'tag': '*', 'do': 'yarn install', 'for': ['json', 'lua', 'vim', ]}
    endif

    if has('nvim') && !empty($VIM_BASH)
        Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
    endif
    "neovim offers best coc/metals experience
    if has('nvim') && !empty($VIM_METALS)
        Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
    endif

    " plug#end automatically runs filetype plugin indent on and syntax enable
    call plug#end()
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"syntax on                  "syntax highlighting
set t_Co=256
colorscheme ir_black

" TODO: find better timeout length
" set timeoutlen=1000          " default is 1000ms

set nobackup                                    " no backup files
set nowritebackup                               " only in case you don't want a backup file while editing
set noswapfile                                  " no swap files
"set backupdir=~/.vim,~/.tmp/,~/tmp,/tmp

set wildmenu                    " display command line's tab complete options as menu
set wrap                        " wrap lines longer than width to next line
set linebreak                   " avoid wrapping line in middle of a word
set scrolloff=1                 " always show at least one line above or below the cursor
set showcmd                     " show commands i'm process of typing in status bar
set number					    " line numbers
set backspace=indent,eol,start  " backspace like most wordprocessors in insert mode
set display+=lastline           " display lastline even if its super long
" set tw=0                        " set textwidth to unlimited (e.g. vim uses tw=78 for .vim filetype and it's annoying)
" set formatoptions+=j            " Delete comment character when joining commented lines


set hlsearch  				" highlight search
highlight Search cterm=underline ctermbg=238
" highlight Search cterm=italic ctermbg=238  "TODO: italics not showing...
set incsearch				" searching as you type (before hitting enter)
set ignorecase              " case-insensitive searches
set smartcase               " with ignorecase, search with all lowercase means INsensitive, any uppercase means sensitive

"TODO: fix, i - included files, kspell dictionary
" set complete-=i | set complete+=kspell

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

" TODO: find a good char for tab and other non-\s whitespaces
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

"globally disable indentLine by default
let g:indentLine_enabled = 0

" globally disable vim-signify by default
if empty($VIM_SIGNIFY) | let g:signify_disable_by_default = 1 | endif


"Mappings
let mapleader = " "				"set metakey for vim shortcuts

" TODO: semicolon repeats last f/F motions, maybe make it goto command mode
" nmap ; :

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
endif

"way faster and easier way to hit escape, rarely hit jk successively in insert mode
inoremap jk  <Esc>
" inoremap jj  <Esc>

inoremap <C-l>  <C-o>:w<cr>
" inoremap <C-k>  <C-o>:w<cr>

"Fast buffer nav
noremap <leader>f :bn<CR>
noremap <leader>d :bp<CR>

" TODO: think off adding these if i use vim windows more
" ctrl-l refreshes screen, ctrl-h backspace, ctrl-j down one line, ctrl-k digraph
"noremap <C-l> <C-w>l
"noremap <C-h> <C-w>h
"noremap <C-j> <C-w>j
"noremap <C-k> <C-w>k

" TODO: not sure, c-m/c-j/c-n/c-g/c-s/c-q/c-h all seem like better alternatives
" C-l in normal defaults to clear and redraw screen
" noremap <C-l>   :w<cr>

exe ":function! MyLeaderMap() \n :map <leader> \n endfunction"

noremap <leader>q :q<cr>
noremap <leader>aa :call MyLeaderMap()<cr>
noremap <leader>as :vsplit ~/rams_dot_files/cheatsheets/current.txt<cr>
noremap <leader>ar :vsplit ~/rams_dot_files/cheatsheets/regex_cheatsheet.txt<cr>
noremap <leader>av :vsplit ~/rams_dot_files/cheatsheets/vim_cheatsheet.txt<cr>
noremap <leader>ab :vsplit ~/rams_dot_files/cheatsheets/shell_cheatsheet.sh<cr>
noremap <leader>ad :vsplit ~/tmp/scratch.txt<cr>
noremap <leader>e :Explore<CR>
noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>o :Files<CR>
noremap <leader>O :Files!<CR>
noremap <leader>l :Lines<CR>
noremap <leader>b :Buffers<CR>
noremap <leader>r :Rg<CR>
noremap <leader>w <C-w>w
noremap <leader>W <C-w>W
noremap <leader>t :tabnew<CR>
noremap <leader>p :vsplit<CR><leader>w
noremap <leader>h :split<CR><leader>w
noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>x :set number!<CR>
noremap <leader>gc :set ignorecase!<cr>:set ignorecase?<cr>
noremap <leader>gf :call ToggleFoldMethod()<cr>:set foldmethod?<cr>
noremap <leader>gt :call ToggleDisplayTrailSpaces()<cr>
noremap <leader>gI :IndentLinesToggle<cr>
noremap <leader>go :call CycleColorCol()<cr>
noremap <leader>gs :SignifyToggle<cr>
noremap <leader>gg :w<CR>:SilentRedraw git add . && git commit -m 'added stuff'<CR>
noremap <leader>gu :set spell!<cr>
" noremap <leader>s :mksession! ~/MyCurrentVimSession.vim<CR>

"gb easier to type than gT
noremap gb :tabprevious<CR>

" turn off highlighting till next search
noremap <leader>s :noh<cr>

" TODO: i think these maps are seriously useful
" nnoremap <C-J> a<CR><Esc>k$
" nnoremap <CR> o<Esc>

" This next line will open a ctag in a new tab
noremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

"Quickly switch between up to 9 vimtabs
for i in range(0,9) | exe 'noremap g'.i.' :tabn '.i.'<CR>' | endfor

" ignore compiled scala/java files, added so CtrlP will ignore these files
set wildignore+=*/target/*

" let netrw file explorer use nerdtree-like expansion on dirs
let g:netrw_liststyle = 3
" let g:netrw_winsize = 25

" for jsonc format, which supports commenting, this will highlight comments
autocmd FileType json syntax match Comment +\/\/.\+$+

"vim73 thinks *.md is modula2, markdown files also have this extension
if v:version <= 703   " 7.3 is 703 not 730, vim versioning is wierd
    autocmd BufNewFile,BufRead *.md set filetype=markdown
endif

""""""""""""""" VIM-INDENT-GUIDES PLUGIN"""""""""""""""""""""""""""""""""""""""""
" let g:indent_guides_guide_size = 1   " guide line is only one col wide
" let g:indent_guides_start_level = 2  " start guide lines at 2nd level indent

" " feb 2020: plugin uses black(000) for IndentGuidesOdd background=dark, ir_black uses 000 so... need custom
" let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=234
" autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=236
" " autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=017


""""" RipGrep and FD """"""""""""""""""
if executable('rg')
    set grepprg=rg\ --color=never
    let g:ctrlp_use_caching = 0
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
endif

" if fd installed prefer that over rg
if executable('fd')
    let g:ctrlp_user_command = 'fd --hidden --exclude .git'
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
