set nocompatible
filetype off

set rtp+=~/.vim/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'L9'
Bundle 'altercation/vim-colors-solarized'
Bundle 'chrisbra/color_highlight'
Bundle 'kana/vim-textobj-user'
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-commentary'
Bundle 'vim-ruby/vim-ruby'
Bundle 'bling/vim-airline'
Bundle 'tomtom/quickfixsigns_vim'
Bundle 'majutsushi/tagbar'

" clojure
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-classpath'
Bundle 'guns/vim-clojure-static'

" snippets
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'

" tmux
Bundle 'jgdavey/tslime.vim'
