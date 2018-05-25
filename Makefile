install:
	@echo Installing...
	ln -fs ~/.vim/vimrc ~/.vimrc
	mkdir -p ~/.config/nvim
	ln -fs ~/.vim/init.vim ~/.config/nvim/init.vim
	ln -fs ~/.vim/.tern-project ~/.tern-project
	git submodule update --init --recursive
	@echo Done

update:
	@echo Updating...
	git pull
	git submodule sync
	git submodule update --init --recursive
	@echo Done

.PHONY: install update
