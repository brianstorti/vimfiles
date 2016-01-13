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
                               \build|
                               \\.tmp|
                               \deps|
                               \\.git|
                               \\.beam|
                               \test_out)'

nnoremap ,s :exec "CtrlPLine " . bufname('%')<CR>
