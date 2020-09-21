"Sreeram's .vimrc
set nocompatible     " must be iMproved

"""""""""" VIM PLUG MANAGEMENT"""""""""""""""""""""""""""""""""""
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

    Plug 'tpope/vim-fugitive'        " git-vim synergy
    Plug 'tpope/vim-commentary'     " smart code commenting
    Plug 'preservim/nerdtree'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " NOTE/FIXME: vim 7.4 doesnt like this syntax
    Plug 'junegunn/fzf.vim'
    Plug 'pbogut/fzf-mru.vim'
    Plug 'ctrlpvim/ctrlp.vim'     "generally use fzf and fzf-mru instead
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tmux-plugins/vim-tmux-focus-events'  "used to get autoread to work below
    Plug 'chrisbra/unicode.vim'     " unicode helper

    if !empty($VIM_DEVICONS)
        " prereq: osx brew cask install https://github.com/ryanoasis/nerd-fonts#patched-fonts
        Plug 'ryanoasis/vim-devicons'
        " colored icons, needs devicons
        Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    endif

    " FIXME: TagbarToggle alway is blank window in scala source files, worked in a python project
    Plug 'majutsushi/tagbar'

    " TODO: check out junegunn vim-easy-align instead of tabular
    Plug 'godlygeek/tabular'        " plasticboy/vim-markdown uses this to format tables
    "NOTE: header highlighting fails, open issue in repo
    Plug 'plasticboy/vim-markdown'

    " real-time render markdown in browser window as you edit the source
    " Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

    "sign col shows revision ctrl changed lines, internet says faster/better than gitgutter
    if has('nvim') || has('patch-8.0.902')
        Plug 'mhinz/vim-signify'
    else
        Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif

    "NOTE:  osx brew vim 8.2 (with conceal) very slow to load, neovim much faster
    "TODO: indentLine displays `"` chars `|` or disspapear in json files...
    Plug 'Yggdroot/indentLine'    " visual guides to indentations for readability
    " Plug 'nathanaelkane/vim-indent-guides'  " alternates odd/even line colors, indentLine doesnt

    if has('nvim')
        Plug 'neoclide/coc.nvim', { 'branch': 'release' }
        "TODO: can enable coc by filetype
        " Plug 'neoclide/coc.nvim', {'tag': '*', 'do': 'yarn install', 'for': ['json', 'lua', 'vim', ]}

        if !empty($VIM_BASH)
            Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
        endif
        "neovim offers best coc/metals experience
        if !empty($VIM_METALS)
            Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
        endif
    endif

    "TODO: find one of these that's better than ir_black
    " grubbox, dracula, molokai are decent, maybe abstract
    Plug 'rafi/awesome-vim-colorschemes'

    "NOTE: will detect .txt files with `***` chars in first line as robot
    Plug 'mfukar/robotframework-vim'    "more recent, i think forked from costallet user

    "NOTE: plug#end automatically runs filetype plugin indent on and syntax enable
    call plug#end()
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"syntax on                  "syntax highlighting
set t_Co=256
colorscheme ram_ir_black    "modified ir_black with red/green vimdiff colors

" TODO: find better timeout length
" set timeoutlen=1000          " default is 1000ms

set nobackup                                    " no backup files
set nowritebackup                               " only in case you don't want a backup file while editing
set noswapfile                                  " no swap files

set splitbelow splitright       " open new windows on bottom for horizontal, right for vertical
set wildmenu                    " display command line's tab complete options as menu
set wildmode=longest,list,full  " complete longest common, list all matches, complete till next full match
set wrap                        " wrap lines longer than width to next line
set linebreak                   " avoid wrapping line in middle of a word
set scrolloff=1                 " always show at least one line above or below the cursor
set showcmd                     " show commands i'm process of typing in status bar
set number					    " line numbers
set backspace=indent,eol,start  " backspace like most wordprocessors in insert mode
set display+=lastline           " display lastline even if its super long
" set tw=0                        " set textwidth to unlimited (e.g. vim uses tw=78 for .vim filetype and it's annoying)

set formatoptions+=j            " Delete comment character when joining commented lines

" disable autocommenting on o and O in normal
autocmd FileType * setlocal formatoptions-=o

"Searching
set hlsearch  				" highlight search
"TODO: italics works in neovim, brew vim8.2 and osx-sys vim8.1 dont
if has('nvim')
    hi Search cterm=italic ctermbg=238
else
    hi Search cterm=underline ctermbg=238
endif
set incsearch				" searching as you type (before hitting enter)
set ignorecase              " case-insensitive searches
set smartcase               " with ignorecase, search with all lowercase means INsensitive, any uppercase means sensitive

"TODO: fix, i - included files, kspell dictionary
" set complete-=i | set complete+=kspell

set foldmethod=indent
set nofoldenable            " dont fold everything when opening buffers

""" Default Status Line
set ls=2					" line status, two lines for status and command
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [POS=%04l,%04v][%p%%]\

"show tabs and trailing spaces with special cars
set list
set listchars=tab:»_,trail:·
if has('nvim')  " highlight dimgrey, vim and neovim use diff group name
    highlight WhiteSpace ctermfg=8 guifg=DimGrey
else
    highlight SpecialKey ctermfg=8 guifg=DimGrey
endif

""" Indent/Tabs
set autoindent                                  " indent on new line for inner scopes in code
set shiftwidth=4                                " use 4 spaces for autoindent (cindent)
set tabstop=4                                   " space 4 columns when reading a <tab> char in file
set softtabstop=4                               " complicated, see docs
set expandtab                                   " use spaces when tab is pressed

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" set cursorline cursorcolumn                " highlight line and column cursor is on

"""""""" Reloading buffers changed outside of vim session """""""""""""""""
" autoread alone doesn't really work, triggers on external commands
    " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
    " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
function RamAutoRead()
    "au FocusGained,BufEnter * :silent! !
    set autoread

    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif

    " Notification after file change (https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread)
    autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
endfunction

if empty($VIM_NO_AUTOREAD) | call RamAutoRead() | endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -nargs=1 SilentRedraw execute ':silent !'.<q-args> | execute ':redraw!'

function! SourceIfExists(file)
  if filereadable(expand(a:file)) | exe 'source' a:file | echo 'source found and loaded' | endif
endfunction

function ToggleFoldMethod()
    "1 ? echo 'indent' : echo 'not indent'  "TODO: wtf vim, basic ternary errors
    if &foldmethod == "indent" | set foldmethod=syntax | else | set foldmethod=indent | endif
endfunction

" let &colorcolumn=join(range(81,999),",")  "highlight columns >80
highlight ColorColumn ctermbg=235

"cycle between line 80, 120, and no colorcolumn
function CycleColorCol()
    if &colorcolumn == 121
        set colorcolumn=81
    elseif &colorcolumn == 81
        set colorcolumn=
    else
        set colorcolumn=121
    endif
endfunction

" TODO: remove this as listchars display trailing spaces, or update to toggle listchar display
function ToggleDisplayTrailSpaces(showmsg)
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
        if (a:showmsg == "t") | echo "ToggleDisplayTrailSpaces ENABLED" | endif
    else
        hi clear ExtraWhitespace
        autocmd! MyTrailSpaces
        if (a:showmsg == "t") | echo "ToggleDisplayTrailSpaces DISABLED" | endif
    endif
endfunction

call ToggleDisplayTrailSpaces('f')

" delete all trailing white space
" NOTE: to make it automatic: autocmd BufWritePre * %s/\s\+$//e
function RemoveTrailingWhiteSpace()
    execute '%s/\s\+$//e'
endfunction

"globally disable indentLine by default
let g:indentLine_enabled = 0

"NOTE!: SignifyDisableAll still requires you to toggle/disable individual buffers
let g:signify_disable_by_default = 0
function ToggleSignifyAll()
    if g:signify_disable_by_default == 1
        exe ':SignifyEnableAll' | echo 'Signify ENABLE all'
    else
        exe ':SignifyDisableAll' | echo 'Signify DISABLE all'
    endif
endfunction


"""""""""" MAPPINGS """"""""""""""""""""""""""""""""
"""TODO: Prime open real estate for normal mode!
"<Leader>a/k/i/u/;/'
"<Leader><Leader>
"c-m/c-n/c-g/c-s/c-q
"c-x (opposite of c-a which i clobber for tmux meta)
"c-p (once i get rid of CtrlP plugin)
"; " semicolon repeats last f/F motions
"," ; in reverse direction
""" For insert mode: c-s

let mapleader = " "				"set metakey for vim shortcuts

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
endif

" TODO: probably remove, c-l seems to work well enough
" much faster than escape, almost never hit jk successively in insert, jj might be good too
" inoremap jk  <Esc>
" when vim in insertmode(awful) c-l goes to normal mode from insert
inoremap <C-l>  <Esc>

" TODO: should i keep?, leader-s saves from normal is nuff i thinks. (c-k default map is enter digraph)
inoremap <C-k>  <C-o>:w<cr>

function SaveDefinedSession()
    if exists("g:DefinedSessionName")
        set sessionoptions+=globals  " mksession wont save global vars by default
        exe ":mksession!" g:DefinedSessionName
        echo "Saved session: ".g:DefinedSessionName
    else
        exe ":mksession! ./MyCurrentVimSession.vim"
        echo "NO DEFINED SESSION NAME!, Saved to ./MyCurrentVimSession.vim"
    endif
endfunction

" if there is one tab, move forward/back buffer, otherwise forward/back tabs
function TabBufNav(direction)
    if !exists('*gettabinfo')  " vim 7.4(and earlier) dont have `gettabinfo`
        if (a:direction == "f") | execute ":tabn" | else |  execute ":tabprevious" | endif
        return
    endif
    if len(gettabinfo()) == 1
        if (a:direction == "f") | execute ":bn!" | else |  execute ":bp!" | endif
    else
        if (a:direction == "f") | execute ":tabn" | else |  execute ":tabprevious" | endif
    endif
endfunction

"close tabs and windows if more than one of either, otherwise closes buffers until none and then quit vim
function TabBufQuit()
    if !exists('*gettabinfo') | execute ":q" | return | endif   " vim 7.4(and earlier) dont have `gettabinfo`
    let tinfo=gettabinfo()
    if len(tinfo) == 1 && len(tinfo[0]['windows']) == 1
        if len(getbufinfo({'buflisted':1})) == 1 | exe ":q" | else | exe ":bd" | endif
    else | exe ":q" | endif
endfunction

noremap <leader>f :call TabBufNav("f")<CR>
noremap <leader>d :call TabBufNav("b")<CR>

"gb easier to type than gT
noremap gb :tabprevious<CR>

" default mappings: ctrl-l refreshes screen, ctrl-h backspace, ctrl-j down one line, ctrl-k digraph
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <leader>w :echo "USE CTRL-HJKL!"<CR>
" noremap <leader>w <C-w>w
" noremap <leader>W <C-w>W

noremap <leader>q :call TabBufQuit()<cr>
noremap <leader>Q :qa<cr>
noremap <leader>s :w<cr>
noremap <leader>S :call SaveDefinedSession()<CR>
noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>t :tabnew<CR>
noremap <leader>e :Explore<CR>
noremap <leader>v :vsplit<CR><leader>w
noremap <leader>h :split<CR><leader>w
"poormans zoom, opens buffer in current window in new tab
noremap <leader>z :tabnew %<CR>
noremap <leader>m :tabm<Space>
" turn off highlighting till next search
noremap <leader>j :noh<cr>

"fzf and nerdtree maps
noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>N :NERDTreeFind<CR>
noremap <leader>o :Files<CR>
noremap <leader>O :Files!<CR>
noremap <leader>l :Lines<CR>
noremap <leader>L :Lines!<CR>
noremap <leader>b :Buffers<CR>
noremap <leader>B :Buffers!<CR>
noremap <leader>r :Rg<CR>
noremap <leader>R :Rg!<CR>
noremap <leader>i :FZFMru<CR>

noremap <leader>gd :tab Gvdiffsplit<cr>
noremap <leader>gD :tab Gvdiffsplit master<cr>
noremap <leader>gf :call ToggleFoldMethod()<cr>:set foldmethod?<cr>
noremap <leader>ga :call RemoveTrailingWhiteSpace()<CR>
noremap <leader>gt :call ToggleDisplayTrailSpaces('t')<cr>
noremap <leader>gI :IndentLinesToggle<cr>
noremap <leader>go :call CycleColorCol()<cr>
noremap <leader>gS :call ToggleSignifyAll()<cr>
noremap <leader>gs :SignifyToggle<cr>
noremap <leader>gh :SignifyToggleHighlight<cr>
noremap <leader>gg :w<CR>:SilentRedraw git add . && git commit -m 'added stuff'<CR>
noremap <leader>gu :setlocal spell! spelllang=en_us<cr>
noremap <leader>gc :set ignorecase!<cr>:set ignorecase?<cr>
noremap <leader>gx :set number!<CR>

"cheatsheet maps
exe ":function! ShowMyLeaderMap() \n :map <leader> \n endfunction"
noremap <leader>cc :call ShowMyLeaderMap()<cr>
noremap <leader>cd :Files ~/rams_dot_files/cheatsheets/<cr>
noremap <leader>ca :vsplit ~/tmp/scratch.txt<cr>
noremap <leader>cs :vsplit ~/rams_dot_files/cheatsheets/shell_cheatsheet.sh<cr>
noremap <leader>cf :vsplit ~/rams_dot_files/cheatsheets/current.txt<cr>
noremap <leader>cl :vsplit ~/rams_dot_files/cheatsheets/linux_cheatsheet.txt<cr>
noremap <leader>cr :vsplit ~/rams_dot_files/cheatsheets/regex_cheatsheet.txt<cr>
noremap <leader>cv :vsplit ~/rams_dot_files/cheatsheets/vim_cheatsheet.txt<cr>

" TODO: i think these maps are seriously useful
" nnoremap <C-J> a<CR><Esc>k$
" nnoremap <CR> o<Esc>

" This next line will open a ctag in a new tab
noremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

"Quickly switch between up to 9 vimtabs
for i in range(0,9) | exe 'noremap g'.i.' :tabn '.i.'<CR>' | endfor
"TODO: maybe try this:  noremap <Leader><Leader>a :tabn 2<CR>

" ignore compiled scala/java files, added so CtrlP will ignore these files
set wildignore+=*/target/*

" let netrw file explorer use nerdtree-like expansion on dirs
let g:netrw_liststyle = 3
" let g:netrw_winsize = 25

" dont save netrw hist file
" au VimLeave * if filereadable("~/.vim/.netrwhist") | call delete("~/vim/.netrwhist") | endif

" for jsonc format, which supports commenting, this will highlight comments
autocmd FileType json syntax match Comment +\/\/.\+$+

"vim73 thinks *.md is modula2, markdown files also have this extension
if v:version <= 703   " 7.3 is 703 not 730, vim versioning is wierd
    autocmd BufNewFile,BufRead *.md set filetype=markdown
endif

"vim 8.2 thinks .sc is markdown...
autocmd BufNewFile,BufRead *.sc set filetype=scala

"""""""""""""""""Airline"""""""""""""""""""""""""""""""""""
"let g:airline_theme='luna'
let g:airline_theme='bubblegum'
"let g:airline_solarized_bg='dark'
"let g:airline_powerline_fonts = 1 " TODO: this needs instal https://github.com/powerline/fonts

let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'    " 'unique_tail_improved' to show shorted path
let g:airline#extensions#tabline#tab_nr_type = 1


"""""""""""""""""" FZF """"""""""""""""""
" Files will use FZF_DEFAULT_COMMAND
" Commits needs vim-fugitive

" for FZF-Mru plugin, prevent fzf from sorting, show by recency
let g:fzf_mru_no_sort = 1

"""""""""""""""""""CTRLP Fuzzyfinder"""""""""""""""""""""""
let g:ctrlp_max_files = 20000
let g:ctrlp_max_height = 20
let g:ctrlp_dotfiles = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
  \ 'file': '\.exe$\|\.so$\|\.dll$',
  \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
  \ }

""""" RipGrep and FD """""""""""""""""""
if executable('rg')
    set grepprg=rg\ --color=never
    let g:ctrlp_use_caching = 0
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
endif

" if fd installed prefer that over rg
if executable('fd')
    let g:ctrlp_user_command = 'fd --hidden --exclude .git'
endif

""""""""""""""" VIM-INDENT-GUIDES PLUGIN"""""""""""""""""""""""""""""""""""""""""
" let g:indent_guides_guide_size = 1   " guide line is only one col wide
" let g:indent_guides_start_level = 2  " start guide lines at 2nd level indent

" " feb 2020: plugin uses black(000) for IndentGuidesOdd background=dark, ir_black uses 000 so... need custom
" let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=234
" autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=236
" " autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=017

" load a local vimrc file if it exists
call SourceIfExists('~/.vimrc.local')
