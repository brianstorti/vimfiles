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
