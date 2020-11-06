#!/usr/bin/python3
# -*- coding: utf8 -*-

## # 简单学习一下，知道有些东西就行。

## ### References

- <https://github.com/ninjaaron/replacing-bash-scripting-with-python/blob/master/README.rst>

import  os, sys, shutil, re, time, psutil
from pathlib import Path
from pyroute2 import IPRoute

# 行缓存，如果没有换行符则没有输入。
# sys.stderr.write('error msg')
sys.stderr.write('error msg\n')
print('error msg.', file=sys.stderr)
# sys.stdout.write('error msg\n')

print(sys.argv)
print(os.environ)

# ### 操作文件

os.mknod('myfile1')
Path('.').touch('myfile1')
shutil.move('myfile1', 'MyFile1')
os.remove('MyFile1')
try:
    os.mkdir('mydir1')
except OSError as err:
    pass
Path('mydir2/mydir1').mkdir(parents=True, exist_ok=True)
try:
    shutil.copytree('mydir2', 'mydir3')
except OSError as err:
    pass
shutil.rmtree('mydir1')
shutil.rmtree('mydir2')


# ### 文件读写

with open('myfile.txt', 'w') as myfile:
        myfile.write('AA \n')
        myfile.write('BB \n')

with open('myfile.txt') as myfile:
    for line in myfile:
        # line 包含换行符
        print(line + '|')
        # 删除换行符
        print(line.rstrip('\n') + '|')
        # 删除行末尾的空白符
        print(line.rstrip() + '|')

# ### 操作文件路径（不处理文件内容）
p = Path()
print(type(p))

for i in p.iterdir():
    print(i)
    print(repr(i))

for i in p.glob('*.txt'):
    print(i)

p = p.absolute()
print(p)
print(p.name)
print(p.parent)
print(p.parts)
print(p.is_dir())
print(p.is_file())
print(p.stat())
myfile = p/'myfile.txt'
print(myfile)


with myfile.open() as file_handle:
    print(type(file_handle))

myfile.chmod(0o775)

print([p for p in Path().glob('**/*') if p.is_dir()])

try:
    os.mknod('src')
    os.mkdir('mydir')
except OSError as e:
    pass

shutil.move('src', 'dest')

print('abc' in 'abcdef')

s = 'dog'

pattern = re.compile('d.')
match = pattern.search(s)
print(match)
print(type(match))
print(match.group())


print('dog'.replace('d', 'D'))

print('ABC:DEF'.split(':'))


print(time.strftime('%Y.%m.%d'))

# s = """abc
# aef
# """
# myfilter = re.compile('a(.*)\n')
# filtered = myfilter.findall(s)
# print(filtered)

shutil.make_archive('my_archive', 'gztar', '.')
os.remove('my_archive.tar.gz')

for p in psutil.process_iter():
    print(p)

ip = IPRoute()
print(ip)
index = ip.link_lookup(ifname='ens33')[0]
ip.addr('add', index, address='192.168.40.129', mask=24)
ip.close()


# os.walk, glob
