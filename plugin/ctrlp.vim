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
let g:ctrlp_custom_ignore = '\v(node_modules|
                               \bower_components|
                               \_bower|
                               \log|
                               \vendor|
                               \_site|
                               \generated|
                               \dist|
                               \\.class|
                               \test_out)'

nnoremap ,s :exec "CtrlPLine " . bufname('%')<CR>
