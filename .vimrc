"Basic settings
syntax on
set number
set ruler
set more
set autoread
set hidden
set noautowrite
set scrolloff=5
set sidescrolloff=5
set history=200
set cmdheight=2
set noerrorbells
set nocompatible
set undolevels=100

"Commands for indenting
set autoindent smartindent
set expandtab
set tabstop=2
set shiftwidth=2

"Commands for searching
set ignorecase
set smartcase
set incsearch

"Prefer to avoid swap files/backups
set nobackup
set nowb
set noswapfile

"Highlight characters 81+ on each line.
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

"Treat tabs in makefiles literally
autocmd FileType make setlocal noexpandtab tabstop=8 sw=8

"Save pinky finger from harm
nore ; :
nore , ;
imap jj <Esc>

"Manage buffer switching
nore gd :bd<CR>
nore gn :bn<CR>
nore gp :bp<CR>

"prefer to swith ^ and 0
nnoremap ^ 0
nnoremap 0 ^

"Move cursor on display visually, and prefer ^ over 0
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap 0 g^
nnoremap ^ g0

"C-l redraws the screen and removes search highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

"Enable C-g in insert mode (displays file name, position within)
inoremap <C-g> <Esc><C-g>i

"Insert lines above and below without entering insert mode
nmap <C-k> O<Esc>j
nmap <C-J> o<Esc>k
