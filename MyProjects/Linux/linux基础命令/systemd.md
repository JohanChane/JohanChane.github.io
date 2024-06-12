# Systemd

## References

-   <https://wiki.archlinux.org/index.php/Systemd_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>
-   《鸟哥私房菜》
-   man page

    -   man 8 service
    -   man systemctl
    -   man systemd.unit
    -   man systemd.target
    -   man systemd.service
    -   man systemd.socket

## Get Help

    systemctl help <单元>

    # 列出 option 的所有值。比如：`systemctl --type=help`, `systemctl --signal=help`
    systemctl <option> help

## Systemd Unit Path

-   系统级的

    `/usr/lib/systemd/system/`：存放系统级的单元

    `/etc/systemd/system/`：用于管理系统级的单元（优先级比 `/usr/lbi/systemd/system` 高）。比如：系统级的单元开机启动时，会添加软链接到 `/etc/systemd/system/multi-user.target.wants`, mask 系统级单元时，会添加该单元的软链接到 `/etc/systemd/system/`，并使其指向 `/dev/null`。还有，一些 wants 文件夹。

-   用户级的（要用 `systemctl --user`）

    `/usr/lib/systemd/user/`：存放用户级的软件包安装的单元。与 `/usr/lib/systemd/system` 对应。

    `~/.config/systemd/user`：用于管理用户级的软件包安装单元（优先级比 `/usr/lib/systemd/user/` 高）。与 `/etc/systemd/system` 对应。

systemd 配置目录（unit path）的优先级

    # ## systemctl show --property=UnitPath
    /etc/systemd/system.control
    /etc/systemd/system
    /etc/systemd/system.attached
    # 将自定义 unit 放在此处
    /usr/local/lib/systemd/system
    /usr/lib/systemd/system

    # ## systemctl --user show --property=UnitPath
    /home/johan/.config/systemd/user.control
    /home/johan/.config/systemd/user
    /etc/xdg/systemd/user
    /etc/systemd/user
    # 将自定义 unit 放在此处
    /home/johan/.local/share/systemd/user
    /usr/local/share/systemd/user
    /usr/share/systemd/user
    /usr/local/lib/systemd/user
    /usr/lib/systemd/user

## Systemctl Unit File

### Unit Types

一个单元配置文件可以描述如下内容之一：系统服务（.service）、挂载点（.mount）、sockets（.sockets） 、系统设备（.device）、交换分区（.swap）、文件路径（.path）、启动目标（.target）、由 systemd 管理的计时器（.timer）。

列出所有 unit type

    # *.target 是多个 unit 的集合*
    systemctl --type=help

### Three sections of the unit file

-   `[Unit]`
        which carries generic information about the unit that is not dependent on the type of unit. 启动顺序: After itself Before

-   Unit Type

    列出所有 unit type

        # ## systemctl --type=help
        service
        mount
        swap
        socket
        target
        device
        automount
        timer
        path
        slice
        scope

-   `[Install]`

    Unit 的安装信息。比如：enable <unit> 时，应该加入哪个 target 的 wants OR requires。

### Section key of unit file

ref: <https://www.cnblogs.com/wjoyxt/p/9289352.html>

#### Unit Section

-   After, Before

    决定启动顺序，不决定要启动什么服务。

    启动是顺序是 `After, 当前 unit, Before`。

