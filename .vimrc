"Pathogen plugin manager
execute pathogen#infect()

"Basic settings
syntax enable
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
if version >= 704
  set formatoptions+=j         " Remove comment char on line join
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

"Custom tab settings
autocmd FileType python set tabstop=4|set shiftwidth=4
autocmd FileType make set tabstop=8|set shiftwidth=8|set noexpandtab

"Configuration for working with julia
"<C-o> conflicts with tmux prefix.
inoremap <C-x><C-x> <C-x><C-o>
autocmd Filetype julia setlocal textwidth=92
autocmd FileType julia setlocal shiftwidth=4 tabstop=4

"Configuration for working with md
autocmd Filetype markdown setlocal textwidth=92

"Best practice for git commits, from thoughtbot.
autocmd Filetype gitcommit setlocal spell textwidth=72

"Colorz
"set background=dark
"colorscheme solarized

"Highlight characters (textwidth+1)+ on each line. Toggle with <leader>m.
"Default to 80
let g:setMatchOn=1
function! ToggleMatch()
  if &textwidth==0
    set textwidth=80
  endif
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
