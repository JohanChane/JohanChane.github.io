# 常用

## sys

[sys](https://docs.python.org/zh-cn/3/library/sys.html#module-sys)

`sys.path`

> 模块搜索路径

`sys.stdin, sys.stdout, sys.stderr`

> 解释器用于标准输入、标准输出和标准错误的文件对象

for example

```python
import sys

print(sys.path)
print(sys.argv)
print(sys.modules)
```

## 程序 exit and exit code

[exit code](https://docs.python.org/zh-cn/3.9/library/os.html#os.EX_OK)

`sys.exit(n)` 退出程序引发SystemExit异常, 可以捕获异常执行些清理工作。<br>
`exit()/quit()`, 跑出SystemExit异常. 一般在交互式shell中退出时使用。

用 `sys.exit("some error message")` 退出比较方便。

for example

```python
import sys

def main():
    sys.exit(123)
    return

if __name__ == '__main__':
    try:
        main()
    except SystemExit as e:
        if str(e) == '123':
            print('---123---')
            exit(123)
```

## IO

[IO](https://docs.python.org/zh-cn/3/library/io.html?highlight=seek#module-io)

处理流的核心工具

### stdandard input output

[stdandard input output](https://docs.python.org/zh-cn/3/library/sys.html?highlight=sys%20stdin#sys.stdin)

    input(), print()

标准 IO 流

    sys.stdin
    sys.stdout
    sys.stderr


for example

```python
s = input('please input something: ')
print(s)
```

for example

```python
import sys

for line in sys.stdin:
    if 'q' == line.rstrip():
        break
    # f 前缀表示 format
    print(f'Input : {line}')
    sys.stdout.write(line)
    sys.stderr.write(line)
```

### 文件读写

[文件读写](https://www.programiz.com/python-programming/file-operation)

    open(), close()
    read(), readline(), readlines()
    write(), writelines()
    tell(), seek()

for example: 打开文件的方式

```python
# ### 打开文件的两种方式
try:
    f = open("testfile", mode='r', encoding='utf-8')
    # perform file operations
finally:
    f.close()

# 会自动调用 close()
with open("testfile", mode='r', encoding = 'utf-8') as f:
    # perform file operations
```

for example

```python
import io
import os

try:
    f = open("testfile", mode='w', encoding='utf-8')
    f.write('ABC\nDEF')
    lines = ['\nUVW\n', 'XYZ']
    f.writelines(lines)

    f = open("testfile", mode='r', encoding='utf-8')
    print(f'read():\n{f.read()}')

    f.seek(0, io.SEEK_SET)
    print(f'read(2):\n{f.read(2)}')

    f.seek(0, io.SEEK_SET)
    # 读入换行符
    print(f'readline():\n{f.readline()}')

    f.seek(0, io.SEEK_SET)
    print(f'readline(2):\n{f.readline(2)}')

    f.seek(0, io.SEEK_SET)
    print(f'readlines():\n{f.readlines()}')

    f.seek(0, io.SEEK_SET)
    # n 不包含换行符
    print(f'readlines(8):\n{f.readlines(8)}')

    os.remove('testfile')

finally:
    f.close()
```

常用操作

for example

```python
# ### read the whole file
with open(<file>, 'r') as file:
    # 返回一个 str
    content = file.read()
    print(content)

with open(<file>, 'r') as file:
    # 返回一个 list, 将每一行作为 list 的元素（读入换行符）。
    content = file.readlines()
    print(content)

myfile = open("bar", "r")
while myfile:
    line  = myfile.readline()
    print(line)
    # readline() 会读入换行符, 所以这样就能判断读到了 EOF。
    if line == "":
        break
myfile.close()

# ### read file line by line
with open(<file>, 'r') as file:
    # line 包含换行符
    for line in file:
        print(line)

with open(filePath, 'r') as f:
    # line 包含换行符
    lines = f.readlines()
    for i in range(0, len(lines)):
        print(lines[i])

# ### read file word by word
with open(<file>, 'r') as file:
    for line in file:
        for word in line.split():
            print(word)

# ### 删除每行最后的空白符
with open(filename) as f:
    content = f.readlines()
content = [x.strip() for x in content]
```

## str, byte, bytearray

```python
# ### str, byte, bytearray 都有的函数
str.split(sep=None, maxsplit=-1)
str.rsplit(sep=None, maxsplit=-1)
str.splitlines([keepends])

str.strip([chars])
# left strip
str.lstrip([chars])
# right strip
str.rstrip([chars])

str.count(sub[, start[, end]])
str.endswith(suffix[, start[, end]])

str.removeprefix(prefix, /)
str.removesuffix(suffix, /)

str.join(iterable)
str.replace(old, new[, count])
str.partition(sep)
str.rpartition(sep)

# byte, bytearray 独有的函数
bytes.decode(encoding="utf-8", errors="strict")
```

## time

```python
import time

time.strftime("%Y-%m-%d_%H-%M-%S", time.localtime())
```

## re（正则表达式）

```python
re.match(pattern, string, flags=0)
re.search(pattern, string, flags=0)

# 序列
prog = re.compile(pattern)
result = prog.match(string)
# 等价于
result = re.match(pattern, string)
```
[re.match vs re.search](https://docs.python.org/zh-cn/3/library/re.html?highlight=re#search-vs-match)

> match 是从字符串的开始位置匹配，而 search 是任意位置匹配。

for example

```python
re.match("c", "abcdef")    # No match
# 等价于
re.search("^c", "abcdef")  # No match

re.search("a", "abcdef")   # Match
re.search("c", "abcdef")   # Match

# 有特殊字符用 raw str 更好
re.search("^\\s+a", " abcdef")
re.search(r"^\s+a", " abcdef")
```

## 处理 json 文件

for example

```python
import json

data = {
    'name' : 'ACME',
    'shares' : 100,
    'price' : 542.23
}

with open('data.json', 'w') as f:
    json.dump(data, f)

with open('data.json', 'r') as f:
    data = json.load(f)

print(type(data))
print(data)
```

## 处理 yaml 文件

refs

-   [使用Python处理yaml格式的数据](https://www.cnblogs.com/keyou1/p/11510975.html)

pyyaml 和 ruamel.yaml

-   pyyaml

    应用最广泛

    封装的api不够简单

    不支持YAML 1.2最新版

-   ruamel.yaml

    是pyyaml的衍生版

    封装的api简单

    支持YAML 1.2最新版

*选择 ruamel.yaml 处理比较方便*


for example: write

```python
from ruamel.yaml import YAML

# 第一步: 创建YAML对象
# yaml = YAML(typ='safe')
yaml = YAML()

# 第二步: 将Python中的字典类型数据转化为yaml格式的数据
src_data = {'user': {'name': '可优', 'age': 17, 'money': None, 'gender': True},
            'lovers': ['柠檬小姐姐', '橘子小姐姐', '小可可']
            }

with open('user_info.yaml', mode='w', encoding='utf-8') as file:
    yaml.dump(src_data, file)
```

for example: read

```python
from ruamel.yaml import YAML

# 第一步: 创建YAML对象
yaml = YAML(typ='safe')

# typ: 选择解析yaml的方式
#  'rt'/None -> RoundTripLoader/RoundTripDumper(默认)
#  'safe'    -> SafeLoader/SafeDumper,
#  'unsafe'  -> normal/unsafe Loader/Dumper
#  'base'    -> baseloader

# 第二步: 读取yaml格式的文件
with open('user_info.yaml', encoding='utf-8') as file:
    data = yaml.load(file)  # 为列表类型

print(data)
```

## configparser

文件的后缀一般为 `.conf/.ini`。

```python
from configparser import ConfigParser

config_parser = ConfigParser()

# ## write
config_parser.add_section('db')
config_parser.set('db', 'db_host', '127.0.0.1')
config_parser.set('db', 'db_port', '22')
config_parser.set('db', 'db_user', 'root')
config_parser.set('db', 'db_pass', 'rootroot')
config_parser.add_section('debug')
config_parser.set('debug', 'log_errors', 'true')

with open('test.conf', 'w', encoding='utf-8') as f:
    config_parser.write(f)

# ## read

config_parser.read('config.ini')

print(config_parser.sections())

print(config_parser.options('db'))
print(config_parser.items('db'))

print(config_parser.get('db', 'db_host'))
print(config_parser.getint('db', 'db_port'))
print(config_parser.getboolean('debug', 'log_errors'))

# ## remove
config_parser.remove_option('debug','log_errors')
config_parser.remove_section('debug')

with open('test.conf', 'w', encoding='utf-8') as f:
    config_parser.write(f)

# ## 检测
print(config_parser.has_section('db'))
print(config_parser.has_option('db', 'user_name'))
```

## requests

refs

-   [Python Requests Tutorial](https://www.geeksforgeeks.org/python-requests-tutorial/)

for example

```python
import requests

response = requests.get('https://w3schools.com/python/demopage.htm')

print(response.text)
print(response.content)
print(response.content.decode(encoding='utf-8'))
print(response.status_code)

with open('response_file', 'wb') as code:
    code.write(response.content)
```

## urllib

### urllib3

refs

-   [urllib3](https://www.cnblogs.com/eliwang/p/14284091.html)

for example

```python
import urllib3

# 创建PoolManager对象，用于处理与线程池的连接以及线程安全的所有细节
http = urllib3.PoolManager()

# 创建ProxyManager对象（使用代理）
#proxy_http = urllib3.ProxyManager('https://175.42.122.96:9999')

# 对需要爬取的网页发送请求
resp = http.request('GET','https://www.baidu.com/')

print(resp.data.decode())   # 响应数据
print(resp.headers)         # 响应头信息
print(resp.status)          # 状态码
resp.release_conn()         # 释放这个http连接
```

for example: SSL

```python
import urllib3
import certifi

#开启ssl证书自动验证
http = urllib3.PoolManager(cert_reqs='CERT_REQUIRED', ca_certs=certifi.where())

headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36'}
resp = http.request('GET', 'https://www.baidu.com/', headers=headers)

print(resp.data.decode())
```

### urllib2

[urllib2 已合并到 urllib.request](https://docs.python.org/2/library/urllib.html)

for example

```python
import urllib.request
url = 'https://w3schools.com/python/demopage.htm'
f = urllib.request.urlopen(url)
data = f.read()
with open('response_file', 'wb') as code:
    code.write(data)
```
