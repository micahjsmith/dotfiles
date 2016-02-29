" Micah Smith
" .vimrc

" Section: Options
" ----------------

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
"set wildmode=longest:full
set wildmode=full
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

"Format blocks of text
if version > 703 || version == 703 && has("patch541")
  set formatoptions+=j         " Remove comment char on line join
endif
if version > 704 || version == 704 && has("patch338")
  set breakindent
endif

" Ignore whitespace with vimdiff
if &diff
    set diffopt +=iwhite
endif

" Section: Commands
" ----------------

" Insert datestamp
nnoremap <leader>d "=strftime("%Y-%m-%d")<CR>P
iab <expr> dts strftime("%Y-%m-%d")

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

" Section: Mappings
" -----------------

"Save pinky finger from harm.
let mapleader = ","
map q: :q
noremap ; :
inoremap jk <Esc>
inoremap JK <nop>

"Move cursor on display physically, preferring the behavior of ^ over 0
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap ^ g0
nnoremap 0 g^

"Redraw the screen and remove any search highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

"Format blocks of text
nnoremap Q gq$

"Manage buffer switching
map gn :bn<CR>
map gp :bp<CR>
map gd :bd<CR>

"Open files for editing that don't exist
"map gf :e <cfile><CR>

"Enable C-g in insert mode - displays file name and other info
inoremap <C-g> <Esc>1<C-g>i
nnoremap <C-g> 1<C-g>

"Insert lines above and below without entering insert mode
nnoremap <C-k> :call append(line('.')-1, '')<CR>
nnoremap <C-j> :call append(line('.'), '')<CR>

" Section: Autocommands
" ---------------------

"Custom language settings - tabs and textwidth
autocmd FileType python    setlocal tabstop=4 shiftwidth=4
autocmd FileType make      setlocal tabstop=8 shiftwidth=8 noexpandtab
autocmd FileType matlab    setlocal tabstop=2 shiftwidth=2
autocmd FileType julia     setlocal tabstop=4 shiftwidth=4 textwidth=92
autocmd FileType markdown  setlocal tabstop=2 shiftwidth=2 textwidth=92
autocmd Filetype gitcommit setlocal                        textwidth=72 spell
autocmd FileType tex       setlocal                        textwidth=92 spell

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" Section: Visual
" ---------------

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
nnoremap <silent> <leader>m :call ToggleMatch()<CR>

"Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
match ExtraWhitespace /\s\+\%#\@<!$/

" Different colorscheme with vimdiff
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

"Colorz
"set background=dark
"colorscheme solarized

" Section: Plugins
" ----------------

" tabular
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a= :Tabularize /=<CR>

" vim-airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = 'wombat'

" pydiction
let g:pydiction_location = "~/.vim/bundle/pydiction/complete-dict"

" Increment.vim (Script #156)
vnoremap <C-a> :Inc<CR>

" vim-expand-region
" See https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/ sec. 3
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" linediff.vim
vnoremap <leader>l :Linediff<CR>
nnoremap <leader>r :LinediffReset<CR>

" indentLine
autocmd FilterWritePre * if &diff | exe "silent! IndentLinesDisable" | endif

" Section: Local
" --------------

source $HOME/.vimrc.local
