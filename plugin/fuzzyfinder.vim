" Need to `brew install fzy ag`

function! FuzzyfinderCommand(vim_command)
  try
    let selection = system("ag . --silent -l -g '' | fzy ")
  catch /Vim:Interrupt/
    redraw!
    return
  endtry
  redraw!

  if !empty(selection)
    exec a:vim_command . " " . selection
  endif
endfunction

nnoremap <c-p> :call FuzzyfinderCommand(":e")<cr>
nnoremap <c-t> :call FuzzyfinderCommand(":tabnew")<cr>
nnoremap <c-u> :call FuzzyfinderCommand(":vs")<cr>
