#!/usr/bin/env python3
# -*- coding: utf8 -*-

## # Python Cheet Sheet

# Python version Python3.8

# 简单地列出一些有关基础知识的例子，详细说明请看个人笔记

# `##` 开头表示是 markdown 的标题

import math

## ## Basic

def funcForDebug():
    print('### funcForDebug')

    i = 100
    print(type(i))
    print(type(int))

    print(dir())

    print(id(i))

    print(isinstance(True, bool))
    print(issubclass(bool, int))

    # 类会被视作其自身的子类
    # True
    print(issubclass(int, int))
    del i

funcForDebug()

def funcForOutput():
    print('### funcForOutput')

    # ### `f/F` 前缀与 `{<expression>}`
    print(f'__name__ = {__name__}')

    def func():
        return 'ABC'
    print(f'ret: {func()}')

    print(f'The value of pi is approximately {math.pi:.3f}.')

    table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 7678}
    for name, phone in table.items():
        print(f'{name:10} ==> {phone:10d}')

    # ### str.format()
    print('We are the {} who say "{}!"'.format('knights', 'Ni'))
    print('{0} and {1}'.format('spam', 'eggs'))
    print('{1} and {0}'.format('spam', 'eggs'))
    print('The story of {0}, {1}, and {other}.'.format('Bill', 'Manfred', other='Georg'))

    # ### 旧的字符串格式化方法
    print('The value of pi is approximately %5.3f.' % math.pi)

funcForOutput()

def funcForStringConcaten():
    print('### funcForStringConcaten')

    # 解析时连接
    print('ABC' 'DEF')
    # 运行时连接
    print('ABC' + 'DEF')

funcForStringConcaten()

def funcForEscapeChar():
    print('### funcForEscapeChar')

    print('\'')
    print('\"')

    # escape newline
    str1 = 'ABC\
DEF'
    print(str1)

    # ### 圆括号、方括号或花括号以内的表达式允许分成多个物理行，无需使用反斜杠。
    str1 = ('ABC',
            'DEF')
    print(str1)

    str1 = ['ABC',
            'DEF']
    print(str1)

    str1 = {'ABC', 
            'DEF'}
    print(str1)

funcForEscapeChar()

## ### data type

def funcForDataType():
    print('### funcForDataType')

    # ### 数字类型
    print('#### 数字类型')
    # #### 整数
    i = 100
    b = True
    # #### 浮点数
    f = 1.5

    # ### complex
    cplx =4.7 + 0.666j          # 定义一个虚数
    print(cplx)                 # 输出这个虚数
    print(cplx.real)            # 输出实部
    print(cplx.imag)            # 输出虚部
    print(cplx.conjugate())     # 输出该复数的共轭复数

    # ### 序列类型
    print('#### 序列类型')
    # #### 不可变序列
    str1 = 'ABC'
    tuple1 = (1, 2)
    # #### 可变序列类型
    list1 = [1, 2]

    # ##### 列表解析
    list2 = [2 * i for i in range(1, 100, 10)]
    print(list2)

    # ### 集合类型
    print('#### 集合类型')

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

    set1 = {1, 2}
    frozenset1 = frozenset('ABC')
    print(frozenset1)

    # TypeError: unhashable type: 'set'
    # print(hash(set1))
    print(hash(frozenset1))

    # 元素必须是不可变对象
    # set2 = {[1, 2]}

    # 元素是不重复的
    set3 = {1, 1, 2}
    print(set3)

    # ### 映射类型
    print('#### 映射类型')

    # #### dict
    # key 的类型只能是 hashable
    dict1 = {0.1: 1, 0.1+0.1j: 2, (1,2): 3, (1, (1, 2)): 4}

    dict1[0.1]
    dict1[0.1+0.1j]
    dict1[(1,2)]

    # 出错，key 不是 hashable
    # dict2 = {(1, [1, 2])}

funcForDataType()

## ### Branch Control

def funcForBranchControl():
    print('### funcForBranchControl')

    if False:
        pass
    elif True:
        pass
    else:
        pass

funcForBranchControl()

## ### Flow Control
def funcForLoopControl():
    print('### funcForLoopControl')

    while True:
        # continue
        break

    words = ['cat', 'window', 'defenestrate']
    for w in words:
        print(w, len(w))

    # range(start : end : step)
    for i in range(5):
        print(i, end='\t')
    print('')

funcForLoopControl()

## ### Function
gVar = 100
def funcForFuncBasic():
    print('### funcForFuncBasic')

    localVar = 10
    # 使用全局变量
    global gVar
    gVar = 1000
    print(gVar)

funcForFuncBasic()

