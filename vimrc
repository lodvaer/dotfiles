if &compatible
  set nocompatible
endif

set viminfo=
set nobackup
set noswapfile
let g:netrw_dirhistmax=0

set visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set runtimepath+=~/.vim/bundle/repos/github.com/Shougo/dein.vim

call dein#begin('~/.vim/bundle')

call dein#add('Shougo/dein.vim')
call dein#add('eagletmt/ghcmod-vim')
call dein#add('eagletmt/neco-ghc')
call dein#add('scrooloose/nerdtree')
call dein#add('scrooloose/nerdcommenter')
call dein#add('godlygeek/tabular')
call dein#add('ervandew/supertab')
call dein#add('Shougo/neocomplete.vim')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('Shougo/vimproc.vim', { 'build': 'make' })
call dein#add('dhruvasagar/vim-table-mode')

call dein#add('sheerun/vim-wombat-scheme')

call dein#end()

syntax on
filetype plugin indent on
set hidden
set lazyredraw

" Editing
set wrap linebreak textwidth=79 colorcolumn=80
set smarttab smartindent autoindent
let g:mapleader = ","

let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

vnoremap <Leader>t= :Tabularize /=<CR>
vnoremap <Leader>t: :Tabularize /::<CR>
vnoremap <Leader>t- :Tabularize /-><CR>

"" Table mode
let g:table_mode_corner_corner="+"
let g:table_mode_header_fillchar="="

" Searching
set incsearch ignorecase smartcase hlsearch

" Theming
set t_Co=256
hi ColorColumn guibg=#442222 ctermbg=10
set list listchars=tab:-\ ,trail:~,extends:>,precedes:<,nbsp:+
set number

colorscheme wombat
let g:airline_theme = 'wombat'

"" Airline
let g:airline_powerline_fonts = 1

" Navigation
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-n> :bn<CR>
noremap <C-p> :bp<CR>
noremap <Leader>n  :NERDTreeToggle<CR>

" .vimrc
augroup sourcing
  autocmd!
  autocmd bufwritepost .vimrc source $MYVIMRC
augroup end

" Syntastic
noremap <Leader>s :SyntasticToggleMode<CR>

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" Languages

"" Haskell

let g:haskellmode_completion_ghc = 1
let g:haskell_tabular = 1

augroup haskell
  autocmd!
  autocmd FileType haskell noremap <buffer> <F3> :%!stylish-haskell<CR>
  autocmd FileType haskell setl et noai ts=8 sw=4
  autocmd FileType haskell setl omnifunc=necoghc#omnifunc
  autocmd FileType haskell noremap <buffer> <Leader>hT :GhcModType<CR>
  autocmd FileType haskell noremap <buffer> <Leader>ht :GhcModTypeInsert<CR>
  autocmd FileType haskell noremap <buffer> <Leader>hs :GhcModSplitFunCase<CR>
  autocmd FileType haskell noremap <buffer> <Leader>c :GhcModTypeClear<CR>
  autocmd FileType haskell noremap <buffer> <Leader>hc :GhcModCheckAndLintAsync<CR>
augroup end
