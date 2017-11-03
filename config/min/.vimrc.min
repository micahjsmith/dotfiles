" core mappings
noremap ; :
inoremap jk <Esc>
nnoremap 0 g^
nnoremap Q gq$
nnoremap <C-k> :call append(line('.')-1, '')<CR>
nnoremap <C-j> :call append(line('.'), '')<CR>

" core settings
syntax enable
set nocompatible
set number
set nowrap
set textwidth=80
set ignorecase
set smartcase
set incsearch
set hlsearch

" secondary mappings
let mapleader = ","
map q: :q
nnoremap gn :bn<CR>
nnoremap gp :bp<CR>
nnoremap gd :bd<CR>
nnoremap K <nop>

" only plugin :)
silent! execute pathogen#infect()
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
