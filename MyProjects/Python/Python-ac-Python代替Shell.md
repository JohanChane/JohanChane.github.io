# 用 Python 代替操作系统的 shell

[用 Python 代替操作系统的 shell](https://github.com/ninjaaron/replacing-bash-scripting-with-python/blob/master/README.rst)

*个人例子代码的系统平台默认是 linux。*

## 原因

问题：每个操作系统都有各自的 Shell，而这个 Shell 脚本语言不能做到完全统一，且存在一些特殊字符等比较难理解的语法。还有它们一般不是面向对象的。

> Python 是面向对象的脚本语法，语法比较统一且容易理解。它内部有很多与操作系统交互的工具，所以用 Python 代替 Shell 是一个不错的选择。

## Python 与操作系统交互的工具

***os, os.path, pathlib.Path, glob, fnmatch, shutil, subprocess***

[OS 模块](https://docs.python.org/zh-cn/3/library/os.html)

> 多种操作系统接口。比如：os.chdir(path) os.getcwd() os.listdir()。

## 执行 Shell 命令

那么什么时候执行 Shell 命令？

> 虽然 Python 已有很多与操作系统交互的工具，但是有 Shell 的程序的功能是 Python 没有，虽然可以用 python 实现这个功能，但是比较麻烦，所以还是直接调用 Shell 命令或运行这个命令的可执行程序会比较省时间。但会是降低可移植性。所以尽量先用 Python 自带的功能。

### os.system

[os.system](https://docs.python.org/zh-cn/3/library/os.html?highlight=system#os.system)

> 在子 shell 中执行命令（字符串）。这是调用标准 C 函数 system() 来实现的，因此限制条件与该函数相同。对 sys.stdin 等的更改不会反映在执行命令的环境中。command 产生的任何输出将被发送到解释器标准输出流，不会放在返回值中。

for example

```python
import subprocess, os, sys
exitCode = os.system('echo abc')
print(exitCode)
print(type(exitCode))
```

### subprocess

[subprocess](https://docs.python.org/zh-cn/3/library/subprocess.html?highlight=subproces#module-subprocess)

> 提供了更强大的工具来生成新进程并跟踪执行结果，使用该模块比使用本函数更好。Popen 是更底层的接口。

#### shell 参数意义

> 当为 True 时，表示是命令（必须是一串字符串）是在 subshell 中执行的，而为 False 时，表示运行一个程序，第一个参数必须是一个可执行程序。且这个是没有经过 Shell 解析的。还有命令必须是一个列表。

for example

```python
import subprocess

# 命令在 subshell 中执行, $HOME 会被 `expand`
subprocess.run('echo $HOME', shell = True)
# echo 有一个可执行程序, 因为命令没有经过 Shell 解析，所以 `$HOME` 不会被 expand
subprocess.run(['echo', '$HOME'])

# 因为 type 是 shell builtin 所以第一参数不是可执行程序，所以出错。
# subprocess.run(['type', 'ls'])
```

设置 linux 或 windows 的 shell 程序

-   windows

        os.environ["COMSPEC"] = 'cmd'
        os.environ["COMSPEC"] = 'powershell'

-   linux

        默认为 sh.
        # subprocess.run 只能是 sh，除非在 arg 中指定用 bash。
        subprocess.Popen(cmd, shell=True, executable='/bin/bash')

#### subprocess.DEVNULL，subprocess.PIPE，subprocess.STDOUT

作为 stdin, stdout, stderr 实参的 subprocess.DEVNULL，subprocess.PIPE，subprocess.STDOUT

-   subprocess.DEVNULL

    int 类型，值为 -3。可被 Popen 的 stdin, stdout 或者 stderr 参数使用的特殊值, 表示使用特殊文件 os.devnull.

-   subprocess.PIPE

    int 类型，值为 -1。可被 Popen 的 stdin, stdout 或者 stderr 参数使用的特殊值, 表示打开标准流的管道. 常用于 Popen.communicate().

-   subprocess.STDOUT

    int 类型，值为 -2。可被 Popen 的 stdin ，stdout 或者 stderr 参数使用的特殊值，表示标准错误与标准输出使用同一句柄。

for example

```python
import subprocess

# ### PIPE
# 打开标准输出、错误输出流管道。标准输出、错误输出输出到 result。
result = subprocess.run('echo aa; echo bb 1>&2', stderr = subprocess.PIPE, stdout = subprocess.PIPE, shell = True)
# `CompletedProcess(args='echo aa; echo bb 1>&2', returncode=0, stdout=b'aa\nbb\n')`
print(result)

# #### stdin 与 PIPE
from subprocess import Popen, PIPE, STDOUT
p = Popen(['grep', 'f'], stdout=PIPE, stdin=PIPE, stderr=STDOUT)
grep_stdout = p.communicate(input=b'one\ntwo\nthree\nfour\nfive\nsix\n')[0]
print(grep_stdout.decode())
# -> four
# -> five
# ->

# ### STDOUT
result = subprocess.run('echo aa; echo bb 1>&2', stderr = subprocess.STDOUT, stdout = subprocess.PIPE, shell = True)
# `CompletedProcess(args='echo aa; echo bb 1>&2', returncode=0, stdout=b'aa\nbb\n')`。返回值 stderr 类型为 None
print(result)
```

#### 返回值

类型是 `<class 'subprocess.CompletedProcess'>`, 成员：

-   stdout

    从子进程捕获到的标准输出.

-   stderr

    捕获到的子进程的标准错误.

for example

```python
import subprocess
result = subprocess.run('echo -e \'aa\nbb\'', stdout=subprocess.PIPE, shell = True)
# 类型是 `<class 'subprocess.CompletedProcess'>`
print(result)
# 类型是 `<class 'bytes'>`
print(type(result.stdout))

print(result.stdout.decode('utf-8'))
# `<class 'str'>`
print(type(result.stdout.decode('utf-8')))

print(result.stdout.split(b'\n'))
```

## os

```python
import os

# ### 进程参数
# #### uid, gid
os.getegid()
os.geteuid()
os.getgid()
os.getpid()

# #### environ
# 注解 直接调用 putenv() 并不会影响 os.environ，所以推荐直接修改 os.environ。
os.environ
# 该变量名修改会影响由 os.system()， popen() ，fork() 和 execv() 发起的子进程。
# os.environ 中的参数赋值会自动转换为对 putenv() 的调用。不过 putenv() 的调用不会更新 os.environ，因此最好使用 os.environ 对变量赋值。
os.getenv(key)
os.putenv(key, value)
os.unsetenv(key)

# ### 文件和目录
os.getcwd()
os.chdir(path)
os.chmod(path, mode, *, dir_fd=None, follow_symlinks=True)
os.chown(path, uid, gid, *, dir_fd=None, follow_symlinks=True)

os.listdir(path='.')
os.stat(path, *, dir_fd=None, follow_symlinks=True)
os.lstat(path, *, dir_fd=None)

# 没有进入子目录
os.scandir(path='.')
    os.DirEntry.name
    os.DirEntry.path
    os.DirEntry.is_dir(*, follow_symlinks=True)
    os.DirEntry.is_file(*, follow_symlinks=True)
    os.DirEntry.is_symlink()
    os.DirEntry.stat(*, follow_symlinks=True)
# 它都会生成一个三元组 (dirpath, dirnames, filenames)，分别是目录的路径，该目录下的子目录名，该目录下的文件名。会递归地访问目录。
os.walk(top, topdown=True, onerror=None, followlinks=False)

# 创建文件
os.mknod(path, mode=0o600, device=0, *, dir_fd=None)
os.mkdir(path, mode=0o777, *, dir_fd=None)
# `mdkir -p`
os.makedirs(name, mode=0o777, exist_ok=False)
# 用于删除文件，不能删除目录
os.remove(path, *, dir_fd=None)
# 相当于 `os.remove`
os.unlink(path, *, dir_fd=None)
# 相当于 shell 的 rmdir`
os.rmdir(path, *, dir_fd=None)
# 相当于 shell 的 `rmdir -p`
os.removedirs(name)
os.rename(src, dst, *, src_dir_fd=None, dst_dir_fd=None)
# 工作方式类似 rename()，除了会首先创建新路径所需的中间目录。重命名后，将调用 removedirs() 删除旧路径中不需要的目录。比如：os.renames(old, newdir/new)。
os.renames(old, new)
os.replace(src, dst, *, src_dir_fd=None, dst_dir_fd=None)

# 创建硬链接
os.link(src, dst, *, src_dir_fd=None, dst_dir_fd=None, follow_symlinks=True)
# 创建软链接
os.symlink(src, dst, target_is_directory=False, *, dir_fd=None)

# `os.F_OK os.R_OK os.W_OK os.X_OK` 作为 access() 的 mode 参数的可选值，分别测试 path 的存在性、可读性、可写性和可执行性。
os.access(path, mode, *, dir_fd=None, effective_ids=False, follow_symlinks=True)

# ### 进程管理
os.execl(path, arg0, arg1, ...)
os.execle(path, arg0, arg1, ..., env)
os.execlp(file, arg0, arg1, ...)
os.execlpe(file, arg0, arg1, ..., env)

os.execv(path, args)
os.execve(path, args, env)
os.execvp(file, args)
os.execvpe(file, args, env)

os.kill(pid, sig)
os.system(command)
# 可用于计算程序运行时间
os.times()
# 相当于 `xdgopen`, 只适用于 windows 平台
os.startfile(path[, operation])
```

os.chown

for example

```python
import pwd
import grp
import os

uid = pwd.getpwnam("nobody").pw_uid
gid = grp.getgrnam("nogroup").gr_gid
path = '/tmp/f.txt'
os.chown(path, uid, gid)
```

os.scandir()

for example

```python
for entry in os.scandir('.') :
    if entry.is_dir() or entry.is_file():
        print(entry.name)

```

os.walk()

for example

```python
for dirpath, dirnames, filenames in os.walk('AA'):
    print(dirpath, dirnames, filenames)

# 只显示文件
for dirpath, dirnames, filenames in os.walk('destDir'):
    for f in filenames:
        fullFilename = os.path.join(dirpath, f)
        print(fullFilename)

# 只显示目录
for dirpath, dirnames, filenames in os.walk('destDir'):
    for d in dirnames:
        fullDirname = os.path.join(dirpath, d)
        print(fullDirname)
```

os.times()

```python
startTime = os.times()
sum = 0
for i in range(0, 100000000):
    sum += i
endTime = os.times()
print(startTime)
print(endTime)
print(f"程序运行时间: {endTime.user - startTime.user} s")
```

## os.path

[os.path](https://docs.python.org/zh-cn/3/library/os.path.html)

```python
import os

os.path.abspath(path)
os.path.isabs(path)
os.path.expanduser(path)

os.path.exists(path)
os.path.lexists(path)
os.path.isfile(path)
os.path.isdir(path)
os.path.islink(path)

os.path.basename(path)
os.path.dirname(path)
os.path.join(path, *paths)
os.path.split(path)
os.path.splitdrive(path)
os.path.splitext(path)

os.path.normpath(path)
os.path.samefile(path1, path2)

os.path.getatime(path)
os.path.getmtime(path)
os.path.getctime(path)
```

常用路径操作

for example

```python
print( os.path.basename('/root/runoob.txt') )       # 返回文件名
print( os.path.dirname('/root/runoob.txt') )        # 返回目录路径
print( os.path.split('/root/runoob.txt') )          # 分割文件名与路径
print( os.path.join('root','test','runoob.txt') )   # 将目录和文件名合成一个路径
```

## pathlib.Path

[对应的 os 模块的工具](https://docs.python.org/zh-cn/3/library/pathlib.html?highlight=pathlib#correspondence-to-tools-in-the-os-module)

```python
from pathlib import Path

Path.glob(pattern)
# 这就像调用 Path.glob`时在给定的相对 *pattern* 前面添加了"``**/`()"
Path.rglob(pattern)
# 不会进入子目录。如果是 linux 平台，返回 <class 'pathlib.PosixPath'>
Path.iterdir()
Path.touch(mode=0o666, exist_ok=True)
```

for example

```python
from pathlib import Path

Path('path/to/file.txt').touch()
```

## glob

相当于 linux 的通配符。支持 `*, ?, [`。

for example

```python
import glob

glob.glob(pathname, *, recursive=False)
```

## fnmatch

用 linux 的通匹符模式匹配文件名。

```python
import fnmatch

fnmatch.fnmatch(filename, pattern)
fnmatch.fnmatchcase(filename, pattern)
# 它等价于 [n for n in names if fnmatch(n, pattern)]，但实现得更有效率。
fnmatch.filter(names, pattern)
# 将通匹符模式转换为正则表达式模式
fnmatch.translate(pattern)
```

fnmatch.filter()

for example

```python
for root, dirs, files in os.walk(directory):
    for filename in fnmatch.filter(files, '*.png'):
        pass
```

fnmatch.translate()

for example

```python
import fnmatch, re
regex = fnmatch.translate('*.txt')
reobj = re.compile(regex)
reobj.match('foobar.txt')
```

## shutil

shutil 模块提供了一系列对文件和文件集合的高阶操作。对于单个文件的操作，请参阅 os 模块。

```python
import shutil

# ### 目录和文件操作
# 仅复制文件，不能复制目录
shutil.copy(src, dst, *, follow_symlinks=True)
# 类似于 copy()，区别在于 copy2() 还会尝试保留文件的元数据。比如：创建时间，修改时间等。
shutil.copy2(src, dst, *, follow_symlinks=True)
shutil.copytree(src, dst, symlinks=False, ignore=None, copy_function=copy2, ignore_dangling_symlinks=False, dirs_exist_ok=False)
shutil.rmtree(path, ignore_errors=False, onerror=None)

# 移动文件或目录。与 `os.rename()` 是一样的功能。
shutil.move(src, dst, copy_function=copy2)
# 与 `os.chown()` 是一样的功能。
shutil.chown(path, user=None, group=None)
# 相当于 shell which
shutil.which(cmd, mode=os.F_OK | os.X_OK, path=None)

# ### 归档操作（tarfile 模块更加强大）
# format: zip, tar, gztar, bztar, xztar，用于 `shutil.get_archive_formats()` 显示支持的 format。
# 只能添加一个目录。
shutil.make_archive(base_name, format[, root_dir[, base_dir[, verbose[, dry_run[, owner[, group[, logger]]]]]]])
shutil.unpack_archive(filename[, extract_dir[, format]])
```

`shutil.make_archive, shutil.unpack_archive`

for example

```python
os.makedirs('aa/bb')
Path('aa/bb/bar').touch()

# `zip -r theArchive.zip ./aa`
shutil.make_archive('theArchive', 'zip', '/home/johan/Desktop/Temp', 'aa')
# `zip -r theArchive.zip ./aa`
shutil.make_archive("theArchive", "zip", ".", "aa")
# `zip -r theArchive.zip /home/johan/Desktop/Temp/aa`
shutil.make_archive("theArchive", "zip", "/", "home/johan/Desktop/Temp/aa")

# `unzip <zipfile>`
shutil.unpack_archive("theArchive.zip")
# `unzip <zipfile> -d <destDir>`
shutil.unpack_archive("theArchive.zip", "destDir")
```

## tarfile

tarfile 支持的 format 和 shell 的 tar 命令相同。

```python
import tarfile

tarfile.open(name=None, mode='r', fileobj=None, bufsize=10240, **kwargs)
TarFile.add(name, arcname=None, recursive=True, *, filter=None)
TarFile.extractall(path=".", members=None, *, numeric_owner=False)
```

for example

```python
import tarfile

# ### 创建压缩文件
with tarfile.open("sample.tar.gz", "w:gz") as tar:
    for name in ["foo", "bar", "quux"]:
        tar.add(name)

# ### 提取压缩文件
tar = tarfile.open("sample.tar.gz")
tar.extractall()
# tar.extractall("destDir")
tar.close()

# ### 查看压缩文件
import tarfile
tar = tarfile.open("sample.tar.gz", "r:gz")
for tarinfo in tar:
    print(tarinfo.name, "is", tarinfo.size, "bytes in size and is ", end="")
    if tarinfo.isreg():
        print("a regular file.")
    elif tarinfo.isdir():
        print("a directory.")
    else:
        print("something else.")
tar.close()
```

## zipfile

```python
ZipFile.printdir()
ZipFile.extractall(path=None, members=None, pwd=None)
ZipFile.write(filename, arcname=None, compress_type=None, compresslevel=None)
```

for example

```python
from zipfile import ZipFile

with ZipFile('sample.zip','w') as zip:
    for name in ["foo", "bar", "qux"]:
        zip.write(name)

with ZipFile('sample.zip', 'r') as zip:
    zip.extractall()
    # zip.extractall('destDir')

with ZipFile('sample.zip','r') as zip:
    zip.printdir()
```

## psutil

`pip install psutil`

for example

```python
# 列出进程
for p in psutil.process_iter():
    print(p)

# 列出网络
psutil.net_connections()

# 列出特定进程的网络
p = psutil.Process(1694)
p.name()
p.connections()
```

## 检测系统平台

[ref](https://stackoverflow.com/questions/1854/python-what-os-am-i-running-on)

```python
import os, platform

# `posix`, `nt`
os.name
# `Linux`, `Windows`, `Darwin`
platform.system()
# `linux`, `linux2`, `win32`, `win64`, `darwin`
sys.platform
```

## python 获得管理员权限 ??

### linux

[ref](https://stackoverflow.com/a/20153881/16235950)

```python
#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import os, subprocess

def prompt_sudo():
    ret = 0
    if os.geteuid() != 0:
        msg = "[sudo] password for %u:"
        ret = subprocess.check_call("sudo -v -p '{0}'".format(msg), shell=True)
    return ret

if __name__ == "__main__":
    if prompt_sudo():
        sys.stderr.write("Can't gain admin privilege!\n")

    print(os.geteuid())
```

### windows

[ref](https://blog.csdn.net/qq_17550379/article/details/79006655)

```python
from __future__ import print_function
import ctypes, sys

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

# ### main
if is_admin():
    # 将要运行的代码加到这里
else:
    if sys.version_info[0] == 3:
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)
    else:#in python2.x
        ctypes.windll.shell32.ShellExecuteW(None, u"runas", unicode(sys.executable), unicode(__file__), None, 1)
```

## 总结 python 替代 shell

```python
import os, glob, fnmatch, shutil, subprocess
from pathlib import Path
import psutil

# ## 路径的处理
print( os.path.basename('/root/runoob.txt') )       # 返回文件名
print( os.path.dirname('/root/runoob.txt') )        # 返回目录路径
print( os.path.split('/root/runoob.txt') )          # 分割文件名与路径
print( os.path.join('root','test','runoob.txt') )   # 将目录和文件名合成一个路径

os.path.abspath(path)
os.path.isabs(path)
os.path.expanduser(path)

# ## 文件管理
os.getcwd()
os.chdir(path)

# ### 创建/删除文件（不包含目录）
# `os.mknod(path, 0o644)`
os.mknod(path, mode=0o600, device=0, *, dir_fd=None)
Path(path).touch()
os.remove(path, *, dir_fd=None)
os.unlink(path, *, dir_fd=None)

# ### 创建/删除空目录（rmdir）
os.mkdir(path, mode=0o777, *, dir_fd=None)
os.makedirs(name, mode=0o777, exist_ok=False)
os.rmdir(path, *, dir_fd=None)
os.removedirs(name)

# ### 复制/删除目录
shutil.copy(src, dst, *, follow_symlinks=True)
shutil.copy2(src, dst, *, follow_symlinks=True)
shutil.copytree(src, dst, symlinks=False, ignore=None, copy_function=copy2, ignore_dangling_symlinks=False, dirs_exist_ok=False)
shutil.rmtree(path, ignore_errors=False, onerror=None)

# ### 重命名文件
os.rename(src, dst, *, src_dir_fd=None, dst_dir_fd=None)
os.renames(old, new)
os.replace(src, dst, *, src_dir_fd=None, dst_dir_fd=None)

# ### 进入目录
os.scandir(path='.')
os.walk(top, topdown=True, onerror=None, followlinks=False)
Path.iterdir()

# ### 判断文件的属性、状态等
os.path.exists(path)
os.path.lexists(path)
os.path.isfile(path)
os.path.isdir(path)
os.path.islink(path)

# `os.F_OK os.R_OK os.W_OK os.X_OK` 作为 access() 的 mode 参数的可选值，分别测试 path 的存在性、可读性、可写性和可执行性。
os.access(path, mode, *, dir_fd=None, effective_ids=False, follow_symlinks=True)
os.scandir(path='.')
    os.DirEntry.is_dir(*, follow_symlinks=True)
    os.DirEntry.is_file(*, follow_symlinks=True)
    os.DirEntry.is_symlink()
    os.DirEntry.stat(*, follow_symlinks=True)

os.stat(path, *, dir_fd=None, follow_symlinks=True)
os.lstat(path, *, dir_fd=None)

# ## 用户
# ### 用户名和 uid 之间相互查询
pwd.getpwuid(uid).pw_name
pwd.getpwnam(name).pw_uid
grp.getgrgid(gid).gr_name
grp.getgrnam(name).gr_gid

# ### 列出用户组成员
os.getgroups()
os.getgrouplist('johan', os.getgid())

# ### 通匹符模式
glob.glob(pathname, *, recursive=False)
fnmatch.fnmatch(filename, pattern)
fnmatch.fnmatchcase(filename, pattern)

# ## 压缩文件
shutil.make_archive(base_name, format[, root_dir[, base_dir[, verbose[, dry_run[, owner[, group[, logger]]]]]]])
shutil.unpack_archive(filename[, extract_dir[, format]])
tarfile.open(name=None, mode='r', fileobj=None, bufsize=10240, **kwargs)
TarFile.add(name, arcname=None, recursive=True, *, filter=None)
TarFile.extractall(path=".", members=None, *, numeric_owner=False)
ZipFile.printdir()
ZipFile.extractall(path=None, members=None, pwd=None)
ZipFile.write(filename, arcname=None, compress_type=None, compresslevel=None)

# ## environ
os.environ
os.getenv(key)
os.putenv(key, value)
os.unsetenv(key)

# ## 进程管理和网络
os.kill(pid, sig)

# 列出进程
for p in psutil.process_iter():
    print(p)

# 列出网络
psutil.net_connections()

# 列出特定进程的网络
p = psutil.Process(1694)
p.name()
p.connections()
```
