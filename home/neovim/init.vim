set encoding=utf-8
scriptencoding utf-8

let mapleader=','
imap jj <Esc>

if has('nvim')
    tnoremap jj <C-\><C-n>
endif

" Windows / Splits
" ctrl-jklm  changes to that split
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

nmap <silent> <leader>/ :nohlsearch<CR>

" switch buffers quickly
nnoremap <leader><leader> <c-^>
nnoremap <c-g> :bn<CR>

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" improve up/down movement on wrapped lines
nnoremap j gj
nnoremap k gk

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

cmap w!! w !sudo tee % >/dev/null

nmap <leader>l :set list!<CR>
nmap <leader>n :set number!<CR>

nmap <silent> <leader>v :vsplit $MYVIMRC<CR>

" Editor

" Line breaks
set wrap linebreak nolist

" Tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set matchtime=5

set cursorline
set showmatch     " set show matching parenthesis

" Searching
set ignorecase
set smartcase
set hlsearch

set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class,.svn,.git

set title
set visualbell
set noerrorbells

" Backups
set nobackup
set nowritebackup

if has('win32')
    set directory=$TEMP//
else
    silent execute '!mkdir -p ~/.vim/swap'
    set directory=~/.vim/swap//
endif

set splitright
set splitbelow

set pastetoggle=<F2>

set nrformats=

set listchars=tab:▸\ ,eol:¬  " invisibles


" Tab completion
set wildmode=list:longest,list:full
set complete=.,w,t

augroup me
    autocmd!
    autocmd BufWritePost $MYVIMRC source % | redraw
    autocmd BufWritePre /tmp/* setlocal noundofile
augroup end


" persist undos
silent execute '!mkdir -p ~/.vim/undo'
set undofile
set undodir=~/.vim/undo//

""" netrw
map <C-d> :Lexplore<CR>
let g:netrw_liststyle = 3
let g:netrw_winsize = 35
let g:netrw_browse_split = 4
let g:netrw_altv = 1

""" Colors / Display
set background=dark
set cursorline
set fillchars+=vert:│,stl:\ ,stlnc:-
set fillchars=
set termguicolors
set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.
set showmode

let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
colorscheme nord

set laststatus=1

""" Custom Functions
function! Preserve(command)
    let l:save = winsaveview()
    execute a:command
    call winrestview(l:save)
endfunction

command! TrimTrailingWhitespace call Preserve("%s/\\s\\+$//e")
nmap _$ :TrimTrailingWhitespace<CR>

command! FormatFile call Preserve("normal gg=G")
nmap _= :FormatFile<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~# '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>


""" fzf
if ! empty(glob('~/.fzf'))
    set runtimepath+=~/.fzf
    nnoremap <leader>b :Buffers<CR>
    nnoremap <leader>f :<c-u>FZF<CR>
endif

""" grepper
let g:grepper = {}
let g:grepper.tools = ['rg', 'grep', 'git']
let g:grepper.next_tool = '<leader>g'
" Search for the current word
nnoremap <Leader>* :Grepper -cword -noprompt<CR>

" Search for the current selection
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
nnoremap <leader>g :Grepper<cr>


""" ale
" Disable linting for all minified JS files.
let g:ale_pattern_options = {'\.min.js$': {'ale_enabled': 0}}

let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 0
let g:ale_set_quickfix = 0
let g:ale_set_loclist = 0

""" Status Line
function! Status(winnum)
    if a:winnum != winnr()
        return '[%n] %<%.99f'
    end

    let stat = '[%n] '
    let stat .= '%{(&readonly || !&modifiable) ? " " : ""}'
    let stat .= '%<%.99f'
    let stat .= '%{&modified?"[+] ":""}'
    let stat .= "%{&filetype!=#''?' ['. &filetype.']':''}"

    if exists('*FugitiveHead') && !empty(FugitiveHead())
        let stat .= '['. FugitiveHead() .']'
    end

    let stat .= '%='  " Right
    let stat .= '%-15( %l,%c%V%) %P'
    return stat
endfunction

function! s:RefreshStatus()
        for nr in range(1, winnr('$'))
            call setwinvar(nr, '&statusline', '%!Status(' . nr . ')')
        endfor
endfunction

augroup status
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * call <SID>RefreshStatus()
augroup END
