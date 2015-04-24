#!/usr/bin/env bash

print_message() {
  echo "\033[1;32m"$1"\033[00m";
}

print_warning() {
  echo "\033[1;33m"$1"\033[00m";
}

print_error() {
  echo "\033[1;31m"$1"\033[00m";
}

if ! type git > /dev/null 2>&1; then
  print_error "This script depends on 'git' to work. Please make sure that it is installed and try to run this script again."
  exit 1
fi

if [ -d ~/.vim ]; then
  print_warning "~/.vim found. Creating a backup for it at '~/.vim.bkp.$$' before proceeding."
  mv ~/.vim ~/.vim.bkp.$$
fi

print_message "Cloning repository."
git clone git://github.com/brianstorti/vimfiles.git ~/.vim

print_message "Installing Vundle."
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

if [ -e ~/.vimrc ]; then
  print_warning "~/.vimrc found. Creating a backup for it at  '~/.vimrc.bkp.$$' before proceeding."
  mv ~/.vimrc ~/.vimrc.bkp.$$
fi

print_message "Linking .vimrc"
ln -sf ~/.vim/vimrc ~/.vimrc

print_message "Installing plugins."
vim -c "BundleInstall"
