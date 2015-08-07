let hostname = substitute(system('hostname'), '\n', '', '')

set guioptions=aegit

if hostname == "aspergoid"
	set guifont=inconsolata\ 14
elseif
	set guifont=inconsolata\ 12
endif

" set number
" colorscheme solarized
" hi Normal guibg=#001b26
