INSTALLDIR=~/dotfiles
DIR=$(INSTALLDIR)/files
BACKUPDIR=backups
BACKUPTMP=dotfilesbackup
FILES=gitconfig sbclrc tmux.conf vim vimrc zcompdump zshrc

.PHONY : newinstall vimplugins install remove backup backupdir

replace: backup remove newinstall

newinstall: install vimplugins

vimplugins: 
	mkdir -p $(DIR)/vim/bundle
	cd $(DIR)/vim/bundle && git clone https://github.com/gmarik/Vundle.vim
	vim -u $(DIR)/vimrc.installation +PluginInstall +qall

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
