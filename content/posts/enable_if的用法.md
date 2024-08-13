+++
title = "enable_if 的用法"
date = "2024-07-27"
categories = ["Cpp语法"]
tags = ["cpp", "基础", "语法"]
+++

## 函数返回值

```cpp
#include <iostream>
#include <type_traits>

template <typename T>
typename std::enable_if<std::is_integral<T>::value, T>::type
foo(T t) {
    std::cout << "Integer: " << t << std::endl;
    return t;
}

template <typename T>
typename std::enable_if<std::is_floating_point<T>::value, T>::type
foo(T t) {
    std::cout << "Floating point: " << t << std::endl;
    return t;
}

int main() {
    foo(10);
    foo(3.14);
    return 0;
}
```

## 模板的默认类型实参

```cpp
#include <iostream>
#include <type_traits>

template <typename T, typename = std::enable_if_t<std::is_integral<T>::value, bool>>
void foo(T t) {     // 只有需要一个版本的 foo 的情况下。因为模板的默认实参不同的两个模板是相同的东西。
                    // 如果想要两个版本以上, 则将 enable_if 做成模板类型, 请继续向下看。
  std::cout << "Integer: " << t << std::endl;
}

int main() {
  foo(10);
  return 0;
}
```

## 模板类型形参

```cpp
#include <iostream>
#include <type_traits>

/* 如果需要两个以上版本的 foo 的情况下。*/

template <typename T, std::enable_if_t<std::is_integral<T>::value, bool> = true>
void foo(T t) {     
  std::cout << "Integer: " << t << std::endl;
}

template <typename T, std::enable_if_t<std::is_floating_point<T>::value, bool> = true>
void foo(T t) {     
  std::cout << "Float: " << t << std::endl;
}

int main() {
  foo(10);
  foo(10.1);
  return 0;
}
```

## 模板的特化形参

```cpp
#include <iostream>
#include <type_traits>

template<typename T, typename U>
class Foo {};

template<typename T>
class Foo<T, std::enable_if_t<std::is_same_v<T, int>, T>> {
  public:
    Foo() {
      std::cout << "int" << std::endl;
    }
};

template<typename T>
class Foo<T, std::enable_if_t<std::is_same_v<T, float>, T>> {
  public:
    Foo() {
      std::cout << "float" << std::endl;
    }
};

template<typename T>
using MyFoo = Foo<T, T>;

int main() {
  MyFoo<int> foo1;
  MyFoo<float> foo2;
  return 0;
}
```

## 扩展 `enable_if`

IsIntegral:

```cpp
template <typename...>
struct IsIntegral;
template <typename T>
struct IsIntegral<T> : std::is_integral<T> {};
template <typename First, typename... Rest>
struct IsIntegral<First, Rest...>
    : std::integral_constant<bool, IsIntegral<First>::value &&
                                       IsIntegral<Rest...>::value> {};

template <typename... Types>
using EnableIfIntegral =
    typename std::enable_if<IsIntegral<Types...>::value>::type;
```

`IsIntegral<T, ...>` 的作用是 enable_if 相同 (控制编译器是否生成相应的代码), 只是可以判断多个类型是否都是整数。See [ref](https://github.com/google/libnop/blob/master/include/nop/base/utility.h)

## References

-   [std::enable_if](https://zh.cppreference.com/w/cpp/types/enable_if)
