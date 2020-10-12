# Git

### Refers

- <https://git-scm.com/book/zh/v2>
    
    - 重要章节

        起步 - Git 是什么？
        起步 - 初次运行 Git 前的配置
        起步 - 获取帮助

        git 基础

        git 分支

- branch

    <https://www.runoob.com/git/git-branch.html>

- svn vs git

    <https://backlog.com/git-tutorial/reference/commands/>

- conflict

    <https://www.rosipov.com/blog/use-vimdiff-as-git-mergetool/#fromHistor>

- git merge tool

    <https://stackoverflow.com/questions/161813/how-to-resolve-merge-conflicts-in-git>
			

### 基本概念

git 的版本控制主要是控制 branches 。分支的创建删除合并。

一个仓库可以有多个 branches 。每个分支都有自己的 commits。

git 对象

> [起步 - Git 是什么？](https://git-scm.com/book/zh/v2/%E8%B5%B7%E6%AD%A5-Git-%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F), [Git 分支 - 分支简介](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%AE%80%E4%BB%8B), [Git-内部原理-Git-对象](https://git-scm.com/book/zh/v2/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-Git-%E5%AF%B9%E8%B1%A1)有详细说明。
> 
> Git 保存的不是文件的变化或者差异，而是一系列不同时刻的文件快照（完全复制）。如果文件没有修改，Git 不再重新存储该文件，而是只保留一个链接指向之前存储的文件。
> 
> git branches 保存了一个指向 commit 对象的指针(引用)。
> 
> 有三种对象，分别是 commit 对象，tree 对象，blob 对象。


本地有一个仓库顾名思义叫本地仓库，仓库包含的东西：

- [Refs](https://git-scm.com/book/zh/v2/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-Git-%E5%BC%95%E7%94%A8)
    
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

    heads 下的是本地仓库的分支引用，而 remotes 下的是远程分支的引用。[Git 分支 - 远程分支](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E8%BF%9C%E7%A8%8B%E5%88%86%E6%94%AF)。它们都是指向 commmit 对象的（可查看 ref 文件内容验证）。

    git fetch origin 时则从中抓取本地没有的数据，并且更新本地数据库，移动 origin/master 指针到更新之后的位置。

    remotes 下的内容是只读的。

- 本地库的每个 branch 有各自的 index(stage area).

    The "index" holds a snapshot of the content of the working directory


#### Others

- [跟踪分支(上游分支)](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E8%BF%9C%E7%A8%8B%E5%88%86%E6%94%AF)

    如果在一个跟踪分支上输入 git pull，Git 能自动地识别去哪个服务器上抓取、合并到哪个分支。

    当克隆一个仓库时，它通常会自动地创建一个跟踪 origin/master 的 master 分支。

- 冲突的产生

    前提有两个分支，且它们都修改了相同的地方（比如某个文件的一行）。这时 git 不知要怎么解决冲突了，是选择分支一的修改还是选择分支二的，还是两个都选，那它们的顺序是怎样的。这就要人为的解决了。

- [fast-forward](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%9A%84%E6%96%B0%E5%BB%BA%E4%B8%8E%E5%90%88%E5%B9%B6)
    
    没有需要解决的分歧的合并操作，叫做 “快进（fast-forward）”。

- 合并的两种方式: merge 以及 rebase

    [Git 分支 - 分支的合并](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%9A%84%E6%96%B0%E5%BB%BA%E4%B8%8E%E5%90%88%E5%B9%B6#_basic_merging)

    [Git 分支 - 变基](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%8F%98%E5%9F%BA)

- [git workflow](https://blog.osteele.com/2008/05/my-git-workflow/)


    working directory, index(stage area), local repository, remote repository.
    
    [起步 - Git 是什么？](https://git-scm.com/book/zh/v2/%E8%B5%B7%E6%AD%A5-Git-%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F)

    文件的状态变化周期

    ![文件的状态变化周期](https://git-scm.com/book/en/v2/images/lifecycle.png)

- 工作区是本地各分支共用的，每个 branch 有各个的缓存区
    
    git branch switch, delete 都不修改工作区的。只是更改或删除缓存区。

### Get Help

    # 三个命令都是等价的
    git help <verb>
    git <verb> --help
    man git-<verb>

    git <verb> -h           # 列出可用选项的快速参考

    <refspec>...
        [+]<src>:<dst>
            The `+` tells Git to update the reference even if it isn’t a fast-forward.

[`<refspec> +` 的作用](https://git-scm.com/book/en/v2/Git-Internals-The-Refspec)


### Git 配置

- 系统配置

    `/etc/gitconfig`。针对系统的配置。
    用 `git config --system` 选项会读写该配置。

- 全局配置

    `~/.gitconfig 或 ~/.config/git/config`。针对用户的配置。
    用 `git config --global` 选项会读写该配置。

- 本地配置

    `<git仓库>/.git/config`。针对该仓库的配置。
    用 `git config --local` 选项会读写该配置。


查看配置

    git config [--system | --global | --local] --list
        List all variables set in config file。

for example:

    git config user.name "<username>"
    git config user.email "<useremail>"
    git config --global user.name "<username>"
    git config --global user.email "<useremail>"

### 常用的引用

- `HEAD, FETCH_HEAD`

    HEAD 表示当前分支，当切换分支，它也会跟着改变。
    FETCH_HEAD 表示最近被 fetch 的 remote branch.

    [Git-内部原理-Git-引用](https://git-scm.com/book/zh/v2/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-Git-%E5%BC%95%E7%94%A8)

    `.git/HEAD, .git/FETCH_HEAD`

    HEAD 其实现是一个分支的引用，或者说是一个 commit 对象的引用，因为分支也是 commit 对象的引用。

        for example:
            .git/HEAD
                ref: refs/heads/master
            refs/heads/master
                f5566833264941efcc983569d6f9cef5eaec0ed0		# commit id
- master, origin

    master 是一个默认分支名，origin 是一个默认仓库名，无特殊意义，你也可以修改成别的名称。


### 查看信息

#### 查看 refs

查看 name ref 引用的东西

    git show-ref
        查看所有 name refs

    git name-rev `cat .git/refs/heads/master`

    git name-rev HEAD

    git name-rev refs/heads/master
    git name-rev heads/master
    git name-rev master
    git name-rev refs/remotes/origin/master
    ...

    git symbolic-ref HEAD
    
### 变量

[Git 内部原理 - 环境变量](https://git-scm.com/book/zh/v2/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F)

    git config [--system | --global | --local] --list
        列出配置的变量

    git var -l
        列出所有变量。

#### 对象

    git rev-list --objects --all
        列出所有 ref 的 commit id 的 objects

#### git log

    git log --oneline --decorate --graph --all
        用图形的方式显示所有分支（包含远程分支）的关系。
        图形是显示 commited 分支的状态不包含工作区和缓存区，即是说要 commit 或 push 之后其状态才会显示在图形上。
        一条线表示一个分支。当两线合并时，则表示两个分支合并了。

    git log             # 查看当前 branch 的 commit。
    git show <commit>   # 查看 commit。

### git verb

    fetch
        Remote-tracking branches are updated。更新 remotes/<branch>, 如果命令中有 dst 则更新/新建本地仓库分支 dst。 
    
    pull
        git pull; git pull origin = git fetch; git merge FETCH_HEAD		// FETCH_HEAD与当前仓库整合
        git pull origin next = git fetch origin; git merge origin/next
    
    push
        git push: push current branch to its upstream branch.
        git push origin: src, dst 都是当前分支名。
        git push origin master: dst 与 src 同名。
			
### repositories

- 查看信息

    git remote -v

- 增删改 repo

        git remote add <repos_ref> <repos_address>
        git remote rename <old> <new>
        git remote set-url origin https://github.com/xxxxxx/SpringBoot.git
        git remote remove <repo>


`git clone <repos>`
    

### branches

- verbose branch

        git branch
            列出本地仓库分支。
        git branch -vv
            查看 branch 的上游 branch，以及 ahead, behind 的情况。
        
        git branch --list [--all | --remote]

        git branch [--merged | --no-merged]
        
        git remote show <repo>
            查看 git pull push 于什么分支。
       
- 创建 branch

        git branch <new branch> <start-point(default HEAD)>
        git checkout -b <new branch> <start-point(default HEAD)>
            创建 new_branch 并 git checkout new_branch .
    
- switch branch

        git checkout <branch>
            切换到该 branch 的 index。

- merge branch

        git merge <branch>
            将 <branch> 合并到当前 <branch>。不是合并 <branch> 的 working directory 和 index，而是本地库的内容（相当于 commit 了一次）。

- delete branch

        git branch -d <branch>                  # 删除本地库的分支
        git push <repository> -d <branch>       # 删除 remote branch

- update branch

        git fetch <repos> <repos_branch>[:<new_local_branch>]
            将 repos_branch 拉到 remotes 中，并再 git branch <new_local_branch> <repos_branch>。new_local_branch 的上游分支是 repos_branch。
            git fetch origin master:refs/remotes/origin/mymaster 则可自定义 remotes/<仓库名> 为 mymaster。
            
        git pull <repos> <repos_branch>
            将 repos_branch 拉到 remotes 中，并在 git merge repos_branch 。

- push branch

        git push <repos> <local_branch>[:<remote_branch(默认与 local_branch 同名)>]
            git push origin master:refs/heads/qa/master 则可将 origin 的分支推到 qa 仓库。

- move/rename branch

    git branch --move <oldname> <newname>

- 操作 branch upstream

        unset upstream
            git branch --unset-upstream master
        set upstream
            git branch --set-upstream-to=origin/master master

[Git-内部原理-引用规范](https://git-scm.com/book/zh/v2/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-%E5%BC%95%E7%94%A8%E8%A7%84%E8%8C%83)
            
### git workflow

    git status

        查看工作区和缓存区的变量
        
    git diff

        只有双方都有的文件才会比较

        查看工作区的变化
            git diff <path>
                diff stage workingDirectory
            git diff <commit>
                diff <commit> workingDirectory
                
        查看暂存区的变化
            git diff --staged <commit>
                diff <commit> stage     # <commit> 默认为 HEAD
        
    working directory update to stage area
        git add --all <paths/files>
    
    stage area update to local repository
        git commit -m "<msg>"
        git commit -a -m "<msg>"
            Git 就会自动把所有已经跟踪过的文件暂存起来一并提交。从而跳过 git add 步骤。
    
    local repository update to remote repository
        git push <repository> <branch>

    undo operator（file 可以是文件夹）:
        undo modify:
            git restore <files>                     # 从缓存区中恢复工作区的文件
            git checkout HEAD~1 -- <files>          # 从 commit 中恢复工作区文件
        undo add:
            git restore --staged <files>            # unstaged files
            git rm --cached -r .                    # 清空缓存区
            # git ls-files --stage                  # 查看缓存区的文件
        覆盖上次 commit
            git commit --amend -m "an updated commit message"
                上次 commit 会被覆盖。
        undo commit:
            git reset --soft HEAD~1
                只是撤消 commit，不修改缓存区与工作区。
            git reset --hard HEAD~1
                撤消 commit，并删除缓存区和还原工作区为上次 commit，所以工作区的修改都会丢失。

            HEAD~1 是一个 commit。

        undo push
            git push -f origin last_known_good_commit:branch_name

#### workflow 常用的命令

    git fetch --prune origin master:master1
        `--prune` update the local list of remote git branches. 因为有时分支在别的地方删除了，而本地的 remotes 还保留着这个分支时，可用此参数删除 remotes 的那个分支。

    git checkout --track origin/master
        相当于 git checkout -b master origin/master

    git checkout -b master1 origin/master

    git branch -d master && git branch --move master1 master

    git push origin master:master

    git status
    git diff
    git add --all
    git commit -m "<message>"

### 合并工具

    git config merge.tool vimdiff
    git config merge.conflictstyle diff3
    git config mergetool.prompt false
    git mergetool

### Others

    git config --global core.autocrlf false
        防止 git 自动转换换行符
