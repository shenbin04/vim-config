# Installation
--------------

To install:
```sh
git clone https://bitbucket.org/shenbin04/vim-config ~/.vim
cd ~/.vim && make install
```

To update:
```sh
make update
```

To install YouCompleteMe (optional):
```sh
# make sure you have python installed
# and `node` for `--tern-completer` option
# and `go` for `--gocode-completer` option
cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer --tern-completer --gocode-completer
```