-   Requires, Wants

    不影响启动顺序。决定着要启动什么服务。

    > Requires: unit 启动前要启动的服务。如果有一个依赖服务是 deactivated 则这个 unit 也是 deactivated。即启动失败。
    >
    > Wants: 是一个弱版本的 requires。这里的依赖服务是否启动失败都不影响则这个 unit 的启动。

    *如果 unit 的 Requires 设置了 UnitA，那么 After 一般也会设置 UnitA。*

    Wants 的单元可在这些 wants 目录中加入 unit-file

    -   `/usr/lib/systemd/system/<unit>.wants`, `/etc/systemd/system/<unit>.wants`
    -   `/usr/lib/systemd/user/<unit>.wants`, `~/.config/systemd/user/<unit>.wants`

    for example

        tree /etc/systemd/system/*.wants

#### Unit Type Section

##### Service Section

-   Type

        # ## `man systemd.service`
        Type=simple：默认值，执行ExecStart指定的命令，启动主进程
        Type=exec：与 simple 类似。simple 表示当 fork() 函数返回时，即算是启动完成，而 exec 则表示仅在 fork() 与 execve() 函数都执行成功时，才算是启动完成。
        Type=forking：以 fork 方式从父进程创建子进程，创建后父进程会立即退出。父进程将会退出，而子进程将作为主服务进程继续运行。这是传统UNIX守护进程的经典做法。
        Type=oneshot：一次性进程，Systemd 会等当前服务退出，再继续往下执行
        Type=dbus：当前服务通过D-Bus启动
        Type=notify：当前服务启动完毕，会通知Systemd，再继续往下执行
        Type=idle：若有其他任务执行完毕，当前服务才会运行

-   User, WorkingDirectory, Environment

        # 以指定用户启动
        User=root
        WorkingDirectory=/root/
        Environment=ENV1=env1

-   ExecStart, ExecStop, ExecReload, RestartSec 之类 Key

        ExecStart：启动当前服务的命令
        ExecStartPre：启动当前服务之前执行的命令
        ExecStartPos：启动当前服务之后执行的命令
        ExecReload：重启当前服务时执行的命令
        ExecStop：停止当前服务时执行的命令
        ExecStopPost：停止当其服务之后执行的命令
        RestartSec: 自动重启当前服务间隔的秒数

#### Install Section

-   WantedBy, RequiredBy

    enable 之后该 unit 会加入相关 unit 的 wants OR Requires。

## 列出依赖

### 查看 unit 的依赖

列出分析之后的依赖信息（不用去看配置文件）

    systemctl show <unit>

以树的形式查看依赖关系

    # 列出这个 unit 的 requires, wants。可用 systemctl show <unit> 查看。
    systemctl list-dependencies [unit]

    # 列出这个 unit 的 requiredby, wantedby。
    systemctl list-dependencies --reverse [unit]

    # --before: 列出 unit 的 before 的字段的依赖 unit。相当于在 unit 之后的 unit 启动的依赖。
    systemctl list-dependencies [--afer | --before] [unit]

### 为一个 unit 添加 wants, requires 的依赖的方式

-   使用依赖的关键字

    requires, wants, requiredby, wantedby, after, before

-   在目录 `<unit>.wants <unit>.requires` 放置依赖 unit 配置文件。目录的好处是不用修改文件。

### 开机流程

在硬件驱动成功后，Kernel 会主动调用 systemd 程序，并以 default.target 流程开机；然后再运行该 unit 的 wants, requires。

for example

    systemctl show default.target
    systemctl list-dependencies

## unit-files/unit 的状态

`systemctl --state=help`

`systemctl list-unit-files`

    列出系统上安装的单位文件及其启用状态

    # unit 配置文件没有 install section。所以无法 enable 这个 unit。
    static

`systemctl list-units --all`

    List units that systemd currently has in memory.

    LOAD   = Reflects whether the unit definition was properly loaded.
        是否 systemctl 将 unit 载入。
    ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
        是 sub 的归纳。
        active, inactive, failed
    SUB    = The low-level unit activation state, values depend on unit type.
        dead, running, exited, listening, plugged(阻塞)

## unit 的动作

`systemctl {enable|disable|mask|unmask|stop|start|restart|reload} <unit>`

enable

    开机主动启动。
    在 {wants|requires} 目录中添加软链接。
    disable 与 enable 相反。

mask

    在 /etc/systemd/system/ 中建立 unit 的软链接，将它指向 /dev/null。
    unmask 与 mask 相反。

## Unit 模板单元

[Unit 模板单元](https://wiki.archlinux.org/title/Systemd_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E4%BD%BF%E7%94%A8%E5%8D%95%E5%85%83)

> 有一些单元的名称包含一个 @ 标记（例如： name@string.service ），这意味着它是模板单元 name@.service 的一个 实例。 string 被称作实例标识符，在 systemctl 调用模板单元时，会将其当作一个参数传给模板单元，模板单元会使用这个传入的参数代替模板中的 %I 指示符。
>
> 在实例化之前，systemd 会先检查 name@string.suffix 文件是否存在（如果存在，就直接使用这个文件，而不是模板实例化）。

for example

```shell
# ## /home/johan/.local/share/systemd/user/test@.service

[Unit]
Description=test

[Service]
Type=simple
ExecStart=/bin/bash -c "echo %I, %h > /home/johan/test.out"

[Install]
WantedBy=default.target

# ## 在 shell 中运行
systemctl --user daemon-reload
systemctl --user restart test@johan
cat /home/johan/test.out
```

```shell
systemctl cat getty@.service
systemctl cat getty@tty1.service
```

## 常用命令

    systemctl {list-units [--all] | list-unit-files} [--type=<unit_type>]

        # 列出已安装的 unit files.
        systemctl list-unit-files

        # 列出已加载入内存的 units。
        systemctl list-units

    # isolate 用于切换
    systemctl get-default, set-default, isolate <target unit name>
    # 列出所有开机启动的服务
    systemctl list-dependencies [default.target]

    # 重新加载配置
    systemctl reload [unit]
    # 重新载入 systemd 系统配置，扫描单元文件的变动。注意这里不会重新加载变更的单元文件。参考 reload。
    systemctl daemon-reload

    # 没有 `--full` 表示新建一个 override unit 会覆盖之前文件的一些属性（有些属性无法覆盖，比如：ExecStart），而 `--full` 是新建一个更高优先级的 unit 覆盖之前的所有属性。其实是在 `/etc/systemd/systemd` 新建一个 unit file，用于覆盖 `/usr/lib/systemd/system/` 下的 unit file。
    systemctl edit [--full] <unit>

    # 可重置已经修改的 unit
    systemctl revert [unit]

    # systemctl reboot` 比 `reboot` 做更多的事。`reboot` 只是为了兼容 systemV 系统。
    systemctl {reboot | poweroff | suspend | hibernate | hybrid-sleep}

    # 以树的形式显示 cgroup。命令前面的数字是 PID
    systemd-cgls

## Examples

### 创建一个 unit

    mkdir -p /usr/local/lib/systemd/system
    touch /usr/local/lib/systemd/system/foo-daemon.service

    # foo-daemon.service
        [Unit]
        Description=Foo

        [Service]
        Type=simple
        ExecStart=/usr/sbin/foo-daemon

        [Install]
        WantedBy=multi-user.target

    systemctl daemon-reload
