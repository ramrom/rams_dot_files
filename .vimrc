"""""""""""""  Sreeram's .vimrc """"""""""""""""""""""""""""""""

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

    Plug 'tpope/vim-fugitive'       " git-vim synergy
    Plug 'tpope/vim-surround'       " add/change/remove surrounding formatting to text-objects
    Plug 'tpope/vim-repeat'         " `.` operator on crack, works with vim-surround
    Plug 'tpope/vim-commentary'     " smart code commenting
    Plug 'ruanyl/vim-gh-line'       " generate github url links from current file
    Plug 'preservim/nerdtree'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " NOTE/FIXME: vim 7.4 doesnt like this syntax
    Plug 'junegunn/fzf.vim'
    Plug 'pbogut/fzf-mru.vim'

    if has('nvim-0.5.0')
        Plug 'nvim-lualine/lualine.nvim'
    else
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
    endif

    Plug 'joshdick/onedark.vim'     " inspired from atom's onedark color theme

    Plug 'chrisbra/unicode.vim'     " unicode helper

    if !has('nvim') && v:version < 8022345          " neovim and vim > 8.2.2345 have native support
        Plug 'tmux-plugins/vim-tmux-focus-events'  " used to get autoread to work below
    endif

    " gitsigns is lua, far more supported
    if has('nvim-0.8')
        Plug 'lewis6991/gitsigns.nvim'
    "signify - sign col shows revision ctrl changed lines, internet says faster/better than gitgutter
    elseif has('patch-8.0.902') || has('nvim')
        Plug 'mhinz/vim-signify'
    else  " vim < 8 needs legacy branch
        Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif

    Plug 'godlygeek/tabular'        " preservim/vim-markdown uses this to format tables
    Plug 'preservim/vim-markdown'

    " real-time render markdown in browser window as you edit the source
    if has('nvim') || has('patch-8.1.0')
        Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
        let g:markdown_preview_plugin_activated = 1
    else " this plugin is almost as good, it doesnt do puml/flowchart/katex/dot/chart/js-sequence-diagram
        Plug 'instant-markdown/vim-instant-markdown', { 'for': 'markdown', 'do': 'yarn install' }
        let g:instant_markdown_autostart = 0
    endif

    " reads ctags file and displays summary (vars/funcs etc) in side window
    Plug 'preservim/tagbar'

    "neovim offers better metals and LSP experience in general
    if has('nvim-0.6.1')
        Plug 'kevinhwang91/nvim-bqf', { 'ft': 'qf' }  "neovim's prefix window will show another preview window

        Plug 'j-hui/fidget.nvim'  " nvim-lsp progress support

        Plug 'hrsh7th/nvim-cmp'         " autocomplete for LSPs
        Plug 'hrsh7th/cmp-nvim-lsp'     " LSP source for nvim-cmp
        Plug 'hrsh7th/cmp-buffer'       " buffer word completion
        Plug 'hrsh7th/cmp-path'         " filesystem path completion
        " Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp
        " Plug 'L3MON4D3/LuaSnip'         " Snippets plugin

        if has('nvim-0.7.0')
            " see https://www.reddit.com/r/neovim/comments/107aoqo/problems_running_neovim_using_the_initlua_from/
            " 0.7.2 breaks with treesitter commit 622baacdc1b22cdfd73bc98c07bb5654a090bcac
            if has('nvim-0.8.0')
                Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
            else  " per the reddit thread, this old version of treesitter works
                Plug 'nvim-treesitter/nvim-treesitter', { 'commit': 'a2d7e78', 'do': ':TSUpdate' }
            endif

            "nvim-metals uses built in lsp-client, needs neovim 0.7.0, plenary.vim, coursier
            Plug 'scalameta/nvim-metals', { 'for': ['scala', 'sbt'] }

            "alternative to nerdtree
            " Plug 'nvim-tree/nvim-tree.lua'
        endif

        Plug 'nvim-lua/plenary.nvim'  "core lua libraries needed by other neovim plugins
        Plug 'mfussenegger/nvim-dap'  "DebugAdapterProtocol, requires neovim 0.6.0
        Plug 'leoluz/nvim-dap-go'     "needs delve>1.7.0, nvim-dap
        Plug 'neovim/nvim-lspconfig'  "requires neovim 0.6.1

    " jan2021, coc warns it should have 0.4.0 at least to work well
    " may2022: restrict to osx, b/c new coc needs new nodejs which isn't in standard ubunutu 22 LTS
    elseif has('nvim-0.4.0') && has('macunix')

        Plug 'neoclide/coc.nvim', { 'branch': 'release' }

        "TODO: can enable coc by filetype
        " Plug 'neoclide/coc.nvim', {'tag': '*', 'do': 'yarn install', 'for': ['json', 'lua', 'vim', ]}

        if !empty($VIM_BASH)
            Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
        endif
        if !empty($VIM_METALS)
            Plug 'scalameta/coc-metals', { 'do': 'yarn install --frozen-lockfile' }
        endif
    endif

    " plugins for indentation line guides
    if has('nvim')
        Plug 'lukas-reineke/indent-blankline.nvim'
    else
        " Plug 'nathanaelkane/vim-indent-guides'  " alternates odd/even line colors, indentLine doesnt

        "NOTE:  osx brew vim 8.2 (with conceal) very slow to load, neovim much faster
        "TODO: indentLine displays `"` chars `|` or disspapear in json files...
        if has('conceal')  " requires conceal, jan2023: osx stock vim doesnt have it installed...
            Plug 'Yggdroot/indentLine'    " visual guides to indentations for readability
        endif
    endif

    " vim inside any web browser text box!
    if has('nvim-0.6.0')
        Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    endif

    if !empty($VIM_DEVICONS)
        " prereq: osx brew cask install https://github.com/ryanoasis/nerd-fonts#patched-fonts
        Plug 'ryanoasis/vim-devicons'

        " colored icons, needs devicons
        Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
        let g:NERDTreeLimitedSyntax = 1   " helps a little with lag issues
    endif

    "NOTE: plug#end automatically runs filetype plugin indent on and syntax enable
    call plug#end()
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" syntax on                  "syntax highlighting
set t_Co=256

" Load matchit.vim, but only if the user hasn't installed a newer version.
    " may2023 - vim needs this, neovim seems to work without it
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif


try  " if loading vim without plugins, onedark will fail, default to ir_black
    augroup colorextend
        autocmd!
        autocmd ColorScheme onedark call onedark#extend_highlight("Normal", { "bg": { "cterm": "000" } })
        " autocmd ColorScheme onedark call onedark#extend_highlight("NonText", { "bg": { "cterm": "000" } })
        autocmd ColorScheme onedark call onedark#set_highlight("htmlH2", { "cterm": "underline" })
        autocmd ColorScheme onedark call onedark#set_highlight("htmlH1", { "cterm": "underline" })
        autocmd ColorScheme onedark call onedark#extend_highlight("htmlH2", { "fg": { "cterm": "196" } })
        autocmd ColorScheme onedark call onedark#extend_highlight("htmlH1", { "fg": { "cterm": "196" } })
        " autocmd ColorScheme onedark call onedark#extend_highlight("markdownHeadingDelimiter", { "fg": { "cterm": "111" } })
    augroup END
    let g:onedark_termcolors=256
    "TODO: italics works in neovim, brew vim8.2, osx default vim9 doesnt
    if has('nvim')
        let g:onedark_terminal_italics=1
    endif
    colorscheme onedark
    hi clear Search                 " clear it, as I use a custom search highlight
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme ram_ir_black    "modified ir_black with red/green vimdiff colors
endtry

set nobackup                    " no backup files
set nowritebackup               " only in case you don't want a backup file while editing
set noswapfile                  " no swap files

" turn off all mouse support by default
set mouse=

set autoread                    " reload file's buffer if file was changed externally
set splitbelow splitright       " open new windows on bottom for horizontal, right for vertical
set wildmenu                    " display command line's tab complete options as menu
set wildmode=longest,list,full  " complete longest common, list all matches, complete till next full match
set wrap                        " wrap lines longer than width to next line
set linebreak                   " avoid wrapping line in middle of a word
set scrolloff=1                 " always show at least one line above or below the cursor
set showcmd                     " show commands i'm process of typing in status bar
set number                      " line numbers
set backspace=indent,eol,start  " backspace like most wordprocessors in insert mode
set display+=lastline           " display lastline even if its super long
" set tw=0                        " set textwidth to unlimited (e.g. vim uses tw=78 for .vim filetype and it's annoying)
" set cursorline                  " highlight line and column cursor is on

set formatoptions+=j            " Delete comment character when joining commented lines

" disable autocommenting on o and O in normal
autocmd FileType * setlocal formatoptions-=o

" for jsonc format, which supports commenting, this will highlight comments
autocmd FileType json syntax match Comment +\/\/.\+$+

"vim73 thinks *.md is modula2, markdown files also have this extension
if v:version <= 703   " 7.3 is 703 not 730, vim versioning is wierd
    autocmd BufNewFile,BufRead *.md set filetype=markdown
endif

"vim 8.2 thinks .sc is markdown...
autocmd BufNewFile,BufRead *.sc set filetype=scala

" any file name starting with Jenkinsfile should be groovy
autocmd BufNewFile,BufRead Jenkinsfile* set filetype=groovy


"""""""""""""SEARCHING """"""""""""""""""
set hlsearch                    " highlight search
"TODO: italics works in neovim, brew vim8.2, osx default vim9 doesnt
if has('nvim')
    hi Search cterm=italic,underline,inverse
else
    hi Search cterm=underline,inverse
endif
set incsearch               " searching as you type (before hitting enter)
set ignorecase              " case-insensitive searches
set smartcase               " with ignorecase, search with all lowercase means INsensitive, any uppercase means sensitive


"TODO: fix, i - included files, kspell dictionary
" set complete-=i | set complete+=kspell

""""""""""""" FOLDING """"""""""""""""""""""""""""""
set foldmethod=indent
set nofoldenable            " dont fold everything when opening buffers

"""""""""""" INDENT/TABS """""""""""""""""""""""
set autoindent              " indent on new line for inner scopes in code
set shiftwidth=4            " use 4 spaces for autoindent (cindent)
set tabstop=4               " space 4 columns when reading a <tab> char in file
set softtabstop=4           " complicated, see docs
set expandtab               " use spaces when tab is pressed

"""""""""""" DEFAULT STATUS LINE """""""""""""""""""
" set cmdheight=2             " 2 lines for command
set ls=2                    " line status, two lines for status and command
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [POS=%04l,%04v][%p%%]\

"""""SHOW TABS AND TRAILING SPACES WITH SPECIAL CARS
set list
set listchars=tab:»_,trail:·
if has('nvim')  " highlight dimgrey, vim and neovim use diff group name
    highlight WhiteSpace ctermfg=8 guifg=DimGrey
else
    highlight SpecialKey ctermfg=8 guifg=DimGrey
endif

" ignore metals LSP files, bloop compiler files
set wildignore+=*/.metals/*,*/.bloop/*,*/.bsp/*


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""" CUSTOM FUNCTION """"""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -nargs=1 SilentRedraw execute ':silent !'.<q-args> | execute ':redraw!'

function! SourceIfExists(file)
  if filereadable(expand(a:file)) | exe 'source' a:file | echo 'source found and loaded' | endif
endfunction

function ToggleFoldMethod()
    "1 ? echo 'indent' : echo 'not indent'  "TODO: wtf vim, basic ternary errors
    if &foldmethod == "indent"
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
    else
        set foldmethod=indent
        set foldexpr=
    endif
endfunction

" if terminal size changes (e.g. resizing tmux pane vim lives in) automatically resize the vim windows
autocmd VimResized * wincmd =

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

"NOTE!: SignifyDisableAll still requires you to toggle/disable individual buffers (call ToggleGitSignsAll)
let g:gitsign_plugin_disable_by_default = 0
function ToggleGitSignsAll()
    if has('nvim')
        exe ':Gitsigns toggle_signs'
    else " assume vim and vim-signify
        if g:gitsign_plugin_disable_by_default == 1
            exe ':SignifyEnableAll' | echo 'Signify ENABLE all'
        else
            exe ':SignifyDisableAll' | echo 'Signify DISABLE all'
        endif
    endif
endfunction

function ToggleGitSignsHighlight()
    if has('nvim-0.8')
        exe ':Gitsigns toggle_linehl'
        exe ':Gitsigns toggle_word_diff'
    else " assume vim and vim-signify
        exe ':SignifyToggleHighlight'
    endif
endfunction

function MyIndentLinesToggle()
    if has('nvim')
        exe ':IndentBlanklineToggle'
    else
        exe ':IndentLinesToggle'
    endif
endfunction

let g:instant_markdown_state = 0
function ToggleInstantMarkdown()
    if g:markdown_preview_plugin_activated == 1
        exe ':MarkdownPreviewToggle'
    else
        if g:instant_markdown_state == 0
            let g:instant_markdown_state = 1 | exe ':InstantMarkdownPreview' | echo 'instant markdown ON'
        else
            let g:instant_markdown_state = 0 | exe ':InstantMarkdownStop' | echo 'instant markdown OFF'
        endif
    endif
endfunction

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
    if exists('*gettabinfo')  " vim 7.4(and earlier) dont have `gettabinfo`
        if len(gettabinfo()) == 1
            if (a:direction == "f") | execute ":bn!" | else |  execute ":bp!" | endif
        else
            if (a:direction == "f") | execute ":tabn" | else |  execute ":tabprevious" | endif
        endif
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

function ClearLspLog()
    "TODO: this hardcoded path is for OSX, on ubuntu it's diff path, find programatic way to find location
    " also metals on osx is diff path
    exe ':SilentRedraw cat /dev/null > ~/.local/state/nvim/lsp.log'
    exe ':SilentRedraw cat /dev/null > .metals/metals.log'
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""" KEY MAPPINGS """"""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""TODO: Prime open real estate for normal mode!
    "NORMAL MODE
        "<Leader>a/w/k/l/x'
            "a is earmarked for smart script run or test run
        "<Leader><Leader>    (except for h/g/q)
        "c-m/c-n/c-g/c-s/c-q
        "c-x (opposite of c-a, i clobber c-a for tmux meta)
        "c-p
        "c-space
        "; " semicolon repeats last f/F motions
        "," ; in reverse direction
    " INSERT MODE
        " c-s, c-space

" TODO: i think these maps are probably useful
" nnoremap <C-J> a<CR><Esc>k$
" nnoremap <CR> o<Esc>

let mapleader = " "

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
endif

" ESCAPE replacement
" NOTE: default C-l behaviour: with `insertmode` enabled, it goes to normal mode from insert
inoremap <C-l>  <Esc>

" TODO: should i keep?, leader-s saves from normal is nuff i thinks. (c-k default map is enter digraph)
inoremap <C-k>  <C-o>:w<cr>

noremap <leader>f :call TabBufNav("f")<CR>
noremap <leader>d :call TabBufNav("b")<CR>

"gb easier to type than gT
noremap gb :tabprevious<CR>

" default mappings: ctrl-l refreshes screen, ctrl-h backspace, ctrl-j down one line, ctrl-k digraph
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
" noremap <leader>w :echo "USE CTRL-HJKL!"<CR>
" noremap <leader>w <C-w>w
" noremap <leader>W <C-w>W

noremap <leader>q :call TabBufQuit()<cr>
noremap <leader>Q :q!<cr>
noremap <leader><leader>q :qa<cr>
noremap <leader>s :w<cr>
noremap <leader>S :call SaveDefinedSession()<CR>
noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>t :tabnew<CR>
noremap <leader>e :Explore<CR>
noremap <leader>v :vsplit<CR><leader>w
noremap <leader>h :split<CR><leader>w
noremap <leader>m :tabm<Space>

"repeat the last command
noremap <leader><leader>r :@:<CR>

" turn off highlighting till next search
noremap <leader>j :noh<cr>
"poormans zoom, opens buffer in current window in new tab
noremap <leader>z :tabnew %<CR>

"fzf and nerdtree maps
noremap <leader><leader>h :Helptags!<cr>
noremap <leader>; :Commands<cr>
noremap <leader>r :History:<cr>
noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>N :NERDTreeFind<CR>
noremap <leader>o :Files<CR>
noremap <leader>O :Files!<CR>
noremap <leader>b :Buffers<CR>
noremap <leader>B :Buffers!<CR>
noremap <leader>k :Rg<CR>
noremap <leader>K :Rg!<CR>
noremap <leader>i :FZFMru<CR>

noremap <leader>ll :Lines<CR>
noremap <leader>L :Lines<CR>

"Git-type stuff
noremap <leader><leader>g :G<CR>
noremap <leader>gd :tab Gvdiffsplit<cr>
noremap <leader>gD :tab Gvdiffsplit master<cr>
noremap <leader>g<c-d> :tab Gvdiffsplit HEAD^<cr>
noremap <leader>gb :BCommits<CR>
noremap <leader>gB :BCommits!<CR>
noremap <leader>gc :Commits<CR>
noremap <leader>gC :Commits!<CR>
noremap <leader>gS :call ToggleGitSignsAll()<cr>
noremap <leader>gs :SignifyToggle<cr>
noremap <leader>gh :call ToggleGitSignsHighlight()<cr>

noremap <leader>gf :call ToggleFoldMethod()<cr>:set foldmethod?<cr>
noremap <leader>gT :call RemoveTrailingWhiteSpace()<CR>
noremap <leader>gt :call ToggleDisplayTrailSpaces('t')<cr>
noremap <leader>gi :call MyIndentLinesToggle()<cr>
noremap <leader>go :call CycleColorCol()<cr>
noremap <leader>gm :call ToggleInstantMarkdown()<cr>
noremap <leader>gu :setlocal spell! spelllang=en_us<cr>
noremap <leader>gz :set ignorecase!<cr>:set ignorecase?<cr>
noremap <leader>gn :set number!<CR>
noremap <leader>gl :set list!<cr>
autocmd FileType markdown noremap <leader>gg :w<CR>:SilentRedraw git add . && git commit -m 'added stuff'<CR>

"cheatsheet maps
exe ":function! ShowMyLeaderMap() \n :map <leader> \n endfunction"
noremap <leader>cC :call ShowMyLeaderMap()<cr>
noremap <leader>cc :Maps!<cr> 'space 
noremap <leader>cm :Maps<cr>
noremap <leader>cg :map g<cr>
noremap <leader><leader>c :Files ~/rams_dot_files/cheatsheets/<cr>
noremap <leader>cl :exe ':Files' $MY_NOTES_DIR<cr>
noremap <leader>cr :exe ':Files' $MY_WORK_DIR<cr>
noremap <leader>cA :vsplit ~/tmp/scratch.md<cr>
noremap <leader>ca :tabnew ~/tmp/scratch.md<cr>
noremap <leader>co :Files ~<cr>
noremap <leader>cs :vsplit ~/rams_dot_files/cheatsheets/shell_cheatsheet.sh<cr>
noremap <leader>cf :vsplit ~/rams_dot_files/cheatsheets/current.md<cr>
noremap <leader>cv :vsplit ~/rams_dot_files/cheatsheets/vim_cheatsheet.md<cr>
noremap <leader>cV :tabnew ~/rams_dot_files/cheatsheets/vim_cheatsheet.md<cr>

" This next line will open a ctag in a new tab
noremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

"Quickly switch between up to 9 vimtabs
for i in range(0,9) | exe 'noremap g'.i.' :tabn '.i.'<CR>' | endfor
"TODO: maybe try this:  noremap <Leader><Leader>a :tabn 2<CR>

" TODO: get strikethrough for neovim in markdown/html
    " default html.vim files use underline unless: `if v:version > 800 || v:version == 800 && has("patch1038")`
    " 0.4.4_2 return 800 for `v:version`, false for the patch
" highlight htmlStrike term=strikethrough cterm=strikethrough gui=strikethrough

"""""""""""" NETRW """""""""""""""""""""
" let netrw file explorer use nerdtree-like expansion on dirs
let g:netrw_liststyle = 3
" let g:netrw_winsize = 25

" dont save netrw hist file
" au VimLeave * if filereadable("~/.vim/.netrwhist") | call delete("~/vim/.netrwhist") | endif

"""""""""""""""""" NERDTree""""""""""""""""""""""""""""""""
" TODO: dont want to open existing tab/window with buffer: https://github.com/preservim/nerdtree/issues/170
" let NERDTreeCustomOpenArgs = {'file': {'reuse': 'currenttab', 'where': 'p'}, 'dir': {}}
" let NERDTreeMapCustomOpen = 'o'

"""""""""""""""""" GH-line (github line)""""""""""""""""""""""""""""""""
let g:gh_line_map_default = 0
let g:gh_line_blame_map_default = 1
let g:gh_line_map = '<leader>wh'
let g:gh_line_blame_map = '<leader>wb'
let g:gh_repo_map = '<leader>wo'
let g:gh_open_command = 'fn() { echo "$@" | pbcopy; }; fn '

""""""""""""""""""""vim-instant-markdown""""""""""""""""""""""""""""
let g:markdown_preview_plugin_activated = 1
let g:instant_markdown_mermaid = 1
let g:instant_markdown_logfile = '/tmp/instant_markdown.log'

"""""""""""""""""""vim-markdown"""""""""""""""""""""""""""
" plasticboy-md: `ge` command will follow anchors in links (of the form file#anchor or #anchor)
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_edit_url_in = 'tab'
let g:vim_markdown_anchorexpr = "substitute(v:anchor,'-',' ','g')"  " customize the way to parse an anchor link


"""""""""""""""""Airline"""""""""""""""""""""""""""""""""""
let g:airline_theme='bubblegum'
"let g:airline_solarized_bg='dark'
"let g:airline_powerline_fonts = 1 " TODO: this needs instal https://github.com/powerline/fonts

let g:airline#extensions#tabline#enabled = 1           " enable airline tabline
let g:airline#extensions#tabline#show_close_button = 0 " remove 'X' at the end of the tabline
let g:airline#extensions#tabline#tab_min_count = 2     " minimum of 2 tabs needed to display the tabline
let g:airline#extensions#tabline#show_splits = 0       " disables the buffer name that displays on the right of the tabline
let g:airline#extensions#tabline#formatter = 'unique_tail'    " 'unique_tail_improved' to show shorted path
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'


"""""""""""""""""" FZF """"""""""""""""""
" Files will use FZF_DEFAULT_COMMAND
" Commits needs vim-fugitive

" for FZF-Mru plugin, prevent fzf from sorting, show by recency
let g:fzf_mru_no_sort = 1

" default implementation of Rg greps over filename, this will just do contents
    " see https://github.com/junegunn/fzf.vim/issues/714
command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

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

"""""""""""""" IDENTLINE AND INDENT_BLANKLINE """""""""""""""""""""""""""""""
"globally disable indentLine and indent_blankline by default
let g:indent_blankline_enabled = 0
let g:indentLine_enabled = 0



" load a local vimrc file if it exists
call SourceIfExists('~/.vimrc.local')
