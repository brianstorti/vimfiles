function! VisualAckSearch()
  let temp = @s
  norm! gv"sy
  return ':Ack! "' . EscapeAllString(@s) . '"'
endfunction

function! EscapeAllString(text)
  return substitute(escape(a:text, '*^$.?/\|{[()]}'), '\n', '\\n', 'g')
endfunction

let g:ackprg="ag --nogroup --nocolor --column --follow
              \ --ignore-dir='log'
              \ --ignore-dir='bower_components'
              \ --ignore-dir='_bower'
              \ --ignore-dir='node_modules'
              \ --ignore-dir='_site'
              \ --ignore-dir='generated'
              \ --ignore-dir='OisServer'
              \ --ignore-dir='test_out'"

let g:ackhighlight=1
vnoremap ,as :<C-u>exec VisualAckSearch()<CR>
nnoremap <leader>ss :Ack! ""<left>
nnoremap <leader>ls :Ack! <up>
