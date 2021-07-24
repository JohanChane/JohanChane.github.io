.PHONY: all install uninstall

all: install

install:
	mkdir -p ~/.config/backuputility
	cp ./default.conf ~/.config/backuputility/backuputility.conf
	mkdir -p ~/BackupUtility/Records
	cp ./default.confs.record ~/BackupUtility/Records/confs
	cp ./default.user_cmds ~/BackupUtility/Cmds/user_cmds
	chmod a+x ~/BackupUtility/Cmds/user_cmds
	mkdir ~/BackupUtilityBackups

uninstall:
	@echo 'rm -r ~/BackupUtility'
	@echo 'rm -r ~/BackupUtilityBackups'
