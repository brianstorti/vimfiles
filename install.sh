#!/bin/bash

if [ -d ~/.vim ]; then
  echo "\033[0;34m~/.vim found. Creating backup for it at '~/.vim.bkp.$$' before proceeding\033[0m"
  mv ~/.vim ~/.vim.bkp.$$
fi

echo "\033[0;34mCloning repository\033[0m"
git clone git://github.com/brianstorti/vimfiles.git ~/.vim

echo "\033[0;34mInstalling vundle\033[0m"
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo "\033[0;34mLinking .vimrc\033[0m"
ln -sf ~/.vim/vimrc ~/.vimrc

echo "\033[0;34mInstalling plugins\033[0m"
vim -c "BundleInstall"
