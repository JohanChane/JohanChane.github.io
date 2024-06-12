# Python 的语言基础

## Content

${toc}

## 说明

*Python version: Python3.8*

## References

-   [官方入门教程](https://docs.python.org/zh-cn/3.8/tutorial/index.html)
-   [python 语法和语义(重点)](https://docs.python.org/zh-cn/3.8/reference/index.html)
-   [Python 标准库参考。有 python 使用例子](https://docs.python.org/zh-cn/3.8/library/index.html)
-   [搜索 python 文档](https://docs.python.org/zh-cn/3.8/search.html)
-   [python 的内置函数](https://docs.python.org/zh-cn/3/library/functions.html)

## 基本概念

### 一切都是对象。

for example

```python
i = 10
print(type(i))
print(type(str))
def func():
    pass

print(type(func))
print(id(func))

func = 100
func
```

*避免混淆，类对象说的是类，而根据类实例化的对象称为实例。*

### 变量名与对象

变量名没有数据类型的概念（java 的变量名有数据类型的概念），只是一个引用对象的标签。但是对象是有数据类型的。

for example

```python
list1 = [1, 2]
list1 = 100;
list1.append(3)             # AttributeError: 'int' object has no attribute 'append'
print(type(list1))          # 显示 list1 变量引用的对象的类型。
```

#### 对象的 id

[对象的 id](https://docs.python.org/zh-cn/3/reference/datamodel.html#objects-values-and-types)

每个对象都有各自的编号、类型和值。一个对象被创建后，它的编号就绝不会改变；你可以将其理解为该对象在内存中的地址。 'is' 运算符可以比较两个对象的编号是否相同；`id()` 函数能返回一个代表其编号的整型数。

在 CPython 中，id(x) 就是存放 x 的内存的地址。

### 对象含有对象是如何存储的

内置序列类型概览

> 容器序列存放的是它们所包含的任意类型的对象的引用，而扁平序列里存放的是值而不是引用。换句话说，扁平序列其实是一段连续的内存空间(所以不包含引用)。由此可见扁平序列其实更加紧凑，但是它里面只能存放诸如字符、字节和数值这种基础类型。

    容器序列
    　　list、tuple 这些序列能存放不同类型的数据。
    扁平序列
    　　str 这类序列只能容纳一种类型。


> 容器序列对象存放的东西都是引用，存入数字和字符串时，也是存入引用。扁平序列对象存放的东西不是引用，而是对象的内容（无引用）。

> 可变序列的对象是可变对象，而不可变序列的对象是不可变对象。

### Ohters

#### 语法变化

花括号不用写，用 `:` 代替。花括号的内容不能为空，可放置 dummpy command (pass)。

```python
def func():
    pass
class  MyClass():
    pass

if True :
else:
```

## Get help

-   `help()`

        help(<object>)

        # 相当于在 help untility 中输入 <string>
        help('<string>')

-   help utility(用 `help()` 进入)

    可列出 a list of available modules, keywords, symbols, or topics。

-   `python -m pydoc <string>` OR `pydoc <string>`

### 查看 builtin 函数或类型的定义

因为 builtin 函数或类型的定义不一定是用 python 实现的，所以就不一定存在其声明或定义。但是官方的 doc 有给出其声明，但 python 内置的 doc 没有其声明，但有另外一种形式的声明。比如：print。

-   [官方的 doc 的 print](https://docs.python.org/zh-cn/3/library/functions.html#print)

-   python 内置的 doc 的 print。`pydoc print`

## 查看信息（用于反馈）

-   `type(), dir(), id(), del`

        type([object])

            查看对象类型

        dir([object])

            列出对象属性

        id(<object>)

            列出对象 id

-   `isinstance(object, classinfo)`

        如果参数 object 是参数 classinfo 的实例或者是其 (直接、间接或 虚拟) 子类的实例则返回 True。

-   `issubclass(class, classinfo)`

        如果 class 是 classinfo 的 (直接、间接或 虚拟) 子类则返回 True。 类会被视作其自身的子类。

for example

```python
print(isinstance(True, bool))
# bool 是 int 的子类
print(isinstance(True, int))
print(isinstance(True, object))

print(issubclass(bool, int))

# 类会被视作其自身的子类
# True
print(issubclass(str, str))

print(issubclass(str, object))
# output: false
print(issubclass(object, str))
```

## 调试程序

调试(导入 pdb module): `python3 -m pdb <script>`

## `print()`

[`print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)`](https://docs.python.org/zh-cn/3/library/functions.html#print)

for example

```python
list1 = ['ABC', 'DEF']
for i in list1:
    print(i, end=' ')

print('')
```

## 输出格式

[输出格式](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html?highlight=seek#input-and-output)

-   `f/F` 前缀与 `{<expression>}`

-   `str.format()`

for example

```python
# ### `f/F` 前缀与 `{<expression>}`
print(f'__name__ = {__name__}')

def func():
    return 'ABC'
print(f'ret: {func()}')

import math
print(f'The value of pi is approximately {math.pi:.3f}.')

table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 7678}
for name, phone in table.items():
    print(f'{name:10} ==> {phone:10d}')

# ### str.format()
print('We are the {} who say "{}!"'.format('knights', 'Ni'))
print('{0} and {1}'.format('spam', 'eggs'))
print('{1} and {0}'.format('spam', 'eggs'))
print('The story of {0}, {1}, and {other}.'.format('Bill', 'Manfred', other='Georg'))
```

旧的字符串格式化方法

    'string' % values

for example

```python
import math
print('The value of pi is approximately %5.3f.' % math.pi)
```

## 字面值

[字面值](https://docs.python.org/zh-cn/3.8/reference/lexical_analysis.html#literals)

字符串字面值(单引号与双引号无区别)

    'ABC'
    "ABC"

### 字符串字面值拼接

[字符串字面值拼接](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#string-literal-concatenation)

有两种拼接方式，用空格或加号。两者区别：[空格是编译时实现拼接的，加号是运行时实现拼接的](https://docs.python.org/zh-cn/3.8/reference/lexical_analysis.html#implicit-line-joining)

    # 结果为 'ABCDEF'
    'ABC' 'DEF'
    'ABC' "DEF"
    'ABC' + 'DEF'
    'ABC' + "DEF"

## 转义字符

`\n`, `\<newline>`, ...

### 转义换行符

```python
"AAAAAAAAAAAAAAAAAAAA \
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

if 1900 < year < 2100 and 1 <= month <= 12 \
and 1 <= day <= 31 and 0 <= hour < 24 \
and 0 <= minute < 60 and 0 <= second < 60:
    return 1
```

[圆括号、方括号或花括号以内的表达式允许分成多个物理行，无需使用反斜杠。](https://docs.python.org/zh-cn/3.8/reference/lexical_analysis.html#implicit-line-joining)

    month_names = ['Januari', 'Februari', 'Maart',      # These are the
               'April',   'Mei',      'Juni',           # Dutch names
               'Juli',    'Augustus', 'September',      # for the months
               'Oktober', 'November', 'December']       # of the year

## 转义引号

单引号与双引号的区别是，在单引号内，双引号是普通字符。在双引号内，单引号是普通字符。

for example

```python
# ### 转义单引号
print("'")
print('\'')
# ### 转义双引号
print('"')
print("\"")
```

## 内置数据类型

[内置数据类型](https://docs.python.org/zh-cn/3.8/reference/datamodel.html#the-standard-type-hierarchy)

### 内置数据类型的分类

#### 数字类型

-   整型数

    -   int(支持的长度取决于虚拟内存的大小)
    -   bool

-   浮点型数

-   复数

#### 序列类型

此类对象表示以非负整数作为索引的有限有序集。

-   不可变序列

    -   字符串
    -   元组

-   可变序列

    -   列表

#### 集合类型

set 对象是由具有唯一性的 hashable 对象所组成的无序多项集。因此它们不能通过下标来索引。但是它们可被迭代。

***set 类型是可变的，而 frozenset 类型是不可变。***

-   set
-   frozenset

#### 映射类型

此类对象表示由任意索引集合所索引的对象的集合。其 key 必须是 hashable。

-   字典

### 常用的内置容器类型

python 常用的内置容器类型：tuple, list, set, dict。它们是可以迭代的且可放置多种类型的元素。

### 可变对象与不可变对象

不可变对象表示生命周期内都是不可改变的，可变对象表示生命周期内可改变的。

对不可变对象赋值时，返回一个新的对象（不会修改原来的对象，所以 `id(<varName>)` 会改变)）。而对可变对象赋值时，不会新建对象。

    for example

        i = 0
        id(i)
        i += 1
        id(i)

-   可变对象的类型

    list, set, dict

-   不可变的对象的类型

    int, bool, float, complex, string, tuple, frozenset

*不可变类型是不可继承的。因为派生类会是可以变的，但其父类是不可变，会比较混乱。?*

*元组与列表的区别是，元组是不可变的，而列表是可变的。有某些场景中，可用元组保护数据。比较：positional_only 参数的实参用 tuple 保存。*

### hashable

[hashable](https://docs.python.org/zh-cn/3.8/glossary.html#term-hashable)

一个对象的哈希值如果在其生命周期内绝不改变，就被称为 hashable （它需要具有 __hash__() 方法），并可以同其他对象进行比较（它需要具有 __eq__() 方法）。可哈希对象必须具有相同的哈希值比较结果才会相同。用户定义类的实例对象默认是可哈希的。 它们在比较时一定不相同（除非是与自己比较），它们的哈希值的生成是基于它们的 id()。

大多数 Python 中的不可变内置对象都是可哈希的；可变容器（例如列表或字典）都不可哈希；不可变容器（例如元组和 frozenset）仅当它们的元素均为可哈希时才是可哈希的。 用户定义类的实例对象默认是可哈希的。

*可变对象一定是 unhashable，不可变对象的元素都是 hashable 时，它才是 hashable。<br>
hashable 对象则是不可变对象且其元素也是 hashable。<br>
不可变对象不一定是 hashable 的，比如：`([1, 2], [3, 4])`*

-   hashable

    int, bool, float, complex, string, frozenset

-   unhashable

    list, set, dict

-   hashable 不确定的

    tuple


for example

```python
tuple1 = (1, 2)
print(hash(tuple1))

set1 = {1, 2}
# TypeError: unhashable type: 'set'
# print(hash(set1))

frozenset1 = frozenset('ABC')
print(hash(frozenset1))
```

### 数字类型

for example

```python
# 输出 `0.5` 这里要注意。
1/2
i = 1000000000000000000000000000000000000000000000000000
# 虽然 `i` 很大，但 `i` 的类型是 <class 'int'>
print(type(i))

i = 10
# ### float
f = 0.1
# e 记法
f = 1e10
f = 1e-10

# ### complex
cplx =4.7+0.666j            # 定义一个虚数
print(cplx)                 # 输出这个虚数
print(cplx.real)            # 输出实部
print(cplx.imag)            # 输出虚部
print(cplx.conjugate())     # 输出该复数的共轭复数
```

#### 类型转换

for example

```python
f = 1.5
i = int(f)
print(i)
str = str(f)
print(str)
f = float(str)
print(f)
```

### 序列类型

序列的通用操作

```python
# ### indexing
str[n]
# ### slicing

str[start : end : step]
    str[start:]
    str[:end]
    str[start::step]
    str[:]

# ### +, *
# ### in, not in

'A' in 'ABC'
'AB' in 'ABC'

# ### len(str), min(str), max(str)
```

for example

```python
str = 'ABC'

tuple1 = (1, 2)
tuple3 = 1, 2
# 错误的做法。tuple2 类型是 int
# tuple2 = (1)
tuple2 = (1,)
tuple4 = 1,
tuple5 = ()

# 不可修改
# tuple1[0]=1

list1 = [1, 2]
list2 = [1]
list3 = []

print(list1[:-1])
```

for example: `list[:]`

```python
# ## 修改对象
l1 = [1, 2, 3]
l2 = l1

# 这里创建了对象 `[1, 2]`
#  l1 = [1, 2]
# 这里修改了之前的 l1 引用的对象
l1[:] = [1, 2]

print(l1)
print(l2)

# ## 传递副本
l3 = [1, 2, 3]
def func(l):
    l.append(4)

# 传引用
#  func(l3)
# 传副本
func(l3[:])
print(l3)
```

#### 列表解析（list comprehension）

语法

    A2 = [i for i in A1 if i in A0]

    相当于：

    A2 = []
    for i in A1:
        if i in A0:
            A2.append(i)

for example

```python
list1 = [2*i for i in range(1, 100, 10)]
# [0, 20, 40, 60, 80, 100, 120, 140, 160, 180]
print(list1)

with open(filename) as f:
    content = f.readlines()
content = [x.strip() for x in content]

# 从列表中删除不符合的元素
list2 = ['a', '', 'c', '']
list3 = [x for x in list2 if x]
print(list3)
```

#### 删除列表中的部分元素

for example

```python
l1 = [9, 8, 7, 6]
# 如果删除的数不存在时，会报错。
l1.remove(8)
print(l1)

l2 = [9, 8, 7, 6]
del l2[1]
print(l2)

l3 = [9, 8, 7, 6]
i = l3.pop(1)
print(i)
print(l3)
```

### 集合类型

set = {<不可变对象>...}

for example

```python
set2 = {1, 2}
# 添加元素
set2.add(3)
print(set2)
# TypeError: 'int' object is not iterable
# set2.update(4)
set2.update([4])

# 删除元素
set2.remove(4)
set2.discard(3)
set2.pop()
print(set2)

# 集合的基本操作
set3 = {1, 2, 3}
set4 = {3, 4, 5}
# TypeError: unsupported operand type(s) for +: 'set' and 'set'
# print(set3 + set4)
# 集合减
print(set3 - set4)
# 并集
print(set3 | set4)
# 交集
print(set3 & set4)
# 不同时包含于 set3 和 set4 的元素
print(set3 ^ set4)
# TypeError: unsupported operand type(s) for *: 'set' and 'set'
# print(set3 * set4)
# TypeError: unsupported operand type(s) for /: 'set' and 'set'
# print(set3 / set4)

set1 = {(1, 2), frozenset('AB')}

# frozenset({'B', 'A', 'C'})
fset1 = frozenset('ABC')
fset1 = frozenset((1, 2))
fset1 = frozenset([1, 2])
fset1 = frozenset({1, 2})
# frozenset({1, 3})
fset1 = frozenset({1: 2, 3: 4})
```

### 映射类型

#### 字典

[字典的键只能是 hashable 的值。即包含列表、字典或其他可变类型的值（此类对象基于值而非对象标识进行比较）不可用作键。](https://docs.python.org/zh-cn/3.8/library/stdtypes.html#mapping-types-dict)

for example

```python
dict1 = {0.1: 1, 0.1+0.1j: 2, (1,2): 3, (1, (1, 2)): 4}

dict1[0.1]
dict1[0.1+0.1j]
dict1[(1,2)]

# 出错，key 不是 hashable
# dict2 = {(1, [1, 2]): 1}

```

## 垃圾回收机制

与 java 类似。

对象引用计数为零时，del 手动回收时，对象会被回收。
对象引用成环时，对象会被回收。

for example

```python
i = 100
# `100` 这个对象会被回收
i = 10
del i

# ### 引用成环

a = [10, 20]
b = [a, 30]
a.append(b)

# `[10, 20, b], [a, 30]` 对象会被回收
a = 100
b = 100
```

### 驻留（interning）

CPython 还会在小的整数上 使用这个优化措施，防止重复创建“热门”数字，如 0、-1 和 42。

*注意，CPython 不会驻留所有字符串和整数，驻留的条件是实现细节，而且没有文档说明。*

for example

```python
i1 = 0
i2 = 0
print(id(i1))
print(id(i2))

s1 = "ABC"
s2 = "ABC"
print(id(s1))
print(id(s2))

t1 = (1, 2)
t2 = (1, 2)     # tuple 也是不可改变的，有些解释器会新建对象，而有些不会。
print(id(t1))
print(id(t2))
```

## Branch Control

    if False:
        pass
    elif True:
        pass
    else:
        pass

### 比较

-   `is` 比较对象 id

-   `==` 比较对象内容

#### 运算符

[运算符](https://www.runoob.com/python/python-operators.html)

-   成员运算符 `in, not in`
-   身份运算符 `is, not is`
-   逻辑运算符 `and, or, not`

## Loop Control

    while True:
        continue
        break

for example

```python
# ## dict
dict1 = {'key1': 'value1', 'key2': 'value2'}

# x 是 key
for x in dict1:
    print(x)

for x in dict1.keys():
    print(x)

for x in dict1.values():
    print(x)

print(dict1.items())
for k, v in dict1.items():
    print(k)
    print(v)

l1 = [[1, 2], [3, 4]]
for a, b in l1:
    print(f'{a}, {b}')

# ## ranger
# range(start : end : step)
for x in range(0, len(l1)):
    print(x)

# ## enumerate
for i, x in enumerate(l1):
    print(f'{i}, {x}')

for i, x in enumerate(dict1):
    print(f'{i}, {x}')

for i, x in enumerate(dict1.items()):
    print(f'{i}, {x}')

for i, (a, b) in enumerate(dict1.items()):
    print(f'{i}, {a}, {b}')
```

## function

语法

    def func([<param>]):
        ...
        [return <object>]

for example

```python
gVar = 100

def func():
    'func doc'      # 不会输出
    localVar = 10
    # 使用全局变量
    global gVar
    gVar = 1000

func()
print(gVar)
print(func.__doc__)
```

### argument

形参的默认值

> 有默认值的形参之后不能有无默认值的形参。否则默认值会被覆盖，则失去默认值的意义。

for example

```python
# def funcForFuncDefaultParam(param1 = 10, param2)
#   pass
```

*不支持参数个数不同的“重载”。如果支持这个功能，很容易导致混乱。*

for example

```python
def func(a):
    print('func_a')

# 因为函数同名，所以会覆盖上面的 `func`。
def func(a, b):
    print('func_a_b')

# func(1)
func(1, 2)
```

#### positional-only or keyword-only arguments

[positional-only or keyword-only arguments](https://docs.python.org/3/tutorial/controlflow.html#positional-or-keyword-arguments)

-   positional-only argments (仅限位置参数) 只能接收位置实参。其类型是 tuple。

-   keyword-only arguments (仅限关键字参数) 只能接收关键字实参。其类型是 dict。

for example

```python
# ### positional-only argments
# x 可接收位置实参或关键字实参
# posOnlyParam 只能一个或多个位置实参。且它后面的形参不能接收位置实参了。
# y 只能接收关键字实参
def funcForFuncDictParam(x, *posOnlyParam, y):
    print(x)
    print(posOnlyParam)
    print(y)

funcForFuncDictParam(1, (1, 2), [1, 2], {1, 2}, {1: 2, 3: 4}, y = 'yVar')

# ###  keyword-only argument
# keywordOnlyParam 只能接收关键字实参，且只能是最后一个形参。
def funcForFuncDictParam(x, **keywordOnlyParam):
    print(x)
    print(keywordOnlyParam)

funcForFuncDictParam(1, key1 = 'var1', key2 = 'var2')

# ### position-only 与 keyword-only 参数共用
# x 可接收位置实参或关键字实参
# y 只能接收关键字实参
def funcForFuncParam(x, *posOnlyParam, y, **keywordOnlyParam):
    print(x)
    print(posOnlyParam)
    print(y)
    print(keywordOnlyParam)

funcForFuncParam(1, {1, 2}, {1: 2, 3: 4}, y = 10, key1 = 'var1', key2 = 'var2')

# ### 当参数既可以接收 position-only 或 keyword-only 的实参时，可用 `/`，表示它前面的参数只接收 position-only 的实参。
def funcForFuncParam(a, b, /, c):
    pass
funcForFuncParam(1, 2, 3)

funcForFuncParam(1, 2, c = 3)
# 错误的
# funcForFuncParam(1, b = 2, c = 3)
# 错误的
# funcForFuncParam(a = 1, b = 2, c = 3)

# ### 形参是一个星号时，表示后面的参数不能接收 positional 实参，那只能是 keyword-only 的。
def funcForFuncParam(a, b, *, c):
    pass
#  错误的
#  funcForFuncParam(1, 2, 3)

funcForFuncParam(1, 2, c = 3)
funcForFuncParam(1, b = 2, c = 3)
funcForFuncParam(a = 1, b = 2, c = 3)
```

##### 展开

for example

```python
def func1(*pos_arg):
    print(pos_arg)

def func2(**key_arg):
    print(key_arg)

list1 = [1, 2, 3]
# func1(1, 2, 3)
func1(*list1)
dict1 = {'key1': 'value1', 'key2': 'value2'}
# func2(key1 = 'value1', key2 = 'value2')
func2(**dict1)
```

### return

```python
def funcForFuncRet():
    return 'abc'

ret = funcForFuncRet()
print(ret)
print(funcForFuncRet())
```

### 传参方式

传副本还是引用？

> 默认情况下是传引用，一些可变对象可指定传副本。不可变对象传副本没有意义，因为对象被修改时，会创建新的对象。

传递可变对象的副本

    #  shallow copy
    list1.copy(), list1[:]
    set1.copy(), set1[:]
    dict1.copy()

for example

```python
def funcForWayOfPassParam(param1, param2, param3):
    pass

funcForWayOfPassParam(list1.copy(), set1.copy(), dict1.copy())
funcForWayOfPassParam(list1[:], set1[:], dict1.copy())
```

#### 浅层 (shallow) 和深层 (deep) 复制操作

[浅层 (shallow) 和深层 (deep) 复制操作](https://docs.python.org/zh-cn/3/library/copy.html)

    copy.copy(x)

        返回 x 的浅层复制。

    copy.deepcopy(x[, memo])

        返回 x 的深层复制。

## 内嵌函数与闭包

内嵌函数只能在函数内部访问。

字面的定义：闭包是由函数及其相关的引用环境组合而成的实体(即：闭包=函数+引用环境)

被返回的内嵌函数是一个闭包。

for example

```python
# ### 内嵌函数
def outerFunc():
    print('outerFunc')
    # 内嵌函数
    def innerFunc():
        print('innerFunc')

    innerFunc()

outerFunc()

# ### 闭包
def outerFunc():
    x = 5
    # 内嵌函数
    def closure():
        # 当对被引用的变量赋值时，则可能是修改外部变量，或新建局变量。默认会认为你在新建一个局部变量，所以 x 是一个局部变量。
        # 但是因为 x 还没有创建，所以出现 `UnboundLocalError: local variable 'x' referenced before assignment`
        x += 1
        print(x)
    return closure

closure = outerFunc()
closure()

# #### 解决方案
def outerFunc():
    x = 5
    # 内嵌函数
    def closure():
        # 指明 x 不是局部变量
        nonlocal x
        x += 1
        print(x)
    return closure()

closure = outerFunc()
closure()
```

## lambda

语法

    # 匿名函数(lambda)不管逻辑多复杂，只能写一行，且逻辑执行结束后的内容就是返回值
    lambda arguments : expression

for example

```python
def func(a, b):
    return a + b

lmbd = lambda a, b: a + b
print(lmbd(10, 20))
```

## 异常

[异常](https://docs.python.org/zh-cn/3/tutorial/errors.html)

无论是否出现异常，finally 语句块都会执行。

目前（至少）有两种可区分的错误：语法错误（解析错误） 和 异常（运行时错误）。

for example

```python
# ### 异常
try:
    1/0
except ZeroDivisionError:
    print('ZeroDivisionError')

finally:
    print('finally')

try:
    1/0
except ZeroDivisionError as err:
    print(err)

finally:
    print('finally')

# ### 语法异常
try:
    ABC
except NameError as err:
    print(err)

# ### 处理异常时出现异常，则没有捕获第二个异常
try:
    ABC
except NameError as err:
    print(err)
    # 再抛出异常
    1/0
except ZeroDivisionError as err:
    print(err)

# 解决方案
try:
    ABC
except NameError as err:
    print(err)
    try:
        1/0
    except ZeroDivisionError as err:
        print(err)
```

## 命名空间和作用域

[ref](https://www.runoob.com/python3/python3-namespace-scope.html)

***虽然 python 的命名空间与 C 语言相差不大，但是作用域与 C 语言是有点区别。***

一般有三种命名空间：

-   内置名称（built-in names）， Python 语言内置的名称，比如函数名 abs、char 和异常名称 BaseException、Exception 等等。
-   全局名称（global names），模块中定义的名称，记录了模块的变量，包括函数、类、其它导入的模块、模块级的变量和常量。
-   局部名称（local names），函数中定义的名称，记录了函数的变量，包括函数的参数和局部定义的变量。（类中定义的也是）

[for example](https://www.zhihu.com/question/22466764/answer/21464993)

```python
a1 = 1 # Global

class Foo:
    a2 = 1 # Local

    def func():
        a3 = 1 # Local
        def _func():
            a5 = 1 # Local
```

有四种作用域：

-   L（Local）：最内层，包含局部变量，比如一个函数/方法内部或闭包内部。
-   E（Enclosing locals）：包围 Local 作用域的非全局非内建作用域。比如：闭包之外的函数作用域，类的作用域。
-   G（Global）：当前脚本的最外层，比如当前模块的全局变量。
-   B（Built-in）： 包含了内建的变量/关键字等，最后被搜索。

[当 Python 遇到一个变量的话他会按照这样的顺序进行搜索：](https://www.zhihu.com/question/22466764)

> L -> E -> G -> B

***注意：PYTHON的作用域由def、class、lambda等语句产生，if、try、for、with 等语句并不会产生新的作用域。***

for example

```python
if True:
    var1 = 10
print(var1)

for i in range(0, 2)
    pass
print(i)

def func():
    local_var = 100
# 没有定义变量
# print(local_var)
```

由于 if, for, try, with 等语句没有产生新的作用域，那么如何避免覆盖其他值？

> 比如用于循环的变量尽量使用单字符。

## class

类的继承与 java 一样，是 `is-a` 的关系。支持多继承。

成员的访问属性只有私有（双下划线开头）的和公有的。

self, cls

    不是关键字，只是大家的约定。
    self 表示实例，cls 表示类。

父子类同名覆盖问题

    因为父类的属性无法用 super() 访问，只能用 self 访问，所以父类属性会被覆盖，只通过父类的方法访问。
    父方法没有被覆盖，可用 super() 访问。

### `super()` 与 `__mro__` 的关系

[`class.__mro__`](https://docs.python.org/zh-cn/3/library/stdtypes.html#class.__mro__)

`__mro__`:

> 此属性是由类组成的元组，在方法解析期间会基于它来查找基类。如果 obj 的 mro 是 `C -> B -> A -> object`，则 `obj.method()` 则查找 D 的 method，如果没有则查找 B 的。依此类推。
>
> `class A(), class B(), class C(A, B)` 中 C 的 mro 是 `C -> B -> A -> object`。

[super()](https://docs.python.org/zh-cn/3/library/functions.html?highlight=super#super)

> 返回一个代理对象，它会将方法调用委托给 type 的父类或兄弟类。 这对于访问已在类中被重载的继承方法很有用。[super() 不能用于调用父类的属性](#super不能访问父类的属性)。
>
> 举例来说，如果 object-or-type 的 `__mro__` 为 D -> B -> C -> A -> object 并且 type 的值为 B，则 super() 将会搜索 C -> A -> object。即 super(C, obj) 会搜索 `C -> A -> object`。

`super()`

    返回父类或父类的兄弟的实例对象。

`super([type[, object-or-type]])`

    根据第二个参数返回类型 type 的”父类或父类的兄弟类“的“实例或类对象“。

Refs:

-   [直接继承object的Python类是否调用super](https://zhuanlan.zhihu.com/p/133110568)

for example

```python
#!/usr/bin/python3
# -*- coding:utf-8 -*-

# 在 python3 中，如果不写 object, 解析器会自动添加。
class Foo():
    def __init__(self):
        # 不一定是调用 object.__init__()。实际调用 Bar.__init__(self)
        super().__init__()
        print('Foo')

class Bar():
    def __init__(self):
        # 实际调用 object.__init__()
        super().__init__()
        print('Bar')

class Baz(Foo, Bar):
    def __init__(self):
        #Foo.__init__(self)
        #Bar.__init__(self)

        # 相当于 `super(Baz, self)`。调用 Foo.__init__()
        super().__init__()

        print('Baz')

print(Baz.__mro__)

baz = Baz()
```

### 类的属性与方法

#### 类的属性

-   实例属性

-   类的属性

for example

```python
class ClassForClassProperties():
    classProperty = 10
    def __init__(self):
        self.instanceProperty = 100

classForClassProperties = ClassForClassProperties()
print(classForClassProperties.instanceProperty)
print(ClassForClassProperties.classProperty)
print(classForClassProperties.classProperty)
```

#### 类的方法

-   `实例方法（instance method）（默认）`

        至少有一个参数（一般第一个形参为 self），否则出错。
        可用 `<instance>.<instanceMethod()>, <className>.<instanceMethod>(<instance>)` 的方式调用。
        当用对象（instance）调用 instance method 时，会将对象传给第一个参数。

-   `类方法（class method） (@classmethod)`

        至少有一个参数（一般第一个形参为 cls），否则出错。
        可用 `<className>.<classMethod>(), <instance>.<classMethod()>` 的方式调用。
        当用类名或对象名调用 class method 时，解释器自动传类对象给第一个形参。

-   `静态方法（static method） (@staticmethod)`

        形参列表可为空。
        当 static method 被调用时，解释器不自动传实参。

for example

```python
class MyClass():
    # default method
    def defaultMethod(self):
        pass

    @classmethod
    def classMethod(cls):
        print(cls)

    @staticmethod
    def staticMethod():
        pass

myClass = MyClass()
myClass.defaultMethod()
MyClass.defaultMethod(myClass)

MyClass.classMethod()
myClass.classMethod()

MyClass.staticMethod()
myClass.staticMethod()
```

### 类的访问属性

for example

```python
class MyClass():
    def __init__(self):
        self.__privateProperty = 10
        self.publicProperty = 'ABC'
    def __privateMethod(self):
        print('__privateMethod')
    def publicMethod(self):
        print('publicMethod')

myClass = MyClass()
# AttributeError: 'MyClass' object has no attribute '__privateProperty'
# print(myClass.__privateProperty)
print(myClass.publicProperty)

# AttributeError: 'MyClass' object has no attribute '__privateMethod'
# myClass.__privateMethod()
myClass.publicMethod()
```

#### name mangling

对 `__*` 的成员使用 name manglin 技术，其不能在外部访问的技术。

for example

```python
class MyClass():
    __privateProperty = 10

myClass = MyClass()
# AttributeError: 'MyClass' object has no attribute '__privateProperty'
# myClass.__privateProperty
dir(myClass)
print(myClass._MyClass__privateProperty)
```

for example

```python
class Base():
    def __init__(self):
        self.__x = 1
        self.y = 2

class Child(Base):
    def __init__(self):
        super().__init__()
        # AttributeError: 'Child' object has no attribute '_Child__x'
        #  print(self.__x)
        print(self.y)

child = Child()
```

### 类的继承

<a name="super不能访问父类的属性"></a>

***可以通过 `self, 父类名，super()` 调用父类的方法。但是只能通过 `self` 来访问父类的属性。***

***当子类定义构造函数时，会覆盖父类的构造函数，这时子类的构造函数不会自动调用父类的构造函数，所以用户要通过 super 来调用父类的构造函数。***

for example

```python
class Base():
    def __init__(self):
        self.y = 2
    def method(self):
        print('Base.method')

class Child(Base):
    def __init__(self):
        super().__init__()

        # ### 调用父类的属性
        print(self.y)
        #  AttributeError: 'super' object has no attribute 'y'
        #  print(super().y)
        #  AttributeError: type object 'Base' has no attribute 'y'
        #  print(Base.y)

        # ### 调用父类的方法
        self.method()
        super().method()
        Base.method(self)

child = Child()
```

如果子类同名覆盖父类属性, 则只能通过调用父类的方法来访问被同名覆盖的父类的属性。

for example:

```python
class Base():
    def __init__(self):
        self.x = 100

    def method(self):
        print('Base.method()')

class MyClass(Base):
    def __init__(self):
        super().__init__()

        # 无法通过 super() 调用父类的属性
        # AttributeError: 'super' object has no attribute 'x'
        # print(super().x)
        print(self.x)
        # 这里是赋值而不是创建 x
        self.x = 1000

        # 可通过 super() 调用父类的 method()
        super().method()
        self.method()

    def method(self):
        print('MyClass.method()')

myClass = MyClass()
```

#### 单继承

for example

```python
class Base():
    def __init__(self):
        print('Base')

class MyClass(Base):
    def __init__(self):
        # 调用父类的构造函数的两种方法
        # Base.__init__(self)
        super().__init__()

myClass = MyClass()

# ### 调用父类的构造函数
class Base():
    def __init__(self):
        print('Base')

class MyClass(Base):
    pass

# 因为继承了 Base.__init__() 所以 MyClass 的 __init__() 是就是 Base.__init__()，所以会调用 Base.__init__()。
myClass = MyClass()

# ### 调用父类的构造函数
class Base():
    def __init__(self):
        print('Base')

class MyClass(Base):
    def __init__(self):
        print('MyClass')

# 因为 MyClass.__init__() 覆盖了 Base.__init__()，所以只会调用 MyClass.__init__()
myClass = MyClass()
```

#### 多重继承

for example

```python
class Base1():
    def __init__(self):
        print('Base1')

class Base2():
    def __init__(self):
        print('Base2')

class MyClass(Base1, Base2):
    def __init__(self):
        Base1.__init__(self)
        Base2.__init__(self)
        # OR
        #super(MyClass, self).__init__()
        #super(Base1, self).__init__()

myClass = MyClass()
```

#### 类的多态

for example

```python
class Base():
    def method(self):
        print('Base method()')

class MyClass(Base):
    def method(self):
        print('MyClass method()')

base = Base()
base.method()
base = MyClass()
base.method()
```

### 抽象基类 abc

[抽象基类 abc](https://docs.python.org/zh-cn/3/library/abc.html#module-abc)

含有抽象方法的类都是抽象基类。

*python 有抽象类函数和抽象的静态函数。*

`class abc.ABC` 是一个使用 ABCMeta 作为元类的工具类。

定义抽象类的方式

```python
# ### 方式1：利用 ABC
from abc import ABC, abstractmethod

class MyAbstractClass(ABC):
    pass

# ### 方式2：利用 ABCMeta
from abc import ABCMeta, abstractmethod

class MyAbstractClass(metaclass=ABCMeta):
    pass

# OR
from abc import ABCMeta, abstractmethod

class MyAbstractClass():
    __metaclass__ = ABCMeta
    pass
```

for example

```python
from abc import ABC, abstractmethod

class MyAbstractClass(ABC):
    @abstractmethod
    def myAbstractMethod(self):
        pass
    @classmethod
    @abstractmethod
    def myAbstractClassmethod(cls):
        pass
    @staticmethod
    @abstractmethod
    def myAbstractStaticmethod():
        pass

class MyClass(MyAbstractClass):
    def myAbstractMethod(self):
        pass
    @classmethod
    def myAbstractClassmethod(cls):
        pass
    @staticmethod
    def myAbstractStaticmethod():
        pass

myClass = MyClass()
myClass.myAbstractMethod()
MyClass.myAbstractClassmethod()
MyClass.myAbstractStaticmethod()
```

## 装饰器（decorator）

装饰器接收类型对象（比如：类对象和函数对象等）并对其进行包装，返回包装后的类型对象，重新赋值原来的标识符，使原始类型对象无法访问。

### 添加一个自定义的 decorator

for example

```python
def null_decorator(func):
    print('null_decorator')
    return func

@null_decorator
def greet():
    print('Hello!')
# output:
#   null _decorator
#   Hello!
greet()

# 上面相当于

def greet():
    print('Hello!')

greet = null_decorator(greet)

greet()
```

### 自定义一个 property 装饰器

#### 系统的 property

[@property 的作用](https://www.liaoxuefeng.com/wiki/1016959663602400/1017502538658208)

> 将方法变为一个属性，将 get，set, del 会触发这个属性的方法。通过这个方法，可以将类的一个属性隐藏，然后为其设置一个属性，通过这个属性操作隐藏的属性即可。

for example

```python
# ### [property](https://docs.python.org/zh-cn/3/library/functions.html#property)
class MyClass():
    def __init__(self, size = 10):
        self._size = size

    # 等同于 size = property(fget=size)
    @property
    def size(self):
        print('get size property')
        return self._size

    # 等同于 size = property(fget=size)。所以，size 不是方法而是 property。
    @size.setter
    def size(self, value):
        print('set size property')
        self._size = value

    @size.deleter
    def size(self):
        print('deleter')
        del self._size

myClass = MyClass()
myClass.size
myClass.size = 100
del myClass.size
```
#### property 的实现

参考 [自定义属性访问的例子](#propertyExample)

<a name="propertyDecoratorExample"></a>

for example

```python
class Property(object):
    def __init__(self, fget=None, fset=None, fdel=None, doc=None):
        print('__init__()', type(self), id(self))
        print(fget == None, fset == None, fdel == None)

        self.fget = fget
        self.fset = fset
        self.fdel = fdel
        if doc is None and fget is not None:
            doc = fget.__doc__
        self.__doc__ = doc

    # 定义 decorator 的访问行为
    def __get__(self, obj, objtype=None):
        print('Property.__get__()', type(self), id(self))

        if obj is None:
            return self
        if self.fget is None:
            raise AttributeError("unreadable attribute")
        return self.fget(obj)

    # 定义 decorator 的设置行为
    def __set__(self, obj, value):
        print('Property.__set__()', type(self), id(self))

        if self.fset is None:
            raise AttributeError("can't set attribute")
        self.fset(obj, value)

    def __delete__(self, obj):
        print('Property.__delete__()', type(self), id(self))

        if self.fdel is None:
            raise AttributeError("can't delete attribute")
        self.fdel(obj)

    # 设置 decorator getter
    def getter(self, fget):
        print('Property.getter()', type(self), id(self))

        return type(self)(fget, self.fset, self.fdel, self.__doc__)

    # 设置 decorator deleter
    def setter(self, fset):
        print('Property.setter()', type(self), id(self))

        return type(self)(self.fget, fset, self.fdel, self.__doc__)

    def deleter(self, fdel):
        print('Property.deleter()', type(self), id(self))

        return type(self)(self.fget, self.fset, fdel, self.__doc__)

class MyClass():
    def __init__(self, size = 10):
        self._size = size

    # 等同于 size = Property(fget=size)
    @Property
    def size(self):
        print('size.getter')
        print('get size property')
        return self._size

    # 调用 size.setter()
    @size.setter
    def size(self, value):
        print('size.setter')
        print('set size property')
        self._size = value

    # 调用 size.delete() ?
    @size.deleter
    def size(self):
        print('size.deleter')
        print('del size property')
        del self._size

myClass = MyClass()
print('get size in main:')
# ### myClass.size 的类型是 Property，其属性 fget, fset, fdel 是被装饰对象（MyClass）的方法。
# 调用 size.__get__()
myClass.size
print('set size in main:')
# 调用 size.__set__()
myClass.size = 100
print('del size in main:')
# 调用 size.__delete__()
del myClass.size
```

## `__*__` 标识符

[`__*__` 标识符](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#identifiers)

*系统定义的名称，在非正式场合下被叫做 "dunder" 名称。*

### 特殊属性

[特殊属性](https://docs.python.org/zh-cn/3/library/stdtypes.html?highlight=__dict__#special-attributes)

    object.__dict__
    instance.__class__
    class.__bases__
    definition.__name__
    definition.__qualname__
    class.__mro__
    class.mro()
    class.__subclasses__()

[__name__](https://docs.python.org/zh-cn/3/reference/import.html?highlight=__name__#import-related-module-attributes)

    `__name__` 属性必须被设为模块的完整限定名称。

[__main__](https://docs.python.org/zh-cn/3/library/__main__.html?highlight=__main__#module-__main__)

    `__main__` 是顶层代码执行的作用域的名称。

for example

```python
dir()
# 输出 `__main__`
print(__name__)

# ### mymodule.py
def printName():
    print(__name__)

printName()

# 输出 `__main__`
python mymodule.py

# ### test.py
import mymodule
mymodule.printName()

# 输出 `__mymodule__`
python test.py
```

`__main__` 的常用形式

for example

```python
if __name__ == '__main__':
    # main 函数体
```

### `class.__mro__, class.mro(), class.__subclass__(), super()`

for example: mro, subclasses

```python
class Base1(object):
    def foo(self):
        print('Base1')

class Base2(object):
    def foo(self):
        print('Base2')

class MyClass(Base1, Base2):
    def foo(self):
        print('MyClass')

myClass = MyClass()
print(MyClass.__mro__)
print(MyClass.mro())
# 对象没有 __mro__
# AttributeError: 'MyClass' object has no attribute '__mro__'
# print(myClass.__mro__)

print(Base1.__subclasses__())
print(MyClass.__subclasses__())
```

### Magic Method(重点)

[Magic Method(重点)](https://docs.python.org/zh-cn/3/reference/datamodel.html?highlight=__new__#special-method-names)

魔法方法会被自动执行。

#### 基本定制

    object.__new__(cls[, ...])

    object.__init__(self[, ...])
        构造函数
    object.__del__(self)
        析构函数
    object.__repr__(self)
    object.__str__(self)
    object.__bytes__(self)
    object.__format__(self, format_spec)

    object.__lt__(self, other)

        object < otherobject 时调用

    object.__le__(self, other)
    object.__eq__(self, other)
    object.__ne__(self, other)
    object.__gt__(self, other)
    object.__ge__(self, other)

    object.__hash__(self)

##### `__new__(), __init__()`

new

> [new 的应用场景](https://www.cnblogs.com/luocodes/p/10723778.html)

> 在实例生成前运行。实例生成后，再用 `__init__` 初始化。

    定制 object 的新建实例的过程。

    调用以创建一个 cls 类的新实例。__new__() 是一个静态方法（@static method）。

    如果 __new__() 返回一个实例则该实例会调用 __init__()。

    __new__() 的目的主要是允许不可变类型的子类 (例如 int, str 或 tuple) 定制实例创建过程。

for example

```python
class MyClass(object):
    def __new__(cls):
        print('create a MyClass instance')
        # 相当于 return object.__new__(cls)
        return super(MyClass, cls).__new__(cls)

    def __init__(self):
        print('__init__()')

myClass = MyClass()
print(type(myClass))
print(MyClass.__mro__)
```

##### `__repr__(), __str__()`

`repr()` 与 `str()` 类似，都是将对象转换为字符串，但是 repr 会输出更多的开发和调试信息。

for example

```python
class MyClass():
    def __repr__(self):
        return '__repr__()'
    def __str__(self):
        return '_str__()'

myClass = MyClass()
print(repr(myClass))
print(str(myClass))
```

##### `__lt__()`

for example

```python
class MyClass():
    number = 0

    def __lt__(self, obj):
        return self.number < self.number

myClass = MyClass()
print(myClass < myClass)
```

#### 自定义属性访问

    object.__getattr__(self, name)
    object.__getattribute__(self, name)
    object.__setattr__(self, name, value)
    object.__delattr__(self, name)
    object.__dir__(self)

##### property 与 getatt, getattribute, setattr, delattr

<a name="propertyExample"></a>

for example

```python
class MyClass():
    def __init__(self, size = 10):
        self.size = size
    def getSize(self):
        return self.size
    def setSize(self, value):
        self.size = value
    def delSize(self):
        del self.size
    # 添加属性 `x`
    x = property(getSize, setSize, delSize)

myClass = MyClass()
print(myClass.x)
myClass.x = 100
del myClass.x

class MyClass():
    # 定义当用户试图获取一个不存在的属性时的行为
    def __getattr__(self, name):
        print('getattr')
    # 定义属性被访问时的行为
    def __getattribute__(self, name):
        print('getattribute')
        return super().__getattribute__(name)
    def __setattr__(self, name, value):
        print('setattr')
        super().__setattr__(name, value)
    def __delattr__(self, name):
        print('delattr')
        super().__delattr__(name)

myClass = MyClass()
# 输出 `getattribute, setattr`
print(myClass.x)
myClass.x = 1
del myClass.x
```

#### 实现描述器

    object.__set__(self, instance, value)
    object.__delete__(self, instance)
    object.__set_name__(self, owner, name)

for example

> [example](#property-的实现)

#### 模拟数字类型

    object.__add__(self, other)
    object.__sub__(self, other)
    object.__mul__(self, other)
    object.__and__(self, other)
    object.__xor__(self, other)
    object.__or__(self, other)
    ...

for example

```python
class Computation():
    def __init__(self,value):
        self.value = value
    def __add__(self,other):
        return self.value + other
    def __sub__(self,other):
        return self.value - other

    c = Computation(5)
    print(c + 5)
    print(c - 3)
```

#### 模拟容器类型

    object.__getitem__(self, key)
        Python的魔法方法__getitem__ 可以让对象实现迭代功能，这样就可以使用 for...in... 来迭代该对象了
    object.__setitem__(self, key, value)
    object.__delitem__(self, key)
    object.__missing__(self, key)
    object.__iter__(self)
    object.__reversed__(self)
    object.__contains__(self, item)

for example

```python
class Animal():
    def __init__(self, animalList):
        self.animalName = animalList
    def __getitem__(self, index):
        return self.animalName[index]

animals = Animal(["dog","cat","fish"])
# 如果没有 `__getitem__()` 时，TypeError: 'Animal' object is not iterable
for animal in animals:
    print(animal)
```

##### `迭代器, __iter__(), __next__()`

-   [`iter()`](https://docs.python.org/zh-cn/3/library/functions.html?highlight=iter#iter)

    调用 iterator 的 __iter__() 方法。

-   [`next(<iterator>)`](https://docs.python.org/zh-cn/3/library/functions.html#next)

    调用 iterator 的 __next__() 方法。

for example

```python
# ### iter(), next()
list1 = [1, 2]
# it 的类型是 <class 'list_iterator'>
it = iter(list1)
print(type(it))
print(next(it))
print(next(it))

list1 = [1, 2]
it = iter(list1)
for i in it:
print(i, end=' ')

# ### __iter__(), __next__()
class MyClass():
    def __iter__(self):
        self.a = 1
        return self
    def __next__(self):
        x = self.a
        self.a += 1
        return x

myClass = MyClass()
iterOfMyClass = iter(myClass)

# iterOfMyClass 与 myClass 类型相同
print(type(myClass))
print(type(iterOfMyClass))
print(dir(myClass))

print(next(iterOfMyClass))
print(next(iterOfMyClass))
```

## 生成器

[生成器](https://docs.python.org/zh-cn/3/tutorial/classes.html#iterators)

在 Python 中，使用了 yield 的函数被称为生成器（generator）。

跟普通函数不同的是，生成器是一个返回迭代器的函数，只能用于迭代操作，更简单点理解生成器就是一个迭代器。

在调用生成器运行的过程中，每次遇到 yield 时函数会暂停并保存当前所有的运行信息，返回 yield 的值, 并在下一次执行 next() 方法时从当前位置继续运行。

for example

```python
def myGenerator(n):
    a = 1
    while True:
        # 结束条件
        if n > 2:
            return
        yield a
        a += 1
        n += 1

g = myGenerator(0)
print(next(g))
print(next(g))
print(next(g))
print(next(g))

# ### 生成器函数 - 斐波那契
import sys

def fibonacci(n):
    a, b, counter = 0, 1, 0
    while True:
        if (counter > n):
            return
        yield a
        a, b = b, a + b
        counter += 1

# f 是一个迭代器，由生成器返回生成
f = fibonacci(10)

while True:
    try:
        print (next(f), end=" ")
    except StopIteration:
        sys.exit()
```

## 包与模块

[ref](https://www.liaoxuefeng.com/wiki/1016959663602400/1017454145014176)

-   包

    含有 `__init__.py` 文件的文件夹。其实 `__init__.py` 也是一个模块，其名与文件名相同。作用是使用包也变成一个模块。

    可用 `pip` 管理包

    列出所有包

        pip list

-   模块

    模块是 `.py` 后缀的文件。

    list all available modules

        pythom -m pydoc modules
        help('modules')

### python 的搜索路径

将 packages 或 module 放在搜索路径即可。

列出搜索路径

    import sys
    print(sys.path)

### from, import, as

[*标识符 `_*` 不会被导入*](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#identifiers)


[from import 的语法](https://docs.python.org/zh-cn/3.8/reference/simple_stmts.html#the-import-statement)

-   `import <module> [as <identifier>] [, <module> [as <identifier>]]...`

    导入整个 module

-   `from {<package> | <module>} import <identifier> [as <identifier>] [, <identifier> as <identifier>]`

    导入整个 module 或导入某个标识符。
    可用于去包名前缀或 module 名前缀。

*identifier 是标志符的意思，只能由字母、数字和下划线组成，且不能以数字开头。*

*import 之后，要用 import 或 as 之后的名称来访问其下的东西。*

*`import <package>` 不会导入包内的所有模块。应该用 ``` from <package> import * ```。*

*`from <module> import *` 导入模块的所有东西。*

*当导入的名称相同时，无法通过添加限定符解决，而是要用别名解决。*

for example

```python
import package1.subpackage1.module1
# 错误
# func1()
package1.subpackage1.module1.func1()

import package1.subpackage1.module1.func1
package1.subpackage1.module1.func1()

# ### from 的 import 之后不能有点
# SyntaxError: invalid syntax. 原因是标识符不能有“点”。
#  from package1 import subpackage1.module1.func1
#  from package1.subpackage1 import module1.func1
#  from package1 import subpackage1.module1
from package1.subpackage1.module1 import func1
from package1.subpackage1 import module1

import package1.subpackage1.module1 as mymodule1
mymodule1.func1()
# 不能用 import 部分访问了
# NameError: name 'package1' is not defined
# package1.subpackage1.module1.func1()
```

### module 的内嵌

for example

```python
# ### package1/module1
def func():
    print('module1.func')
# ### package1/module2
import module1
# ### main.py
import sys
sys.path.append('./package1')

import module2
module2.module1.func()
```
