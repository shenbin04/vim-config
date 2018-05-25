install:
	@echo Installing...
	ln -fs ~/.vim/vimrc ~/.vimrc
	mkdir -p ~/.config/nvim
	ln -fs ~/.vim/init.vim ~/.config/nvim/init.vim
	git submodule update --init --recursive
	@echo Done

update:
	@echo Updating...
	git pull
	git submodule sync
	git submodule update --init --recursive
	@echo Done

.PHONY: install update
