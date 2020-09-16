# Line Diff

### Refers

- <https://github.com/AndrewRadev/linediff.vim>

### 使用

Linediff
LinediffAdd, LinediffLast
tabclose

for example:

    ABCDEFGHIJKLMN
    OPQRSTUVWXYZ

    ABCDEFGHIIKLMN
    OPQRSTUUWXYZ

    ABCDEFGHIJKLNN
    OPQRSTUVVXYZ

    # 比较两个区块 
    :1, 2Linediff
    :4, 5Linediff
    :tabclose       " diff 的信息也会丢失，下次再比较时，要重新选。

    # 比较多个区块
    :1, 2Linediff
    :4, 5LinediffAdd
    :7, 8LinediffLast
    :tabclose
