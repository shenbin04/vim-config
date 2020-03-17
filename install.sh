#!/usr/bin/env bash

echo 'Installing...'

ln -fs ~/.vim/vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -fs ~/.vim/init.vim ~/.config/nvim/init.vim
ln -fs ~/.vim/.tern-project ~/.tern-project
vim -S snapshot.vim +qa

pip install virtualenvwrapper
mkvirtualenv --python=python2 vim
pip install msgpack==0.6.1
pip install pynvim
mkvirtualenv --python=python3 vim
pip install msgpack==0.6.1
pip install pynvim
pip install python-language-server
pip install yapf

npm install -g neovim@4.6.0

echo 'Done'
