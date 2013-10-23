call pathogen#runtime_append_all_bundles()
source ~/.vim/vundle.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf8
set encoding=utf8
set fileencoding=utf8
set termencoding=utf8

set listchars=tab:▸\ ,trail:·,nbsp:·
set list
set nobomb
set nowrap
set nocompatible
" allow unsaved background buffers and remember marks/undo for them
set hidden
" remember more commands and search history
set history=10000
set expandtab
set tabstop=2
set shiftwidth=4
set softtabstop=4
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
set cmdheight=1
set switchbuf=useopen
set number
set relativenumber
set numberwidth=1
set showtabline=2

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Store temporary files in a central spot
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
" include '?' and '!' in autocomplete
set iskeyword+=-,?,!
" Enable highlighting for syntax
syntax on
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu

" indent with 2 spaces
autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et

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
" COLORS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
set t_Co=256
syntax enable
let g:solarized_termcolors=256
colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%) "\ %{fugitive#statusline()}

hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

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
autocmd BufWritePre * call Preserve('%s/\s\+$//e')
autocmd BufWritePre * call Preserve('%s/\v($\n\s*)+%$//e')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0
let g:ctrlp_switch_buffer = '0'
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_abbrev = {
            \ 'gmode': 't',
            \ 'abbrevs': [
            \ { 'pattern': '^a/', 'expanded': 'app/' },
            \ { 'pattern': '^c/', 'expanded': 'app/controllers/' },
            \ { 'pattern': '^m/', 'expanded': 'app/models/' },
            \ { 'pattern': '^v/', 'expanded': 'app/views/' },
            \ { 'pattern': '^h/', 'expanded': 'app/helpers/' },
            \ { 'pattern': '^s/', 'expanded': 'spec/' }
            \ ]
            \ }

let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git,log,vendor)$',
            \ }
noremap <c-s> :exec "CtrlPLine " . bufname('%')<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunTest(...)
  let s:command = SelectTestCommand()

  if a:0 " run all file
    let g:lastTmuxCmd = s:command["command"].s:command["file"]."\n"
  else
    let g:lastTmuxCmd = s:command["command"].s:command["file"].s:command["line"]."\n"
  endif

  call Send_to_Tmux(g:lastTmuxCmd)
endfunction

function! SelectTestCommand()
  let s:thisFile = expand("%")

  if match(s:thisFile, "_feature.rb") != -1 || match(s:thisFile, "_spec.rb") != -1
    return {
          \ "command": "bundle exec rspec ",
          \ "file": expand('%'),
          \ "line": ":".line(".")
          \ }
  elseif match(s:thisFile, "_test.rb") != -1
    return {
          \ "command": "ruby -I".matchstr(expand("%:h"), ".*test")." ",
          \ "file": expand('%'),
          \ "line": " -n /" . GetCurrentTest() . "/"
          \ }
  endif
endfunction

function! GetCurrentTest()
  let s:line = search("def\ test_", "b")
  return matchstr(getline(s:line), 'def\s\zstest_.*')
endfunction

nmap <leader>rf :call RunTest(1)<CR>
nmap <leader>rl :call RunTest()<CR>
nmap <leader>rr :call Send_to_Tmux(g:lastTmuxCmd)<CR>
nmap <leader>ra :call Send_to_Tmux("bundle exec rspec\n")<CR>
nmap <leader>rc :call Send_to_Tmux("bundle exec cucumber\n")<CR>
nmap <leader>rs :call Send_to_Tmux("rspec\n")<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SEARCHES WORD UNDER CURSOR WITH ACK
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! VAckSearch()
  let temp = @s
  norm! gv"sy
  return ':Ack "' . EscapeAllString(@s) . '"'
endfunction

function! EscapeAllString(text)
  return substitute(escape(a:text, '*^$.?/\|{[()]}'), '\n', '\\n', 'g')
endfunction

let g:ackprg="ack -H -i --nogroup --nocolor --column --follow --ignore-dir='log'"
let g:ackhighlight=1
vnoremap ,as :<C-u>exec VAckSearch()<CR>
nnoremap ,as :Ack<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <c-n> :NERDTreeFind<cr>
let NERDTreeAutoDeleteBuffer=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SYNTASTIC CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_auto_loc_list=0 "don't pop up the Errors list automatically
let g:syntastic_check_on_open=1
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': ['c', 'cpp', 'scss', 'css', 'javascript', 'json', 'sh', 'tex', 'html', 'xml', 'yaml'],
            \ 'passive_filetypes': ['puppet'] }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ONLY SHOW CURSORLINE IN THE CURRENT WINDOW AND IN NORMAL MODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup cline
    au!
    au WinLeave * set nocursorline
    au WinEnter * set cursorline
    au InsertEnter * set nocursorline
    au InsertLeave * set cursorline
augroup END

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
set mouse=a
set ttymouse=xterm2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
imap <c-l> <space>=><space>
imap <c-k> <space>=<space>

" Clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

" switch between last two files
nnoremap <leader><leader> <c-^>

" jk to go to normal mode
inoremap jk <esc>l

" run current file
nnoremap <leader>] :w <enter> :!ruby % <cr>

nnoremap j gj
nnoremap k gk
nnoremap <leader>tn :tabnew<cr>

" copy and paste from clipboard
vnoremap Y "+y
nnoremap P "+p

" with this line, 'y' and 'p' play fine with the clipboard
" set clipboard=unnamed

" insert and remove comments in visual and normal mode
vnoremap ,c :s/^/#/g<CR>:let @/ = ""<CR>
nnoremap ,c :s/^/#/g<CR>:let @/ = ""<CR>
vnoremap ,r :s/^#//g<CR>:let @/ = ""<CR>
nnoremap ,r :s/^#//g<CR>:let @/ = ""<CR>

" previous tab
nnoremap gr gT

" highlight word under cursor w/o moving the cursor position
nnoremap ! *<c-o>

" edit and source vimrc
nnoremap <leader>ev :100vs  ~/.vim/vimrc<cr>
nnoremap <leader>sv :source ~/.vim/vimrc<cr>

" ack
nnoremap <leader>bb :Ack --ruby --ignore-dir="bin" 'debugger'<cr>
nnoremap <leader>ss :Ack ""<left>
nnoremap <leader>ls :Ack <up>

" really remove the buffer when it's closed
:cabbrev q bw<cr>
nnoremap <leader>q :bw<cr>

" bind :Q to :q and :W to :w
command! Q q
command! W w

" indent file
noremap <leader>f :call Preserve('normal gg=G')<CR>

let g:quickfixsigns_classes=['vcsdiff']

" makes * and # work on visual mode too
function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

vmap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vmap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

nnoremap ,d Orequire 'pry'; binding.pry<esc>
nnoremap <F2> :TagbarToggle<cr>
