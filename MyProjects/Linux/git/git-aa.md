# My Git Manual

## References

- [git book](https://git-scm.com/book/zh/v2)

    重要章节

        起步 - Git 是什么？
        起步 - 初次运行 Git 前的配置
        起步 - 获取帮助

        git 基础

        git 分支

- [archwiki git](https://wiki.archlinux.org/index.php/Git_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

- svn vs git

    <https://backlog.com/git-tutorial/reference/commands/>

- git cheet sheet

    <https://training.github.com/downloads/zh_CN/github-git-cheat-sheet/>

## 基本概念

git 的版本控制主要是控制 branches 。分支的创建删除合并。

一个仓库可以有多个 branches 。每个分支都有自己的 commits, reflog, configs（e.g. upstream）。

working tree and index 不属于分支。

*tag 不属于任何分支。tag 的作用更像是备份一个 git object。*

### Git 是什么？

[起步 - Git 是什么？](https://git-scm.com/book/zh/v2/%E8%B5%B7%E6%AD%A5-Git-%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F)

Git 和其它版本控制系统（包括 Subversion 和近似工具）的主要差别在于 Git 对待数据的方式。  
Git 保存的不是文件的变化或者差异，而是一系列不同时刻的文件快照（完全复制）。如果文件没有修改，Git 不再重新存储该文件，而是只保留一个链接指向之前存储的文件。

svn 存储每个文件与初始版本的差异

![](https://git-scm.com/book/en/v2/images/deltas.png)

git 存储项目随时间改变的快照.

![](https://git-scm.com/book/en/v2/images/snapshots.png)

### git 对象

[Git-内部原理-Git-对象](https://git-scm.com/book/zh/v2/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-Git-%E5%AF%B9%E8%B1%A1)

git 共有三种对象，分别是 blob object（数据对象）, tree object（树对象）, commit object（提交对象）。最初均以单独文件的形式保存在 .git/objects 目录下。

> 数据对象类似 UNIX 的普通文件，用于存储文件内容，不存储文件。  
> 树对象类似 UNIX 的目录文件，用于存储文件名，以及文件内容的位置。  
> 提交对象的格式很简单：  
> > 它先指定一个顶层树对象，代表当前项目快照。git cat-file -p master^{tree} 可查看顶层树对象；  
> > 然后是可能存在的父提交（前面描述的提交对象并不存在任何父提交）；   
> > 之后是作者/提交者信息（依据你的 user.name 和 user.email 配置来设定，外加一个时间戳）；  
> > 留空一行，最后是提交注释。

![](https://git-scm.com/book/en/v2/images/data-model-3.png)

*每次我们运行 git add 和 git commit 命令时，Git 所做的工作实质就是将被改写的文件保存为数据对象，更新暂存区，记录树对象，最后创建一个指明了顶层树对象和父提交的提交对象。*

***branch, commit, tag, reflog, stash 都是引用一个 git object。***

### Git 分支 - 分支简介

[Git 分支 - 分支简介](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%AE%80%E4%BB%8B)

git branches 保存了一个指向 commit 对象的指针(引用)。

![](https://git-scm.com/book/en/v2/images/advance-master.png)

### git 引用

[Refs](https://git-scm.com/book/zh/v2/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-Git-%E5%BC%95%E7%94%A8)

分支引用的 Git 目录对象

![](https://git-scm.com/book/en/v2/images/data-model-4.png)

#### HEAD 引用

HEAD 文件通常是一个符号引用（symbolic reference），指向目前所在的分支的最后一次 commit 对象。

*FETCH_HEAD 表示最近被 fetch 的 remote branch.*

[HEAD^[N], HEAD~[N]](https://stackoverflow.com/questions/20954566/what-is-the-difference-from-head-head-and-head1)

HEAD^1 是 HEAD 的第一个 parent。HEAD^2 是 HEAD 的第二个 parent。  
HEAD~1 是 HEAD 的 parent。HEAD~2 是 HEAD 的 grandparent。

#### 标签引用

> 前面我们刚讨论过 Git 的三种主要的对象类型（数据对象、树对象 和 提交对象 ），然而实际上还有第四种。   
> 标签对象（tag object） 非常类似于一个提交对象——它包含一个标签创建者信息、一个日期、一段注释信息，以及一个指针。   
> 主要的区别在于，标签对象通常指向一个提交对象，而不是一个树对象。 它像是一个永不移动的分支引用——永远指向同一个提交对象，只不过给这个提交对象加上一个更友好的名字罢了。

*相关命令 `git tag`*

#### 远程引用

> 远程引用（remote reference）。 如果你添加了一个远程版本库并对其执行过推送操作，Git 会记录下最近一次推送操作时每一个分支所对应的值，并保存在 refs/remotes 目录下。比如：.git/refs/remotes/origin/master。
> 
> git fetch origin 时则从中抓取本地没有的数据，并且更新本地数据库，移动 .git/refs/remotes/origin/master 指针到更新之后的位置。

[Git 分支 - 远程分支](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E8%BF%9C%E7%A8%8B%E5%88%86%E6%94%AF)

详细介绍了 get clone, git fetch, git push 对 .git/refs/remotes 下的引用的影响。

#### git 与引用相关的文件

```
.git/refs/
├── heads
│   ├── master
│   ├── master1
│   ├── master2
│   └── newmaster
├── remotes
│   └── origin
│       ├── HEAD
│       └── master
└── tags
```

> heads 下的是本地仓库的分支引用，而 remotes 下的是远程分支的引用。

### git 工作流

[git workflow](https://blog.osteele.com/2008/05/my-git-workflow/)

![](https://images.osteele.com/2008/git-transport.png)

![](https://images.osteele.com/2008/git-workflow.png)

克隆一个 git 仓库时，包含以下东西：

- worksapce
- index(stage area)
- local repository

    commit 是将文件加入本地仓库

- remote repository 的快照

    fetch 是更新本地 remote repository 的快照。  
    push 是将本地仓库的文件推送到 remote repository，并更新 remote repository 快照。

### 冲突的产生

前提有两个分支，且它们都修改了相同的地方（比如某个文件的一行）。这时 git 不知要怎么解决冲突了，是选择分支一的修改还是选择分支二的，还是两个都选，那它们的顺序是怎样的。这就要人为的解决了。

### 跟踪分支(上游分支)

[跟踪分支(上游分支)](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E8%BF%9C%E7%A8%8B%E5%88%86%E6%94%AF)

> 如果在一个跟踪分支上输入 git pull，Git 能自动地识别去哪个服务器上抓取、合并到哪个分支。  
> 当克隆一个仓库时，它通常会自动地创建一个跟踪 origin/master 的 master 分支。

### fast-forward

[fast-forward](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%9A%84%E6%96%B0%E5%BB%BA%E4%B8%8E%E5%90%88%E5%B9%B6)

> 当你试图合并两个分支时， 如果顺着一个分支走下去能够到达另一个分支，那么 Git 在合并两者的时候， 只会简单的将指针向前推进（指针右移），因为这种情况下的合并操作没有需要解决的分歧——这就叫做 “快进（fast-forward）”。

如果没有分叉时，分支都会 fast-forward

    git pull
    git pull --rebase
    git pull --ff-only

### 合并的两种方式: merge 以及 rebase

#### merge

[Git 分支 - 分支的合并](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%9A%84%E6%96%B0%E5%BB%BA%E4%B8%8E%E5%90%88%E5%B9%B6#_basic_merging)

[arch man](https://man.archlinux.org/man/extra/git/git-merge.1.en)

将两个分支和它们的共同祖先进行三方整合。会产生一个新的 commit。

#### rebase

[Git 分支 - 变基](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%8F%98%E5%9F%BA)

[arch man](https://man.archlinux.org/man/extra/git/git-rebase.1.en)

将两个分支相对于它们共同祖先的补丁和修改应用于它们的共同祖先。不同于 merge，不会产生新的 commit。

## basic

### Get Help

[arch man](https://man.archlinux.org)

    # 三个命令都是等价的
    git help <verb>
    git <verb> --help
    man git-<verb>

    # 列出可用选项的快速参考
    git <verb> -h           

## Git 配置

- 系统配置

    `/etc/gitconfig`。针对系统的配置。

    `git config --system` 选项会读写该配置。

- 全局配置

    `~/.gitconfig 或 ~/.config/git/config`。针对用户的配置。

    `git config --global` 选项会读写该配置。

- 本地配置

    `<git仓库>/.git/config`。针对该仓库的配置。

    `git config --local` 选项会读写该配置。

查看配置

    # List all variables set in config file。
    git config [--system | --global | --local] --list

for example:

    git config user.name "<username>"
    git config user.email "<useremail>"
    git config --global user.name "<username>"
    git config --global user.email "<useremail>"

## 在 working tree 阶段工作的常用命令

### git add

    git add
    # 输入问号可查看帮助
    git add --patch <path>

### 恢复文件

    # 从缓存区中恢复工作区的文件
    git restore -- [file]...
    # 从 HEAD 中恢复工作区文件
    git checkout [HEAD] -- [file]...

### 比较文件

    # 比较工作区与暂存区（只比较 tracked files）
    git diff

    # 比较工作区与 HEAD（只比较 tracked files）
    git diff [HEAD]

### git clone

    git clone --shallow-exclude v4.13   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
    git clone --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
    git pull --unshallow

### git pull and fetch

fetch and pull 的区别

> pull 相当于 git fetch; git merge FETCH_HEAD。

#### git fetch 

    # `--prune` update the local list of remote git branches. 因为有时分支在别人删除了，而本地的 remotes 还保留着这个分支时，可用此参数删除 remotes 的那个分支。
    git fetch [origin] [--prune]
    # 也可以这样删除
    git branch -d --remotes origin/master

    # 将 repos_branch 拉到 remotes 中，并再 git branch <new_local_branch> <repos_branch>。new_local_branch 的上游分支是 repos_branch。
    git fetch <repos> <repos_branch>[:<new_local_branch>]

#### git pull

    git pull
    git pull <repos> <repos_branch>

    # 配置 git pull, 将替换 merge 操作
    #git config pull.rebase false     # merge (the default strategy)
    #git config pull.rebase true      # rebase
    #git config pull.ff only          # fast-forward only

    git pull --rebase
    git pull --ff-only

### Others

    # list tracked files
    git ls-files

    # 删除未跟踪的文件和目录
    git clean -fd

## 在 index 阶段工作的常用命令

    # list files in index
    git ls-files --stage

    # show content of file in index
    git show :<file>

    # 比较暂存区与 HEAD
    git diff --stage [HEAD]

    # 删除 index 的所有文件
    git rm --cached -r .

    # 从 HEAD 中恢复 index 文件
    git restore --stage [file]...

## 在 commit 阶段工作的常用命令

    git commit [-a] [-v] -m <msg>
    git commit [-a] --patch

    # 修改上次 commit（其实是用 rebase）。产生新的 commit 替换旧的 commit。
    git commit --amend -m <msg>

### 撤消 commit

    # 撤消 commit，不修改缓存区与工作区。
    git reset --soft HEAD~1
    # 撤消 commit，还原缓存区，不修改工作区。
    git reset --mix
    # 撤消 commit，还原缓存区和工作区。
    git reset --hard HEAD~1

### git revert

    # 用 commit 的补丁为 HEAD 反向打补丁。branch 增加一个新的 commit。
    git revert <commit>...
    git revert {--abort | --continue}

### git cherry-pick

[ref](https://www.atlassian.com/git/tutorials/cherry-pick)

    # 用 commit 的补丁为 HEAD 正向打补丁。branch 增加一个新的 commit。
    git cherry-pick <commit>...
    git cherry-pick {--abort | --continue}

### git 合并

#### git merge

    # 与 HEAD 合并。branch 增加一个新的 commit。
    git merge <commit>
    git merge {--abort | --continue}

#### git rebase
    
    # 将两个分支相对于它们共同祖先的补丁和修改应用于它们的共同祖先。不同于 merge，branch 不会增加 commit，只是用新 commit 替换旧的 commit。
    git rebase <commit>
    git rebase {--abort | --continue}

rebase 支持的操作

    git fixup, squash, reword(edit commit msg), edit, drop, ... commits
    
##### git fixup and squash commits

[ref](http://git-scm.com/docs/git-rebase#_interactive_mode)

合并 commit

fixup 与 squash 区别：fixup 不保留 commit messages.

    # pick 第一个 commit patch（如果将所有的pick都改为了 fixup or squash 那就没有合并的载体了），fixup or squash 其他 commit patchs。
    git rebase -i <commit>

###### git autofixup and autosquash

    # 与 commit 的差别是，只是在 msg 前面添加 fixup! or squash!
    git commit --fixup=<commit>
    git commit --squash=<commit>

    # 将 msg 开头是 `fixup!` or `squash!` 的 commit 的 rebase 操作改为 `fixup` or `squash`。
    git rebase -i --autosquash

### 解决冲突

[git merge tool](https://stackoverflow.com/questions/161813/how-to-resolve-merge-conflicts-in-git)

    git config merge.tool vimdiff
    git config merge.conflictstyle diff3
    git config mergetool.prompt false

    # 编辑冲突
    git mergetool
    # 标识文件为 `unresolve`
    git update-index --unresolve <file>...

#### 冲突的相关文件

      ╔═══════╦══════╦════════╗
      ║       ║      ║        ║
      ║ LOCAL ║ BASE ║ REMOTE ║
      ║       ║      ║        ║
      ╠═══════╩══════╩════════╣
      ║                       ║
      ║        MERGED         ║
      ║                       ║
      ╚═══════════════════════╝

-   foo.LOCAL
    
    the "ours" side of the conflict - ie, your branch (HEAD) that will contain the results of the merge
    
-   foo.REMOTE

    the "theirs" side of the conflict - the branch you are merging into HEAD

-   foo.BASE

    the common ancestor. useful for feeding into a three-way merge tool

-   foo.BACKUP

    the contents of file before invoking the merge tool, will be kept on the filesystem if mergetool.keepBackup = true.

    *本地修改如果没有 commit or stash 时，则不能合并，所以 backup file 一般与 local file 相同。*

-   foo.orig

    保存冲突的文件。合并冲突后，其他会自动删除，而这个要手动删除。

for example

```
git branch masterA HEAD~1
...
git checkout masterA

git merge master
git mergetool
git update-index --unresolve <file>...
git merge --quit
rm *.orig
```

### Others

    # list file of commit
    git cat-file -p master^{tree}
    # 查看 object 的内容
    git cat-file -p <objectid>
    # 查看 commit 的文件内容
    git show [HEAD:]<file>

    git diff HEAD origin/master

## 在 push 阶段工作的常用命令

### git push

#### `<refspec>` 中的 `+` 的作用

[`<refspec>` 中的 `+` 的作用](https://git-scm.com/book/en/v2/Git-Internals-The-Refspec)

    # The `+` tells Git to update the reference even if it isn’t a fast-forward. 也可用 `git push --force` 代替。
    [+]<src>:<dst>

#### 常用操作

    git push <repository> -d <branch>       # 删除 remote branch

    # git push origin master:refs/heads/repoa/master 则可将 origin 的分支推到 repoa 仓库。
    git push <repos> <local_branch>[:<remote_branch(默认与 local_branch 同名)>]

    # undo push
    # 因为 commit 是属于分支的，所以 push 之后，远端的分支与本地分支相同。
    git push -f origin <commit>:branch_name
    git push origin +<commit>:branch_name

    git push --delete origin <branch>

## git branch

### git checkout branch

    git checkout <branch>
    git checkout -

#### checkout branch 要注意的地方

*工作区和暂存区是本地各分支共用的。*

git checkout 会恢复当前分支的 index, 还有工作区的文件。  
对于两个分支的共同文件来说，本地修改（工作区和缓存区的修改）会保留。如果无法保留，会提示用户 commit or stash 此修改。

注意：删除两个分支的非共同文件的操作不算是本地修改（设计不够好），就算 stage change 也不会保留修改。所以切换前要 commit 或 stash 删除非共同文件操作。比如：

> 删除一个非共同文件并切换到另一个分支，再切换回还原来的分支时，文件则没有被删除。  

### 常用操作

    # 创建一个 branch。start-point 默认为 HEAD。注意不会复制 start-point 的 config and reflog。
    git branch <branchname> [<start-point>]
    # 创建 new_branch 并 git checkout new_branch .
    git checkout -b <new branch> <start-point>

    # rename
    git branch (-m | -M) [<oldbranch>] <newbranch>
    # copy。与 rename 类似，会复制 oldbranch 的 config and reflog
    git branch (-c | -C) [<oldbranch>] <newbranch>
    git branch (-d | -D) [--remotes] <branchname>...

    # 查看 upstream
    git branch -vv
    # 设置 upstream
    git branch (--set-upstream-to=<upstream> | -u <upstream>) [<branchname>]
    git branch --unset-upstream [<branchname>]

    # 查看所有分支
    git branch -a
    # 只查看远程分支
    git branch --remotes

### git log

    # all 显示所有引用；abbrev-commit 显示 shortid
    git log --abbrev-commit --graph --all --pretty=oneline

    # 显示本地主分支与远程主分支之间的差异
    git log -p master..origin/master

### git reflog

    # 列出总的 reflog。HEAD 在此不代表当前分支。
    git reflog [HEAD]
    # 列出该分支的 reflog。不记录 staged change 操作。
    git reflog <branch>
    git checkout HEAD@{<N>}
    git show HEAD@{<N>}

    # 删除 reflog
    git reflog expire --expire=1.month.ago
    git reflog expire --expire=all

## git stash

[arch man](https://man.archlinux.org/man/extra/git/git-stash.1.en#EXAMPLES)

保存工作区和暂存区

stash entry

    git stash list
    
    # 可添加 msg
    git stash push -p -m <msg> -- .
    # 
    git stash
    
    # 查看 stash
    git stash show -p stash@{<N>}
    
    # 默认不恢复 index
    git stash pop [--index] [<stash>]
    # 不同于 pop, 这个不删除 stash
    git stash apply [--index] [<stash>]
    # 将 stash 作为新的分支，并删除 stash
    git stash branch <branchname> [<stash>]
    
    git stash drop [<stash>]
    git stash clear

## git tags

[refer](https://git-scm.com/book/zh/v2/Git-%E5%9F%BA%E7%A1%80-%E6%89%93%E6%A0%87%E7%AD%BE)

Git 支持两种标签：轻量标签（lightweight）与附注标签（annotated）。

两者的区别

> 轻量标签很像一个不会改变的分支——它只是某个特定提交的引用。
> 
> 而附注标签是存储在 Git 数据库中的一个完整对象， 它们是可以被校验的，其中包含打标签者的名字、电子邮件地址、日期时间， 此外还有一个标签信息，并且可以使用 GNU Privacy Guard （GPG）签名并验证。 通常会建议创建附注标签，这样你可以拥有以上所有信息。但是如果你只是想用一个临时的标签， 或者因为某些原因不想要保存这些信息，那么也可以用轻量标签。

*tag 不属于任何分支。tag 的作用更像是备份一个 git object。*

for example

    # ### 本地操作标签
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

    # ### 远程操作标签
    # 提交标签
    # 默认情况下，git push 命令并不会传送标签到远程仓库服务器上。 在创建完标签后你必须显式地推送标签到共享服务器上。
    git push origin v1.5
    # 提交所有标签
    # 在本地删除后，用此方法不能删除 remote tags
    git push origin --tags
    # 删除标签
    git push origin --delete <tagname>

[部分接收](https://wiki.archlinux.org/index.php/Git_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E9%83%A8%E5%88%86%E6%8E%A5%E6%94%B6)

for example
    
    git fetch --tags --shallow-exclude v4.1
    git fetch --tags --shallow-since 2016-01-01

## git remote

[ref](https://man.archlinux.org/man/extra/git/git-remote.1.en#EXAMPLES)

不严谨的说法，管理远端仓库的本地缓存。即 `.git/refs/remotes/` 下的东西。

- 查看信息

        # 查看 remote repos
        git remote -v

- 增删改 repo

        git remote add <repos_ref> <repos_address>
        git remote rename <old> <new>
        git remote set-url origin https://github.com/xxxxxx/SpringBoot.git
        git remote remove <repo>

for example

    git remote -v
    git remote add staging git://git.kernel.org/.../gregkh/staging.git
    git remote -v
    git remote set-url staging https://github.com/xxxxxx/SpringBoot.git

## 查看信息

### 查看 git refs

`git-name-rev` - Find symbolic names for given revs

for example

    # 查看所有 name refs
    git show-ref
    # 查看所有分支的引用
    git show-branch

    git name-rev `cat .git/refs/heads/master`
    git name-rev HEAD
    git name-rev refs/heads/master
    git name-rev heads/master
    git name-rev master
    git name-rev refs/remotes/origin/master
    ...

### 变量

[Git 内部原理 - 环境变量](https://git-scm.com/book/zh/v2/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F)

*配置也是变量*

    # List all variables set in config file
    git config [--system | --global | --local] --list

    # 列出所有变量
    git var -l

### 对象

[git 对象](https://git-scm.com/book/zh/v2/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-Git-%E5%AF%B9%E8%B1%A1)

    # 列出 master commit id 的属性 tree，即 commit id 的所有文件
    git cat-file -p master^{tree}
    git cat-file -p <objId>

    # 列出所有 commit id 的 objects
    git rev-list --objects --all

## Others

### git ignore

    # ./.gitignore
    # 忽略隐藏文件
    .*

    # 不忽略 .gitignore 文件
    !.gitignore

#### 防止 git 自动转换换行符

在 windows 平台时，git 会自动为文件转换为 windows 的换行符

    git config --global core.autocrlf false

## lazygit

[ref](https://www.bilibili.com/video/BV1gV411k7fC?from=search&seid=1428657935457952894)

lazygit branch arrow 的意思: origin/master 向下再向上会到达 HEAD. git log --abbrev-commit --graph --all --pretty=oneline。

    # 查看一个文件的所有历史记录
    view scooping options...
    # 选中一个文件，将它与光标的文件比较
    open diff menu

    # 可在 stage 过程中，筛选 patch。
    # commit 文件中，筛选 patch，并应用到其他地方。
    view custom patch options...
