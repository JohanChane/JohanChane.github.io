# NERDTree help


### Refers

- help NERDTree

### Get help

按 `?` 显示 quickhelp

`help NERDTree-contents` 显示帮助目录

### 配置

map <C-n> :NERDTreeToggle<CR>       " 打开或关闭 NERDTree

### 常用命令

- file node

    preview 与 open 的区别是打开文件后光标的位置。
    o, go, i, gi, s, gs
    
- directory node

    o, p, P, O, X

- filesysteme

    r, m(对 node 添加/删除等), cd(作为当前工作目录)

    - tree root（文件系统正在打开的路径，与当前工作目录不同）

        CD(返回到 tree root), C, u, R

- Bookmark

    B, Bookmark, D, 与 file node 相同的操作

- filtering

    I(隐藏 `.` 开头的文件), f(隐藏特定文件。与 NERDTressIgnore 有关), F(隐藏文件，只能看到目录)

        let NERDTressIgnore=['\.vim$']      " 隐藏 .vim 后缀的文件

