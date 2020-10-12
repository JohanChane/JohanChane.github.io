# Python

*Python version: Python3.8*

### Refers

- <https://docs.python.org/zh-cn/3.8/tutorial/index.html>

    官方入门教程

- <https://docs.python.org/zh-cn/3.8/reference/index.html>

    python 语法和语义(重点)

- <https://docs.python.org/zh-cn/3.8/library/index.html>

    Python 标准库参考。有 python 使用例子

- <https://docs.python.org/zh-cn/3.8/search.html>

    搜索 python 文档

- <https://docs.python.org/zh-cn/3/library/functions.html>

    python 的内置函数

## 基本概念

### 一切都是对象。

    for example

        i = 10
        type(i)
        type(string)
        def func():
            pass

        type(func)
        id(func)

        func = 100
        func

*避免混淆，类对象说的是类，而根据类实例化的对象称为实例。*

### 变量名与对象

变量名没有数据类型的概念（java 的变量名有数据类型的概念），只是一个引用对象的标签。但是对象是有数据类型的。

    for example
        list1 = [1, 2]
        list1 = 100;
        list1.append(3)		# AttributeError: 'int' object has no attribute 'append'
        type(list1)         # 显示 list1 变量引用的对象的类型。


#### [对象的 id](https://docs.python.org/zh-cn/3/reference/datamodel.html#objects-values-and-types)

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

    def func():
        pass
    class  MyClass():
        pass

    if True :
    else:

## Basic

### Get help

- `help()`

        help(<object>)

        help('<string>')
            相当于在 help untility 中输入 <string>

- ``help utility(用 `help()` 进入)``

    可列出 a list of available modules, keywords, symbols, or topics。

- `python -m pydoc <string>` OR `pydoc <string>`


#### 查看 builtin 函数或类型的定义

因为 builtin 函数或类型的定义不一定是用 python 实现的，所以就不一定存在其声明或定义。但是官方的 doc 有给出其声明，但 python 内置的 doc 没有其声明，但有另外一种形式的声明。比如：print。

