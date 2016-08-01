" Strongly based on <https://github.com/begriffs/haskell-vim-now>
set nocompatible
set viminfo=
set nobackup
set noswapfile
let g:netrw_dirhistmax=0

set visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Vundle {{{

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/Vundle.vim'

" Support bundles
Bundle 'jgdavey/tslime.vim'
Bundle 'Shougo/vimproc.vim'
Bundle 'ervandew/supertab'
Bundle 'scrooloose/syntastic'
Bundle 'moll/vim-bbye'
Bundle 'vim-scripts/gitignore'

" Git
Bundle 'tpope/vim-fugitive'
Bundle 'int3/vim-extradite'

" Bars, panels, and files
Bundle 'scrooloose/nerdtree'
Bundle 'bling/vim-airline'
Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'

" Allow pane movement to jump out of vim into tmux
Bundle 'christoomey/vim-tmux-navigator'

" Text manipulation
Bundle 'vim-scripts/Align'
Bundle 'vim-scripts/Gundo'
Bundle 'tpope/vim-commentary'
Bundle 'godlygeek/tabular'

" Haskell
" Bundle 'raichoo/haskell-vim'
if executable("ghc-mod")
    Bundle 'eagletmt/ghcmod-vim'
endif
Bundle 'eagletmt/neco-ghc'
Bundle 'Twinside/vim-hoogle'
Bundle 'pbrisbin/vim-syntax-shakespeare'

" Idris
Bundle 'idris-hackers/idris-vim'

" Look
Bundle 'cdaddr/gentooish.vim'
try
  colorscheme gentooish
catch
endtry

" Text
Bundle 'dhruvasagar/vim-table-mode'
let g:table_mode_corner_corner="+"
let g:table_mode_header_fillchar="="

" Adjust signscolumn and syntastic to match wombat
hi! link SignColumn LineNr
hi! link SyntasticErrorSign ErrorMsg
hi! link SyntasticWarningSign WarningMsg

" Use pleasant but very visible search hilighting
hi Search ctermfg=white ctermbg=173 cterm=none guifg=#ffffff guibg=#e5786d gui=none
hi! link Visual Search

" Match wombat colors in nerd tree
hi Directory guifg=#8ac6f2

" Searing red very visible cursor
hi Cursor guibg=red

" Use same color behind concealed unicode characters
hi clear Conceal

" }}}

syntax on
filetype plugin indent on
set hidden
set lazyredraw
set ruler
set incsearch ignorecase smartcase hlsearch
set wrap linebreak textwidth=79 colorcolumn=80
set foldmethod=marker foldlevel=20
set list listchars=tab:-\ ,trail:~,extends:>,precedes:<,nbsp:+
set cmdheight=1
set background=dark
set so=4
set backspace=eol,start,indent ww=b,s,[,]
set wildmenu wildmode=list:longest,full
set magic
set showmatch mat=2
set laststatus=2
set wildignore+=.git\*,.hg\*,.svn\*
highlight ColorColumn guibg=#442222 ctermbg=10

let mapleader = ","
let g:mapleader = ","
set tm=2000
nnoremap <leader>o :set foldlevel=20<CR>
nnoremap <leader>c :set foldlevel=0<CR>
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-n> :bn<CR>
noremap <C-p> :bp<CR>
noremap <F1>  :NERDTreeToggle<CR>
noremap <F2>  :MBEToggle<CR>
noremap <F3>  :%!stylish-haskell<CR>

let g:syntastic_mode_map = { 'mode': 'passive' }
noremap <F4>  :SyntasticCheck<CR>
noremap <F8>  :SyntasticReset<CR>

" Source the vimrc file after saving it
augroup sourcing
  autocmd!
  autocmd bufwritepost .vimrc source $MYVIMRC
augroup END

" Open file prompt with current path
nmap <leader>e :e <C-R>=expand("%:p:h") . '/'<CR>

" Show undo tree
nmap <silent> <leader>u :GundoToggle<CR>

" Fuzzy find files
nnoremap <silent> <Leader><space> :CtrlP<CR>
let g:ctrlp_max_files=0

" Disable highlight when <leader><cr> is pressed
" but preserve cursor coloring
nmap <silent> <leader><cr> :noh\|hi Cursor guibg=red<cr>
augroup haskell
  autocmd!
  autocmd FileType haskell map <silent> <leader><cr> :noh\|GhcModTypeClear<cr>
  autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
augroup END

" Slime {{{
vmap <silent> <Leader>rs <Plug>SendSelectionToTmux
nmap <silent> <Leader>rs <Plug>NormalModeSendToTmux
nmap <silent> <Leader>rv <Plug>SetTmuxVars
" }}}

" Alignment {{{

" Stop Align plugin from forcing its mappings on us
let g:loaded_AlignMapsPlugin=1
" Align on equal signs
map <Leader>a= :Align =<CR>
" Align on commas
map <Leader>a, :Align ,<CR>
" Align on pipes
map <Leader>a<bar> :Align <bar><CR>
" Prompt for align character
map <leader>ap :Align

" Enable some tabular presets for Haskell
let g:haskell_tabular = 1

" }}}

" Tags {{{

set tags=tags;/,codex.tags;/

let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }

" Generate haskell tags with codex and hscope
map <leader>tg :!codex update<CR>:call system("git hscope")<CR><CR>:call LoadHscope()<CR>

map <leader>tt :TagbarToggle<CR>

set csprg=hscope
set csto=1 " search codex tags first
set cst
set csverb
nnoremap <silent> <C-\> :cs find c <C-R>=expand("<cword>")<CR><CR>
" Automatically make cscope connections
function! LoadHscope()
  let db = findfile("hscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/hscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /*.hs call LoadHscope()

" }}}

" Git {{{

let g:extradite_width = 60
" Hide messy Ggrep output and copen automatically
function! NonintrusiveGitGrep(term)
  execute "copen"
  " Map 't' to open selected item in new tab
  execute "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
  execute "silent! Ggrep " . a:term
endfunction

command! -nargs=1 GGrep call NonintrusiveGitGrep(<q-args>)
nmap <leader>gs :Gstatus<CR>
nmap <leader>gg :copen<CR>:GGrep
nmap <leader>gl :Extradite!<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gb :Gblame<CR>

function! CommittedFiles()
  " Clear quickfix list
  let qf_list = []
  " Find files committed in HEAD
  let git_output = system("git diff-tree --no-commit-id --name-only -r HEAD\n")
  for committed_file in split(git_output, "\n")
    let qf_item = {'filename': committed_file}
    call add(qf_list, qf_item)
  endfor
  " Fill quickfix list with them
  call setqflist(qf_list, '')
endfunction

" Show list of last-committed files
nnoremap <silent> <leader>g? :call CommittedFiles()<CR>:copen<CR>

" }}}

" Haskell Interrogation {{{

set completeopt+=longest

let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

" But provide (neco-ghc) omnicompletion
if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

" Show types in completion suggestions
let g:necoghc_enable_detailed_browse = 1

nmap <silent> <leader>ht :GhcModType<CR>
nmap <silent> <leader>hT :GhcModTypeInsert<CR>

nmap <silent> <leader>qn :cn<CR>
nmap <silent> <leader>qq :cc<CR>
nmap <silent> <leader>qp :cp<CR>

nmap <silent> <leader>hc :GhcModCheckAsync<CR>
nmap <silent> <leader>hl :GhcModLintAsync<CR>

nnoremap <silent> <leader>hh :Hoogle<CR>
nnoremap <leader>hH :Hoogle
nnoremap <silent> <leader>hi :HoogleInfo<CR>
nnoremap <leader>hI :HoogleInfo
nnoremap <silent> <leader>hz :HoogleClose<CR>

" }}}

" Conversion {{{

function! Pointfree()
  call setline('.', split(system('pointfree '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction
vnoremap <silent> <leader>h. :call Pointfree()<CR>

function! Pointful()
  call setline('.', split(system('pointful '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction
vnoremap <silent> <leader>h> :call Pointful()<CR>

" }}}

set autoindent
set smartindent
set smarttab
set tildeop
set noet ts=8 sw=0 sts=-1

map <leader>ss :setl spell!<cr>
set nospell spelllang=en_us

let c_space_errors = 1
aut FileType c setl cindent cinoptions=:0,p4,t0,+4,(4,u4,U1
aut FileType markdown setl sw=4 et
aut FileType haskell setl sw=4 et nosmarttab
aut FileType cabal setl sw=4 et
aut FileType yaml setl ts=2 sts=0 et

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif
