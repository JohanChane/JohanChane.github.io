+++
title = "Cpp 单例模式的线程安全的探讨"
date = "2024-03-03"
categories = ["设计模式"]
tags = ["cpp", "单例模式", "线程安全"]
+++

## 预备知识

### 静态变量的构造和析构顺序

See [Destruction order of static objects in C++](https://stackoverflow.com/a/469653/10498412)

静态变量之间的构造顺序是不确定的。但是可以通过 global-static 的方式手动的控制它们的构造顺序:

for example:

file_system.cc:

```cpp
#include <iostream>

class FileSystem {
public:
  FileSystem() {
    std::cout << "FileSystem()" << std::endl;
  }
  ~FileSystem() {
    std::cout << "~FileSystem()" << std::endl;
  }
};

FileSystem& tfs() {
  static FileSystem fs;
  return fs;
}
```

directory.cc:

```cpp
#include <iostream>

class Directory {
public:
  Directory() {
    std::cout << "Directory()" << std::endl;
  }
  ~Directory() {
    std::cout << "~Directory()" << std::endl;
  }
};

Directory& tdir() {
  static Directory dir;
  return dir;
}
```

main.cc:

```cpp
#include <iostream>

class FileSystem {};
class Directory {};
extern FileSystem& tfs();
extern Directory& tdir();

int main() {
  tdir();
  tfs();

  std::cout << "main end" << std::endl;
  return 0;
}
```

静态变量的析构顺序是和构造顺序顺序相反的。比如:

```cpp
int main() {
  tfs();
  tdir();

  std::cout << "main end" << std::endl;
  return 0;
}
```

### 静态变量的初始化

静态变量的初始化是否是线程安全的，是由编译器决定的:
-   VS2013 中不是线程安全的, VS2014 是线程安全的。See [ref](https://stackoverflow.com/a/19907903/10498412)。
-   C++11 之后的标准是线程安全的。

在C中，静态变量的初始化器必须是常量，在C++中，引入了类, 静态变量可以用非常量初始化, 所以要解决静态变量不使用常量初始化的问题。那么 C++ 是如何保证静态变量的初始化语义(只初始化一次)的呢:

for example:

```cpp
struct Foo {
  Foo() {
    abcdefg = 12345678;
  }
  int abcdefg;

  Foo& operator+(int i) {
    abcdefg += i;
    return *this;
  }
};

Foo& get_instance() {
  static Foo local_static_var = Foo() + 1 + 2 + 3;
  return local_static_var;
}

int main() {
  auto v = get_instance();

  return 0;
}
```

```sh
g++ -S main.cc -std=c++17
cat main.s | c++filt
```

```gas
get_instance():
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax

    // 判断 local_static_var 是否已经被初始化
	movzbl	guard variable for get_instance()::local_static_var(%rip), %eax
	testb	%al, %al
	sete	%al
	testb	%al, %al
	je	.L5         // 如果初始化了, 跳到 .L5

    // 调用加锁函数
	leaq	guard variable for get_instance()::local_static_var(%rip), %rax
	movq	%rax, %rdi
	call	__cxa_guard_acquire@PLT

    // 判断 `__cxa_guard_acquire@PLT` 的返回值, 判断 local_static_var 是否已经被初始化?
	testl	%eax, %eax
	setne	%al
	testb	%al, %al
	je	.L5

    // Foo() + 1 + 2 + 3
	leaq	-12(%rbp), %rax
	movq	%rax, %rdi
	call	Foo::Foo()
	leaq	-12(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	Foo::operator+(int)
	movl	$2, %esi
	movq	%rax, %rdi
	call	Foo::operator+(int)
	movl	$3, %esi
	movq	%rax, %rdi
	call	Foo::operator+(int)
	movl	(%rax), %eax
	movl	%eax, get_instance()::local_static_var(%rip)

    // 调用解锁函数
	leaq	guard variable for get_instance()::local_static_var(%rip), %rax
	movq	%rax, %rdi
	call	__cxa_guard_release@PLT
.L5:
    // 返回 local_static_var
	leaq	get_instance()::local_static_var(%rip), %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L7
	call	__stack_chk_fail@PLT
```

从上可知, 是对 `Foo() + 1 + 2 + 3` 加锁保护初始化的, 而不是只对静态变量的内存加锁保护。

### main 结束之后, 什么时候回收静态变量?

静态变量是属于进程的。进程结束时会调用 `exit()`, 静态变量会被回收。

如果 main 结束之后, 如果还有 detach 线程, 则不同的操作系统会有不同的处理。有些调用 exit, detach 线程会退出。有些调用 pthread_exit, 会等待 detach 线程结束。[ref](https://stackoverflow.com/questions/19744250/what-happens-to-a-detached-thread-when-main-exits)

"Unix/Linux系统编程手册"一书的说法: 其他线程调用了 `exit()`，或是主线程执行 `return` 语句(return 之后会调用 exit)时，即便遭到分离的线程也还是会受到影响。此时，不管线程处于可连接状态还是已分离状态，进程的所有线程会立即终止。

Linux/Unix 系统: 进程 exit 的过程, 个人猜测应该会保证所有线程 exit 之后, 才回收静态变量。这样能保证线程可以安全地使用进程的静态变量。

## 各种实现版本

Scott Meyers 优雅的单例模式 (懒汉模式):

<a name="scott_meyers_singleton"></a>
```cpp
Foo& getInst() {
  static Foo inst(...);         // 从"静态变量的初始化"可知, 进入 static 语句和退出 static 语句是加锁保护的, 所以是线程安全的。
  return inst;
}
```

unique_ptr 版本:

<a name="unique_ptr_singleton"></a>
```cpp
struct Singleton {
  static Singleton* get_instance() {
    static auto inst = make_unique<Singleton>();
    return inst.get();
  }
};
```
如果静态变量的初始化是线程安全的，那么这个实现是线程安全的。如果单例对象和其他静态对象有关联, 返回指针则会出现析构顺序的问题:

```cpp
#include <vector>
#include <iostream>
#include <memory>

class FileSystem {
public:
  FileSystem() {
    std::cout << "FileSystem" << std::endl;
  }
  ~FileSystem() {
    std::cout << "~FileSystem" << std::endl;
  }

  static FileSystem* get_instance() {

    static auto inst = std::make_unique<FileSystem>();
    return inst.get();
  }

  void close_files() {
    for (const auto& f : m_files) {
      std::cout << f << std::endl;
    }
  }

private:
  std::vector<std::string> m_files;
};

class Diretory {
public:
  ~Diretory() {
    std::cout << "~Diretory" << std::endl;
    close_files();
  }

  static Diretory* get_instance() {
    static auto inst = std::make_unique<Diretory>();
    return inst.get();
  }

  void close_files() {
    FileSystem::get_instance()->close_files();
  }
};

int main() {
  Diretory::get_instance()->close_files();

  return 0;
}
```

Directory 对象先构造, 然后是 FileSystem 对象。main 函数结束后, FileSystem 对象先析构，然后是 Diretory 对象。但是 Directory 的析构函数调用 close_files, close_files 调用 `FileSystem::get_instance()`, 但是这时 main 已经结束了, 系统开始回收进程的资源, 这时再在静态区创建对象, 会出现问题。为了解决这个问题, 返回 shared_ptr 即可: [ref](https://stackoverflow.com/a/40337728/10498412):

<a name="shared_ptr_singleton"></a>
```cpp

#include <vector>
#include <iostream>
#include <memory>

class FileSystem {
public:
  FileSystem() {
    std::cout << "FileSystem" << std::endl;
  }
  ~FileSystem() {
    std::cout << "~FileSystem" << std::endl;
  }

  static std::shared_ptr<FileSystem> get_instance() {

    static auto inst = std::make_shared<FileSystem>();
    return inst;
  }

  void close_files() {
    for (const auto& f : m_files) {
      std::cout << f << std::endl;
    }
  }

private:
  std::vector<std::string> m_files;
};

class Diretory {
public:
  ~Diretory() {
    std::cout << "~Diretory" << std::endl;
    close_files();
  }

  static Diretory* get_instance() {
    static auto inst = std::make_unique<Diretory>();
    return inst.get();
  }

  void init() {
    m_fs = FileSystem::get_instance();
  }

  void close_files() {
    FileSystem::get_instance()->close_files();
  }

private:
  std::shared_ptr<FileSystem> m_fs;
};

int main() {
  Diretory::get_instance()->init();

  Diretory::get_instance()->close_files();

  return 0;
}
```

单例模式的 `get_instance` 是很可能是调用比较频繁的, get_instance 返回会构造 shared_ptr, 而 shared_ptr 是线程安全的, 所以会有一点性能损耗。

C++11 提供中的 std::call_once: 如果使用 pthread 则使用 pthread_once。

<a name="call_once_singleton"></a>
```cpp

#include <thread>
#include <vector>
#include <iostream>
#include <mutex>

class Singleton {
public:
  static Singleton* get_instance() {
    std::call_once(m_once_flag, []() {
        m_instance.reset(new Singleton());
    });

    return m_instance.get();
  }

private:
  static std::once_flag m_once_flag;
  static std::unique_ptr<Singleton> m_instance;
};

std::once_flag Singleton::m_once_flag;
std::unique_ptr<Singleton> Singleton::m_instance = nullptr;

int main() {
  std::vector<std::thread> v;
  for (int i = 0; i < 100; i++) {
    v.emplace_back([](){
        auto inst = Singleton::get_instance();
        if (!inst) {
          std::cerr << "inst is nullptr" << std::endl;
        }
      });
  }

  for (auto& e : v) {
    e.join();
  }

  return 0;
}
```

如果有关联其他静态变量，get_instance 返回 shared_ptr 即可。

如果是静态变量的初始化是线程安全的编译标准, 该选择哪个实现版本? 最安全不一定是最适合的, 我要依据自己的情况来选择合适的版本:
-   Scott Meyers 优雅的单例模式是可以解决大多数情况的。如果该静态变量不关联其他静态变量, 选择该版本即可。同时 `get_instance` 是比较频繁的, 返回指针效率是比较高的。[link](#scott_meyers_singleton)
-   如果该单例不关联其他静态变量, 选择 unique_ptr 版本即可。[link](#unique_ptr_singleton)
-   如果该单例关联其他静态变量, 选择 sharded_ptr 版本即可。[link](#shared_ptr_singleton)
-   如果想要用 call_once, 选择 call_once 版本即可。[link](#call_once_singleton)

原子操作的版本:

```cpp
class singleton {
public:
    static singleton* instance() 
    {
        singleton* ptr = inst_ptr_.load(std::memory_order_acquire);     // 1
        if (inst_ptr_ == nullptr)
        {
            std::lock_guard<std::mutex> lk(mutex_);
            ptr = inst_ptr_.load(std::memory_order_relaxed);            // 2
            if (inst_ptr_ == nullptr) {
                ptr = new singleton();                                  // 4
                inst_ptr_.store(ptr, std::memory_order_release);        // 3
            }
        }
        return ptr;
    }
private:
    singleton() {}
    singleton(const singleton&) {}
    singleton& operator = (const singleton&);
private:
    static std::atomic<singleton*> inst_ptr_;
    static std::mutex mutex_;
};

std::atomic<singleton*> singleton::inst_ptr_;
std::mutex singleton::mutex_;
```

是线程安全的。我觉得 1, 3 可以改为 memory_order_relaxed。因为 3 依赖 4, 指令重排后, 4 是保证先序于 3 的, 且没有其他各个线程共享的内存需要修改, 所以就不需要用 release-acquire 同步修改。同时 mutex/sem 之类的同步原语会使用内存屏障同步修改。See [ref](https://en.wikipedia.org/wiki/Memory_barrier#Multithreaded_programming_and_memory_visibility)。

## References
-   [How do you implement a singleton efficiently and thread-safely?](https://stackoverflow.com/questions/2576022/how-do-you-implement-a-singleton-efficiently-and-thread-safely)
-   [How do you implement the Singleton design pattern?](https://stackoverflow.com/questions/1008019/how-do-you-implement-the-singleton-design-pattern)
-   Effective C++
-   [Thread-Safe Initialization of Data](http://www.modernescpp.com/index.php/thread-safe-initialization-of-data/)
-   [C++多线程如何获取真正安全的单例](https://cloud.tencent.com/developer/article/1606879)

上述不正确之处, 欢迎指出。
