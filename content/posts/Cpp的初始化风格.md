+++
title = "Cpp 初始化风格"
date = "2024-03-08"
categories = ["C/Cpp的语言风格"]
tags = ["c", "cpp", "初始化"]
+++

## cpp 的初始化风格

兼容 C 的初始化风格:

```cpp
int i = 10;
int a[] = {1, 2, 3};

struct Foo {
  char c;
  int i;
};

union Bar {
  char c;
  int i;
};

Foo foo = {.c = 'A', .i = 42};
Bar bar = {.c = 'A'};
```

但是 Cpp 引入了类, 这样会导致一个问题:

```cpp
#include <iostream>

struct Foo {
};

struct Bar {
  Bar(const Foo& foo) {
    std::cout << "Bar::Bar" << std::endl;
  }
};

int main() {
  //Bar bar(Foo());     // 只是一个函数声明
  //Bar bar((Foo()));     // 解决方案 1
  Bar bar{Foo()};     // 解决方案 2
  
  return 0;
}
```

Cpp 的花括号初始化:
-   好处是, 初始化更加安全。
-   坏处是, 如果类型有 initializer_list 初始化方式, 则优先使用 std::initializer_list 构造函数。如果你想为一个类型添加 initializer_list 初始化方式, 你需要找到它的对象原来用花括号初始化改为用圆括号初始化。而且用户用花括号初始化时, 需要知道该类型有没有 initializer_list 的初始化方式。

for example:

```cpp
vector<int> v{5};        // 使用 initializer_list 的方式初始化
vector<int> v = {5};     // 使用 initializer_list 的方式初始化
vector<int> v(5);
```

个人觉得 cpp 的花括号初始化和数组初始化有点混淆。如果不用兼容 C, 可以像 rust 一样使用 `[]` 初始化数组, `{}` 初始化结构体。但是 C 已经使用 `{}` 来初始化数组了, 如果 C++ 改用 `[]` 来初始化数组则不统一了。

## `=` 的初始化风格

我更加喜欢类似于 rust, python, java 等语言的初始化方式, 使用 `=`:

```cpp
int i = 10;         // 原始类型使用原来的风格。
auto mt = MyType(param1, param2);       // 非原始类型使用此风格。
                                        // 虽然不能声明多个同类型的对象, 但是不建议一行声明多个对象。See [ref](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#es10-declare-one-name-only-per-declaration).
                                        // 不会有多余的操作, 因为有[复制消除](https://zh.cppreference.com/w/cpp/language/copy_elision)。
                                        // 同时它一定不是一个函数声明, 所以避免了函数声明和对象定义的混淆。

auto mt = MyType{param1, param2};       // 使用花括号初始化, 但是要注意不要混淆 initializer_list 的初始化方式, 且该类型以后最好不用添加 initializer_list 的初始化方式。
```

对于 C 的数据类型初始化风格:

```cpp
int i = int();          // 使用 `=` 号赋值能保证内存会被初始化

// 指针类型
int* iptr1 = nullptr;   // 如果我想定义一个指针变量。
auto iptr2 = &i;

// cpp 的类型
Foo* foo_ptr1 = nullptr;
auto foo = Foo();
auto foo_ptr2 = &foo;
```

综上, 使用 `=` 初始化会保证变量会被初始化。这样会更加安全。所以优先使用 `=` 初始化, 如果变量不需要初始化时, 再使用非 `=` 的初始化风格, 是一个不错的选择。

## References

-   [Tip of the Week #88: Initialization: =, (), and {}](https://abseil.io/tips/88)
