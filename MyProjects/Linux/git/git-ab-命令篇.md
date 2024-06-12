# Git 的命令篇

## Content

${toc}

## 命令的基础知识

### 命令中的 refspec

    # 推送 local_branch 到 repo/remote_branch
    git push <repo> <local_branch>[:<remote_branch(默认与 local_branch 同名)>]
    # 取回 repo/remote_branch 分支，并与本地的 local_branch 分支合并
    git fetch <repo> <remote_branch>[:<local_branch>(默认与 remote_branch 同名)]

#### refspec 中的 `+` 的作用

[refspec 中的 `+` 的作用](https://git-scm.com/book/en/v2/Git-Internals-The-Refspec)

    # The `+` tells Git to update the reference even if it isn’t a fast-forward. 也可用 `git push --force` 代替。
    [+]<src>:<dst>

for example

```shell
git push -f origin <commit>:branch_name
git push origin +<commit>:branch_name
```

### 一些操作中的 abort, continue, quit

    git merge (--continue | --abort | --quit)
    git rebase (--continue | --skip | --abort | --quit | --edit-todo | --show-current-patch)
    git cherry-pick (--continue | --skip | --abort | --quit)
    git am (--continue | --skip | --abort | --quit | --show-current-patch[=(diff|raw)])

abort 和 quit 的区别

> abort 表示回到操作前的状态，而 quit 表示保留当前的子操作的状态，退出之后的子操作。skip 可以跳过一个子操作。show-current 可以显示当前的子操作。

### 命令中 offset

```shell
# 展开两次更新显示每次提交的内容差异
# +offset or -offset
# 相当于 `git log -p HEAD~2..HEAD`
git log -p -2

# 相当于 `git format-patch -k --stdout HEAD~5..HEAD~3`
git format-patch -k --stdout -2 HEAD~3
```

### 命令中 `-p, --patch` 参数

`-p, --patch` 表示显示补丁。

```shell
# `-p` 显示添加的内容和 index 的补丁
git add -p .

# 恢复指定的文件
git reset -p HEAD~1 -- config.h

git stash push -p -m <msg> -- .

# 显示本地主分支与远程主分支之间的差异
git log -p master..origin/master
```
### 表示仓库文件的 pathspec

for example

```shell
# 查看 commit 的文件内容
git show <commit>:<file>

# [git diff. 仓库文件与非仓库文件的比较](https://stackoverflow.com/a/16683184/16235950)
git diff HEAD:full/path/to/foo full/path/to/bar
```

## git reset

Reset current HEAD to the specified state

*reset 之后，commits 也会被 reset。比如：`git reset --soft HEAD~1` 会删除 HEAD 这个 commit。*

for example

```shell
# 撤消 commit，不修改缓存区与工作区。
git reset --soft HEAD~1
# 撤消 commit，还原缓存区，不修改工作区。默认选项。
git reset [--mix] HEAD~1
# 撤消 commit，还原缓存区和工作区。
git reset --hard HEAD~1

# 恢复指定的文件
git reset --patch HEAD~1 -- config.h
```

## git restore

Restore working tree files

for example

```shell
# -W, --worktree; -S, --staged. 默认是 `-W`. 有 `-S` 时，表示从 HEAD 中恢复，否则，从 index 中恢复。
# 从 index 中恢复 worktree 的文件
git restore -- config.h
# 从 HEAD 恢复 worktree 和 index 的文件。
git restore -W -S -- config.h
# -s, --source. 从 HEAD~1 中恢复 worktree 和 index 的文件
git restore -s HEAD~1 -W -S -- config.h

# 相当于 `git reset --hard`
git restore -W -S -- .
```

## git checkout

Switch branches or restore working tree files

for example

```shell
# ## 切换分支
git checkout master
# 切换到上一个切换的分支
git checkout -

# ## 新建分支
# 新建分支 new_branch, 并设置 new_branch 的 upstream 为 origin/master，然后切换到 new_branch。
# `--track` 是默认的。`--no-track` 表示不设置 upstream。
git checkout [--track] -b new_master origin/master

# 这种方式新建的分支(empty_branch)是没有 commit 记录的
git checkout --orphan empty_branch

# ## 恢复文件（git restore 可以代替）
# 从 index 恢复 worktree 的文件
git checkout -- .
# 从 HEAD~1 恢复 worktree 和 index 的文件
git checkout HEAD~1 -- .
```

## git switch

Switch branches

for example

```shell
# 为了防止 checkout 关键词的理解混乱，git 的新版本已使用 switch 代替。
git switch <branch>
# 切换到上一个切换的分支
git switch -
```

## git rm

Remove files from the working tree and from the index

for example

```shell
# 删除 worktree 和 index 的文件
git rm -- config.h
# 只删除 index 的文件
git rm --cached -- config.h

# 删除 index 的所有文件
git rm --cached -r .
```

## git clean

Remove untracked files from the working tree

*reset 和 checkout 都不会删除新增的文件。*

for example

```shell
# 删除没有被跟踪的文件。`x` 表示不会使用 gitignore, 所以会删除 ignore 的文件。
git clean -df[x]
```

## git diff

for example

```shell
# 比较 worktree 和 index（只比较 tracked files）
git diff
# 比较 worktree 和 HEAD（只比较 tracked files）
git diff HEAD
# 比较 index 和 HEAD
git diff --staged [HEAD]

# ## `git diff` 可用于仓库文件之间的比较，仓库和文件系统的文件的比较。`git diff --no-index` 还可用于文件系统之间的比较。
# commit 之间的比较
git diff HEAD~1 HEAD
# commit 区间的比较
git diff HEAD~3..HEAD
# 文件系统之间的比较
git diff [<options>] --no-index [--] <path> <path>

# [git diff. 仓库文件与非仓库文件的比较](https://stackoverflow.com/a/16683184/16235950)
git diff HEAD:full/path/to/foo full/path/to/bar
```

## git branch

for example

```shell
# ## new/del/copy/rename 分支
# 新建一个分支 new_master
git branch new_master master
# move. 重命名分支
git branch -m master mymaster
# 复制分支。与 rename 类似，但是会复制 oldbranch 的 config and reflog
git branch -c master master1
# 删除分支
git branch -d master

# ## upstream
# 查看 upstream
git branch -vv
# 设置 upstream
git branch -u origin/master master
# 删除 upstream
git branch --unset-upstream master

# ## 列出分支
# 只查看本地分支
git branch
# 只查看远程分支
git branch --remotes
# 查看所有分支
git branch -a
```

## git remote

for example

```shell
# 增加3个远程库地址
git remote add origin https://github.com/JSLite/JSLite.git
git remote set-url --add origin https://gitlab.com/wang/JSLite.js.git
git remote set-url --add origin https://oschina.net/wang/JSLite.js.git

git remote rename origin myorigin
git remote remove origin

git remote -v
git remote -vv

# 如果远程的仓库的分支删除了，而本地的 remote 分支没有删除时，可用此命令删除过时的 remote branch。
git remote prune origin
```

## git commit

for example

```shell
git commit -m "Initial commit"
# commit 时显示 patch
git commit -p
# 跳过使用暂存区域，把所有已经跟踪过的文件暂存起来一并提交
git commit -a

# 修改最后一次提交
git commit --amend

# 提交一个新的 commit。但与 commit 的差别是，只是在指定的 commit（默认是 HEAD） 的 msg 前面添加 fixup! or squash!
git commit --fixup[=<commit>]
git commit --squash[=<commit>]
# 只是在指定的 commit 的 msg 前添加 `amend!` or `reword!`
git commit --fixup=amend:<commit>
git commit --fixup=reword:<commit>
# 将 msg 开头是 `fixup!` or `squash!` 的 commit 的 rebase 操作改为 `fixup` or `squash`。
git rebase -i --autosquash
```

## git add

for example

```shell
git add .
# `-p` 显示添加的内容和 index 的补丁
git add -p .
```

## git push

for example

```shell
# ## branch
git push origin master
# 将本地的分支 master 推送到远程分支 master1
git push origin master:master1

# delete
git push -d origin <branch>

# ## 远程操作标签
# 提交标签
git push origin v1.0.0
# 提交所有标签
# 在本地删除后，用此方法不能删除 remote tags
git push origin --tags
# 删除标签
git push origin --delete v1.0.0
```

## git pull

for example

```shell
git pull
git pull origin master
# 合并操作用 rebase。默认是 merge。
git pull --rebase
# 合并操作只用 fast-forward
git pull --ff-only

# 取回origin主机的next分支，与本地的master分支合并
git pull origin next:master

# 如果远程主机删除了某个分支，默认情况下，git pull 不会在拉取远程分支的时候，删除对应的本地分支。
git pull -p
# 等同于下面的命令
git fetch --prune origin
git fetch -p
```

## git fetch

fetch and pull 的区别

> pull 相当于 `git fetch; git merge FETCH_HEAD`。

for example

```shell
git fetch
git fetch origin
# 取回origin主机的next分支，与本地的master分支合并
git fetch origin next:master
# 拉取远程分支时，自动删除 remote 过时（远程已删除的分支）的分支。
git fetch --prune

git fetch --tags --shallow-exclude v4.1
git fetch --tags --shallow-since 2016-01-01
```

## git merge

for example

```shell
# 当前分支与 master 合并
git merge master
```

## git rebase

for example

```shell
# 当前分支与 master 分支合并
# 将两个分支相对于它们共同祖先的补丁和修改应用于它们的共同祖先。不同于 merge，branch 不会增加 commit，只是用新 commit 替换旧的 commit。
git rebase master

# pick 第一个 commit patch（如果将所有的pick都改为了 fixup or squash 那就没有合并的载体了），fixup or squash 其他 commit patchs。
# fixup 与 squash 区别：fixup 不保留 commit messages.
git rebase -i HEAD~4

# 将 msg 开头是 `fixup!` or `squash!` 的 commit 的 rebase 操作改为 `fixup` or `squash`。
git rebase -i --autosquash
```

## git revert

for example

```shell
# 添加一个与 HEAD~1 相反操作的 commit。
git revert HEAD~1
```

## git cherry-pick

[Git Cherry Pick](https://www.atlassian.com/git/tutorials/cherry-pick)

[git cherry-pick 教程](https://www.ruanyifeng.com/blog/2020/04/git-cherry-pick.html)

作用

> 将某个分支一个或多个 commits 复制到另一个分支。

for example

```shell
# 拣选 commit，并将 commit 合并到当前分支。这会添加多个 commit(s)。
git cherry-pick <commit(s)>
# 拣选 commit，并将 commit 合并到当前分支的 worktree and index。
git cherry-pick -n commit
```

## git stash

for example

```shell
# ### list/show
git stash list
# 查看 stash 的内容
git stash show -p stash@{<N>}

# ### push
git stash
# 可添加 msg
git stash push -p -m <msg> -- .

# ### apply/pop
# 不同于 pop, 这个不删除 stash
git stash apply [--index] [<stash>]
# 默认不恢复 index
git stash pop [--index] [<stash>]

# ### drop/clear
git stash drop [<stash>]
git stash clear

# ### Others
# 将 stash 作为新的分支，并删除 stash
git stash branch <branchname> [<stash>]
```

## git tag

for example

```shell
# ## 本地操作标签
# 列出标签
git tag -l
# 附注标签
git tag -a v1.4 -m "my version 1.4"
git tag -a v1.2 <commit>
# 轻量标签
git tag v1.4
# 查看标签
git show <tag>
# 删除标签
git tag -d v1.4
```

## git log

for example

```shell
# all 显示所有引用；abbrev-commit 显示 shortid
git log --graph --pretty=oneline --abbrev-commit [--all]

# 显示本地主分支与远程主分支之间的差异
git log -p master..origin/master
# 展开两次更新显示每次提交的内容差异
# +offset or -offset
# 相当于 `git log -p HEAD~2..HEAD`
git log -p -2
# 一天内的提交
git log --since=1.day
# 浏览 commit 相关的文件
git log --stat
# 某次的改动的修改记录
git log -p <commit>
git show <commit>
# 显示文件的每一行是在那个版本最后修改。
git blame 文件名
```

## git reflog

记录用户的所有操作，用于回滚。用户操作修改了分支时，会为修改后的分支添加一个 commit 对象。用户回滚时，只要 checkout 这个 commit 即可。

```shell
# 列出总的 reflog。HEAD 在此不代表当前分支。
git reflog [HEAD]
# 列出该分支的 reflog。不记录 staged change 操作。
git reflog <branch>
git checkout HEAD@{<N>}
git show HEAD@{<N>}

# 删除 reflog
git reflog expire --expire=1.month.ago
git reflog expire --expire=all
```

## git config

### git config origin and scope

-   系统配置

    origin is `/etc/gitconfig`.
    scope is `system`.

    `git config --system` 选项会读写该配置。

-   全局配置（用户配置）

    origin is `~/.gitconfig 或 ~/.config/git/config`
    scope is `global`.

    `git config --global` 选项会读写该配置。

-   本地配置（仓库配置）

    origin is `<git仓库>/.git/config`
    scope is `local`.

    `git config --local` 选项会读写该配置。默认选项。

### 基本概念

> 在不同范围内，一个名字可有多个值。而且在同一范围内，也可以如此。

for example

```shell
git config --add core.editor "vim"
git config --add core.editor "nvim"

# 查看名字的值
git config --get core.editor
# scope is local
git config --get-all core.editor

# 名字只有一个值时才可用
git config --replace core.editor "nvim"
# scope is local
git config --replace-all core.editor "nvim"

# 名字只有一个值时才可用
git config --unset core.editor "nvim"
# scope is local
git config --unset-all core.editor "nvim"
```

### git config 的基本操作

```shell
# ### list
# 查看所有配置的信息。不指定 scope 时，包括 `system, global, local`。
git config --list
# List all variables set in all scope
git config [--show-origin] [--show-scope] --list
# List all variables set in specified scope
git config [--system | --global | --local] --list

# ### add or modify
# scope is local. 如果没有此名字则添加，如果有，则修改。
git config <name> <value>

# ### unset
git config --unset-all <name>
# error. 只能指定一个范围
#git config --system --global --unset-all <name>

# 编辑配置
git config [--system | --global | --local] --editor
```

### git config 的常用命令

```shell
# ## Basic
git config --global user.name <user_name>
git config --global user.email <user_email>

# ## 冲突
git config merge.tool vimdiff
git config merge.conflictstyle diff3
git config mergetool.prompt false

# ## pull
git config pull.rebase false     # merge (the default strategy)
git config pull.rebase true      # rebase
git config pull.ff only          # fast-forward only

# ## git command alias
# `git st` == `git status`
git config --global alias.st status
git config --global alias.br branch
git config --global alias.co checkout
git config --global alias.ci commit

# ## Others
# 在 windows 平台时，git 会自动为文件转换为 windows 的换行符。linux 平台时，会...
git config --global core.autocrlf input
# git status 显示中文问题
git config --global core.quotepath false
```

## git init

for example

```shell
git init
git init --bare
```

## git clone

for example

```shell
git clone git://github.com/JSLite/JSLite.js.git
# 克隆到自定义文件夹
git clone git://github.com/JSLite/JSLite.js.git mypro

# 这样就只会下载 v4.14 及以后的文件
git clone --shallow-exclude v4.13   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
# 克隆最新的仓库快照，忽略所有的历史记录
git clone --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
```

## git apply

git diff 产生的补丁用 git apply 打补丁。

for example

```shell
git diff > mypatch.patch
git diff --staged > mypatch.patch
git apply mypatch.patch
# -3, --3way
git apply -3 mypatch.patch
```

## git format-patch/am

git format-patch/am 的作用

    git-format-patch - Prepare patches for e-mail submission
    git-am - Apply a series of patches from a mailbox

git format-patch 可为多个 commits 生成补丁。

for example

```shell
# 相当于 `git format-patch -k --stdout HEAD~5..HEAD~3`
git format-patch -k --stdout -2 HEAD~3

# 相当于 `git format-patch -k --stdout HEAD~2..HEAD`
git format-patch -k --stdout -2 > test.patch
# `-3` 是三路合并。Mine, Yours, Base。
git am -k -3 < test.patch

# revision range: [origin, HEAD]。
git format-patch origin
# revision range: [root, HEAD]。root 表示一个 commit 都没有的时候。
git format-patch -k --stdout --root HEAD > test.patch
```

## git show

Show various types of objects

```shell
# show content of file in index
git show :<file>
# 查看 commit 的文件内容
git show <commit>:<file>

git show {<tag> | <commit> | ...}
```

## git ls-files

```shell
# list tracked files
git ls-files
# list files in index
git ls-files --stage
```

## 撤消操作

恢复状态

```shell
git reset
```

恢复文件

```shell
# 从 index 恢复 worktree 的文件
git restore -- config.h
# 从 HEAD 恢复 index 的文件。unadd 操作。
git restore -S -- config.h
# 从 HEAD 恢复 worktree 和 index 的文件
git restore -W -S -- config.h
# 从 HEAD 恢复 worktree 的文件

# 从 HEAD 恢复 worktree 的文件
git restore -s HEAD -W -- config.h
# 从 HEAD 恢复 worktree 和 index 的文件
git restore -s HEAD -W -S -- config.h
```

修改 commit

```shell
git commit --amend -m <msg>
git commit --fixup=HEAD
git commit --squash=HEAD
git rebase -i HEAD~4
git revert HEAD
```

## 部分接收

[部分接收](https://wiki.archlinux.org/title/Git_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E9%83%A8%E5%88%86%E6%8E%A5%E6%94%B6)

```shell
# 这样就只会下载 v4.14 及以后的文件
git clone --shallow-exclude v4.13   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
# 克隆最新的仓库快照，忽略所有的历史记录
git clone --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

git fetch --tags --shallow-exclude v4.1
git fetch --tags --shallow-since 2016-01-01
```
