if executable('ag')
  let g:ctrlp_user_command = 'ag %s -g ""'
endif

let g:ctrlp_working_path_mode = 0
let g:ctrlp_switch_buffer = '0'
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_abbrev = {
            \ 'gmode': 't',
            \ 'abbrevs': [
            \ { 'pattern': '^a/', 'expanded': 'app/' },
            \ { 'pattern': '^c/', 'expanded': 'app/controllers/' },
            \ { 'pattern': '^m/', 'expanded': 'app/models/' },
            \ { 'pattern': '^v/', 'expanded': 'app/views/' },
            \ { 'pattern': '^h/', 'expanded': 'app/helpers/' },
            \ { 'pattern': '^se/', 'expanded': 'app/serializers/' },
            \ { 'pattern': '^f/', 'expanded': 'test/fixtures/' },
            \ { 'pattern': '^t/', 'expanded': 'test/' },
            \ { 'pattern': '^g/', 'expanded': 'app/models/graph/' },
            \ { 'pattern': '^s/', 'expanded': 'spec/' }
            \ ]
            \ }
let g:ctrlp_custom_ignore = '\v(node_modules|
                               \bower_components|
                               \_bower|
                               \vendor|
                               \_site|
                               \generated|
                               \dist|
                               \\.class|
                               \\.tmp|
                               \deps|
                               \\.git|
                               \\.beam|
                               \\.beam|
                               \priv/static|
                               \elm-stuff|
                               \test_out)'

nnoremap ,s :exec "CtrlPLine " . bufname('%')<CR>
