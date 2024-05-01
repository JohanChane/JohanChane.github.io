.PHONY: all install uninstall

all: install

install:
	mkdir -p ~/.config/backuputility
	configFile=~/.config/backuputility/backuputility.conf; \
	if [[ ! -f $$configFile ]]; then \
		cp ./default.conf $$configFile; \
	fi
	@echo '手动将 backuputility 程序加入 path。'

uninstall:
	@echo '手动 rm ~/.config/backuputility/backuputility.conf'
	@echo '手动 rm record_dir cmd_dir dest_dir'
