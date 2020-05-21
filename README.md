# Installation
--------------

To install:
```sh
git clone https://github.com/shenbin04/vim-config.git ~/.vim
cd ~/.vim && ./install.sh
```

To install project specific config (optional), add below code to .vimrc.local (either ~/.vim/.vimrc.local or <project>/.vimrc.local)
```vim
set runtimepath+=$HOME/.vim/bundle/vim-config-projects/<project>
```
