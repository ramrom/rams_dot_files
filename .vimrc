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

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    Plug 'joshdick/onedark.vim'     " inspired from atom's onedark color theme

    Plug 'chrisbra/unicode.vim'     " unicode helper

    if v:version < 8022345          " neovim and vim > 8.2.2345 have native support
        Plug 'tmux-plugins/vim-tmux-focus-events'  " used to get autoread to work below
    endif

    "signify - sign col shows revision ctrl changed lines, internet says faster/better than gitgutter
    if has('patch-8.0.902')
        Plug 'mhinz/vim-signify'
    else  " vim < 8 needs legacy branch
        Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif

    Plug 'godlygeek/tabular'        " preservim/vim-markdown uses this to format tables
    Plug 'preservim/vim-markdown'
    " let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim']

    " real-time render markdown in browser window as you edit the source
    if has('patch-8.1.0')
        Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
        let g:markdown_preview_plugin_activated = 1
    else " this plugin is almost as good, it doesnt do puml/flowchart/katex/dot/chart/js-sequence-diagram
        Plug 'instant-markdown/vim-instant-markdown', { 'for': 'markdown', 'do': 'yarn install' }
        let g:instant_markdown_autostart = 0
    endif

    " reads ctags file and displays summary (vars/funcs etc) in side window
    Plug 'preservim/tagbar'

    " Plug 'nathanaelkane/vim-indent-guides'  " alternates odd/even line colors, indentLine doesnt

    "NOTE:  osx brew vim 8.2 (with conceal) very slow to load, neovim much faster
    "TODO: indentLine displays `"` chars `|` or disspapear in json files...
    if has('conceal')  " requires conceal, jan2023: osx stock vim doesnt have it installed...
        Plug 'Yggdroot/indentLine'    " visual guides to indentations for readability
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
        " autocmd ColorScheme onedark call onedark#extend_highlight("NonText", { "bg": { "cterm": "000" } })
        autocmd ColorScheme onedark call onedark#extend_highlight("Normal", { "bg": { "cterm": "000" } })
        autocmd ColorScheme onedark call onedark#set_highlight("htmlH2", { "cterm": "underline" })
        autocmd ColorScheme onedark call onedark#set_highlight("htmlH1", { "cterm": "underline" })
        autocmd ColorScheme onedark call onedark#extend_highlight("htmlH2", { "fg": { "cterm": "196" } })
        autocmd ColorScheme onedark call onedark#extend_highlight("htmlH1", { "fg": { "cterm": "196" } })
        " autocmd ColorScheme onedark call onedark#extend_highlight("markdownHeadingDelimiter", { "fg": { "cterm": "111" } })
    augroup END
    let g:onedark_termcolors=256
    "TODO: italics works in neovim, brew vim8.2, osx default vim9 doesnt
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
" italics works in neovim, brew vim8.2, osx default vim9 doesnt
hi Search cterm=underline,inverse
set incsearch               " searching as you type (before hitting enter)
set ignorecase              " case-insensitive searches
set smartcase               " with ignorecase, search with all lowercase means INsensitive, any uppercase means sensitive

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
" TODO: add feature to toggle listchar display
set list
set listchars=tab:»_,trail:·
highlight SpecialKey ctermfg=8 guifg=DimGrey

" ignore metals LSP files, bloop compiler files
set wildignore+=*/.metals/*,*/.bloop/*,*/.bsp/*


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""" CUSTOM FUNCTION """"""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -nargs=1 SilentRedraw execute ':silent !'.<q-args> | execute ':redraw!'

function! SourceIfExists(file)
  if filereadable(expand(a:file)) | exe 'source' a:file | echo 'source found and loaded' | endif
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

" delete all trailing white space
" NOTE: to make it automatic: autocmd BufWritePre * %s/\s\+$//e
function RemoveTrailingWhiteSpace()
    execute '%s/\s\+$//e'
endfunction

"NOTE!: SignifyDisableAll still requires you to toggle/disable individual buffers (call ToggleGitSignsAll)
let g:gitsign_plugin_disable_by_default = 0
function ToggleGitSignsAll()
    if g:gitsign_plugin_disable_by_default == 1
        exe ':SignifyEnableAll' | echo 'Signify ENABLE all'
    else
        exe ':SignifyDisableAll' | echo 'Signify DISABLE all'
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""" KEY MAPPINGS """"""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""TODO: Prime open real estate for normal mode!
    "NORMAL MODE
        "<Leader>a/w/l/x'
            "a is earmarked for smart script run or test run
        "<Leader><Leader>    (all except for h/g/q/r)
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

" ESCAPE replacement
" NOTE: default C-l behaviour: with `insertmode` enabled, it goes to normal mode from insert
inoremap <C-l>  <Esc>

" TODO: should i keep?, leader-s saves from normal is nuff i thinks. (c-k default map is enter digraph)
inoremap <C-k>  <C-o>:w<cr>

"repeat the last command
noremap <leader>. :@:<CR>

noremap <leader><leader>e :Explore<CR>

" turn off highlighting till next search
noremap <leader>j :noh<cr>

" command line history editor
noremap <leader><leader>r q:


" TAB MOVE/NAV/CREATE
noremap <leader>f :call TabBufNav("f")<CR>
noremap <leader>d :call TabBufNav("b")<CR>
noremap <leader>t :tabnew<CR>
noremap <leader>m :tabm<Space>
"poormans zoom, opens buffer in current window in new tab
noremap <leader>z :tabnew %<CR>
"gb easier to type than gT
noremap gb :tabprevious<CR>

" WINDOW MOVE/CREATE
" default mappings: ctrl-l refreshes screen, ctrl-h backspace, ctrl-j down one line, ctrl-k digraph
noremap <leader>v :vsplit<CR><leader>w
noremap <leader>h :split<CR><leader>w
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
" noremap <leader>w :echo "USE CTRL-HJKL!"<CR>
" noremap <leader>w <C-w>w
" noremap <leader>W <C-w>W

" SMART SAVE
noremap <leader>s :w<cr>
noremap <leader>S :call SaveDefinedSession()<CR>

" COPY/PASTE CLIPBOARD
noremap <leader>y "+y
noremap <leader>p "+p

" SMART QUIT
noremap <leader><leader>q :qa<cr>
noremap <leader>q :call TabBufQuit()<cr>
noremap <leader>Q :q!<cr>

"FZF
noremap <leader><leader>h :Helptags!<cr>
noremap <leader>; :Commands<cr>
noremap <leader><leader>r :History:<cr>
noremap <leader>i :FZFMru<CR>
noremap <leader>o :Files<CR>
noremap <leader>O :Files!<CR>
noremap <leader><leader>o :Files ~<cr>
noremap <leader>b :Buffers<CR>
noremap <leader>B :Buffers!<CR>
noremap <leader>el :Rg<CR>
noremap <leader>eL :Rg!<CR>
noremap <leader>ei :Lines<CR>
noremap <leader>eo :BLines<CR>

" NERDTree
noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>N :NERDTreeFind<CR>

" GIT-TYPE STUFF
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
noremap <leader>gh :SignifyToggleHighlight<cr>

"CHEATSHEET AND NOTES
exe ":function! ShowMyLeaderMap() \n :map <leader> \n endfunction"
noremap <leader>cC :call ShowMyLeaderMap()<cr>
noremap <leader>cM :Maps!<cr> 'space 
noremap <leader>cm :Maps<cr>
noremap <leader>cg :map g<cr>
noremap <leader><leader>c :Files ~/rams_dot_files/cheatsheets/<cr>
noremap <leader>cn :exe ':Files' $MY_NOTES_DIR<cr>
noremap <leader>cw :exe ':Files' $MY_WORK_DIR<cr>
noremap <leader>ca :tabnew $MY_WORK_TODO<cr>
noremap <leader>cS :vsplit ~/tmp/scratch.md<cr>
noremap <leader>cs :tabnew ~/tmp/scratch.md<cr>

" OTHER
noremap <leader>wT :call RemoveTrailingWhiteSpace()<CR>
noremap <leader>wi :IndentLinesToggle<cr>
noremap <leader>wo :call CycleColorCol()<cr>
noremap <leader>wM :call ToggleInstantMarkdown()<cr>
noremap <leader>wm :messages<cr>
noremap <leader>wu :setlocal spell! spelllang=en_us<cr>
noremap <leader>wz :set ignorecase!<cr>:set ignorecase?<cr>
noremap <leader>ws :set number!<CR>
noremap <leader>wl :set list!<cr>
autocmd FileType markdown noremap <leader>gg :w<CR>:SilentRedraw git add . && git commit -m 'added stuff'<CR>

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
