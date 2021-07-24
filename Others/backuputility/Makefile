.PHONY: all install uninstall

all: install

install:
	mkdir -p ~/.config/backuputility
	cp ./default.conf ~/.config/backuputility/backuputility.conf
	mkdir ~/BackupUtilityRecords
	cp ./default.confs.record ~/BackupUtilityRecords/confs
	cp ./default.backuputility_cmd ~/BackupUtilityRecords/backuputility_cmd
	chmod a+x ~/BackupUtilityRecords/backuputility_cmd
	mkdir ~/BackupUtilityBackups

uninstall:
	@echo 'rm -r ~/BackupUtilityRecords'
	@echo 'rm -r ~/BackupUtilityBackups'
	@echo 'rm -r ~/BackupUtilityCmdOutput'
