function! VisualAckSearch()
  let temp = @s
  norm! gv"sy
  return ':Ack "' . EscapeAllString(@s) . '"'
endfunction

function! EscapeAllString(text)
  return substitute(escape(a:text, '*^$.?/\|{[()]}'), '\n', '\\n', 'g')
endfunction

let g:ackprg="ag -i --nogroup --nocolor --column --follow --ignore-dir='log'"
let g:ackhighlight=1
vnoremap ,as :<C-u>exec VisualAckSearch()<CR>
nnoremap ,as :Ack<CR>
nnoremap <leader>ss :Ack ""<left>
nnoremap <leader>ls :Ack <up>
