" my nvim vimrc, rewritten

" deferring configuration until runtimepath has been set {{{
let s:deferred = []
function! s:defer(command)
    call add(s:deferred, a:command)
endfunction
function! s:run_deferred()
    for command in s:deferred
        execute command
    endfor
endfunction
command! -nargs=1 Defer call <sid>defer(<q-args>)
" }}}

call plug#begin()

" USER INTERFACE {{{
" solarized
Plug 'altercation/vim-colors-solarized'
let g:solarized_hitrail = 1
let g:solarized_termtrans = 1
let g:neosolarized_italic = 1
Defer colorscheme solarized
set background=dark

" lightline
Plug 'itchyny/lightline.vim'
set showtabline=2
let g:lightline = {}
let g:lightline.component = {}
let g:lightline.component_visible_condition = {}
let g:lightline.component_function = {}
let g:lightline.tabline = {}

let g:lightline.colorscheme = 'solarized'
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }

let g:lightline.tabline.left = [['mru']]
let g:lightline.tabline.right = [['tabs']]

function! LightlineMRU()
    return 'yo'
endfunction
let g:lightline.component_function.mru = 'LightlineMRU'

function! LightlineReadonly()
    return &modifiable ? '' : ''
endfunction
let g:lightline.component_function.readonly = 'LightlineReadonly'

" search
set nohlsearch
set incsearch
set inccommand=nosplit
set ignorecase
set smartcase
nnoremap <silent> <esc> :nohlsearch<cr>

" misc
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set number
set relativenumber
set noshowmode " don't clutter up the bottom with -- INSERT --
set showcmd
set lazyredraw
set mouse=nvc
set scrolloff=10
set nostartofline
set hidden

Plug 'yuttie/comfortable-motion.vim'

" }}}
" MAPPINGS {{{
let mapleader = "\<space>"

"" insert
" jk is escape
inoremap jk <esc>
inoremap jk <esc>
" line autocomplete
inoremap <c-l> <c-x><c-l>

"" normal
" easier beginning/ending
noremap H ^
noremap L $

" buffers
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

" operator-pending
onoremap J j
onoremap K k

" yes i am going to do this
noremap , :
noremap : ,

set gdefault
nnoremap <silent> & :&&<cr>
xnoremap <silent> & :&&<cr>

xnoremap <silent> . :normal .<cr>

" terminal
tnoremap jk <c-\><c-n>
nnoremap <expr> gv "`[".getregtype()[0]."`]"
" }}} 
" ESSENTIAL FEATURES {{{

set exrc

" nothing works if you don't have python
Plug 'roxma/python-support.nvim'
let g:python_support_python3_requirements = get(g:, 'python_support_python3_requirements', [])
command! -nargs=* PyRequire
            \ call extend(g:python_support_python3_requirements, [<f-args>])

" ctrl-p: fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_prompt_mappings = {'PrtClearCache()': ['<tab>']}
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_match_window = 'max:20'
let g:ctrlp_user_command = 'ag --follow --nocolor --nogroup -g "" %s'
let g:ctrlp_mruf_relative = 1
let g:ctrlp_mruf_case_sensitive = 0

" async autocomplete
Plug 'roxma/nvim-completion-manager'
let g:cm_refresh_default_min_word_len = [[1,1]]
PyRequire setproctitle psutil
set completeopt=menuone,noinsert,noselect
set shortmess+=c
" press tab for the next match
inoremap <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
inoremap <expr> <c-y> pumvisible() ? "\<c-e><c-y>" : "\<c-y>"
inoremap <expr> <c-e> pumvisible() ? "\<c-e><c-e>" : "\<c-e>"
inoremap <expr> <cr> pumvisible() ? "\<c-y><cr>" : "\<cr>"
imap <c-space> <plug>(cm_force_refresh)

PyRequire jedi
Plug 'roxma/clang_complete'
let g:clang_library_path = '/Applications/Xcode.app/Contents/Frameworks/libclang.dylib'

" snippets
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger = "\<nop>"
let g:UltiSnipsListSnippets = "\<nop>"
let g:UltiSnipsJumpForwardTrigger = "\<nop>"
let g:UltiSnipsJumpBackwardTrigger = "\<nop>"

" Tags
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_define_advanced_commands = 1
let g:gutentags_file_list_command = "ag --follow --nocolor --nogroup -g ''"
" }}} 
" LESS ESSENTIAL FEATURES {{{

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'rking/ag.vim'
Plug 'sjl/gundo.vim'
nnoremap <silent> <leader>u :GundoToggle<cr>

Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function'

Plug 'danro/rename.vim'
Plug 'Olical/vim-enmasse'
Plug 'chaoren/vim-wordmotion'
let g:wordmotion_mappings = {
            \ 'w' : '<a-w>',
            \ 'b' : '<a-b>',
            \ 'e' : '<a-e>',
            \ 'ge' : 'g<a-e>',
            \ 'aw' : 'a<a-w>',
            \ 'iw' : 'i<a-w>'
            \ }
Plug 'tommcdo/vim-exchange'

Plug 'machakann/vim-swap'
nnoremap <silent> <leader>h :SidewaysLeft<cr>
nnoremap <silent> <leader>l :SidewaysRight<cr>

Plug 'neomake/neomake'
let g:neomake_python_enabled_makers = ['python'] ", 'pylint']
Defer autocmd BufRead,BufWritePost,CursorHoldI * Neomake

" italics
Defer let &t_ZH="\e[3m"
Defer let &t_ZR="\e[23m"
Defer highlight Comment cterm=italic
Defer syntax match ErrorMsg "\v\S\zs\s+$"

" netrw
Plug 'tpope/vim-vinegar'
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_browse_split = 4

" floobits
Plug 'floobits/floobits-neovim'
" }}}
" EXPERIMENTAL FEATURES {{{


" best. idea. ever.
Plug 'timeyyy/orchestra.nvim'
Plug 'timeyyy/clackclack.symphony'
Defer call orchestra#prelude()
" Defer call orchestra#set_tune('clackclack')

" gitgutter
Plug 'airblade/vim-gitgutter'

" todo
Plug 'machakann/vim-highlightedyank'
Plug 'christianrondeau/vimcastle'

set undofile
" }}}
" MY FEATURES {{{

" quick vimrc editing
nnoremap <silent> <leader>v :e $MYVIMRC<cr>

set updatetime=100
augroup myautocommands
    autocmd!
    " auto vimrc reloading
    " autocmd BufWritePost,FileWritePost $MYVIMRC nested source $MYVIMRC
    " autosaving
    autocmd CursorHold,InsertLeave * nested silent! update
    " jump to the last cursor position when reading a file
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
augroup END
set autowriteall
" }}}
" LANGUAGES {{{

Plug 'dag/vim-fish', {'for': 'fish'}
Plug 'raimon49/requirements.txt.vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'mndrix/prolog.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'chrisbra/csv.vim'
Plug 'igankevich/mesonic'

augroup langs
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType python iabbrev <buffer> bpoint from celery.contrib import rdb;rdb.set_trace()
augroup END

set cinoptions=l1

" Spaces. Four of them.
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" }}}
" WHY I USED TO HATE VIM {{{
" Backups can be nice but are mostly useless because of autosave
set backupdir=~/.vim-tmp
" Swapfiles are 100% useless for recovery because autosave, so put them on a
" ram disk
set directory=/tmp/vim
" }}}

" fin {{{
call plug#end()
filetype plugin indent on
syntax on
call s:run_deferred()
set secure " exrc should do nothing risky
" }}}
