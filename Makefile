INSTALLDIR=~/dotfiles
DIR=$(INSTALLDIR)/files
BACKUPDIR=backups
BACKUPTMP=dotfilesbackup
FILES=gitconfig sbclrc tmux.conf vim vimrc zcompdump zshrc stumpwmrc

help:
	@echo Help:
	@echo "  make help"
	@echo "  make replace: backup remove newinstall"
	@echo "  make vimplugins: vundle"
	@echo "  make newinstall: install vimplugins"
	@echo "  make vimplugins: vundle"

replace: backup remove newinstall

newinstall: install vimplugins

vimplugins: vundle
	vim -u vimrc.installation +PluginInstall +qall

vundle:
	mkdir -p $(DIR)/vim/bundle
	git clone https://github.com/gmarik/Vundle.vim $(DIR)/vim/bundle/Vundle.vim

install: $(FILES:%=%.install) 

remove: $(FILES:%=%.remove) 

backup: backupdir $(FILES:%=%.backup)
	tar cf $(BACKUPDIR)/backup-`date +'%y.%m.%d-%H:%M:%S'`.tar $(BACKUPTMP)
	rm -rf $(INSTALLDIR)/$(BACKUPTMP)

backupdir:
	mkdir -p $(INSTALLDIR)/$(BACKUPTMP)
	mkdir -p $(INSTALLDIR)/$(BACKUPDIR)

%.install: 
	ln -s $(DIR)/$(@:%.install=%) ~/$(@:%.install=.%)

%.remove:
	rm -fr ~/$(@:%.remove=.%)

%.backup: 
	cp -a ~/$(@:%.backup=.%) $(INSTALLDIR)/$(BACKUPTMP)/$(@:%.backup=%)
