"Pathogen plugin manager
execute pathogen#infect()

"Basic settings
syntax enable
set ruler
set more
set autoread
set hidden
set number
set noautowrite
set scrolloff=2
set sidescrolloff=5
set history=1000
set cmdheight=2
set noerrorbells
set visualbell
set nowrap
set backspace=indent,eol,start
set wildmenu
set textwidth=80

"Indenting
filetype plugin indent on
set autoindent 
set smartindent

"Tabs
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4

"Searching
set ignorecase
set smartcase
set incsearch
set hlsearch

"Prefer to avoid swap files/backups.
set nobackup
set nowb
set noswapfile

"Save pinky finger from harm.
noremap ; :
inoremap jk <Esc>
inoremap kj <Esc>
inoremap jj <nop>
inoremap JK <nop>
inoremap JJ <nop>
inoremap KJ <nop>
let mapleader = ","
map q: :q
    
"Move cursor on display physically, prefering the behavior of ^ over 0
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap ^ g0
nnoremap 0 g^

"Redraw the screen and remove any search highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

"Format blocks of text
nnoremap Q gq$
if version > 703 || version == 703 && has("patch541")
  set formatoptions+=j         " Remove comment char on line join
endif
if version > 704 || version == 704 && has("patch338")
  set breakindent
endif

"Manage buffer switching
map gn :bn<CR>
map gp :bp<CR>
map gd :bd<CR>

"Enable C-g in insert mode - displays file name and other info
inoremap <C-g> <Esc><C-g>i

"Insert lines above and below without entering insert mode
nnoremap <C-k> O<Esc>j
nnoremap <C-j> o<Esc>k

"vim-airline configuration
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = 'wombat'

"pydiction configuration
let g:pydiction_location = "~/.vim/bundle/pydiction/complete-dict"

"Mapping in visual block mode for Increment.vim. See Script #156.
vnoremap <C-a> :Inc<CR>

"Custom language settings - tabs and textwidth
autocmd FileType python    setlocal tabstop=4 shiftwidth=4
autocmd FileType make      setlocal tabstop=8 shiftwidth=8 noexpandtab
autocmd FileType matlab    setlocal tabstop=2 shiftwidth=2
autocmd FileType julia     setlocal tabstop=4 shiftwidth=4 textwidth=92
autocmd FileType markdown  setlocal tabstop=2 shiftwidth=2 textwidth=92
autocmd Filetype gitcommit setlocal                        textwidth=72 spell

"Configuration for working with julia
"<C-o> conflicts with tmux prefix.
inoremap <C-x><C-x> <C-x><C-o>

"Colorz
"set background=dark
"colorscheme solarized

"Highlight characters (textwidth+1)+ on each line. Toggle with <leader>m.
"Default to 80
let g:setMatchOn=1
function! ToggleMatch()
  if g:setMatchOn
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    let g:matchOverLength=matchadd('OverLength', '\%>'.&l:textwidth.'v.\+', -1)
    let g:setMatchOn=0
  else
    call matchdelete(g:matchOverLength)
    let g:setMatchOn=1
  endif
endfunction
nnore <silent> <leader>m :call ToggleMatch()<CR>

" Keep screen view in same spot when switching between buffers. See
" vim.wikia.com/wiki/Avoid_scrolling_when_switch_buffers
" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" Different colorscheme with vimdiff
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

" Insert datestamp
nnoremap <leader>d "=strftime("%Y-%m-%d")<CR>P
iab <expr> dts strftime("%Y-%m-%d")
