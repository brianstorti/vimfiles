#!/bin/bash

echo "\033[0;34mCloning repository\033[0m"
git clone git://github.com/brianstorti/vimfiles.git ~/.vim

echo "\033[0;34mInstalling vundle\033[0m"
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo "\033[0;34mLinking .vimrc\033[0m"
ln -sf ~/.vim/vimrc ~/.vimrc

echo "\033[0;34mInstalling plugins\033[0m"
vim -c "BundleInstall"