- [官方的 doc 的 print](https://docs.python.org/zh-cn/3/library/functions.html#print)

- python 内置的 doc 的 print。`pydoc print`

### 查看信息（用于反馈）

- `type(), dir(), id(), del`

        type([object])

            查看对象类型
                
        dir([object])

            列出对象属性

        dir(<object>)

            列出对象 id

- `isinstance(object, classinfo)`

        如果参数 object 是参数 classinfo 的实例或者是其 (直接、间接或 虚拟) 子类则返回 True。

- `issubclass(class, classinfo)`

        如果 class 是 classinfo 的 (直接、间接或 虚拟) 子类则返回 True。 类会被视作其自身的子类。

for example

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


### 调试程序

`调试(导入 pdb module): python3 -m pdb <script>`

### Output

在 python interactive 模式与脚本运行的模式下输出的区别

    for example

        # ### interactive 模式下
        # 输出 `ABC`
        'ABC'
        # 输出 `ABC\nDEF` 注意，没有输出换行符
        'ABC\nDEF'
        # 输出两行
        print('ABC\nDEF')

        # ### 脚本模式下
        # 没有输出
        'ABC'
        # 输出字符串
        print('ABC')

### [print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)](https://docs.python.org/zh-cn/3/library/functions.html#print)

for example

    list1 = ['ABC', 'DEF']
    for i in list1:
        print(i, end=' ')

    print('')

### [输出格式](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html?highlight=seek#input-and-output)

- `f/F` 前缀与 `{<expression>}`

- `str.format()`

for example

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

旧的字符串格式化方法

    'string' % values

for example

    import math
    print('The value of pi is approximately %5.3f.' % math.pi)

### [字面值](https://docs.python.org/zh-cn/3.8/reference/lexical_analysis.html#literals)

字符串字面值(单引号与双引号无区别)

    'ABC'
    "ABC"

#### [字符串字面值拼接](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#string-literal-concatenation)

有两种拼接方式，用空格或加号。两者区别：[空格是编译时实现拼接的，加号是运行时实现拼接的](https://docs.python.org/zh-cn/3.8/reference/lexical_analysis.html#implicit-line-joining)

    # 结果为 'ABCDEF'
    'ABC' 'DEF'
    'ABC' "DEF"
    'ABC' + 'DEF'
    'ABC' + "DEF"

### 转义字符

`\n`, `\<newline>`, ...

#### 转义换行符

    "AAAAAAAAAAAAAAAAAAAA \
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

    if 1900 < year < 2100 and 1 <= month <= 12 \
    and 1 <= day <= 31 and 0 <= hour < 24 \
    and 0 <= minute < 60 and 0 <= second < 60:
        return 1
        
    
[圆括号、方括号或花括号以内的表达式允许分成多个物理行，无需使用反斜杠。](https://docs.python.org/zh-cn/3.8/reference/lexical_analysis.html#implicit-line-joining)

    month_names = ['Januari', 'Februari', 'Maart',      # These are the
               'April',   'Mei',      'Juni',           # Dutch names
               'Juli',    'Augustus', 'September',      # for the months
               'Oktober', 'November', 'December']       # of the year

### [内置数据类型](https://docs.python.org/zh-cn/3.8/reference/datamodel.html#the-standard-type-hierarchy)

- 数字类型

    - 整型数

        - int(支持的长度取决于虚拟内存的大小)
        - bool

    - 浮点型数

    - 复数

- 序列类型

    此类对象表示以非负整数作为索引的有限有序集。

    - 不可变序列

        - 字符串
        - 元组

    - 可变序列

        - 列表

- 集合类型

    此类对象表示由不重复且不可变对象组成的无序且有限的集合。因此它们不能通过下标来索引。但是它们可被迭代。
    
    set 类型是可变的（***注意：虽然元素是不可变的，但 set 是可变的***），而 ***frozenset 类型是不可变并且为 hashable***。

    - set
    - frozenset

- 映射类型

    此类对象表示由任意索引集合所索引的对象的集合。其 key 必须是 hashable。

    - 字典


#### 常用的内置容器类型

python 常用的内置容器类型：tuple, list, set, dict。它们是可以迭代的且可放置多种类型的元素。

#### 可变对象与不可变对象

不可变对象表示生命周期内都是不可改变的，可变对象表示生命周期内可改变的。

对不可变对象赋值时，返回一个新的对象（不会修改原来的对象，所以 `id(<varName>)` 会改变)）。而对可变对象赋值时，不会新建对象。

    for example

        i = 0
        id(i)
        i += 1
        id(i)

- 可变对象的类型

    list, set, dict

- 不可变的对象的类型

    int, bool, float, complex, string, tuple, frozenset

#### [hashable](https://docs.python.org/zh-cn/3.8/glossary.html#term-hashable)

一个对象的哈希值如果在其生命周期内绝不改变，就被称为 hashable （它需要具有 __hash__() 方法），并可以同其他对象进行比较（它需要具有 __eq__() 方法）。可哈希对象必须具有相同的哈希值比较结果才会相同。用户定义类的实例对象默认是可哈希的。 它们在比较时一定不相同（除非是与自己比较），它们的哈希值的生成是基于它们的 id()。

大多数 Python 中的不可变内置对象都是可哈希的；可变容器（例如列表或字典）都不可哈希；不可变容器（例如元组和 frozenset）仅当它们的元素均为可哈希时才是可哈希的。 用户定义类的实例对象默认是可哈希的。

*可变对象一定是 unhashable，不可变对象的元素都为不可变对象时，它才是 hashable。*

- hashable

    int, bool, float, complex, string

- unhashable

    list, set, dict

- hashable 不确定的

    tuple, frozenset


for example

    tuple1 = (1, 2)
    print(hash(tuple1))

    set1 = {1, 2}
    # TypeError: unhashable type: 'set'
    # print(hash(set1))

    frozenset1 = frozenset('ABC')
    print(hash(frozenset1))
    
#### 数字类型

for example

    # 输出 `0.5` 这里要注意。
    1/2
    i = 1000000000000000000000000000000000000000000000000000
    # 虽然 `i` 很大，但 `i` 的类型是 <class 'int'>
    type(i)

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

##### 类型转换

for example

    f = 1.5
    i = int(f)
    print(i)
    str = str(f)
    print(str)
    f = float(str)
    print(f)

#### 序列类型

序列的通用操作

    indexing
        str[n]
    slicing

        str[start : end : step]
            str[start:]
            str[:end]
            str[start::step]
            str[:]
    +, *
    in, not in

        'A' in 'ABC'
        'AB' in 'ABC'

    len(str), min(str), max(str)

for example

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

##### 列表解析（list comprehension）

语法

    A2 = [i for i in A1 if i in A0]

    相当于：
    
    A2 = []
    for i in A1:
        if i in A0:
            A2.append(i)

for example

    list1 = [2*i for i in range(1, 100, 10)]
    # [0, 20, 40, 60, 80, 100, 120, 140, 160, 180]
    print(list1)

#### 集合类型

set = {<不可变对象>...}

for example

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

#### 映射类型

##### 字典


[字典的键只能是非 hashable 的值。即包含列表、字典或其他可变类型的值（此类对象基于值而非对象标识进行比较）不可用作键。](https://docs.python.org/zh-cn/3.8/library/stdtypes.html#mapping-types-dict)

for example

    dict1 = {0.1: 1, 0.1+0.1j: 2, (1,2): 3, (1, (1, 2)): 4}

    dict1[0.1]
    dict1[0.1+0.1j]
    dict1[(1,2)]

    # 出错，key 不是 hashable
    # dict2 = {(1, [1, 2])}

### 垃圾回收机制

与 java 类似。

对象引用计数为零时，del 手动回收时，对象会被回收。
对象引用成环时，对象会被回收。

    for example

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

#### 驻留（interning）

CPython 还会在小的整数上 使用这个优化措施，防止重复创建“热门”数字，如 0、-1 和 42。

*注意，CPython 不会驻留所有字符串和整数，驻留的条件是实现细节，而且没有文档说明。*

for example

		i1 = 0
		i2 = 0
		print(id(i1))
		print(id(i2))

		s1 = "ABC"
		s2 = "ABC"
		print(id(s1))
		print(id(s2))

		t1 = (1, 2)
		t2 = (1, 2)		# tuple 也是不可改变的，有些解释器会新建对象，而有些不会。
		print(id(t1))
		print(id(t2))	

### Branch Control

    if False:
        pass
    elif True:
        pass
    else:
        pass

#### 比较

- `is` 比较对象 id

- `==` 比较对象内容

##### [运算符](https://www.runoob.com/python/python-operators.html)

- 成员运算符 `in, not in`
- 身份运算符 `is, not is`
- 逻辑运算符 `and, or, not`

### Loop Control

    while True:
        continue
        break

    words = ['cat', 'window', 'defenestrate']
    for w in words:
        print(w, len(w))
    
    # range(start : end : step)
    for i in range(5):
        print(i)

### function

语法

    def func([<param>]):
        ...
        [return <object>]

for example

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

#### argument

形参的默认值

> 有默认值的形参之后不能有无默认值的形参。否则默认值会被覆盖，则失去默认值的意义。

for example

    # def funcForFuncDefaultParam(param1 = 10, param2)
    #   pass

*不支持参数个数不同的“重载”。如果支持这个功能，很容易导致混乱。*

for example

    def func(a):
        print('func_a')

    # 因为函数同名，所以会覆盖上面的 `func`。
    def func(a, b):
        print('func_a_b')
    
    # func(1)
    func(1, 2)

##### [positional-only or keyword-only arguments](https://docs.python.org/3/tutorial/controlflow.html#positional-or-keyword-arguments)

- positional-only argments (仅限位置参数) 只能接收位置实参。其类型是 tuple。

- keyword-only arguments (仅限关键字参数) 只能接收关键字实参。其类型是 dict。

for example

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
    # dictParam 只能接收关键字实参，且只能是最后一个形参。
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

#### return

    def funcForFuncRet():
        return 'abc'

    ret = funcForFuncRet()
    print(ret)
    print(funcForFuncRet())

#### 传参方式

传副本还是引用？

> 默认情况下是传引用，一些可变对象可指定传副本。不可变对象传副本没有意义，因为对象被修改时，会创建新的对象。

传递可变对象的副本

    #  shallow copy
    list1.copy(), list1[:]
    set1.copy(), set1[:]
    dict1.copy()

for example

    def funcForWayOfPassParam(param1, param2, param3):
        pass

    funcForWayOfPassParam(list1.copy(), set1.copy(), dict1.copy())
    funcForWayOfPassParam(list1[:], set1[:], dict1.copy())

##### [浅层 (shallow) 和深层 (deep) 复制操作](https://docs.python.org/zh-cn/3/library/copy.html)

    copy.copy(x)

        返回 x 的浅层复制。

    copy.deepcopy(x[, memo])
    
        返回 x 的深层复制。

### 内嵌函数与闭包

内嵌函数只能在函数内部访问。

字面的定义：闭包是由函数及其相关的引用环境组合而成的实体(即：闭包=函数+引用环境)

被返回的内嵌函数是一个闭包。

for example

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

### lambda

语法

    # 匿名函数(lambda)不管逻辑多复杂，只能写一行，且逻辑执行结束后的内容就是返回值
    lambda arguments : expression

for example

    def func(a, b):
        return a + b

    lmbd = lambda a, b: a + b
    print(lmbd(10, 20))

### [异常](https://docs.python.org/zh-cn/3/tutorial/errors.html)

无论是否出现异常，finally 语句块都会执行。

目前（至少）有两种可区分的错误：语法错误（解析错误） 和 异常（运行时错误）。

for example

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

## class

类的继承与 java 一样，是 `is-a` 的关系。支持多继承。

成员的访问属性只有私有（双下划线开头）的和公有的。

self, cls

    不是关键字，只是大家的约定。
    self 表示实例，cls 表示类。

父子类同名覆盖问题

    因为父类的属性无法用 super() 访问，只能用 self 访问，所以父类属性会被覆盖，只通过父类的方法访问。
    父方法没有被覆盖，可用 super() 访问。

### [super()](https://docs.python.org/zh-cn/3/library/functions.html?highlight=super#super)

`super()`

    返回父类实例对象。

`super([type[, object-or-type]])`

    根据第二个参数返回，类型为 type 的实例或类对象

for example

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
    
    # 根据 myClass 实例返回 MyClass 父类实例
    superOfObj = super(MyClass, myClass)
    # 根据 MyClass 类对象返回 MyClass 父类的类对象
    superOfClass = super(MyClass, MyClass)
    superOfObj.foo()
    # 因为 superOfClass 是一个类对象，也可说 superOfClass 是未绑定的，所以要传一个实例。
    superOfClass.foo(myClass)

### 类的属性与方法

#### 类的属性

- 实例属性

- 类的属性

for example

    class ClassForClassProperties():
        classProperty = 10
        def __init__(self):
            self.instanceProperty = 100

    classForClassProperties = ClassForClassProperties()
    print(classForClassProperties.instanceProperty)
    print(ClassForClassProperties.classProperty)
    print(classForClassProperties.classProperty)

#### 类的方法

- `实例方法（instance method）（默认）`

        至少有一个参数（一般第一个形参为 self），否则出错。
        可用 `<instance>.<instanceMethod()>, <className>.<instanceMethod>(<instance>)` 的方式调用。
        当用对象（instance）调用 instance method 时，会将对象传给第一个参数。

- `类方法（class method） (@classmethod)`

        至少有一个参数（一般第一个形参为 cls），否则出错。
        可用 `<className>.<instanceMethod>(<instance>), <instance>.<instanceMethod()>` 的方式调用。
        当用类名或对象名调用 class method 时，解释器自动传类对象给第一个形参。

- `静态方法（static method） (@staticmethod)`

        形参列表可为空。
        当 static method 被调用时，解释器不自动传实参。

for example

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

### 类的访问属性

for example

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

#### name mangling

对 `__*` 的成员使用 name manglin 技术，其不能在外部访问的技术。

for example

    class MyClass():
        __privateProperty = 10
        
    myClass = MyClass()
    # AttributeError: 'MyClass' object has no attribute '__privateProperty'
    # myClass.__privateProperty
    dir(myClass)
    print(myClass._MyClass__privateProperty)

### 类的继承

可以通过 `super()` 调用父类的方法，但是不能调用父类的属性（要用 self 调用从父类继承的属性）。

#### 类的多态

for example

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

#### 单继承

for example

    class Base():
        def __init__(self):
            print('Base')

    class MyClass(Base):
        def __init__(self):
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

#### 多重继承

for example

    class Base1():
        def __init__(self):
            print('Base1')

    class Base2():
        def __init__(self):
            print('Base2')

    class MyClass(Base1, Base2):
        def __init__(self):
            # 无法用 super 调用父类的构造函数了
            Base1.__init__(self)
            Base2.__init__(self)

    myClass = MyClass()

##### 子类同名覆盖父类的问题

for example:

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

### [抽象基类 abc](https://docs.python.org/zh-cn/3/library/abc.html#module-abc)

含有抽象方法的类都是抽象基类。

*python 有抽象类函数和抽象的静态函数。*

`class abc.ABC` 是一个使用 ABCMeta 作为元类的工具类。

定义抽象类的方式

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

for example

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

## 装饰器（decorator）

### 添加一个自定义的 decorator

[参考 Property Decorator Example](# propertyDecoratorExample)

<a name="customizeDecoratorExample"></a>

for example

    def null_decorator(func):
        print('null_decorator')
        return func

    def greet():
        print('Hello!')

    greet = null_decorator(greet)

    # output: `Hello!`
    greet()

    # 调用 null_decorator()
    @null_decorator
    def greet1():
        print('Hello!')

    # 调用 null_decorator 返回的 func(), 实际是调用 greet1()
    # output: `Hello!`
    greet1()


for example

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
    # 调用 size.__get__()
    myClass.size
    print('set size in main:')
    # 调用 size.__set__()
    myClass.size = 100
    print('del size in main:')
    # 调用 size.__delete__()
    del myClass.size

### Others

`@staticmethod, @classmethod`

[@property](https://www.cnblogs.com/bob-coder/p/11532718.html)

参考 [property 例子](# propertyExample)

<a name="propertyDecoratorExample"></a> 

for example

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

    
## [`__*__` 标识符](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#identifiers)

*系统定义的名称，在非正式场合下被叫做 "dunder" 名称。*

### [特殊属性](https://docs.python.org/zh-cn/3/library/stdtypes.html?highlight=__dict__#special-attributes)

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

### [class.__mro__, class.mro(), class.__subclass__(), super()](https://docs.python.org/zh-cn/3/library/stdtypes.html#class.__mro__)

    class.__mro__, class.mro()
    class.__subclasses__()

for example

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

    # 打印 Base1 的子类对象
    print(Base1.__subclasses__())

### [Magic Method(重点)](https://docs.python.org/zh-cn/3/reference/datamodel.html?highlight=__new__#special-method-names)

魔法方法会被自动执行。

#### 基本定制

    object.__new__(cls[, ...])

        定制 object 的新建实例的过程。

        调用以创建一个 cls 类的新实例。__new__() 是一个静态方法（@static method）。

        如果 __new__() 返回一个实例则该实例会调用 __init__()。

        __new__() 的目的主要是允许不可变类型的子类 (例如 int, str 或 tuple) 定制实例创建过程。

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

for example

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

##### `__repr__(), __str__()`

for example

    class MyClass():
        def __repr__(self):
            return '__repr__()'
        def __str__(self):
            return '_str__()'

    myClass = MyClass()
    print(repr(myClass))
    print(str(myClass))


##### `__lt__()`

for example

    class MyClass():
        number = 0

        def __lt__(self, obj):
            return self.number < self.number

    myClass = MyClass()
    print(myClass < myClass)

#### 自定义属性访问

    object.__getattr__(self, name)
    object.__getattribute__(self, name)
    object.__setattr__(self, name, value)
    object.__delattr__(self, name)
    object.__dir__(self)

##### property 与 getatt, getattribute, setattr, delattr

<a name="propertyExample"></a>

for example

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

#### 实现描述器

    object.__set__(self, instance, value)
    object.__delete__(self, instance)
    object.__set_name__(self, owner, name)

for example

    [example](# customizeDecoratorExample)
    
#### 模拟数字类型

    object.__add__(self, other)
    object.__sub__(self, other)
    object.__mul__(self, other)
    object.__and__(self, other)
    object.__xor__(self, other)
    object.__or__(self, other)
    ...

for example

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

    class Animal():
        def __init__(self, animalList):
            self.animalName = animalList
        def __getitem__(self, index):
            return self.animalName[index]

    animals = Animal(["dog","cat","fish"])
    # 如果没有 `__getitem__()` 时，TypeError: 'Animal' object is not iterable
    for animal in animals:
        print(animal)

##### <a name="iterNextExample"></a>迭代器，__iter__(), __next__()

- [`iter()`](https://docs.python.org/zh-cn/3/library/functions.html?highlight=iter#iter)

    调用 iterator 的 __iter__() 方法。

- [`next(<iterator>)`](https://docs.python.org/zh-cn/3/library/functions.html#next)

    调用 iterator 的 __next__() 方法。

for example

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


##### [生成器](https://docs.python.org/zh-cn/3/tutorial/classes.html#iterators)

在 Python 中，使用了 yield 的函数被称为生成器（generator）。

跟普通函数不同的是，生成器是一个返回迭代器的函数，只能用于迭代操作，更简单点理解生成器就是一个迭代器。

在调用生成器运行的过程中，每次遇到 yield 时函数会暂停并保存当前所有的运行信息，返回 yield 的值, 并在下一次执行 next() 方法时从当前位置继续运行。

for example

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

### 包与模块

- 包

    含有 `__init__.py` 文件的文件夹

    可用 `pip` 管理包

    列出所有包

        pip list

- 模块

    模块是 `.py` 后缀的文件。

    list all available modules

        pythom -m pydoc modules
        help('modules')


#### python 的搜索路径

将 packages 或 module 放在搜索路径即可。
            
列出搜索路径

    import sys
    print(sys.path)

#### from, import, as

[*标识符 `_*` 不会被导入*](https://docs.python.org/zh-cn/3/reference/lexical_analysis.html#identifiers)


[from import 的语法](https://docs.python.org/zh-cn/3.8/reference/simple_stmts.html#the-import-statement)

- `import <module> [as <identifier>] [, <module> [as <identifier>]]...`
    
    导入整个 module

- `from {<package> | <module>} import <identifier> [as <identifier>] [, <identifier> as <identifier>]`

    导入整个 module 或导入某个标识符。
    可用于去包名前缀或 module 名前缀。


*identifier 是标志符的意思，只能由字母、数字和下划线组成，且不能以数字开头。*

*不能导入整个包*

*如果没有 as 部分则用 import 部分来访问*

*当导入很多包时，导入的 module 名称要尽量不相同且用不同的 module 前缀来访问 module 内的标识符。这样就能避免同名问题。*

for example

    # ### import syntax
    import package1.subpackage1.module1
    package1.subpackage1.module1.func1()
    # 错误
    # func1()
    
    import package1.subpackage1.module1 as mymodule1
    mymodule1.func1()
    # 不能用 import 部分访问了
    # NameError: name 'package1' is not defined
    # package1.subpackage1.module1.func1()

    # #### 尝试给包名加个前缀
    # SyntaxError: invalid syntax. 因为标识符不能有点。
    # import package1.subpackage1.module1 as subpackage1.module1
    # subpackage1.module1.func1()

    # ### from ... import syntax
    from package1.subpackage1 import module1
    module1.func1()

    from package1.subpackage1.module1 import func1
    func1()

    # 尝试给标识符加个 module 前缀
    # SyntaxError: invalid syntax. 原因是标识符不能有“点”。
    # from package1.subpackage1 import module1.func1
    # module1.func1()

    # ### 去除包名前缀
    from package1.subpackage1 import module1
    from package1.subpackage1 import module2
    module1.func1()
    module2.func1()

    # ### 去除 module 前缀
    from package1.subpackage1.module1 import func1
    func1()

## 常用

### [sys](https://docs.python.org/zh-cn/3/library/sys.html#module-sys)

`sys.path`

> 模块搜索路径

`sys.stdin, sys.stdout, sys.stderr`

> 解释器用于标准输入、标准输出和标准错误的文件对象

for example

    import sys

    print(sys.path)
    print(sys.argv)
    print(sys.modules)

### [IO](https://docs.python.org/zh-cn/3/library/io.html?highlight=seek#module-io)

处理流的核心工具

#### [stdandard input output](https://docs.python.org/zh-cn/3/library/sys.html?highlight=sys%20stdin#sys.stdin)

    input(), print()

标准 IO 流

    sys.stdin
    sys.stdout
    sys.stderr


for example

    s = input('please input something: ')
    print(s)

for example

    import sys

    for line in sys.stdin:
        if 'q' == line.rstrip():
            break
        # f 前缀表示 format
        print(f'Input : {line}')
        sys.stdout.write(line)
        sys.stderr.write(line)

#### [文件读写](https://www.programiz.com/python-programming/file-operation)

    open(), close()
    read(), readline(), readlines()
    write(), writelines()
    tell(), seek()

for example: 打开文件的方式

    # ### 打开文件的两种方式
    try:
        f = open("testfile", mode='r', encoding='utf-8')
        # perform file operations
    finally:
        f.close()

    # 会自动调用 close()
    with open("testfile", mode='r', encoding = 'utf-8') as f:
        # perform file operations

for example

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

##### 读写 json 文件

for example

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

### [OS 模块](https://docs.python.org/zh-cn/3/library/os.html)

多种操作系统接口。

#### 执行命令

os.system(command)
在子 shell 中执行命令（字符串）。这是调用标准 C 函数 system() 来实现的，因此限制条件与该函数相同。对 sys.stdin 等的更改不会反映在执行命令的环境中。command 产生的任何输出将被发送到解释器标准输出流。

subprocess 模块提供了更强大的工具来生成新进程并跟踪执行结果，使用该模块比使用本函数更好。

#### [获取命令的输出](https://stackoverflow.com/questions/4760215/running-shell-command-and-capturing-the-output)

for example

    import subprocess
    result = subprocess.run(['ls', '-l'], stdout=subprocess.PIPE)
    print(result.stdout.decode('utf-8'))

#### [os.path](https://docs.python.org/zh-cn/3/library/os.path.html)

常用路径操作

for example

    import os
    
    print( os.path.basename('/root/runoob.txt') )   # 返回文件名
    print( os.path.dirname('/root/runoob.txt') )    # 返回目录路径
    print( os.path.split('/root/runoob.txt') )      # 分割文件名与路径
    print( os.path.join('root','test','runoob.txt') )  # 将目录和文件名合成一个路径

### Python 与 C/C++ 相互调用

Refer

- <https://www.cnblogs.com/apexchu/p/5015961.html>
- <https://www.geeksforgeeks.org/calling-python-from-c-set-1/>
- <https://realpython.com/build-python-c-extension-module/>
- <https://docs.python.org/zh-cn/3.8/extending/index.html>

Python 与 C/C++ 相互调用的方式

- Python 调用 C/C++ 的方式

    - 通过 ctype 加载动态链接库调用 C/C++
    - C/C++ 用 python API 制作 python module, 然后 python 调用该 module

- C/C++ 调用 Python 的方式

    - 通过 python API 来加载 python module, 并调用 module 内的东西。

PyObject 与 C/C++ 之间类型转换

- [具体的对象层](https://docs.python.org/zh-cn/3/c-api/concrete.html)

        long PyLong_AsLong(PyObject *obj)

- [解析参数并构建值变量](https://docs.python.org/zh-cn/3/c-api/arg.html)

        PyObject* Py_BuildValue(const char *format, ...)

#### Python 调用 C/C++

for example: ctype

    # ## python 调用 C

    # ### pycallc.c
    /* gcc -o libpycallc.so -shared -fPIC pycallc.c */

    long add(long a, long b) {
        return a + b;
    }

    # ### pycallc.py
    import ctypes

    loadLibrary = ctypes.cdll.LoadLibrary
    libpycallc = loadLibrary("./libpycallc.so")
    print('sum = {}'.format(libpycallc.add(1, 2)))

    # ## python 调用 C++

    # ### pycallcpp.cpp
    /* g++ -o libpycallcpp.so -shared -fPIC pycallcpp.cpp */

    class Calculator {
    public:
        long add(long a, long b) {
            return a + b;
        }
    };

    extern "C" {
        Calculator cal;

        long add(long a, long b) {
            return cal.add(a, b);
        }
    }

    # ### pycallcpp.py
    import ctypes

    loadLibrary = ctypes.cdll.LoadLibrary
    libpycallcpp = loadLibrary("./libpycallcpp.so")
    print("sum = {}".format(libpycallcpp.add(1, 2)))

##### 用 C/C++ 扩展 Python

###### 用 C/C++ 扩展 Python 的函数

用 C/C++ 实现一个函数，然后在 Python 中调用这个函数。

[*CPython 用 C 添加 builtin 函数 print。(搜索 `builtin_print`)*](https://github.com/python/cpython/blob/master/Python/bltinmodule.c)

for example
    
    # ## 相关文件
    cextpy.c
        用 C 制作 python module cext (用 C 扩展 Python)
    setup.py
        安装 cext 模块
    test.py
        在 python 中调用 cext 模块

    # ## 操作过程
    python setup.py install
    # 查看已安装的模块 cext
    pip show cext
    python test.py

    # 卸载（因为使用了 distutils，无法使用 pip uninstall）
    find /usr/lib/python*/site-packages/ | grep -i cext
    find /usr/lib/python*/site-packages/ | grep -i cext | xargs rm
    pip show cext

    # ## cextpy.c
    #include "Python.h"

    // ### C 函数
    long add(long a, long b) {
        return a + b;
    }

    // ### 用样板来包装代码
    static PyObject* cExtAdd(PyObject *self, PyObject *args) {
        long a, b;

        if (!PyArg_ParseTuple(args, "ll", &a, &b)) {
            return NULL;
        }

        return (PyObject*) Py_BuildValue("l", add(a, b));
    }

    // ### 将函数封装到 python module
    static PyMethodDef cExtMethods[] = {
        {"add", cExtAdd, METH_VARARGS, "Python interface for the add function"},
        {NULL, NULL, 0, NULL}
    };

    /*********************************
    // python 2.x 的做法
    void initcExt() {
        Py_InitModule("cExt", cExtMethods);
    }
    *********************************/

    static struct PyModuleDef cExtModule = {
        PyModuleDef_HEAD_INIT,
        "cExt",      /* name of module */
        "",          /* module documentation, may be NULL */
        -1,          /* size of per-interpreter state of the module, or -1 if the module keeps state in global variables. */
        cExtMethods
    };

    // 函数名的格式：PyInit_<module>()
    // ImportError: dynamic module does not define module export function (PyInit_cext)
    PyMODINIT_FUNC PyInit_cext() {
        return PyModule_Create(&cExtModule);
    }

    # ## setup.py

    #!/usr/bin/python3

    // ### 安装 module
    """
    from distutils.core import setup, Extension

    MOD = 'cext'
    setup(name=MOD, ext_modules=[Extension(MOD, sources=['cextpy.c'])])
    """

    # 另外一种做法。能添加更多的信息。
    from distutils.core import setup, Extension

    def main():
        setup(name="cExt",
            version="1.0.0",
            description="Python interface for the C functions",
            author="Johan Chane",
            author_email="your_email@gmail.com",
            ext_modules=[Extension("cExt", ["cextpy.c"])])

    if __name__ == "__main__":
        main()

    # ## test.py

    #!/usr/bin/python3
    
    // ### 测试 module
    import cext

    print("sum = {}".format(cext.add(1, 2)))

###### [用 C/C++ 扩展 Python 的类型](https://docs.python.org/zh-cn/3/extending/newtypes_tutorial.html)

用 C/C++ 实现一个 Python 类型。

[*CPython 用 C 添加 builtin 类型(搜索 `INIT_TYPE(`)*](https://github.com/python/cpython/blob/master/Objects/object.c)

for example

    # ## 相关文件
    custom.c
        简单地添加一个新类型。
    custom2.c
        在 custom 模块上为类型添加属性与方法。
    setup.py
        安装 custom, custom2 模块
    test.py
        在 python 中调用 custom, custom2 模块的新类型

    # ## 操作过程
    python setup.py install
    # 查看已安装的模块 custom, custom2
    pip show custom custom2
    python test.py

    # 卸载（因为使用了 distutils，无法使用 pip uninstall）
    find /usr/lib/python*/site-packages/ | grep -i custom
    find /usr/lib/python*/site-packages/ | grep -i custom | xargs rm
    pip show custom custom2

    # ## custom.c

    #define PY_SSIZE_T_CLEAN
    #include <Python.h>

    typedef struct {
        PyObject_HEAD
        /* Type-specific fields go here. */
    } CustomObject;

    /* 新的类型 CustomType */
    static PyTypeObject CustomType = {
        PyVarObject_HEAD_INIT(NULL, 0)
        .tp_name = "custom.Custom",
        .tp_doc = "Custom objects",
        .tp_basicsize = sizeof(CustomObject),
        .tp_itemsize = 0,
        .tp_flags = Py_TPFLAGS_DEFAULT,
        .tp_new = PyType_GenericNew,
    };

    static PyModuleDef custommodule = {
        PyModuleDef_HEAD_INIT,
        .m_name = "custom",
        .m_doc = "Example module that creates an extension type.",
        .m_size = -1,
    };

    PyMODINIT_FUNC
    PyInit_custom(void)
    {
        PyObject *m;
        if (PyType_Ready(&CustomType) < 0)
            return NULL;

        m = PyModule_Create(&custommodule);
        if (m == NULL)
            return NULL;

        Py_INCREF(&CustomType);
        // 添加新的类型
        if (PyModule_AddObject(m, "Custom", (PyObject *) &CustomType) < 0) {
            Py_DECREF(&CustomType);
            Py_DECREF(m);
            return NULL;
        }

        return m;
    }

    # ## custom2.c

    #define PY_SSIZE_T_CLEAN
    #include <Python.h>
    #include "structmember.h"

    typedef struct {
        PyObject_HEAD
        PyObject *first; /* first name */
        PyObject *last;  /* last name */
        int number;
    } CustomObject;

    static void
    Custom_dealloc(CustomObject *self)
    {
        Py_XDECREF(self->first);
        Py_XDECREF(self->last);
        Py_TYPE(self)->tp_free((PyObject *) self);
    }

    static PyObject *
    Custom_new(PyTypeObject *type, PyObject *args, PyObject *kwds)
    {
        CustomObject *self;
        self = (CustomObject *) type->tp_alloc(type, 0);
        if (self != NULL) {
            self->first = PyUnicode_FromString("");
            if (self->first == NULL) {
                Py_DECREF(self);
                return NULL;
            }
            self->last = PyUnicode_FromString("");
            if (self->last == NULL) {
                Py_DECREF(self);
                return NULL;
            }
            self->number = 0;
        }
        return (PyObject *) self;
    }

    static int
    Custom_init(CustomObject *self, PyObject *args, PyObject *kwds)
    {
        static char *kwlist[] = {"first", "last", "number", NULL};
        PyObject *first = NULL, *last = NULL, *tmp;

        if (!PyArg_ParseTupleAndKeywords(args, kwds, "|OOi", kwlist,
                                        &first, &last,
                                        &self->number))
            return -1;

        if (first) {
            tmp = self->first;
            Py_INCREF(first);
            self->first = first;
            Py_XDECREF(tmp);
        }
        if (last) {
            tmp = self->last;
            Py_INCREF(last);
            self->last = last;
            Py_XDECREF(tmp);
        }
        return 0;
    }

    static PyMemberDef Custom_members[] = {
        {"first", T_OBJECT_EX, offsetof(CustomObject, first), 0,
        "first name"},
        {"last", T_OBJECT_EX, offsetof(CustomObject, last), 0,
        "last name"},
        {"number", T_INT, offsetof(CustomObject, number), 0,
        "custom number"},
        {NULL}  /* Sentinel */
    };

    static PyObject *
    Custom_name(CustomObject *self, PyObject *Py_UNUSED(ignored))
    {
        if (self->first == NULL) {
            PyErr_SetString(PyExc_AttributeError, "first");
            return NULL;
        }
        if (self->last == NULL) {
            PyErr_SetString(PyExc_AttributeError, "last");
            return NULL;
        }
        return PyUnicode_FromFormat("%S %S", self->first, self->last);
    }

    static PyMethodDef Custom_methods[] = {
        {"name", (PyCFunction) Custom_name, METH_NOARGS,
        "Return the name, combining the first and last name"
        },
        {NULL}  /* Sentinel */
    };

    /* tp_members 为新类型的成员；tp_methods 为新类型的方法 */
    static PyTypeObject CustomType = {
        PyVarObject_HEAD_INIT(NULL, 0)
        .tp_name = "custom2.Custom",
        .tp_doc = "Custom objects",
        .tp_basicsize = sizeof(CustomObject),
        .tp_itemsize = 0,
        .tp_flags = Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE,
        .tp_new = Custom_new,
        .tp_init = (initproc) Custom_init,
        .tp_dealloc = (destructor) Custom_dealloc,
        .tp_members = Custom_members,
        .tp_methods = Custom_methods,
    };

    static PyModuleDef custommodule = {
        PyModuleDef_HEAD_INIT,
        .m_name = "custom2",
        .m_doc = "Example module that creates an extension type.",
        .m_size = -1,
    };

    PyMODINIT_FUNC
    PyInit_custom2(void)
    {
        PyObject *m;
        if (PyType_Ready(&CustomType) < 0)
            return NULL;

        m = PyModule_Create(&custommodule);
        if (m == NULL)
            return NULL;

        Py_INCREF(&CustomType);
        if (PyModule_AddObject(m, "Custom", (PyObject *) &CustomType) < 0) {
            Py_DECREF(&CustomType);
            Py_DECREF(m);
            return NULL;
        }

        return m;
    }

    # ## setup.py

    from distutils.core import setup, Extension
    setup(name="custom", version="1.0",
        ext_modules=[
            Extension("custom", ["custom.c"]),
            Extension("custom2", ["custom2.c"]),
            ])

    # ## test.py

    import custom
    import custom2

    mycustom = custom.Custom()

    mycustom2 = custom2.Custom('myfirst', 'mylast')

    print(dir(mycustom2))
    print(mycustom2.first)
    print(mycustom2.last)
    print(mycustom2.name())

#### C/C++调用 Python

for exmple: 通过 Python C/C++ API 调用 C/C++ 函数

    # ## ccallpy.py
    def add(a, b):
        return a + b
    
    # ## ccallpy.c
    /* gcc -o ccallpy ccallpy.c -I/usr/include/python3.8 -L/usr/lib64/python3.8/config -lpython3.8 */
    #include <Python.h>
    #include <stdio.h>
    #include <stdlib.h>

    void ccallpy() {
        Py_Initialize();
        if (!Py_IsInitialized()) {
            exit(EXIT_FAILURE);
        }

        // 添加当前路径到 sys.path
        PyRun_SimpleString("import sys");
        PyRun_SimpleString("sys.path.append('./')");

        // ### 载入 py module
        char moduleName[] = "ccallpy";
        PyObject* pyModuleName = PyUnicode_FromString(moduleName);
        PyObject* pyModule = PyImport_Import(pyModuleName);
        if (!pyModule) {
            fprintf(stderr, "can't find %s\n", moduleName);
            exit(EXIT_FAILURE);
        }

        // ### 调用函数
        // #### 找出名为 add 的函数
        /**********************************************
        PyObject* pyDict = PyModule_GetDict(pyModule);
        if (!pyDict) {
            fprintf(stderr, "PyModule_GetDict failed!\n");
            exit(EXIT_FAILURE);
        }

        PyObject* pyFunc = PyDict_GetItemString(pyDict, "add");
        if (!pyFunc || !PyCallable_Check(pyFunc)) {
            fprintf(stderr, "can't find function add OR function is not callable!\n");
            exit(EXIT_FAILURE);
        }
        **********************************************/
        // 找出函数的另一种方法
        PyObject* pyFunc = PyObject_GetAttrString(pyModule, "add");
        if (!pyFunc || !PyCallable_Check(pyFunc)) {
            fprintf(stderr, "can't find function add OR function is not callable!\n");
            exit(EXIT_FAILURE);
        }

        // #### 构建参数
        /********************************
        PyObject* pyArgs = PyTuple_New(2);
        PyTuple_SetItem(pyArgs, 0, Py_BuildValue("l", 1));
        PyTuple_SetItem(pyArgs, 1, Py_BuildValue("l", 2));
        *********************************/
        // 构建参数的另一种方法
        PyObject* pyArgs = Py_BuildValue("ll", 1, 2);
        if (!pyArgs) {
            fprintf(stderr, "Py_BuildValue failed!\n");
            exit(EXIT_FAILURE);
        }

        // #### 调用 python 函数
        PyObject* pyRes = PyObject_CallObject(pyFunc, pyArgs);
        if (!pyRes) {
            fprintf(stderr, "PyObject_CallObject failed!\n");
            exit(EXIT_FAILURE);
        }

        long res = PyLong_AsLong(pyRes);
        printf("sum = %ld\n", res);

        // ### 清除并退出
        Py_DECREF(pyModuleName);
        Py_DECREF(pyArgs);
        Py_DECREF(pyModule);

        // 退出 python
        Py_Finalize();
    }

    int main() {
        ccallpy();
        return 0;
    }

## Others

### [PEPs (Python Enhancement Proposals)](https://www.python.org/dev/peps/)

[pep 翻译](https://github.com/chinesehuazhou/peps-cn)

[Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/)

### [python 的实现](https://docs.python.org/zh-cn/3/reference/introduction.html#alternate-implementations)

- CPython

    这是最早出现并持续维护的 Python 实现，以 C 语言编写。新的语言特性通常在此率先添加。

- Jython
- Python for .NET
- IronPython
- PyPy

### [urllib](https://docs.python.org/zh-cn/3/library/urllib.html)

for example

    import urllib.request

    response = urllib.request.urlopen("http://www.example.com")
    html = response.read()
    print(html)

    html = html.decode("utf-8")
    print(html)

    print(response.info())

### [Tkinter(GUI)](https://docs.python.org/zh-cn/3/library/tk.html)

EasyGUI 太简单了，功能不够强大。Tkinter 比较优秀，移植性比较高，被很多脚本语言（perl, ruby）使用，这也是 python 的默认 GUI 包。