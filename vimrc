set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
source ~/.vim/vundle.vim
source ~/.vim/snippets/support_functions.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf8
set encoding=utf8
set fileencoding=utf8
set termencoding=utf8

set list " display unprintable characters
set listchars=tab:▸\ ,trail:·,nbsp:·
set nowrap " avoid breaking a line single line into multiple lines
set nocompatible " make vim not compatible with vi
set hidden " allow unsaved background buffers and remember marks/undo for them
set history=100 " remember more commands and search history (default is 20)
set expandtab " insert spaces instead of tabs
set tabstop=2 " define how many spaces are added for a tab
set shiftwidth=2 " number of spaces used for autoindent (<<, >>)
set laststatus=2 " always shows statusline for every window
set incsearch " show search result as I type
set hlsearch " highlight the search results
set ignorecase smartcase " make searches case-sensitive only if they contain upper-case characters
set cursorline " highlight current line
set cmdheight=1 " number of screen lines used for the command-line
set number " show line numbers
set relativenumber " show line numbers relative to the current line
set numberwidth=1 " minimal number of columns to used for the line number
set showtabline=2 " always displays tabs
set t_ti= t_te= " doesn't remove vim screen from the view when running external commands (:!ls)

" Store temporary files in a central spot
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set showcmd " display incomplete commands
set iskeyword+=-,?,! " include '?' and '!' in autocomplete

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

set wildmode=longest,list " use emacs-style tab completion when selecting files, etc
set wildmenu " make tab completion for files/buffers act like bash
set wildignore+=*.zip,*.gz,*.bz,*.tar
set wildignore+=*.jpg,*.png,*.gif,*.avi,*.wmv,*.ogg,*.mp3,*.mov

set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

" indent with 2 spaces
autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber,sh set ai sw=2 sts=2 et

" indent with 4 spaces in java files
autocmd FileType java set ai sw=4 sts=4 et

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLORS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
set t_Co=256
syntax enable
let g:solarized_termcolors=256
colorscheme solarized
let g:airline_theme="bubblegum"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SNIPPETS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.vim/snippets/support_functions.vim

let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['ruby'] = 'ruby,ruby-rails,ruby-rspec'
let g:snipMate.scope_aliases['eruby'] = 'html'
let g:snipMate.scope_aliases['javascript'] = 'javascript,javascript-jasmine,handlebars,angular'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EXECUTE COMMAND PRESERVING THE LOCATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Preserve(command)
  let _s=@/

  let l:winview = winsaveview()
  silent execute a:command
  call winrestview(l:winview)

  let @/=_s
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SPLITS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap < <c-w><
nnoremap > <c-w>>

set splitright
set splitbelow

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> :echo "arrow keys are not allowed"<cr>
map <Right> :echo "arrow keys are not allowed"<cr>
map <Up> :echo "arrow keys are not allowed"<cr>
map <Down> :echo "arrow keys are not allowed"<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REMOVE TRAILING WHITESPACES AND BLANK LINES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! StripTrailingWhitespace()
  if &ft !~ 'markdown'
    call Preserve('%s/\s\+$//e')
  endif
endfun

autocmd BufWritePre * call StripTrailingWhitespace()
autocmd BufWritePre * call Preserve('%s/\v($\n\s*)+%$//e')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" USE A BAR-SHAPED CURSOR FOR INSERT MODE.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAKE SURE VIM RETURNS TO THE SAME LINE WHEN YOU REOPEN A FILE.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup line_return
    au!
    au BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \     execute 'normal! g`"zvzz' |
                \ endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SHUT UP BACKUP FILES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set undodir=/tmp/
set backupdir=/tmp/
set directory=/tmp/
set backup
set noswapfile

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" USE THE MOUSE TO SCROLL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a " works in all modes
set ttymouse=xterm2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" USE *, # AND ! IN VISUAL MODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! VSetSearch()
  try
    let temp = @s
    norm! gv"sy
    return substitute(escape(@s, '\'), '\n', '\\n', 'g')
  finally
    let @s = temp
  endtry
endfunction

vnoremap * :<c-u>set hls \| let @/=VSetSearch()<CR>//<CR>
vnoremap # :<c-u>set hls \| let @/=VSetSearch()<CR>??<CR>
vnoremap <silent> ! :<c-u>set hls \| let @/=VSetSearch()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DISABLE STANDARD PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:loaded_getscriptPlugin=1 " download latest version of vim scripts
let g:loaded_netrwPlugin=1 " read and write files over a network
let g:loaded_tarPlugin=1 " tar file explorer
let g:loaded_2html_plugin=1 " convert to html
let g:loaded_vimballPlugin=1 " create self-installing Vim-script
let g:loaded_zipPlugin=1 " zip archive explorer
let loaded_gzip=1 " reading and writing compressed files
let loaded_rrhelper=1 " helper function(s) for --remote-wait

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

" switch between last two files
nnoremap <leader><leader> <c-^>

" jk to go to normal mode
inoremap jk <esc>l

" run current file
nnoremap <leader>] :w <enter> :!ruby  %<cr>

nnoremap j gj
nnoremap k gk
nnoremap <leader>tn :tabnew<cr>

" previous tab
nnoremap gr gT

" highlight word under cursor w/o moving the cursor position
nnoremap <silent> ! :set hls \| let @/=expand('<cword>')<CR>

" edit and source vimrc
nnoremap <leader>ev :100vs  ~/.vim/vimrc<cr>
nnoremap <leader>sv :source ~/.vim/vimrc<cr>

nnoremap <leader>q :q<cr>

" indent file
nnoremap <leader>f :call Preserve('normal gg=G')<CR>

nnoremap ,dp Orequire 'pry'; binding.pry<esc>
nnoremap ,db Orequire 'byebug'; byebug<esc>

nnoremap <F4> :TagbarToggle<cr>
nnoremap <C-]> g<C-]>
nnoremap ,r :!pry<cr>
nnoremap ,mt <c-w>T<cr> " move current buffer to its own tab

vnoremap ,e :Eval<cr> " eval clojure core
nnoremap ,a maggVG

vnoremap ,cb y'>o<esc>p
vnoremap ,ca y'<O<esc>P
