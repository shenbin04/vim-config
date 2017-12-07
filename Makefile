install:
	ln -fs ~/.vim/vimrc ~/.vimrc
	git submodule update --init

update:
	git pull
	git submodule sync
	git submodule update --init
