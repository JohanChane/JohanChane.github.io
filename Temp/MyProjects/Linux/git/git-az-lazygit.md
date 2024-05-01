# lazygit

[用最高效的工具，学会Git最强的功能 —— 命令行神器 Lazygit](https://www.bilibili.com/video/BV1gV411k7fC?from=search&seid=1428657935457952894)

## lazygit branch arrow 的意思

> 向上箭头的数字表示，表示需要 push 的 commits 的数量。即 HEAD 与其相对应的 remote 分支相差的 commits 数量。<br>
> 向下箭头的数字表示，表示需要 pull 的 commits 的数量。即远程的分支与其相对应的 remote 分支相关的 commits 数量。

## 操作

    # stage/unstage 文件的行
    file 窗口 -> enter -> 空格选中行。

    # commit 文件中，筛选 patch，并应用到其他地方。
    commits 窗口 -> enter -> enter -> 空格选中行 -> ctrl + p

    # git commit --fixup
    commits 窗口 -> F

    # git rebase -i
    commits 窗口 -> e -> p(ick)/f(ixup)/s(quash)/d(rop) -> m

    # cherry-pick
    commits 窗口 -> c... -> 转到要粘贴的分支 -> v

    # diff
    commits 窗口 -> w -> 移到光标到要比对的 commits

    # 查看一个文件的所有历史记录
    ctrl + s

    # log
    commits 窗口 -> ctrl + l -> show git graph... -> ctrl + l -> toggle show whole git graph

    # undo
    commits 窗口 -> ctrl + z

    # git reset/clean
    g
    files 窗口 -> D/d
