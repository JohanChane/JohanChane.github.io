# bash 快捷键

### refer:

man bash: READLINE 章节

### 行编辑器

其实我们输入命令是用一个行编辑器的东西。记住一些快捷键会让我们输入命令更加有效率。

既然是编辑器就涉及一些编辑习惯的问题。linux 有一些经典的编辑器。比如：vi, emacs。bash 的行编辑器一般默认是 emacs 的编辑习惯。

但是可通过下面命令修改为其他编辑器习惯：
> `bind -m {emacs, emacs-standard, emacs-meta,  emacs-ctlx,  vi,  vi-move,  vi-command, and vi-insert}`

### bash 常用快捷键

bash 有很多快捷键，但是有常用与不常用的，按自己的需求来记忆常用的快捷键即可。有如下需求：

> *`(C-r)`: C 表示 ctrl*
> 
> *`(M->)/(A->)`: M/A 表示 alt*

- 移动

    - 词间移动：`M-B, M-F`        # B：backward, F: forward
    
    - 行首尾移动：`C-A, C-E`
    
- 删除

    - 删除词：`C-w, M-backspce`

		*`C-w` 是 unix 删除，与 `M-backspce` 区别是 `C-w` 以空白符为词的分隔符，而 `M-backspce` 以非 Alpha 为分隔符。Alpha 是 26 字母加下划线。`C-w` 较为常用。*

    - 删除行：`C-u`
    
- 向前搜索历史命令：`C-r`
	
	*可按多次*
	
- 转到空白行（最后一个历史命令）: `M->`
  
	*应用场景：`C-r` 没有搜索出合适的命令，重新转到空白行输入命令。*
	
- 上一个命令的最后一个参数：`M-`.

	*可按多次。这个就很常用了。*
	
- 重复前一个参数：`{C-w, C-y, C-y}` 

	*应用场景：最后两个参数很长且差不多相同。*
	
- 复制, 粘贴：`C-insert, shift-insert`

	*与 vim 相同。软件一般设置选中即复制了，所以记粘贴即可。*

- 切换 job: `C-z, %+(%), %-, %n, jobs`

	*请记住 `%` 代表 `%+`， 这样就能更方便地切换 jobs。*

### 搜索可执行命令

	compgen -c | grep <command>		# compgen -c 列出 shell 所知的所有命令。`

此命令的作用：

- 因为 TAB 只能根据前面的字符进行联想，如果忘记前面字符，可用此命令查找。*比如：*
	
		`compgen -c | grep _release`
	
- 列出相关的所有命令。*比如：*
	
		`compgen -c | grep pci`

### 目录切换

	cd -

### bash-completion 软件

使的 TAB 能补全参数。

---

觉得在 bash 打命令很烦，可能是你没有记住常用的快捷键而已。同理也可记一下 windows 一些关于编辑的快捷方式。比如：删除一个词等。

以上东西基本够用，想要更加详细的说明，可查官方文档。man bash: READLINE 章节。
