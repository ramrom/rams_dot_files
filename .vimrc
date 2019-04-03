"Sreeram's VI RC

set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" added nerdtree
Plugin 'scrooloose/nerdtree'
" add CtrlP
Plugin 'ctrlpvim/ctrlp.vim'
set runtimepath^=~/.vim/bundle/ctrlp.vim

call vundle#end()            " required
filetype plugin indent on    " required

syntax on					"syntax highlighting
set t_Co=256
colorscheme ir_black
set number					" line numbers
set ls=2					" line status, two lines for status and command
set hlsearch  					" highlight search
set incsearch					" incremental search
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ 
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [POS=%04l,%04v][%p%%]\ 

set nobackup                                    " no backup files
set nowritebackup                               " only in case you don't want a backup file while editing
set noswapfile                                  " no swap files

set shiftwidth=4                                " use indents of 4 spaces
set tabstop=4                                   " an indentation every four columns
set softtabstop=4                               " let backspace delete indent
set expandtab

set autoindent

"set list
"set listchars=tab:>-,trail:.  			"when spacing/tabbing show temp chars
"set colorcolumn=81

set tabline=%!MyTabLine()  " custom tab pages line\
function MyTabLine()
        let s = '' " complete tabline goes here
        " loop through each tab page
        for t in range(tabpagenr('$'))
                " set highlight\
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLine#'
                endif
                " set the tab page number (for mouse clicks)\
                let s .= '%' . (t + 1) . 'T'
                let s .= ' '
                " set page number string\
                let s .= t + 1 . ' '
                " get buffer names and statuses\
                let n = ''      "temp string for buffer names while we loop and check buftype\
                let m = 0       " &modified counter
                let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '\
                " loop through each buffer in a tab
                for b in tabpagebuflist(t + 1)
                        " buffer types: quickfix gets a [Q], help gets [H]\{base fname\}\
                        " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname\
                        if getbufvar( b, "&buftype" ) == 'help'
                                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
                        elseif getbufvar( b, "&buftype" ) == 'quickfix'
                                let n .= '[Q]'
                        else
                                let n .= pathshorten(bufname(b))
                        endif
                        " check and ++ tab's &modified count\
                        if getbufvar( b, "&modified" )
                                let m += 1
                        endif
                        " no final ' ' added...formatting looks better done later\
                        if bc > 1
                                let n .= ' '
                        endif
                        let bc -= 1
                endfor
                " add modified label [n+] where n pages in tab are modified\
                if m > 0
                        let s .= '[' . m . '+]'
                endif
                " select the highlighting for the buffer names\
                " my default highlighting only underlines the active tab\
                " buffer names.\
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLine#'
                endif
                " add buffer names\
                if n == ''
                        let s.= '[New]'
                else
                        let s .= n
                endif
                " switch to no underlining and add final space to buffer list\
                let s .= ' '
        endfor
        " after the last tab fill with TabLineFill and reset tab page nr\
        let s .= '%#TabLineFill#%T'
        " right-align the label to close the current tab page\
        if tabpagenr('$') > 1
                let s .= '%=%#TabLineFill#%999Xclose'
        endif
        return s
endfunction


"vim73 thinks *.md is modula2, markdown files also have this extension
autocmd BufNewFile,BufRead *.md set filetype=markdown
" robot.vim syntax file obtained from https://github.com/seeamkhan/robotframework-vim
autocmd BufNewFile,BufRead *.robot set filetype=robot

"Mappings
let mapleader = ","				"set metakey for vim shortcuts
inoremap jk  <Esc>
cnoremap jk  <Esc>
inoremap dk  <Esc>
cnoremap dk  <Esc>

map <leader>q :filetype plugin on<CR>:filetype indent on<CR>

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

"CTRLP Fuzzyfinder 
map <leader>f :CtrlP 
let g:ctrlp_max_files = 20000
let g:ctrlp_max_height = 20
let g:ctrlp_dotfiles = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
  \ 'file': '\.exe$\|\.so$\|\.dll$',
  \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
  \ }

let i=0
while i<10
  exe 'map g'.i.' :tabn '.i.'<CR>'
  let i+=1
endwhile