# x 可接收位置实参或关键字实参
# y 只能接收关键字实参
# keywordOnlyArgs 后面不能有参数（即只能是最后一个参数）
def funcForFuncArgs(x, *posOnlyArgs, y, **keywordOnlyArgs):
    print('### funcForFuncArgs')

    print('x = {}'.format(x))
    print(posOnlyArgs)
    print('y = {}'.format(y))
    print(keywordOnlyArgs)

funcForFuncArgs(1, 2, 3, y = 4, key1 = 5, key2 = 6)

def funcForFuncReturn():
    print('### funcForFuncReturn')
    return [1, 2]

print(funcForFuncReturn())

# 默认情况下是传引用，一些可变对象可指定传副本。不可变对象传副本没有意义，因为对象被修改时，会创建新的对象。
def funcForWayOfPassArgs(list1, set1, dict1):
    print('### funcForWayOfPassArgs')

    list1[0] = 10
    set1.pop()
    dict1['key1'] = 10

list1 = [1, 2]
set1 = {1, 2}
dict1 = {'key1': 1, 'key2': 2}
funcForWayOfPassArgs(list1.copy(), set1.copy(), dict1.copy())
print('list1 = {}, set1 = {}, dict1 = {}'.format(list1, set1, dict1))
funcForWayOfPassArgs(list1, set1, dict1)
print('list1 = {}, set1 = {}, dict1 = {}'.format(list1, set1, dict1))

## ### 内嵌函数与闭包

def funcForInnerFunc():
    print('### funcForInnerFunc')

    # 内嵌函数
    def innerFunc():
        print('innerFunc')

    innerFunc()

funcForInnerFunc()

def funcForClosure():
    print('### funcForClosure')

    x = 5
    # 内嵌函数
    def closure():
        # 指明 x 不是局部变量
        nonlocal x
        x += 1
        print(x)
    return closure

closure = funcForClosure()
closure()

## ### lambda
print('### lambda')

def func(a, b):
    return a + b

lmbd = lambda a, b: a + b
print(lmbd(10, 20))

## ### 异常

def funcForException():
    print('### funcForException')

    # ### 异常
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
        print('err = {}'.format(err))

funcForException()


## ## Class

## ### super

print('### super')

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

## ### 属性

print('### ClassForClassProperties')
class ClassForClassProperties():
    classProperty = 10
    def __init__(self):
        self.instanceProperty = 100

classForClassProperties = ClassForClassProperties()
print(classForClassProperties.instanceProperty)
print(ClassForClassProperties.classProperty)
print(classForClassProperties.classProperty)

## ### 方法

print('### ClassForClassMethods')
class ClassForClassMethods():
    # default method
    def defaultMethod(self):
        pass

    @classmethod
    def classMethod(cls):
        print(cls)

    @staticmethod
    def staticMethod():
        pass

classForClassMethods = ClassForClassMethods()
classForClassMethods.defaultMethod()
ClassForClassMethods.defaultMethod(classForClassMethods)

ClassForClassMethods.classMethod()
classForClassMethods.classMethod()

ClassForClassMethods.staticMethod()
classForClassMethods.staticMethod()

print('### ClassForClassAccessModifiers')
class ClassForClassAccessModifiers():
    def __init__(self):
        self.__privateProperty = 10
        self.publicProperty = 100
    def __privateMethod(self):
        print('__privateMethod')
    def publicMethod(self):
        print('publicMethod')

classForClassAccessModifiers = ClassForClassAccessModifiers()
print(classForClassAccessModifiers.publicProperty)
# print(classForClassAccessModifiers.__privateProperty)
classForClassAccessModifiers.publicMethod()
# classForClassAccessModifiers.__privateMethod()

## ### 多态

print('### Polymorphic')

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

## ### 单继承

print('### SingleInheriting')

class Base():
    def __init__(self):
        print('Base')

class MyClass(Base):
    def __init__(self):
        # Base.__init__(self)
        super().__init__()

myClass = MyClass()

## ### 多重继承

print('### MultiInheriting')

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

## #### 子类同名覆盖父类的问题

print('### Overriding in inheriting')

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

## ### 抽象类

print('### AbstractClass')

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

## ## `__*__` 标识符

## ### `__new__(), __init__()`

print('### `__new__(), __init__()`')

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

## ### 自定义属性访问

print('### 自定义属性访问')

## #### property()

print('#### `property()`')

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

## #### `__getattr__(),__getattribute__(),  __setattr__(), __delattr__()`

print('#### `__getattr__(),__getattribute__(),  __setattr__(), __delattr__()`')

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

## ### 模拟数字类型

print('### 模拟数字类型')

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
