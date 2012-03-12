LN = @ln -sf

BINSCRIPTS= $(wildcard bin/*)

BINTARGETS = $(patsubst %,~/%, $(BINSCRIPTS))

DOTITEMS = \
~/.zshrc \
~/.zscripts \
~/.re.pl/repl.rc \
~/.lesskey \
~/.gitignore \
~/.vim \
~/.vimrc

install : $(BINTARGETS) $(DOTITEMS) ~/.vim
	
rebuildvim :
	@rebuild-vim.sh

clean :
	@echo removing $(BINTARGETS) $(DOTITEMS)...
	@rm -f $(BINTARGETS) $(DOTITEMS)
	@rm -rf ~/.vim

~/.zshrc : zsh/zshrc
	@echo installing .zshrc...
	$(LN) $(PWD)/zsh/zshrc ~/.zshrc

~/.zscripts : zsh/scripts
	@echo installing .zscripts...
	$(LN) $(PWD)/zsh/scripts ~/.zscripts

~/.re.pl/repl.rc : repl/main.rc
	@echo instaling repl.rc...
	@mkdir -p ~/.re.pl
	$(LN) $(PWD)/repl/main.rc ~/.re.pl/repl.rc

~/.lesskey : lesskey
	@echo installing .lesskey...
	$(LN) $(PWD)/lesskey ~/.lesskey
	@lesskey $<

~/.gitignore : git/gitignore
	@echo installing .gitignore...
	$(LN) $(PWD)/git/gitignore ~/.gitignore

~/bin/% : bin/%
	@echo installing $@...
	@mkdir -p ~/bin
	$(LN) $(PWD)/$< $@

~/.vimrc : vimrc
	@echo installing .vimrc...
	$(LN) $(PWD)/vimrc ~/.vimrc

~/.vim :
	@echo installing .vim...
	@mkdir -p ~/.vim/bundle ~/.vim/autoload
	@wget -q 'https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim' --no-check-certificate -O ~/.vim/autoload/pathogen.vim
	@git clone https://github.com/jasonmay/jasonmay.vim ~/.vim/bundle/jasonmay
	@git clone git://git.wincent.com/command-t.git ~/.vim/bundle/command-t
	@git clone git://github.com/vim-scripts/parrot.vim.git ~/.vim/bundle/parrot
	@git clone git://github.com/msanders/snipmate.vim.git ~/.vim/bundle/snipmate
	@git clone git://github.com/petdance/vim-perl.git ~/.vim/bundle/perl
	@git clone git://github.com/vim-ruby/vim-ruby.git ~/.vim/bundle/ruby
	@git clone git://github.com/tpope/vim-ragtag.git ~/.vim/bundle/ragtag
	@git clone git://github.com/lucasoman/vim-listfile ~/.vim/bundle/listfile

.PHONY : clean install build

