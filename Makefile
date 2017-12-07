install:
	git submodule update --init
update:
	git pull
	git submodule sync
	git submodule update --init

