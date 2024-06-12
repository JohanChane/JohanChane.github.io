# Cpp11 新特性总结

## Content

${toc}

## References

-   《深入理解 C++11 ：C++11 新特性解析与应用》
-   《C++ 标准程序库》
-   <https://zh.cppreference.com>
-   [cpp insight](https://cppinsights.io/)

## 值类别

值类别的概念

> 每个 C++ 表达式（带有操作数的操作符、字面量、变量名等）可按照两种独立的特性加以辨别：类型和值类别 (value category)。

### 值类别的定义

[值类别](https://zh.cppreference.com/w/cpp/language/value_category)

值类别的关系

![](https://docs.microsoft.com/en-us/cpp/cpp/media/value_categories.png?view=msvc-160)

每个表达式都具有某种非引用类型，且每个表达式只属于三种基本值类别中的一种：纯右值 (prvalue)、亡值 (xvalue)、左值 (lvalue)。

> 亡值是 C++11 引入的概念。<br>
> 纯右值是 C++98 的右值，左值是 C++98 的左值。亡值不属于纯右值和左值。

### C++ 值类别的历史

[C++ 值类别的历史](https://zh.cppreference.com/w/cpp/language/value_category#.E5.8E.86.E5.8F.B2)

随着移动语义引入到 C++11 之中，值类别被重新进行了定义，以区别表达式的两种独立的性质：

-   拥有身份 (identity)：可以确定表达式是否与另一表达式指代同一实体，例如通过比较它们所标识的对象或函数的（直接或间接获得的）地址；
-   可被移动：移动构造函数、移动赋值运算符或实现了移动语义的其他函数重载能够绑定于这个表达式。

C++11 中：

-   拥有身份的表达式被称作“泛左值 (glvalue) 表达式”。左值和亡值都是泛左值表达式。
-   可被移动的表达式被称作“右值 (rvalue) 表达式”。纯右值和亡值都是右值表达式。

所以有：

-   拥有身份且不可被移动的表达式被称作左值 (lvalue)表达式；
-   拥有身份且可被移动的表达式被称作亡值 (xvalue)表达式；
-   不拥有身份且可被移动的表达式被称作纯右值 (prvalue)表达式；
-   不拥有身份且不可被移动的表达式无法使用。

***左值都是可以取址的，纯右值和亡值都是不可取址的。***

### 值类别的总结

[值类别的总结](https://www.cnblogs.com/zpcdbky/p/5275959.html)

1.  左值

    能够用&取地址的表达式是左值表达式。

    > 是其求值确定一个对象、位域或函数的个体的表达式（除了将亡值）

2.  纯右值

    满足下列条件之一：

        1）本身就是赤裸裸的、纯粹的字面值，如3、false；
        2）求值结果相当于字面值或是一个不具名的临时对象。

    不能取址。

3.  将亡值

    在C++11之前的右值和C++11中的纯右值是等价的。C++11中的将亡值是随着右值引用的引入而新引入的。换言之，“将亡值”概念的产生，是由右值引用的产生而引起的，将亡值与右值引用息息相关。所谓的将亡值表达式，就是下列表达式：

        1）返回右值引用的函数的调用表达式
        2）转换为右值引用的转换函数的调用表达式

    不能取址。

4.  特别注意

    1.  字符串字面值是左值。

        早期C++将字符串字面值实现为char型数组，实实在在地为每个字符都分配了空间并且允许程序员对其进行操作。比如：

            cout<<&("abc")<<endl;
            // 对于char *p_char="abc";，在GCC编译器上,GCC4.9(C++14)及以前的版本会给出警告，在GCC5.3(C++14)及以后的版本则直接报错：ISO C++ forbids converting a string constant to 'char*'（ISO C++禁止string常量向char*转换）。但这并不影响“字符串字面值是左值”这一结论的正确性。
            char *p_char="abc";

    2.  函数名和数组名是左值，都是可以取址的。
    3.  具名的右值引用是左值，不具名的右值引用是右值。

for example

```cpp
10;             // 纯右值
int i;          // 左值
int funcA();
int&& funcB();
int& funcC();

funcA();        // 纯右值
funcB();        // 亡值
funcC();        // 左值
```

返回右值引用不会生成临时对象

```cpp
class C { };

C&& func(C& c) {
    return std::move(c);
}

C c;

// 没有生成临时对象
C c1 = func(c);
// 没有生成临时对象
func(c);

// 没有生成临时对象
func(c).method();
```

***用 `decltype((表达式))` 可找出表达式的值类别。<a name="decltypeValueCategory"></a>***

```cpp
#include <iostream>
#include <type_traits>

using namespace std;

#define VALUE_CATEGORY(expr) ( \
    valueCategory<decltype((expr))>() \
)

// 用法：valueCategory<decltype((<expr>))>();
template<typename T>
const char* valueCategory() {
    if (is_lvalue_reference<T>::value) {
        return "lvalue";
    } else if (is_rvalue_reference<T>::value) {
        return "xvalue";
    } else {
        return "rvalue";
    }
}

int gi;

int func1() {
    return 0;
}

int& func2() {
    return gi;
}
int&& func3() {
    return static_cast<int&&>(gi);
}

int main() {
    cout << VALUE_CATEGORY(func1()) << endl;
    cout << VALUE_CATEGORY(func2()) << endl;
    cout << VALUE_CATEGORY(func3()) << endl;
    cout << VALUE_CATEGORY(0) << endl;
    cout << VALUE_CATEGORY(gi) << endl;
}
```

### 值类别例子

[值类别例子](https://zh.cppreference.com/w/cpp/language/value_category)

*值类别比较难理解，应该多算例子。*

-   左值

    ```cpp
    字符串字面量，例如 "Hello, world!"；

    int i;
    const int ci;
    int& ilr = i;
    const int& cilr = i;

    // int& func();
    func();

    int a, b;
    a = b; a += b; ...	// 所有内建的赋值及复合赋值表达式；

    转换为左值引用类型的转型表达式，例如 static_cast<int&>(x)；
    转换为函数的右值引用类型的转型表达式，如 static_cast<void (&&)(int)>(x)。
    ```

-   右值

    ```cpp
    （除了字符串字面量之外的）字面量，例如 42、true 或 nullptr；

    // int func();
    func();

    int a, b;
    a + b; ...
    a && b; ...
    a < b; ...

    class C;
    C();

    int i;
    &i;

    转换为非引用类型的转型表达式，例如 static_cast<double>(x)、std::string{} 或 (int)42；
    this 指针；
    ```

-   亡值

    ```cpp
    // int&& func();
    func();
    a.m，对象成员表达式，其中 a 是右值且 m 是非引用类型的非静态数据成员；
    a.*mp，对象的成员指针表达式，其中 a 为右值且 mp 为数据成员指针；
    转换为对象的右值引用类型的转型表达式，例如 static_cast<char&&>(x)；
    ```

## 右引用与左引用

右引用只能绑定右值（包含将亡值）。

非常量的左引用只能绑定左值（不包含亡值）。

*注意：常量的左引用可以绑定右值，可以代替常量右引用，所以常量右引用只是使得语法完整而没有实质的作用。*

***注意：右引用是一个左值。***

for example

```cpp
#include <iostream>

using namespace std;

int&& funcA(int&& i) {
    return move(i);
}

int main() {
    // 绑定右值到右引用时，会创建临时变量。
    int&& iRightRef = 10;
    cout << &iRightRef << endl;
    // 这里是赋值，地址相同。
    iRightRef = 100;
    cout << &iRightRef << endl;

    // error
    // int& iLeftRef = funcA();
    // ok
    int&& iRightRef2 = funcA(10);
}
```

### 右引用与左引用的函数匹配

因为右引用只能绑定右值，所以形参为右引用时，表示实参只能是右值。

因为非常量的左引用只能绑定左值，所以形参为非常量的左引用时，表示实参只能是左值。同理可知常量左引用。

## 移动语义与完美转发

### 移动语义（move semantics）

表示将一个将不被使用的对象的资源移动到另一个对象。

***如果没有引用右值，则在语句结束后，用户将无法再次使用右值，所以可以偷右值的资源。***

注意 事实上，移动语义并不是什么新的概念，在C++98/03的语言和库中，它已经存在了，比如：

- 在某些情况下拷贝构造函数的省略（copy constructor elision in some contexts），即复制省略。
- 智能指针的拷贝（auto_ptr“copy”）
- 链表拼接（list::splice）
- 容器内的置换（swap on containers）

*以上这些操作都包含了从一个对象向另外一个对象的资源转移（至少概念上）的过程，唯一欠缺的是统一的语法和语义的支持，所以 C++11 引入了右引用与亡值的概念。*

*std::move() 在语义上表示移动资源。实质在实现上只是转为右值。*

```cpp
template<typename T>
typename std::remove_reference<T>::type&& move(T&& t) noexcept;
```

for example

```cpp
// ## 问题
class C {
    int* iPtr;
public:
    C(int i) {
        iPtr = new int(i);
    }
    C(const int& i) {
        iPtr = new int(i);
    }
    ~C() {
        delete iPtr;
    }
};

C func(const C c) {
    return c;
}

int main() {
    C c;
    // 如果不考虑复制消除，因为临时对象将被回收，所以可以将其资源转到 c
    C cc = func(c);
}

// ## 用移动语义解决

class C {
    int* iPtr;
public:
    C(int i) {
        iPtr = new int(i);
    }
    C(const int& i) {
        iPtr = new int(i);
    }
    // 实参会是一个右值，所以可以偷其资源
    C(int&& i) {
        iPtr = i.iPtr;
        i.iPtr = nullptr;
    }
    ~C() {
        if (iPtr) {
            delete iPtr;
        }
    }
};

C func(const C c) {
    return c;
}

int main() {
    C c;
    // 因为临时对象是一个右值，所以调用移动构造函数
    C cc = func(c);
}
```

### 完美转发

完美转发

> 指的是函数模板可以将自己的参数“完美”地转发给内部调用的其它函数。所谓完美，即不仅能准确地转发参数的值，还能保证被转发参数的左、右值属性不变。

如果使用 C++ 98/03 标准下的 C++ 语言，我们可以采用函数模板重载的方式实现完美转发。

for example

```cpp
#include <iostream>

using namespace std;

void func(int& i) {
    cout << "func(int&)\n";
}

void func(const int& i) {
    cout << "func(const int&)\n";
}

template<typename T>
void funcWrapper(T& t) {
    func(t);
}

template<typename T>
void funcWrapper(const T& t) {
    func(t);
}

int main() {
    funcWrapper(10);       // void func(const int& i)
    int i;
    funcWrapper(i);        // void func(int& i)
}
```

在 C++11 标准中实现完美转发，只需要编写如下一个模板函数即可。

for example

```cpp
#include <iostream>

using namespace std;

// std::forward 其中一个版本的实现
template<typename T>
T&& forward(typename std::remove_reference<T>::type& t) noexcept {
    cout << "forward(typename std::remove_reference<T>::type& T)\n";
    return static_cast<T&&>(t);
}

void func(int& i) {
    cout << "func(int&)\n";
}

void func(const int& i) {
    cout << "func(const int&)\n";
}

template<typename T>
void funcWrapper(T&& t) {
    // 都是调用 func(int&), 因为右引用是一个左值。
    //func(t);
    // 完美转发
    func(::forward<T>(t));
}

int main() {
    funcWrapper(10);       // func(int&& i); T = int&&
    int i;
    funcWrapper(i);        // func(int& i); T = int&
}
```

以下的 forward 实现了完美转发。转发左值（具名的右值引用是左值）为左值或右值，依赖于 T。<a name="forwardExample1"></a>

```cpp
template<typename T>
T&& forward(typename std::remove_reference<T>::type& t) noexcept;

template<class T>
void wrapper(T&& arg) {
    // arg 始终是左值
    foo(std::forward<T>(arg)); // 转发为左值或右值，依赖于 T
}
```

#### 引用折叠

那C++11是如何解决完美转发的问题的呢？
> 实际上，C++11是通过引入一条所谓“引用折叠”（reference collapsing）的新语言规则，并结合新的模板推导规则来完成完美转发。

在C++11以前，形如下列语句：

    typedef const int T;
    typedef T& TR;
    TR& v = 1;      //该声明在C++98中会导致编译错误

> 其中TR＆v=1这样的表达式会被编译器认为是不合法的表达式，而在C++11中，一旦出现了这样的表达式，就会发生引用折叠，即将复杂的未知表达式折叠为已知的简单表达式。

##### 转发引用

[转发引用](https://zh.cppreference.com/w/cpp/language/reference#.E8.BD.AC.E5.8F.91.E5.BC.95.E7.94.A8)

转发引用是一种特殊的引用，它保持函数实参的值类别，使得 std::forward 能用来转发实参。转发引用是下列之一：

-   函数模板的函数形参（不包含返回值），其被声明为同一函数模板的类型模板形参的无 cv 限定的右值引用：

    ```cpp
    template<class T>
    int f(T&& x);   // x 是转发引用

    template<class T>
    int g(const T&& x);     // x 不是转发引用：const T 不是无 cv 限定的

    template<class T> struct A {
        template<class U>
        A(T&& x, U&& y, int* p);    // x 不是转发引用：T 不是构造函数的类型模板形参（因为 T 为实例化决定）
                                    // 但 y 是转发引用
    };
    ```

-   auto&& 是转发引用，但当其从花括号包围的初始化器列表推导时除外：

    ```cpp
    auto&& vec = foo();       // foo() 可以是左值或右值，vec 是转发引用

    for (auto&& x: f()) {
      // x 是转发引用；这是使用范围 for 循环最安全的方式
    }

    auto&& z = {1, 2, 3}; // *不是*转发引用（初始化器列表的特殊情形）
    ```

##### 引用折叠规则

对模板参数类型演绎推理的引用折叠规则.

| Expanded type | Collapsed type |
| --            | --             |
| T& &          | T&             |
| T&& &         | T&             |
| T& &&         | T&             |
| T&& &&        | T&&            |

[当函数模板的函数形参是转发引用时，函数模板才会用这些推导规则](https://www.cnblogs.com/zpcdbky/p/5284711.html)

> 只要我们传递一个基本类型是 A 的左值，那么，传递后，T 的类型就是 A&，形参在函数体中的类型就是 A&。<br>
> 只要我们传递一个基本类型是 A 的右值，那么，传递后，T 的类型就是 A，形参在函数体中的类型就是 A&&。

for example

```cpp
#include <iostream>
#include <type_traits>

using namespace std;

template<typename T>
void typeTrait(T&& t) {
    cout << "### type trait\n";
    cout << "is_lvalue_reference: " << is_lvalue_reference<T>::value << endl;
    cout << "is_rvalue_reference: " << is_rvalue_reference<T>::value << endl;
}

int get1(int i) {
    return i;
}

int& get2(int& t) {
    return t;
}

int&& get3(int&& t) {
    return static_cast<int&&>(t);
}

int main() {
    int i = 100;
    int* iptr = &i;
    int& ilr = i;
    int&& irr = 200;

    // ### lvalue_ref. T = int&, typeTrait(int& && t) ==> typeTrait(int& t);
    typeTrait(i);
    typeTrait(*iptr);
    typeTrait(ilr);
    typeTrait(irr);
    typeTrait<int&>(i);
    typeTrait<int&>(ilr);
    typeTrait<int&>(irr);
    typeTrait(get2(i));

    // ### not lvalue_ref or rvalue_ref. T = int, typeTrait(int && t) ==> typeTrait(int&& t);
    typeTrait(100);
    typeTrait(get1(10));
    typeTrait(get3(30));
    typeTrait(static_cast<int&&>(i));

    // ### rvalue_ref. T = int&&, typeTrait(int&& && t) ==> typeTrait(int&& t);
    // error
    // typeTrait<int&&>(irr);
    typeTrait<int&&>(100);

    return 0;
}
```

转发引用的模板类型推导与普通的模板的类型推导规则是不相同的。

for example

```CPP
template<typename T>
void func(T& t);

func(100);      // T = int
int i;
func(i);		// T = int

func<int&>(i);  // T = int&
```

#### `std::forward` 的另一个版本

以下的 forward 是将右值转发为右值并禁止将右值的转发为左值。<br>

```cpp
template <class T>
T&& forward(typename std::remove_reference<T>::type&& arg) noexcept {
  static_assert(!std::is_lvalue_reference<T>::value, "bad forward");
  return static_cast<T&&>(arg);
}
```

与[之前的版本](#forwardExample1)结合，用于转发表达式（如函数调用）的结果。

用法:

```cpp
// expr 不能作为模板实参
//foo( forward< <expr> >(<expr>) );
// 一个 decltype 后，可作为模板实参。
foo( forward<decltype(<expr>)>(<expr>) );
```

for example: 若包装器不仅转发其参数，还在参数上调用成员函数，并转发其结果：

```cpp
// 转换包装器
template<class T>
void wrapper(T&& arg) {
    // expr = forward<T>(arg).get()
    foo(forward<decltype(forward<T>(arg).get())>(forward<T>(arg).get()));
}

struct Arg {
    int i = 1;
    int  get() && { return i; } // 此重载的调用为右值
    int& get() &  { return i; } // 此重载的调用为左值
};
```

## Cpp 的类型

### 类型分类

ref: [类型分类](https://zh.cppreference.com/w/cpp/language/type)

Cpp 的类型分为两大类

-   基本类型
-   复合类型

根据类型的各项性质，以可以将它们分组到不同的类别之中：

-   对象类型
-   标量类型
-   平凡类型
-   POD 类型
-   字面类型
-   [聚合类型](https://zh.cppreference.com/w/cpp/language/aggregate_initialization)
-   ...

### 类型特征库

ref: [类型特征库](https://zh.cppreference.com/w/cpp/types)

-   `is_fundamental`
-   `is_compound`
-   `is_object`
-   `is_scalar`
-   `is_trivial`
-   `is_pod`
-   `is_literal_type`
-   [`is_aggregate`](https://zh.cppreference.com/w/cpp/types/is_aggregate)
-   ...

## 初始化列表与 `initializer_list`

在C++11中，这种初始化的方法被称为“初始化列表”（initializer list）。

```C++
vector<int> v{1, 3, 5};
map<int, float> m = {{1, 1.0f},
                     {2, 2.0f},
                     {5, 3.2f}};
```

`initializer_list` 的使用时机：

> 初始一个数组或有数组功能的类型，比如：vector, array 等。<br>
> 还有一种是构造函数只有一个形参, 且形参是一个实例时。一般是整数相关的类型，比如：int，double 等。这样可以防止类型收窄。

使用列表初始化还有一个最大优势是可以防止类型收窄（narrowing）。

```cpp
#include <iostream>

#include <initializer_list>
#include <utility>

#include <vector>

using namespace std;

class C {
public:
    C(int a, int b, int c) {
        std::cout << "C(int, int, int)\n";
    }
    C(std::initializer_list<int> list) {
        for (std::initializer_list<int>::iterator it = list.begin(); it < list.end(); it++) {
            std::cout << *it << '\t';
        }
        std::cout << std::endl;
        std::cout << "list.size = " << list.size() << std::endl;
    }
    C(std::initializer_list<std::pair<int, float>> list) {
    }

    void method(initializer_list<int> list) {
    }
};

int main() {
    // ### 如果构造函数的参数与 initializer_list 相同，则优先使用 initializer_list。
    C c1(1, 2, 3);
    // 调用 initializer_list
    C c2{1, 2, 3};
    // 调用 initializer_list
    C c3({1, 2, 3});
    // 调用 initializer_list
    C c4{{1, 2, 3}};

    vector<int> v{10};
    // size == 1
    cout << v.size() << endl;

    // ### initializer_list 可防止类型收窄
    C c5(1.0, 2, 3);
    // C c6{1.0, 2, 3};

    // ### pairs
    C c7{{1,1.0f},{2,2.0f},{5,3.2f}};

    // ### 非构造函数的 initializer_list 参数
    // 要使用圆括号
    // c1.method{1, 2, 3};
    c1.method({1, 2, 3});
}
```

`C c = {3 + 4}` 与 `C c{3 + 4}` 的区别

> 前者将初始化列表隐式转换为 C，然后复制构造到 c。<br>
> 后者是直接调用构造函数初始化 c。

for example: 初始化列表与 explicit

```cpp
class C {
public:
    C(int a, int b) { }
    explicit C(int a, int b, int c) { }
};

C cA{1, 2};
C cB = {1, 2};
C cC{1, 2, 3};

C cD = {1, 2, 3};       // error, duo to explicit
C cE = C{1, 2, 3};      // ok, 显式类型转换。
```

## auto

auto 是类型占用符。

### auto 推导细则

auto 与 cv 限定符：不能“带走” cv 限定符。

for example

```cpp
// ### cv 限定符
// name 没有 cv 限定符
auto name = <cv 对象>

// ### 引用
// name 是对象的类型，而不是引用
auto name = <对象的引用>;
// name 是一个引用
auto& name = <对象>;
// vec 是转发引用
auto&& vec = foo();       // foo() 可以是左值或右值，vec 是转发引用

// ### 指针
// name 的类型相同，都是指针的类型。所以 `*` 是冗余的。
auto name = <对象的指针>;
auto* name = <对象的指针>;
```

### auto 禁止项

auto也不是万能的，受制于语法的二义性，或者是实现的困难性，auto往往也会有使用上的限制。

1.  auto 不能为形参（包括模板参数）类型。因为会影响重载解析。
1.  对于类与结构体来说，非静态成员变量类型不能用 auto。因为影响编译器知道对象的大小。
1.  不能声明 auto 数组。
1.  实例化模板时，不能用 auto。因为会影响重载解析。

### auto 极佳的应用场景

#### 推导模板类型

for example

```cpp
template<typename T1,typename T2>
double sum(T1& t1, T2& t2) {
    auto s=t1+t2;                       //s的类型会在模板实例化时被推导出来
    return s;
}
int main(){
    int a=3;
    long b=5;
    float c=1.0f,d=2.3f;
    auto e=sum<int,long>(a,b);          //s的类型被推导为long
    auto f=sum<float,float>(c,d);       //s的类型被推导为float
}
```

#### 模板函数与宏函数中使用。

for example

```cpp
#define Max1(a, b) ({\
    (a) > (b) ? (a) :(b)\
})

#define Max2(a, b)({\
    auto _a = (a);\
    auto _b = (b);\
    (_a > _b) ? _a : _b;\
})

int main(){
    int m1=Max1(1*2*3*4,5+6+7+8);
    int m2=Max2(1*2*3*4,5+6+7+8);
}
```

## decltype

decltype 与 typeof 功能类似，且都是编译时确定类型的。

decltype 最大的用途就是用在追踪返回类型的函数中。

-   更好确定返回值类型。
-   函数指针写法简单明了。
-   转发函数更加灵活了。

### 标识表达式

> 标识符是由数字，下划线，大小写字母构成的。不能以数字开头。

for example

> `int arr[4];` 那么 arr 是一个标识符表达式，而 `arr[3]+0,arr[3], *arr, &arr` 等，则都不是标识符表达式。`(arr)` 是带括号的标识符表达式。<br>
> 函数 `void func(int)`, `func` 是标识符表达式，而 `func(10)` 不是。

### decltype 推导四项规则

具体地，当程序员用decltype(e)来获取类型时，编译器将依序判断以下四规则：

1.  如果e是一个没有带括号的标识符表达式（id-expression）或者类成员访问表达式，那么decltype(e)就是e所命名的实体的类型。此外，如果e是一个被重载的函数，则会导致编译时错误。
2.  否则，假设e的类型是T，如果e是一个将亡值(xvalue)，那么decltype(e)为T&&。
3.  否则，假设e的类型是T，如果e是一个左值，则decltype(e)为T&。
4.  否则，假设e的类型是T，则decltype(e)为T。（纯右值）

*如果想推导出标识表达式的值类别，用 [`decltype((标识表达式))`](#decltypeValueCategory) 即可。*

decltype 尽量带走 cv 限定符。

for example

```cpp
#include <iostream>

using namespace std;

int gi;

struct C {
    int data;
    static int staticData;
};

int C::staticData;

int&& func1(int) {
    return static_cast<int&&>(gi);
}

int& func2(int) {
    return static_cast<int&>(gi);
}

int func3(int) {
    return static_cast<int&>(gi);
}

void func4(int) {
}

void func4(double) {
}

int main() {
    int a[2];

    // ## 没有括号的标识表达式
    cout << is_same<int, decltype(gi)>::value << endl;

    // ## 没有括号的类成员访问表达式
    C c1;
    C* cptr = &c1;
    cout << is_same<int, decltype(c1.data)>::value << endl;
    cout << is_same<int, decltype(C::staticData)>::value << endl;
    cout << is_same<int, decltype(cptr->data)>::value << endl;
    cout << is_same<int, decltype(cptr->staticData)>::value << endl;

    // ## decltype 与 cv 限定符的类继承
    const C c2 = C();
    // 成员不会继承 cv 限定符。
    // cout << is_same<const int, decltype(c1.data)>::value << endl;
    cout << is_same<int, decltype(c1.data)>::value << endl;

    // ## 数组
    cout << is_same<int[2], decltype(a)>::value << endl;
    // false
    // cout << is_same<int*, decltype(a)>::value << endl;
    cout << is_same<int&, decltype(a[0])>::value << endl;
    cout << is_same<int, decltype(a[0] + 1)>::value << endl;
    cout << is_same<int (*)[2], decltype(&a)>::value << endl;
    cout << is_same<int&, decltype(*a)>::value << endl;

    // 因为重载而 decltype 失败
    // decltype(func4)* func4Ptr;

    // 有括号的标识表达式
    cout << is_same<int (&)[2], decltype((a))>::value << endl;

    // ## 函数
    typedef int&& (Func1Ptr)(int);
    cout << is_same<Func1Ptr, decltype(func1)>::value << endl;
    // false
    // cout << is_same<void (*)(int), decltype(func1)>::value << endl;
    decltype(func1)* func1Ptr1 = func1;
    Func1Ptr* func1Ptr2 = func1;

    cout << is_same<int&&, decltype(func1(10))>::value << endl;
    cout << is_same<int&, decltype(func2(10))>::value << endl;
    cout << is_same<int, decltype(func3(10))>::value << endl;

    // 有括号的标识表达式
    cout << is_same<Func1Ptr&, decltype((func1))>::value << endl;

    // ## const, volatile
    // ### 对象。对于对象类型，const 和 volatile 是冗余的。
    const volatile int cvi = 10;
    decltype(cvi) x1 = 10;
    cout << is_same<const volatile int, decltype(x1)>::value << endl;
    const volatile decltype(cvi) x2 = 10;
    cout << is_same<const volatile int, decltype(x2)>::value << endl;

    // ### 引用。对于引用类型，const, volatile 和 `&` 是冗余的。
    const volatile int& cviR = gi;

    decltype(cviR) z1 = gi;
    cout << is_same<const volatile int&, decltype(z1)>::value << endl;

    // warning。 const, volatile 是冗余的。
    const volatile decltype(cviR) z2 = gi;
    cout << is_same<const volatile int&, decltype(z2)>::value << endl;
    // warning。 const, volatile 是冗余的。
    const volatile decltype(cviR)& z3 = gi;
    cout << is_same<const volatile int&, decltype(z3)>::value << endl;

    // ### 指针。对于指针类型, const, volatile 和 `*` 并不冗余。
    const volatile int* cviPtr = &gi;
    decltype(cviPtr) y1;
    cout << is_same<const volatile int*, decltype(y1)>::value << endl;
    const volatile decltype(cviPtr) y2 = &gi;
    cout << is_same<const volatile int* const volatile, decltype(y2)>::value << endl;
    const volatile decltype(cviPtr)* y3 = &cviPtr;
    cout << is_same<const volatile int* const volatile *, decltype(y3)>::value << endl;

    return 0;
}
```

## 追踪返回类型（auto and decltype）

作用：使用得模板函数的返回类型更加灵活；返回函数指针时，声明更加简洁。

for example

```cpp
// 编译器从左到右读入符号，ta, tb 还没有定义，为解决这个问题，引入新语法，追踪返回值类型。
template<typename Ta, typename Tb>
decltype(ta + tb) func(Ta ta, Tb tb) {
    return ta + tb;
}

// 新语法
template<typename Ta, typename Tb>
auto func(Ta ta, Tb tb) -> decltype(ta + tb){
    return ta + tb;
}
```

返回函数指针

for example

```cpp
#include <iostream>

using namespace std;

// 函数指针作为返回值: <函数指针的返回值> (*<函数名>(<参数列表>))(<函数指针的参数列表>)
auto func1(int) -> char (*)(short);
char (*func2(int)) (short);

// ### 返回一个函数指针 auto (*)(int)，且该函数指针相应的函数是返回一个函数指针 char (*)(short)。
char (*(*func3(double)) (int)) (short);
auto func4(double) -> auto (*)(int) -> char (*)(short);

int main() {
    cout << is_same<decltype(func1), decltype(func2)>::value << endl;
    cout << is_same<decltype(func3), decltype(func4)>::value << endl;
}
```

## constexpr

const 描述的是“运行时常量性”的概念。constexpr 描述的是“编译时期的常量”的概念。

> constexpr 变量是 read-only 的。即拥有 const 属性。
> const 变量不一定是 constexpr。而 `const int i = 10;` 中的 `i` 是 constexpr 的。

使用constexpr声明的数据最常被问起的问题是，下列两条语句有什么区别：

```cpp
const int i=1;
constexpr int j=1;
```

> 事实上，两者在大多数情况下是没有区别的。<br>
> 不过有一点是肯定的，就是如果 i 在全局名字空间中，编译器一定会为 i 产生数据（分配内存）。<br>
> 而对于 j，如果不是有代码显式地使用了它的地址，编译器可以选择不为它生成数据，而仅将其当做编译时期的值（是不是想起了光有名字没有产生数据的枚举值，以及不会产生数据的右值字面常量？事实上，它们也都只是编译时期的常量）。

### constexpr 变量

只能由常量表达式来赋值。

for example

```cpp
#include <iostream>

using namespace std;

int main() {
    const int i1 = 10;
    constexpr int i2 = 10;
    // i1 是常量
    constexpr int i3 = i1;
    // constexpr 也是 const 的
    cout << is_const<remove_reference<decltype(i2)>::type>::value << endl;

    int i4 = 10;
    // i5 不是常量
    const int i5 = i4;
    // constexpr int i6 = i4;
    // constexpr int i7 = i5;
}
```

### constexpr 函数

常量表达式函数的要求非常严格，总结起来，大概有以下几点：

-   函数体只有单一的return返回语句。
-   函数必须有返回值（不能是void函数）。
-   在使用前必须已有定义。
-   return 返回语句表达式中不能使用非常量表达式的函数、全局数据，且必须是一个常量表达式。

constexpr 的实参可以是常量或非常量。当返回的表达式含有形参时，返回值的常量性由实参的常量性决定。

*constexpr 函数都是 inline 的。*

for example

```cpp
#include <iostream>

constexpr int func(int i) {
    return i * i;
}

int main() {
    constexpr int ret1 = func(10);
    int i = 10;
    // 返回值不是常量
    // constexpr int ret2 = func(i);
    constexpr int ret3 = func(func(10));
}
```

返回的表达式的必须是一个常量。当编译器检测返回的表达式的常量性时，会认为 constexpr 形参是常量的。当检测到返回的表达式不是常量时，会报错。

for example

```cpp
#include <iostream>

int gi;

// constexpr int func1() {
//     // 返回的表达式不是常量
//     return gi;
// }

// constexpr int func2(int i) {
//     // error: expression ‘(i = 1)’ is not a constant expression
//     return i = 1;
// }

int main() {
}
```

constexpr 函数只能调用 constexpr 函数。

for example

```cpp
#include <iostream>

int gi;

const int func1() {
    return 1;
}

// // error: call to non-‘constexpr’ function ‘const int func1()’
// constexpr int func2() {
//     return func1();
// }

constexpr int func3(int i) {
    return i * i;
}

constexpr int func4(int i) {
    // error: the value of ‘gi’ is not usable in a constant expression
    // return func3(gi);
    return func3(10);
}

int main() {
}
```

constexpr 函数必须在使用前定义。

for example

```cpp
#include <iostream>

int main() {
    constexpr int func(int);
    // error: ‘constexpr int func(int)’ used before its definition
    // constexpr int ret = func(10);
}

constexpr int func(int i) {
    return i * i;
}
```

### constexpr 对象

constexpr 关键字是不能用于修饰自定义类型的定义的。正确地做法是，定义自定义常量构造函数（可为模板）且非复制或移动构造函数。<br>
当 class 或struct 拥有 constexpr 构造函数时，用该构造函数初始化一个 constexpr 对象，则该对象是 constexpr 的。

常量表达式的构造函数也有使用上的约束，主要的有以下两点：

-   函数体必须为空。
-   初始化列表只能由常量表达式来赋值。

*constexpr 对象的数据成员也是 constexpr 的。*

*在C++11中，不允许常量表达式作用于 virtual 的成员函数。*

*跟常量表达式函数一样，常量表达式构造函数也可以用于非常量表达式中的类型构造，重写了编译器也会报错的。因而，程序员不必为类型再重写一个非常量表达式版本。*

for example

```cpp
struct MyType {
    constexpr MyType(int i) : data(i) { }
    int data;
};

constexpr MyType mt(0);
```

for example

```cpp
#include <iostream>

using namespace std;

struct Date{
    constexpr Date(int y,int m,int d): year(y), month(m), day(d) { }

    // constexpr 成员函数，默认是 const 的，const 关键词可不用写。
    // constexpr int getYear() const {return year;}
    constexpr int getYear() {return year;}
    constexpr int getMonth() {return month;}
    constexpr int getDay() {return day;}

    // ### constexpr, const 对象可调用这样函数，但是返回的值不是常量。
    // int getYear() const {return year;}
    // int getMonth() const {return month;}
    // int getDay() const {return day;}

    // ### 任意属性的对象可调用这样函数，但是返回的值不是常量。
    // int getYear() {return year;}
    // int getMonth() {return month;}
    // int getDay() {return day;}

    void method() const {
        getYear();
    }

private:
    int year;
    int month;
    int day;
};

int main(){
    constexpr Date PRCfound{1949, 10, 1};
    constexpr int foundYear = PRCfound.getYear();
    constexpr int foundMonth = PRCfound.getMonth();
    constexpr int foundDay = PRCfound.getDay();

    // 与 constexpr 类似，可接收非常量的实参，但是返回值不是常量。
    int i = 10;
    Date date{i, i, i};
    int year = date.getYear();
    int month = date.getMonth();
    int day = date.getDay();

    // constexpr 成员函数默认是 const 的。
    const Date cdate{i, i, i};
    year = cdate.getYear();
    cdate.method();
}
```

### constexpr 与模板

当声明为常量表达式的模板函数后，而某个该模板函数的实例化结果不满足常量表达式的需求的话，constexpr 会被自动忽略，这一点与普通的 constexpr 一样。

for example

```cpp
template<typename T>
constexpr T func(T t) {
    return t + t;
}

int main() {
    int iz = 2;
    constexpr int ia = func(10);
    // error: the value of ‘iz’ is not usable in a constant expression
    // constexpr int ib = func(iz);
}
```

## lambda

lambda 的目的是, 更加方便地实现并使用一个函数。

### lambda 实现的原理

ref: [cpp insight](https://cppinsights.io/)

事实上，仿函数（一个类重载了 `operator ()()`）是编译器实现 lambda 的一种方式。在现阶段，通常编译器都会把 lambda 函数转化为一个仿函数对象。因此，在C++11中，lambda 可以视为仿函数的一种等价形式了，或者更动听地说，lambda 是仿函数的“语法甜点”。

lambda 与局部函数

> 注意局部函数（localfunction，即在函数作用域中定义的函数），也称为内嵌函数（nestedfunction）。局部函数通常仅属于其父作用域，能够访问父作用域的变量，且在其父作用域中使用。C/C++语言标准中不允许局部函数存在（不过一些其他语言是允许的，比如FORTRAN），C++11标准却用比较优雅的方式打破了这个规则。因为事实上，lambda可以像局部函数一样使用。
>
> 在现行 C++11 标准中，捕捉列表仅能捕捉父作用域的自动变量，而对超出这个范围的变量，是不能被捕捉的。祖父作用域无法捕捉。

*lambda 类型是 closure 类型。而 closure 类型被定义为特有的（unique）、匿名且非联合体（unnamed nonunion）的 class 类型。*

*每个 lambda 表达式则会产生一个闭包类型的临时对象（右值）。*

*lambda 可隐式转换为函数指针，而函数指针无法转换成 lambda。*

### lambda 的使用

通常情况下，lambda 函数的语法定义如下：

    [<capture>](<parameters>) mutable -> <return-type> {<statement>...}

> lambda 函数还采用了追踪返回类型的方式声明其返回值。
>
> 在 lambda 函数的定义中，参数列表和返还类型都是可选的部分，而捕捉列表和函数体都可能为空。那么在极端情况下，C++11 中最为简略的 lambda 函数只需要声明为 `[]{}`。

#### 捕捉列表 `[capture]`

事实上，[] 是 lambda 引出符。编译器根据该引出符判断接下来的代码是否是 lambda 函数。<br>
捕捉列表能够捕捉上下文中的变量以供lambda函数使用。

语法上，捕捉列表由多个捕捉项组成，并以逗号分割。捕捉列表有如下几种形式：

    [=] 表示值传递方式捕捉所有父作用域的变量（包括this）。
    [&] 表示引用传递捕捉所有父作用域的变量（包括this）。
    [var] 表示值传递方式捕捉变量var。
    [&var] 表示引用传递捕捉变量var。
    [this] 表示值传递方式捕捉当前的this指针。
    [&this]
    [=, &a, &b]
    [&, a, b]
    ...

#### mutable 修饰符

默认情况下，lambda 对象有 `void operator()(<parameters>) const;` 。这表明 lambda 不能修改 lambda 对象的内容。<br>
添加 mutable 之后，lambda 对象的 `operator()` 变为 `void operator()(<parameters>);`。这表明 lambda 可以修改 lambda 对象的内容了。在使用该修饰符时，参数列表不可省略（即使参数为空）。

for example

```cpp
#include <iostream>
int main() {
    int a = 1;
    auto lambda = [=]() mutable { a = 10;};
    lambda();
    std::cout << a << std::endl;        // output: 1
}
```

## function

[function](https://zh.cppreference.com/w/cpp/utility/functional/function)

类模板 std::function 是通用多态函数封装器。std::function 的实例能存储、复制及调用任何可调用 (Callable) 目标——函数、 lambda 表达式、 bind 表达式或其他函数对象，还有指向成员函数指针和指向数据成员指针。

for example

```cpp
#include <iostream>
#include <functional>

using namespace std;

struct Foo {
    Foo(int n) : num(n) {}
    void add(int i) const { cout << num + i << '\n'; }
    int num;
};

void printNum(int i)
{
    cout << i << '\n';
}

struct PrintNum {
    void operator()(int i) const
    {
        cout << i << '\n';
    }
};

int main()
{
    // ### 存储自由函数
    function<void(int)> funcObj1 = printNum;
    funcObj1(10);

    // ### 存储 lambda
    function<void()> funcObj2 = []() { printNum(10); };
    funcObj2();

    // 存储函数对象的调用
    function<void(int)> funcObj = PrintNum();
    funcObj(10);

    // ### 存储成员函数的调用
    function<void(const Foo&, int)> funcObjAdd = &Foo::add;
    const Foo foo(10);
    funcObjAdd(foo, 20);
    // OR
    funcObjAdd(10, 20);

    // ### 存储数据成员访问器的调用
    function<int(Foo const&)> funcObjNum = &Foo::num;
    cout << "num: " << funcObjNum(foo) << '\n';

    // ## bind
    // ### 存储 bind 对象
    function<void()> funcObj3 = bind(printNum, 30);
    funcObj3();

    // ### 存储成员函数及对象的调用
    using placeholders::_1;
    function<void(int)> funcObjObjAdd = bind(&Foo::add, foo, _1);
    funcObjObjAdd(20);

    // ### 存储成员函数和对象指针的调用
    function<void(int)> funcObjPtrAdd = bind(&Foo::add, &foo, _1);
    funcObjPtrAdd(20);
}
```

## nullptr

标准库对 NULL 的定义。CPP 定义为 `0`，C 定义为 `(void*) 0`

```cpp
#undef NULL
#if defined(__cplusplus)
    #define NULL 0
#else
    #define NULL(( void*) 0)
#endif
```

### NULL 存在的问题

#### Cpp 的 NULL 问题

在 C++ 中，“整数值 0 到指针类型的转换和任何类型的指针到类型 `void*` 的转换（`void*` 到任何类型的指针的转换，要显式转换）”是标准转换。


问题

```cpp
#include <iostream>

void func(char* c) {
    std::cout << "func_char" << std::endl;
}
void func(int i) {
    std::cout << "func_int" << std::endl;
}

int main() {
    // 调用 func(int)
    func(0);
    // error: call of overloaded ‘func(NULL)’ is ambiguous
    // 如果没有过多的处理会是 `func(0)`
    // func(NULL);
    func((char*)0);

}
```

> 为了避免用户使用上的错误，有的编译器做了比较激进的改进。典型的如g++编译器，它直接将NULL转换为编译器内部标识（`__null`），并在编译时期做了一些分析，一旦遇到二义性就停止编译并向用户报告错误。虽然这在一定程度上缓解了二义性带来的麻烦，但由于标准并没有认定NULL为一个编译时期的标识，所以也会带来代码移植性的限制。

```cpp
int* ipa = NULL;
int* ipb = 0;

// `int*` 转换到 `void*` 是标准转换。
void* ipc = ipa;

// error: invalid conversion from ‘void*’ to ‘int*’ [-fpermissive]
// 由于 `void*` 直接赋值给 `int*` 不是很安全，CPP 不允许这样的行为，可见将 NULL 定义为 `(void*) 0` 不是那么完美。
// int* ipa = ipc;
```

#### C 语言的 NULL 问题

在 C 中，`void*` 与任意类型的指针可相互转换。`0` 可转换为任意类型的指针。

因为没有函数重载，所以 C 的 NULL（`void*`） 没有什么问题。

for example

```cpp
// ok
int* ipa = NULL;
// ### `0` 可用于赋值 `int*`, 而 `1` 则警告。
ipa = 0;
// warning: initialization of ‘int *’ from ‘int’ makes pointer from integer without a cast
// ipa = 1;

// ### void*, int* 之间可相互赋值而没有警告
void* ipb = ipa;
ipa = ipb;
```

### nullptr_t 类型

nullptr 的类型是 `nullptr_t`

C++11 标准严格规定了 `nullptr_t` 与其他数据间的关系。大体上常见的规则简单地列在了下面：

1.  所有定义为 `nullptr_t` 类型的数据都是等价的，行为也是完全一致。
2.  `nullptr_t` 类型数据可以隐式转换成任意一个指针类型。
3.  `nullptr_t` 类型数据不能转换为非指针类型，即使使用 `reinterpret_cast<nullptr_t>()` 的方式也是不可以的。
4.  `nullptr_t` 类型数据不适用于算术运算表达式。
5.  `nullptr_t` 类型数据可以用于关系运算表达式，但仅能与 `nullptr_t` 类型数据或者指针类型数据进行比较，当且仅当关系运算符为 ==、<=、>= 等时返回 true。

nullptr 虽说是一个对象，但是不能对它取址，因为这样做没有什么意义，且它是一个右值，可被引用到右值引用。可利用右值引用对它取址，即使是无意义的。

for example: nullptr 的使用

```cpp
int main() {
    int* ipa = nullptr;
    if (ipa == nullptr) { }
    if (ipa != nullptr) { }
}
```

### nullptr 的模板类型推导（nullptr 被当作一种非指针类型）

for example

```cpp
template<typename T>
void funcA(T t) {
}

template<typename T>
void funcB(T* t) {
}

int main() {
    funcA(nullptr);         // T = nullptr_t
    funcA((int*)nullptr);   // T = int*

    // error: no matching function for call to ‘funcB(std::nullptr_t)’
    // funcB(nullptr);
    funcB((int*)nullptr);   // T = int

    return 0;
}
```

### `nullptr_t` 不能接收除了 `nullptr_t` 类型之外的数据类型

for example

```cpp
nullptr_t pa;
int* ip = pa;
// cannot convert ‘int*’ to ‘nullptr_t’ {aka ‘std::nullptr_t’} in assignment
// pb = ip;

void* vp = pa;
// cannot convert ‘void*’ to ‘nullptr_t’ {aka ‘std::nullptr_t’} in assignment
pa = vp;
```

## 智能指针

-   `auto_ptr`, `unique_ptr`

    使得一个资源只被一个 `auto_ptr / unique_ptr` 绑定。

-   `shared_ptr`

    使得一个资源可被多个 `shared_ptr` 绑定。

-   `weak_ptr`

    解决 `shared_ptr` 导致环状引用的问题。

`auto_ptr`, `unique_ptr`, `shared_ptr` 都是用普通构造函数取得资源的初始控制权。<br>
它们的普通构造函数都是 explicit 的，所以不支持隐式转换。

`auto_ptr / unique_ptr` 都是用复制构造函数和移动赋值函数转移资源的控制权。<br>
`shared_ptr` 用复制构造函数和赋值函数（非移动）共享资源。

### `auto_ptr`, `unique_ptr`

`auto_ptr`, `unique_ptr` 自动销毁时，会自动删除它所指之物，所以不要让多个 `auto_ptr`, `unique_ptr` 同时指向同一个对象。为了预防这个情况，通过 copy 构造函数或 copy assignment 操作操作符复制它时，它会变成 null。

*它们调用的是 delete, 而不是 delete[], 所以不能指向数组。代替方案是用 vector, string 代替数组。*

*C++11 已弃用 `auto_ptr`, 引入 `unique_ptr` 代替。`unique_ptr` 继承 `auto_ptr`, 并且更不容易出错。<br>
`auto_ptr` 用 copy 转移资源，而 `unique_ptr` 用 move 转移资源。这是 `auto_ptr` 弃用的原因。*

for example: 基本使用

```cpp
#include <iostream>
#include <memory>

using namespace std;

class Foo {
public:
    Foo(int i) : i(i) {}
    ~Foo() {
        cout << "~Foo(): i = " << i << endl;
    }
private:
    int i;
};

int main() {
    // ## unique_ptr
    // error. 不支持隐式转换
    //unique_ptr<Foo> fooPtr1 = new Foo(1);
    unique_ptr<Foo> fooPtr1(new Foo(1));

    // ### 通过复制构造的方式绑定资源
    unique_ptr<Foo> fooPtr2(move(fooPtr1));         // fooPtr1 = nullptr

    // ### 通过赋值的方式绑定资源
    unique_ptr<Foo> fooPtr3(new Foo(2));
    fooPtr2 = move(fooPtr3);                        // fooPtr3 = nullptr; fooPtr2 原来的资源会被释放。

    // ## auto_ptr
    // error. 不支持隐式转换
    //auto_ptr<Foo> fooAutoPtr1 = new Foo(10);
    auto_ptr<Foo> fooAutoPtr1(new Foo(10));

    // ### 通过复制构造的方式绑定资源
    auto_ptr<Foo> fooAutoPtr2(fooAutoPtr1);         // fooAutoPtr2 = nullptr

    // ### 通过赋值的方式绑定资源
    auto_ptr<Foo> fooAutoPtr3(new Foo(11));
    fooAutoPtr2 = fooAutoPtr3;                      // fooAutoPtr3 = nullptr; fooAutoPtr2 原来的资源会被释放。

    cout << "main end\n";
}
```

### `shared_ptr`

多个 `shared_ptr` 可指向同一个对象，并且最后一个 `shared_ptr` 会自动销毁它。

for example: 基本使用

```cpp
#include <iostream>
#include <memory>

using namespace std;

class Foo {
public:
    Foo(int i) : i(i) {}
    ~Foo() {
        cout << "~Foo(): i = " << i << endl;
    }
private:
    int i;
};

int main() {
    // error. 不支持隐式转换
     //shared_ptr<Foo> fooPtr1 = new Foo();
    shared_ptr<Foo> fooPtr1(new Foo(1));

    // ### 通过复制构造的方式共享资源
    shared_ptr<Foo> fooPtr2(fooPtr1);

    // ### 通过赋值的方式共享资源
    shared_ptr<Foo> fooPtr3(new Foo(2));
    cout << "fooPtr1 use count: " << fooPtr1.use_count() << endl;
    fooPtr2 = fooPtr3;          // fooPtr2 原来的资源的引用数会减 1。
    cout << "fooPtr1 use count: " << fooPtr1.use_count() << endl;

    // ### move
    auto fooPtr10 = make_shared<Foo>(10);
    shared_ptr<Foo> fooPtr11(move(fooPtr10));       // fooPtr10 = nullptr
    cout << "fooPtr10 use count: " << fooPtr10.use_count() << endl;

    auto fooPtr12 = make_shared<Foo>(11);
    fooPtr11 = move(fooPtr12);
    cout << "fooPtr12 use count: " << fooPtr12.use_count() << endl;

    cout << "main end.\n";
}
```

当已有一个的 `shared_ptr` 指向一个对象时，要再创建一个 `shared_ptr` 指向同一对象时，应该通过复制构造或赋值的方式共享资源，而不是通过构造函数（不包含复制构造函数）。

for example

```cpp
int* iPtr = new int();

// iPtr 会被销毁两次
std::shared_ptr<int> iPtrA(iPtr);
std::shared_ptr<int> iPtrB (iPtr);
```

亡值 unique_ptr 可用于初始化/赋值 shared_ptr。

for example

```cpp
#include <iostream>
#include <memory>

using namespace std;

class Foo {
public:
    Foo(int i) : i(i) {}
    ~Foo() {
        cout << "~Foo(): i = " << i << endl;
    }
private:
    int i;
};

int main() {
    auto fooUPtr1 = make_unique<Foo>(1);
    shared_ptr<Foo> fooSPtr1(move(fooUPtr1));

    auto fooUPtr2 = make_unique<Foo>(2);
    fooSPtr1 = move(fooUPtr2);
}
```

### `weak_ptr`

`shared_ptr` 导致环状引用的问题，所以引入 `weak_ptr` 解决这个问题。将环状中的其中一个 `shared_ptr` 换成 `weak_ptr` 即可。

`weak_ptr` 表示“共享但不拥有”。

通过 `weak_ptr` 访问对象

> `weak_ptr` 并不能直接访问数据，因为它没有增加 `shared_ptr` 的对对象的引用数，所以对象随时都可能会被销毁。
>
> 但是可通过 lock() 或用 `weak_ptr` 复制构造/赋值一个 `shared_ptr` 来访问对象。如果对象已销毁，前者不会抛出异常，后者会抛出 `bad_weak_ptr` 异常。<br>
> 若对象没有销毁， std::`weak_ptr`::lock 则创建 `shared_ptr`（指向对象） 并返回。否则返回用默认构造函数初始化的 `shared_ptr`。这时 `bool(shared_ptr)` 为 `false`。

for example: `weak_ptr` 的基本使用

```cpp
#include <iostream>
#include <memory>

void testWeakPtr() {
    std::shared_ptr<int> sPtr(new int());
    std::weak_ptr<int> wPtr = sPtr;

    std::cout << wPtr.use_count() << std::endl;
    std::cout << wPtr.expired() << std::endl;

    sPtr.reset();

    std::cout << wPtr.use_count() << std::endl;
    std::cout << wPtr.expired() << std::endl;

    if (std::shared_ptr<int> tempSPtr = wPtr.lock()) {
        std::cout << *tempSPtr << std::endl;
    } else {
        std::cout << "unable to lock weak_ptr\n";
    }

    try {
        std::shared_ptr<int> sPtrB(wPtr);
    } catch (const std::exception& e) {
        std::cerr << "exception: " << e.what() << std::endl;
    }
}

int main() {
    testWeakPtr();
    return 0;
}
```

for example

```cpp
// ### 问题
class Node {
    std::shared_ptr<Node> prev;
    std::shared_ptr<Node> next;
};

// ### 解决
class Node {
    std::shared_ptr<Node> prev;
    std::weak_ptr<Node> next;
};
```

## using

在 C++11 中，using 关键字的能力已经包括了 typedef 的部分。

```cpp
#include <iostream>
#include <map>

using Type = int;
template<typename T>
using Map = std::map<T, T>;

int main() {
    Type i = 100;
    Map<int> m{{10, 100}};
}
```

## 变长模板

### C 的 `va_list`

for example

```c
#include <stdio.h>
#include <stdarg.h>

double sumOfFloat(int count, ...) {
    va_list ap;
    double sum = 0;
    va_start(ap,count);             //获得变长列表的句柄ap
    for(int i = 0; i < count; i++) {
        sum += va_arg(ap, double);     //每次获得一个参数
    }
    va_end(ap);
    return sum;
}
int main(){
    printf("%f\n",sumOfFloat(3,1.2f,3.4,5.6));      //10.200000
}
```

### CPP 可用 tuple 代替变长参数，但参数数量有限。

for example

```cpp
std::tuple<double,char,std::string> collections = std::make_tuple(9.8,'g',"gravity");
```

> 注意 在C++98中，由于没有变长模板，tuple能够支持的模板参数数量实际上是有限的。这个数量是由标准库定义了多少个不同参数版本的tuple模板而决定的。
>
> 而 C++11 引入变长模板，因此 tuple 包含的类型的数量可以任意多。 `template<typename...Elements> class tuple;`。

### 模板参数包

```cpp
template<typename T, typename... Args>
void funcUtil(T t, Args... args) {
}

template<typename... Args>
void func(Args... args) {
    funcUtil(args...);
}

```

在 C++11 中，Args 被称作是一个“模板参数包”（template parameter pack），而 args... 则被称为包扩展（pack expansion）。直观地看，参数包会在包扩展的位置展开为多个参数。

使用说明

> 声明一个”模板参数包”: `typename... Args, Args... args` OR `typename ...Args, Args ...args`。<br>
> 展开“参数包”：`args...`。

手动解包。程序在应用上没有意义。

```cpp
#include <iostream>

using namespace std;

template<typename T>
void funcUtil3(T t) {
    cout << t << endl;
}

template<typename T, typename... Args>
void funcUtil2(T t, Args... args) {
    cout << t << '\t';
    funcUtil3(args...);
}

template<typename T, typename... Args>
void funcUtil1(T t, Args... args) {
    cout << t << '\t';
    funcUtil2(args...);
}

template<typename... Args>
void func(Args... args) {
    funcUtil1(args...);
}

int main() {
    func('A', 1, 0.1);
}
```

函数模板递归实例化解包

```cpp
#include <iostream>

using namespace std;

template<typename T>
void printUtil(T value) {
    cout << value << endl;
}

template<typename T, typename... Args>
void printUtil(T value, Args... args) {
    cout << value << '\t';
    printUtil(args...);
}

template<typename... Args>
void print(const Args... args) {
    printUtil(args...);
}

int main() {
    print('A', 1, 0.1);
}
```

与函数模板递归实例化解包类似，用类模板递归实例化解包

```cpp
#include <iostream>

using namespace std;

template<long... nums> struct Printer;

// ### 模板偏特化
// #### 实例化时，会递归生成这些版本
// typename<long first, long second, long third, long fourth, ...>
// typename<long first, long second, long third, long fourth, ...>
// typename<long first, long third, long fourth, ...>
// ...
// typename<long first>     // 因为模板参数包可以为空。
template<long first, long... last>
struct Printer<first, last...> {
    void print() {
        cout << first << '\t';

        // 递归实例化（last 可为空）
        Printer<last...> printer;
        printer.print();
    }
};

// ### 偏特化边界条件
template<>
struct Printer<> {
    void print() {
        cout << endl;
    }
};

int main() {
    Printer<2, 3, 4, 5> printer;
    printer.print();
    return 0;
}
```

打印任何大小的 tuple

```cpp
#include <iostream>
#include <tuple>
#include <string>

// 打印任何大小 tuple 的帮助函数
template<class Tuple, std::size_t N>
struct TuplePrinter {
    static void print(const Tuple& t)
    {
        // 递归实例化
        TuplePrinter<Tuple, N-1>::print(t);
        std::cout << ", " << std::get<N-1>(t);
    }
};

// 定义边界
template<class Tuple>
struct TuplePrinter<Tuple, 1> {
    static void print(const Tuple& t)
    {
        std::cout << std::get<0>(t);
    }
};

template<class... Args>
void print(const std::tuple<Args...>& t) {
    std::cout << "(";
    TuplePrinter<decltype(t), sizeof...(Args)>::print(t);
    std::cout << ")\n";
}
// 结束帮助函数

int main() {
    std::tuple<int, std::string, float> t1(10, "Test", 3.14);
    print(t1);
}
```

实现类似 c 的 printf

for example

```cpp
// ## 用法
// `%s` 代替一个数据，而非字符串。如果不是基础类型，而调用 `<非基础类型>::operator<<(const ostream& os)`

#include <iostream>
#include <stdexcept>

using namespace std;

// ### myPrintf 可以不指定 format 只输出字符串
void myPrintf(const char* formatStr) {
    while(*formatStr != '\0') {
        if(*formatStr == '%') {
            switch (*(++formatStr)) {
                case '%':
                    cout << '%';
                    break;
                case 's':
                    // args 过少
                    throw runtime_error("invalid format string:missing arguments");
                    break;
                default:
                    throw runtime_error("invalid format");
            }
            // 跳过 % 之后的字符
            ++formatStr;
        } else {
            cout << *(formatStr++);
        }
    }
}

// ### 实例化时，会递归生成这些版本
// typename<typename T, typename T1, typename T2, typename T3, ...>
// typename<typename T, typename T2, typename T3, ...>
// ...
// typename<typename T>     // 因为模板参数包可以为空。
template<typename T, typename... Args>
void myPrintf(const char* formatStr, T value, Args... args) {
    while (*formatStr != '\0') {
        if(*formatStr == '%') {
            switch (*(++formatStr)) {
                case 's':
                    cout << value;
                    return myPrintf(++formatStr, args...);
                    break;
                case '%':
                    cout << '%';
                    break;
                default:
                    // 目前只支持 `%s / %%`
                    throw runtime_error("invalid format");
            }
            // 跳过 % 之后的字符
            ++formatStr;
        } else {
            cout << *(formatStr++);
        }
    }

    // 根据实例化结果可知，args 过多时才会调用。这与普通函数的思维不一样。
    throw runtime_error("extra arguments provided to myPrintf");
}

struct C {
    C(int i) : data(i) { }
    friend ostream& operator<<(ostream& os, const C& c) {
        os << c.data;
        return os;
    }

    int data;
};

int main(){
    C c1(20);
    myPrintf("hello %s %s. %s %% %s\n", "Johan", "Chane", 10, c1);
}
```

## export/extern 模板

export/extern 模板

> export 作用是实现模板的声明与定义分离。c++11 已弃用该关键字。<br>
> 关键字 export 告诉编译器在生成被其他文件使用的函数模板实例时可能需要这个模板定义。所以编译器知道该模板的定义（而不是模板的实例化）。
>
> extern 作用是解决模板实例化重复的问题。因为模板实例化只在本模块中寻找，所以不同的模块会存在相同的模板实例化，虽然在链接时会去重，但编译器工作量大。<br>
> 关键字 extern 告诉编译器该模板实例化（而不是模板的定义）存在于别的模块中，不要在本模板中实例化，而是去别的模块找。

for example: export

```cpp
// ### model.h
template<typename T>
void templateFunc(T t);

// ### model.cpp
#include <iostream>
export template<typename T>
void templateFunc(T t) {
    std::cout << t << std::endl;
}

// ### main.cpp
#include <iostream>
#include "model.h"

int main() {
    templateFunc(10);
    return 0;
}
```

for example: extern

```cpp
// model.h
template<typename T>
void templateFunc(T t) {
    std::cout << t << std::endl;
}

// model.cpp
#include <iostream>
#include "model.h"
template void templateFunc<int>(int);

// main.cpp
#include <iostream>
#include "model.h"
extern template void templateFunc<int>(int);

int main() {
    templateFunc(10);
    return 0;
}
```
