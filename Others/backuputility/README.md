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
dest_dir = /home/johan/BackupUtilityBackups
record_dir = /home/johan/BackupUtilityRecords
cmd_path = /home/johan/BackupUtilityRecords/backuputility_cmd
```

`dest_dir`

> 备份到哪个目录

`record_dir`

> 备份文件的记录。记录哪些文件需要备份。<br>
> 支持 linux 路径格式。windows 路径格式，比如: `C:\dir\subdir`, `C:/dir/subdir`。<br>
> *可以添加注释。*

`cmd_path`

> 执行脚本的路径。记录命令的输出。因为有时候要记录系统的状态。比如：`pacman -Qeq, pip list` 等。<br>
> 实现细节。脚本中的命令将结果输出到一个个文件，然后这些文件的路径添加到 record 中即可。

### 例子

#### records

`/home/johan/BackupUtilityRecords/backuputility_cmd`

```
#!/bin/bash

old_pwd=$(pwd)
cd /home/johan/BackupUtilityCmdOutput

# add cmds here
pacman -Qeq > ./pacmanQeq
pacman -Qeq | xargs expac -Q --timefmt='%Y-%m-%d %T' '%l\t%n' | sort -nr | awk '{print $1" "$2"\t"$3}' > ./expacqe

cd $old_pwd
```

`/home/johan/BackupUtilityRecords/confs`

```
# ### backuputility
/opt/myapps/backuputility/
/home/johan/.config/backuputility/
/home/johan/BackupUtilityRecords/

# #### backuputility_cmd
/home/johan/BackupUtilityCmdOutput

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

    # 执行 cmd
    backuputility -e

    # 执行 cmd 并备份命令的输出（confs record 记得添加输出结果的文件）
    backuputility -e confs

    # 添加，删除，查看（建议直接编辑）
    backuputility -a <file> confs
    backuputility -d <file> confs
    backuputility -l confs apps
