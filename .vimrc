"Pathogen plugin manager
execute pathogen#infect()

"Basic settings
syntax on
filetype plugin indent on
set ruler
set more
set autoread
set hidden
set number
set noautowrite
set autoindent 
set smartindent
set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set scrolloff=2
set sidescrolloff=5
set history=200
set cmdheight=2
set ignorecase
set smartcase
set incsearch
set noerrorbells
set visualbell
set nowrap
set backspace=indent,eol,start

"Prefer to avoid swap files/backups.
set nobackup
set nowb
set noswapfile

"Custom tab settings
autocmd FileType python set tabstop=4|set shiftwidth=4
autocmd FileType make set tabstop=8|set shiftwidth=8|set noexpandtab

"Save pinky finger from harm.
noremap ; :
noremap , ;
imap jj <Esc>

"Highlight characters 81+ on each line. Toggle with C-m
let g:setMatchOn=1
function! ToggleMatch()
  if g:setMatchOn
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%81v.\+/
    let g:setMatchOn=0
  else
    match none
    let g:setMatchOn=1
  endif
endfunction
nnore <silent> <C-m> :call ToggleMatch()<CR>
    
"Move cursor on display physically, prefering the behavior of ^ over 0
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap ^ g0
nnoremap 0 g^

"Redraw the screen and remove any search highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

"Reformat block of text, at expense of rarely-used Ex mode
nnoremap Q gq$

"Manage buffer switching
map gn :bn<CR>
map gp :bp<CR>
map gd :bd<CR>

"Enable C-g in insert mode - displays file name and other info
inoremap <C-g> <Esc><C-g>i

"Insert lines above and below without entering insert mode
nmap <C-k> O<Esc>j
nmap <C-j> o<Esc>k

"vim-airline configuration
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = 'wombat'

"pydiction configuration
let g:pydiction_location = "~/.vim/bundle/pydiction/complete-dict"

"Mapping in visual block mode for Increment.vim
vnoremap <C-a> :Inc<CR>
