call pathogen#runtime_append_all_bundles()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
set relativenumber
set numberwidth=1
set showtabline=2
"set winwidth=79
set shell=zsh
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
"let mapleader="/\"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  "autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256 
set background=dark
color xoria256

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%) "\ %{fugitive#statusline()}
hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>y "*y

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
imap <c-k> <space>=<space>

" Clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>
nnoremap <leader><leader> <c-^>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> :echo "arrow keys are not allowed"<cr>
map <Right> :echo "arrow keys are not allowed"<cr>
map <Up> :echo "arrow keys are not allowed"<cr>
map <Down> :echo "arrow keys are not allowed"<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
let old_name = expand('%')
let new_name = input('New file name: ', expand('%'))
if new_name != '' && new_name != old_name
  exec ':saveas ' . new_name
  exec ':silent !rm ' . old_name
  redraw!
endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REMOVE TRAILING WHITESPACES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RemoveTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType ruby autocmd BufWritePre <buffer> :call RemoveTrailingWhitespaces()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPS TO JUMP TO SPECIFIC COMMAND-T TARGETS AND FILES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>x :CommandTFlush<cr>\|:CommandT<cr>
map <leader>z :CommandTFlush<cr>\|:CommandT extensions<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunTests(filename)
" Write the file and run tests for the given filename
:w
:!clear
if match(a:filename, '\.feature$') != -1
  exec ":!script/features " . a:filename
else
  if filereadable("script/test")
    exec ":!script/test " . a:filename
  elseif filereadable("Gemfile")
    exec ":!bundle exec rspec --color " . a:filename
  else
    exec ":!rspec --color " . a:filename
  end
end
endfunction

function! SetTestFile()
" Set the spec file that tests will be run for.
let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
if a:0
  let command_suffix = a:1
else
  let command_suffix = ""
endif

" Run the tests for the previously-marked file.
let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
if in_test_file
  call SetTestFile()
elseif !exists("t:grb_test_file")
  return
end
call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
let spec_line_number = line('.')
call RunTestFile(":" . spec_line_number . " -b")
endfunction

map <leader>tt :call RunTestFile()<cr>
map <leader>TT :call RunNearestTest()<cr>
map <leader>aa :call RunTests('')<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searches word under the cursor with ack
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! VAckSearch()
let temp = @s
norm! gv"sy
return ':Ack "' . EscapeAllString(@s) . '"'
endfunction

function! EscapeAllString(text)
return substitute(escape(a:text, '*^$.?/\|{[()]}'), '\n', '\\n', 'g')
endfunction

let g:ackprg="ag -H -i --nogroup --nocolor --column --follow"
let g:ackhighlight=1
vnoremap ,as :<C-u>exec VAckSearch()<CR>
nnoremap ,as :Ack<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Moves the cursos to the node in the NERDTree that represents the current file
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! FindInNERDTree(...)
if a:0
  let l:path = a:1
else
  let l:nerdbuf = 0
  for item in tabpagebuflist()
    if bufname(item) =~ "^NERD_tree_"
      let l:nerdbuf = item
    endif
  endfor

  if l:nerdbuf == bufnr('%')
    " already in the tree
    return 0
  endif

  let l:path = g:NERDTreePath.New(bufname('%'))

  if l:nerdbuf
    silent! exec bufwinnr(l:nerdbuf) . "wincmd w"
  else
    silent! exec "NERDTreeToggle"
  endif

  call cursor(g:NERDTreeFileNode.GetRootLineNum(), 1)
endif
let l:root = g:NERDTreeDirNode.GetSelected()

if l:root.path.compareTo(l:path) == 0
  return l:root.findNode(l:path)
elseif l:path.str() !~ '^' . l:root.path.str()
  echo "Not in the current NERD tree!"
  return 0
else
  let l:node = FindInNERDTree(l:path.getParent())
  if !empty(l:node)
    call l:node.open()
    if a:0
      return l:node.findNode(l:path)
    else
      call NERDTreeRender()
      call g:NERDTreeFileNode.New(l:path).putCursorHere(1, 0)
    endif
  endif
endif

