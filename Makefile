install:
	@echo Installing...
	@ln -fs ~/.vim/vimrc ~/.vimrc
	@git submodule update --init
	@echo Done

update:
	@echo Updating...
	git pull
	git submodule sync
	git submodule update --init
	@echo Done

.PHONY: install update
