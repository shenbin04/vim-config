#!/usr/bin/env bash

echo 'Installing...'

ln -fs ~/.vim/vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -fs ~/.vim/init.vim ~/.config/nvim/init.vim
ln -fs ~/.vim/.tern-project ~/.tern-project
vim -S snapshot.vim +qa
echo 'Done'
