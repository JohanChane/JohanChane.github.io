backuputility
===

### 说明

支持 linux 和 windows(msys2)。

所有文件的格式都为 `utf-8 nobomb`。

### 帮助

`backuputility {-h | --help}`

### 配置文件

`~/.config/backuputility/backuputility.conf`

for example

```
[base]
dest_dir = /b/backupsOfbackupUtility
record_dir = /home/johan/backuputilityRecords
```

`dest_dir`

> 备份到哪个目录

`record_dir`

> 备份文件的记录。记录哪些文件需要备份。  
> 支持 linux 路径格式。windows 路径格式，比如: `C:\dir\subdir`, `C:/dir/subdir`。  
> *可以添加注释。*

### 例子

#### records

`/home/johan/backuputilityRecords/confs`

```
# ### backuputility
/opt/myapps/backuputility/
/home/johan/.config/backuputility/
/home/johan/backuputilityRecords/

# ### system config files
/etc/fstab
/boot/grub/grub.cfg
/etc/environment
/home/johan/.pam_environment
/home/johan/.xprofile
/usr/share/rime-data/default.yaml

# #### bash
/home/johan/.bashrc
/root/.bashrc
# #### zsh
/home/johan/.zshrc

# #### pacman
/etc/pacman.d/mirrorlist
/etc/pacman.conf
# #### neovim
/home/johan/.config/nvim/init.vim
/home/johan/.config/nvim/coc-settings.json
/root/.config/nvim/init.vim
/home/johan/.config/nvimpager/init.vim
```

`/home/johan/backuputilityRecords/apps`

```
...
```

#### 命令

    # 检查不存在的文件
    backuputility -c confs apps
    # 检查重复的文件
    backuputility -D confs apps
    # 备份文件
    backuputility confs apps

    # 添加，删除，查看（建议直接编辑）
    backuputility -a <file> confs
    backuputility -d <file> confs
    backuputility -l confs apps
