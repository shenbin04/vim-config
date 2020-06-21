#!/usr/bin/env bash

command_exists() {
  if ! [[ -x "$(command -v "$1")" ]]; then
    printf '\033[41m ERROR \033[0m `%s` not installed.\n' "$1"
    false
  else
    true
  fi
}

confirm() {
  echo -n "$@? [Y/n] "
  read YN

  if [[ $YN = *n* || $YN = *N* ]]; then
    echo "Skipping ..."
    return 1
  else
    return 0
  fi
}

if [[ -x "$VIRTUAL_ENV" ]]; then
  printf '\033[41m ERROR \033[0m Cannot install within virtualenv, please `deactivate`.\n'
  exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]] && ! command_exists brew; then
  printf '\033[41m ERROR \033[0m Please install homebrew first.\n'
  if confirm 'Do you want to install homebrew now'; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  else
    exit 1
  fi
fi

if ! command_exists nvim; then
  printf '\033[41m ERROR \033[0m Please install nvim first.\n'
  if [[ "$OSTYPE" == "darwin"* ]] && confirm 'Do you want to install nvim now'; then
    brew install neovim
  else
    exit 1
  fi
fi

printf '\033[0;32mInstalling...\033[0m\n'

if command_exists pip && command_exists python && command_exists python3; then
  printf '\033[0;32mInstalling python environments...\033[0m\n'

  pip install virtualenvwrapper
  source $(which virtualenvwrapper.sh)
  mkvirtualenv --python=python2 vim
  pip install msgpack==0.6.1
  pip install pynvim
  mkvirtualenv --python=python3 vim3
  pip install msgpack==0.6.1
  pip install pynvim
  pip install python-language-server
  pip install yapf
  pip install black
fi

if command_exists npm && command_exists node; then
  printf '\033[0;32mInstalling node environments...\033[0m\n'

  node_version_str=$(node --version)
  node_version=${node_version_str:1:1}
  if [ '8' == $node_version ]; then
    npm install -g neovim@4.6.0
  else
    npm install -g neovim
  fi

  npm install -g jsctags
fi

if [[ "$OSTYPE" == "darwin"* ]] && command_exists brew; then
  printf '\033[0;32mInstalling third parity environments...\033[0m\n'
  brew install bat ctags pgformatter
fi

printf '\033[0;32mConfiguring neovim...\033[0m\n'
ln -fs ~/.vim/vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -fs ~/.vim/init.vim ~/.config/nvim/init.vim
ln -fs ~/.vim/.tern-project ~/.tern-project
nvim -S ~/.vim/snapshot.vim +qa

printf '\n\033[0;32mDone\033[0m 🎉\n'
