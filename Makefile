install:
	@echo Installing...
	ln -fs ~/.vim/vimrc ~/.vimrc
	mkdir -p ~/.config/nvim
	ln -fs ~/.vim/init.vim ~/.config/nvim/init.vim
	ln -fs ~/.vim/.tern-project ~/.tern-project
	vim -S snapshot.vim +qa
	if [ -a bundle/tern_for_vim/node_modules/tern/plugin/modules.js ]; then sed -i'.bak' -e $$'s/\.js\$$/.jsx?/g' -e $$'s/if (server.findFile(path + ".js")) return path + ".js"/if (server.findFile(path + ".js")) return path + ".js"\\\n    if (server.findFile(path + ".jsx")) return path + ".jsx"/g' bundle/tern_for_vim/node_modules/tern/plugin/modules.js; fi;
	if [ -a bundle/YouCompleteMe/third_party/ycmd/third_party/tern_runtime/node_modules/tern/plugin/modules.js ]; then sed -i'.bak' -e $$'s/\.js\$$/.jsx?/g' -e $$'s/if (server.findFile(path + ".js")) return path + ".js"/if (server.findFile(path + ".js")) return path + ".js"\\\n    if (server.findFile(path + ".jsx")) return path + ".jsx"/g' bundle/YouCompleteMe/third_party/ycmd/third_party/tern_runtime/node_modules/tern/plugin/modules.js; fi;
	@echo Done

.PHONY: install