return {}
endfunction
nnoremap <leader>nt :call FindInNERDTree()<cr>
inoremap \nt <esc>:call FindInNERDTree()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_auto_loc_list=0 "don't pop up the Errors list automatically
let g:syntastic_check_on_open=1
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_mode_map = { 'mode': 'active',
      \ 'active_filetypes': ['ruby', 'eruby', 'c', 'cpp', 'scss', 'css', 'javascript', 'json', 'sh', 'tex', 'html', 'xml', 'yaml'],
      \ 'passive_filetypes': ['puppet'] }
set statusline+=%{SyntasticStatuslineFlag()}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup snippets
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
  source ~/.vim/snippets/support_functions.vim
catch
  source ~/vimfiles/snippets/support_functions.vim
endtry
autocmd vimenter * call s:SetupSnippets()
function! s:SetupSnippets()

"if we're in a rails env then read in the rails snippets
if filereadable("./config/environment.rb")
  try
    call ExtractSnips("~/.vim/snippets/ruby-rails", "ruby")
    call ExtractSnips("~/.vim/snippets/eruby-rails", "eruby")
  catch
    call ExtractSnips("~/vimfiles/snippets/ruby-rails", "ruby")
    call ExtractSnips("~/vimfiles/snippets/eruby-rails", "eruby")
  endtry
endif

try
  call ExtractSnips("~/.vim/snippets/html", "eruby")
  call ExtractSnips("~/.vim/snippets/html", "xhtml")
  call ExtractSnips("~/.vim/snippets/html", "php")
catch
  call ExtractSnips("~/vimfiles/snippets/html", "eruby")
  call ExtractSnips("~/vimfiles/snippets/html", "xhtml")
  call ExtractSnips("~/vimfiles/snippets/html", "php")
endtry
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only show cursorline in the current window and in normal mode.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup cline
  au!
  au WinLeave * set nocursorline
  au WinEnter * set cursorline
  au InsertEnter * set nocursorline
  au InsertLeave * set cursorline
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use a bar-shaped cursor for insert mode.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make sure Vim returns to the same line when you reopen a file.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shut up backup files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set undodir=/tmp/   
set backupdir=/tmp/
set directory=/tmp/
set backup        
set noswapfile   

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use the mouse to scroll
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a
set ttymouse=xterm2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Useful maps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap jk <esc>l
inoremap JK <esc>l

" indent file
nnoremap <leader>f <esc>:normal mdG=gg`d<cr>

"run current file
inoremap \] <esc>:w <enter> <esc> :!ruby % <cr>
nnoremap <leader>] :w <enter> :!ruby % <cr>

inoremap ;w <esc>:w
inoremap :w <esc>:w
inoremap ;q <esc>:q
nnoremap j gj
nnoremap k gk
nnoremap <leader>tn :tabnew<cr>
nnoremap < <c-w><
nnoremap > <c-w>>

"copy and paste from clipboard
vnoremap Y "+y
nnoremap P "+p
"with this line, 'y' and 'p' play fine with the clipboard
"set clipboard=unnamed

"list lines with the word under the cursor and ask which one you wanna jump to
nnoremap ,f [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

"insert and remove comments in visual and normal mode
vnoremap ,c :s/^/#/g<CR>:let @/ = ""<CR>
nnoremap ,c :s/^/#/g<CR>:let @/ = ""<CR>
vnoremap ,r :s/^#//g<CR>:let @/ = ""<CR>
nnoremap ,r :s/^#//g<CR>:let @/ = ""<CR>

"previous tab
nnoremap gr gT 

"open todo list
nnoremap <leader>td :100vs ~/.todo.txt<cr> :set wrap<cr>

"highlight word under cursor w/o moving the cursor position
nnoremap ! *<c-o>

"edit and source vimrc
nnoremap <leader>ev :100vs  ~/.vim/vimrc<cr>
nnoremap <leader>sv :source ~/.vim/vimrc<cr>

"ack
nnoremap <leader>bb :Ack 'debugger'<cr>
nnoremap <leader>ss :Ack ""<left>
nnoremap <leader>ls :Ack <up>

nnoremap <leader>q :q<cr>

"bind :Q to :q
command! Q q 

nnoremap ,s :SplitjoinSplit<cr>
nnoremap ,j :SplitjoinJoin<cr>

