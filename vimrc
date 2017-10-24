if &compatible
  set nocompatible
endif

set backspace=indent,eol,start

set viminfo=
set nobackup
set noswapfile
let g:netrw_dirhistmax=0

set visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set runtimepath+=~/.vim/bundle/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.vim/bundle')
  call dein#begin('~/.vim/bundle')

  " Misc
  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/vimproc.vim', { 'build': 'make' })

  " UI
  call dein#add('scrooloose/nerdtree')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('sheerun/vim-wombat-scheme')
  call dein#add('rafi/awesome-vim-colorschemes')
  call dein#add('mileszs/ack.vim')
  call dein#add('/usr/share/vim/vimfiles')
  call dein#add('junegunn/fzf.vim')
  call dein#add('w0rp/ale')

  " Editing
  call dein#add('scrooloose/nerdcommenter')
  call dein#add('godlygeek/tabular')
  if has('nvim')
    call dein#add('Shougo/deoplete.nvim')
  else
    call dein#add('Shougo/neocomplete.vim')
  endif
  call dein#add('dhruvasagar/vim-table-mode')
  call dein#add('xolox/vim-misc')
  " call dein#add('xolox/vim-easytags')

  " SCM
  call dein#add('tpope/vim-fugitive')

  " fasm
  call dein#add('RIscRIpt/vim-fasm-syntax')

  " C
  if has('nvim')
    call dein#add('zchee/deoplete-clang')
  else
    call dein#add('Rip-Rip/clang_complete')
  endif

  " Haskell
  call dein#add('neovimhaskell/haskell-vim')
  call dein#add('bitc/vim-hdevtools')
  call dein#add('eagletmt/neco-ghc')

  call dein#add('derekwyatt/vim-fswitch')

  call dein#end()
  call dein#save_state()
endif

syntax on
filetype plugin indent on
set hidden
set lazyredraw

if dein#check_install()
  call dein#install()
endif

" Editing
set wrap linebreak textwidth=79 colorcolumn=80
set smarttab smartindent autoindent
set formatoptions+=rolj
set formatoptions-=t
let g:mapleader = ","

vnoremap <Leader>t= :Tabularize /=<CR>
vnoremap <Leader>t: :Tabularize /::<CR>
vnoremap <Leader>t- :Tabularize /-><CR>

let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 1
call deoplete#custom#set('around', 'rank', 50)

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

inoremap <silent><expr> <TAB>
\ pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" :
\ deoplete#mappings#manual_complete()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

"" Table mode
let g:table_mode_corner="|"

" Searching
set incsearch ignorecase smartcase hlsearch
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
nmap <C-t> :Files<CR>

" Theming
set t_Co=256
hi ColorColumn guibg=#442222 ctermbg=10
set list listchars=tab:-\ ,trail:~,extends:>,precedes:<,nbsp:+
set number

colorscheme wombat
let g:airline_theme = 'wombat'

"" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

" Navigation
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-n> :bn<CR>
noremap <C-p> :bp<CR>
noremap <Leader>n  :NERDTreeToggle<CR>
set mouse=nv

let NERDTreeIgnore = ['\.pyc$', '\.egg-info$']

" .vimrc
augroup sourcing
  autocmd!
  autocmd bufwritepost .vimrc source $MYVIMRC
augroup end

" ALE
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0

" Languages

"" Vim
augroup vim
  autocmd!
  autocmd FileType vim setl et ts=2 sw=2
augroup end

"" Haskell

set tags=tags;/,codex.tags;/

let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1
let g:haskell_backpack = 1

let g:haskell_indent_if = 4
let g:haskell_indent_case = 4
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 4
let g:haskell_indent_case_alternative = 4

let g:haskellmode_completion_ghc = 0

augroup haskell
  autocmd!
  autocmd FileType haskell noremap <buffer> <F3> :%!stylish-haskell<CR>
  autocmd FileType haskell noremap <buffer> <F4> :%!hindent<CR>
  autocmd FileType haskell setl formatprg=hindent
  autocmd FileType haskell setl et noai ts=8 sw=4
  autocmd FileType cabal setl et noai ts=8 sw=2
  autocmd FileType haskell setl omnifunc=necoghc#omnifunc
  autocmd FileType haskell noremap <buffer> <Leader>hT :GhcModType<CR>
  autocmd FileType haskell noremap <buffer> <Leader>ht :GhcModTypeInsert<CR>
  autocmd FileType haskell noremap <buffer> <Leader>hs :GhcModSplitFunCase<CR>
  autocmd FileType haskell noremap <buffer> <Leader>c :GhcModTypeClear<CR>
  autocmd FileType haskell noremap <buffer> <Leader>hc :GhcModCheckAndLintAsync<CR>
augroup end

"" Markdown

augroup markdown
  autocmd!
  autocmd FileType markdown setl sw=4 et foldmethod=indent
  " TODO: test formatoptions+=t
augroup end

"" yaml

augroup yaml
  autocmd!
  autocmd FileType yaml setl sw=2 et
augroup end

"" C & CPP

augroup c
  autocmd!
  autocmd FileType c setl noet sw=4 ts=8
  autocmd FileType c setl cinoptions=>2s,p2s,t0,+4,(0,U1,:0,=2s " )
augroup end

let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'

" misc

augroup matlab
  autocmd!
  autocmd FileType matlab setl et sw=4 ts=4
augroup end

augroup groovy
  autocmd!
  autocmd FileType groovy setl et noai ts=4 sw=4
augroup end

" asm

augroup asm
  autocmd!
  autocmd BufNewFile,BufRead *.asm setl ft=fasm ts=8 sw=8
augroup end

" Host-local settings

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif
