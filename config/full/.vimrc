" Micah Smith
" .vimrc

" Section: Options
" ----------------

"Pathogen plugin manager
execute pathogen#infect()

"Basic settings
syntax enable
set nocompatible
set ruler
set more
set autoread
set hidden
set number
set relativenumber
set noautowrite
set scrolloff=2
set sidescrolloff=5
set history=1000
set cmdheight=1
set noerrorbells
set visualbell
set nowrap
set backspace=indent,eol,start
set wildmenu
"set wildmode=longest:full
set wildmode=full
set textwidth=80
let g:tex_conceal = ''

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

"Ignore whitespace with vimdiff
if &diff
    set diffopt +=iwhite
endif

"Encryption
if version > 704 || version==704 && has("patch399")
    set cryptmethod=blowfish2
endif

"Mouse
if has('mouse')
  set mouse=a
endif

" Section: Mappings
" -----------------

"Save pinky finger from harm.
let mapleader = ","
map q: :q
noremap ; :
inoremap jk <Esc>
inoremap JK <nop>

"Search token under cursor wthout jumping to first match (uses mark `i`)
nnoremap * :keepjumps normal! mi*`i<CR>

"Move cursor on display physically, preferring the behavior of ^ over 0
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap ^ g0
nnoremap 0 g^

"Redraw the screen and remove any search highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

"Format blocks of text
nnoremap Q gqap

"Manage buffer switching
nnoremap gn :bn<CR>
nnoremap gp :bp<CR>
nnoremap gd :bd<CR>
"autocmd FileType netrw nnoremap <buffer> :bd<CR>

"Open files for editing that don't exist
map ge :e <cfile><CR>

"Insert lines above and below without entering insert mode. Disable K which I
"accidentally hit all the time.
nnoremap <C-k> :call append(line('.')-1, '')<CR>
nnoremap <C-j> :call append(line('.'), '')<CR>
nnoremap K <nop>

"Remove all trailing whitespace in file
nnoremap <leader>w :%s/[ \t]\+$//g<CR>

"Execute current selection in bash shell
vnoremap <leader>b :w !bash<CR>

"Toggle spelling
nnoremap <leader>s :set invspell<CR>

"Replace misspelled word with first suggestion
nnoremap <leader>z 1z=

"Make default goal
nnoremap <leader>k :Make<CR>

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

"Auto-change directory to working directory. See Vim Wikia Tip 64.
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif

" Section: Autocommands
" ---------------------

"Custom language settings - tabs and textwidth
autocmd FileType python     setlocal tabstop=4 shiftwidth=4 textwidth=79 foldnestmax=2 foldmethod=indent
autocmd FileType python     inoremap # X<C-h>#
autocmd FileType make       setlocal tabstop=8 shiftwidth=8 noexpandtab
autocmd FileType matlab     setlocal tabstop=2 shiftwidth=2 | syntax keyword matlabRepeat parfor
autocmd FileType julia      setlocal tabstop=4 shiftwidth=4 textwidth=92
autocmd FileType markdown   setlocal tabstop=4 shiftwidth=4 textwidth=92 spell
autocmd Filetype gitcommit  setlocal                        textwidth=72 spell
autocmd FileType tex        setlocal                        textwidth=92 spell
autocmd FileType html       setlocal tabstop=2 shiftwidth=2 textwidth=0 wrap
autocmd FileType css        setlocal tabstop=2 shiftwidth=2 textwidth=0 wrap
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 textwidth=0 wrap

"Lint current file
autocmd FileType python     nnoremap <leader>p :!pylint -E %<CR>
autocmd FileType javascript nnoremap <leader>p :!jshint %<CR>
autocmd FileType sh         nnoremap <leader>p :!shellcheck %<CR>

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" Fix bug with closing netrw
autocmd FileType netrw setlocal bufhidden=wipe

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

" "Colorz
" colorscheme solarized
" if has("gui_running") || $GNOME_SOLARIZED_LIGHT==1
"     set background=light
" elseif getenv("TERM_PROGRAM") == "vscode"
"     set background=light
" else
"     set background=dark
" endif

" Section: Plugins
" ----------------

" netrw
let g:netrw_liststyle=3

" tabular
vmap <leader>a= :Tabularize /^[^=]*\zs=/l1c1l0<CR>
nmap <leader>a= :Tabularize /^[^=]*\zs=/l1c1l0<CR>
vmap <leader>a; :Tabularize /:<CR>
nmap <leader>a; :Tabularize /:<CR>

" vim-airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = 'solarized'

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
function! ToggleTmuxCopy()
    if g:indentLine_enabled
        silent! IndentLinesToggle
    endif
    set number! relativenumber!
endfunction
nnoremap <silent> <leader>t :call ToggleTmuxCopy()<CR>

" nerdtree
nnoremap <silent> <leader>n :NERDTreeToggle<CR>
" open nerdtree automatically if vim is opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close vim if the only window left is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Section: Local
" --------------

silent! source $HOME/.vimrc.local
