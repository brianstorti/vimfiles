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
set cmdheight=2
set switchbuf=useopen
set number
set numberwidth=5
set showtabline=2
"set winwidth=79
set shell=bash
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
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%) "\ %{fugitive#statusline()}
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>y "*y
" Make <leader>' switch between ' and "
nnoremap <leader>' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
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
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

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
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
:normal! dd
" :exec '?^\s*it\>'
:normal! P
:.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
:normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EXTRACT VARIABLE (SKETCHY
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ExtractVariable()
let name = input("Variable name: ")
if name == ''
  return
endif
" Enter visual mode (not sure why this is needed since we're already in visual mode anyway)
normal! gv

" Replace selected text with the variable name
exec "normal c" . name
" Define the variable on the line above
exec "normal! O" . name . " = "
" Paste the original selected text to be the variable value
normal! $p
endfunction
vnoremap <leader>rv :call ExtractVariable()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INLINE VARIABLE (SKETCHY
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InlineVariable()
" Copy the variable under the cursor into the 'a' register
:let l:tmp_a = @a
:normal "ayiw
" Delete variable and equals sign
:normal 2daW
" Delete the expression into the 'b' register
:let l:tmp_b = @b
:normal "bd$
" Delete the remnants of the line
:normal dd
" Go to the end of the previous line so we can start our search for the
" usage of the variable to replace. Doing '0' instead of 'k$' doesn't
" work; I'm not sure why.
normal k$
" Find the next occurence of the variable
exec '/\<' . @a . '\>'
" Replace that occurence with the text we yanked
exec ':.s/\<' . @a . '\>/' . @b
:let @a = l:tmp_a
:let @b = l:tmp_b
endfunction
nnoremap <leader>ri :call InlineVariable()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPS TO JUMP TO SPECIFIC COMMAND-T TARGETS AND FILES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>gr :topleft :split config/routes.rb<cr>
function! ShowRoutes()
" Requires 'scratch' plugin
:topleft 100 :split __Routes__
" Make sure Vim doesn't write __Routes__ as a file
:set buftype=nofile
" Delete everything
:normal 1GdG
" Put routes output in buffer
:0r! rake -s routes
" Size window to number of lines (1 plus rake output length)
:exec ":normal " . line("$") . "_ "
" Move cursor to bottom
:normal 1GG
" Delete empty trailing line
:normal dd
endfunction
map <leader>x :CommandT<cr>
map <leader>z :CommandTFlush<cr>\|:CommandT extensions<cr>
map <leader>gR :call ShowRoutes()<cr>
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
map <leader>gs :CommandTFlush<cr>\|:CommandT public/stylesheets/sass<cr>
map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>gt :CommandTFlush<cr>\|:CommandTTag<cr>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
let new_file = AlternateForCurrentFile()
exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
let current_file = expand("%")
let new_file = current_file
let in_spec = match(current_file, '^spec/') != -1
let going_to_spec = !in_spec
let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1
if going_to_spec
  if in_app
    let new_file = substitute(new_file, '^app/', '', '')
  end
  let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
  let new_file = 'spec/' . new_file
else
  let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
  let new_file = substitute(new_file, '^spec/', '', '')
  if in_app
    let new_file = 'app/' . new_file
  end
endif
return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

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
" OpenChangedFiles COMMAND
" Open a split for each dirty file in git
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenChangedFiles()
only " Close all windows, unless they're modified
let status = system('git status -s | grep "^ \?\(M\|A\)" | cut -d " " -f 3')
let filenames = split(status, "\n")
exec "edit " . filenames[0]
for filename in filenames[1:]
  exec "sp " . filename
endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

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

let g:ackprg="ack -H -i --column --follow"
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
" InsertTime COMMAND
" Insert the current time
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>


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
"
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
" Use a bar-shaped cursor for insert mode, even through tmux.
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

nnoremap ; :
inoremap ;w <esc>:w
inoremap ;q <esc>:q
nnoremap qq :q<cr>
nnoremap j gj
nnoremap k gk
nnoremap <leader>tn :tabnew<cr>
nnoremap < <c-w><
nnoremap > <c-w>>
nnoremap <leader>ss :mksession!<cr>

"copy and paste from clipboard
vnoremap Y "+y
nnoremap P "+p

"list lines with the word under the cursor and ask which one you wanna jump to
nnoremap ,f [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

"insert and remove comments in visual and normal mode
vnoremap ,c :s/^/#/g<CR>:let @/ = ""<CR>
nnoremap ,c :s/^/#/g<CR>:let @/ = ""<CR>
vnoremap ,r :s/^#//g<CR>:let @/ = ""<CR>
nnoremap ,r :s/^#//g<CR>:let @/ = ""<CR>

"previous tab
nnoremap gr gT 

"go to tab
nnoremap g1 1gt
nnoremap g2 2gt
nnoremap g3 3gt
nnoremap g4 4gt
nnoremap g5 5gt
nnoremap g6 6gt
nnoremap g7 7gt
nnoremap g8 8gt
nnoremap g9 :tabl<cr> 

"open todo list
nnoremap <leader>td :100vs ~/.todo.txt<cr> :set wrap<cr>

"use '!' to highlight word under cursor w/o moving the cursor position
nnoremap ! *<c-o>

"edit and source vimrc
nnoremap <leader>ev :100vs  ~/.vim/vimrc<cr>
nnoremap <leader>sv :source ~/.vim/vimrc<cr>
