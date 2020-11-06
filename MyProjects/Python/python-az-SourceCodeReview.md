# CPython Source Code Review


### Refers

- <https://docs.python.org/zh-cn/3/reference/introduction.html#alternate-implementations>

- <https://github.com/python/cpython>


### 基本概念

- PyTypeObject 是 Python 对象的类型。PyTypeObject.tp_members（类型是 PyMemberDef）存放类型的成员, PyTypeObject.tp_methods（类型是 PyMethodDef）存放类型的方法。

- Python modules 的类型是 PyModuleDef。

### 下载 CPython 源代码

    cd /usr/local/src/
    git clone https://github.com/python/cpython.git

### CPython 源代码目录结构

查看各目录的 README 文件

    find /usr/local/src/cpython-master/ | grep -i 'readme'

CPython 源代码目录结构

- Objects
    
    Source files for various builtin objects

- Modules

    Source files for standard library extension modules, and former extension modules that are now builtin modules.

- Python

    Miscellaneous source files for the main Python shared library

- Programs

    Source files for binary executables (as opposed to shared modules)

    所有平台都转向了 pymain_main 函数。

- Include

    有 `Python.h`

### Others

#### 查看 builtin 类型的实现

    grep -i 'INIT_TYPE(' /usr/local/src/cpython-master/Objects/object.c

#### 查看 builtin 函数 print 的实现

     grep -i 'builtin_print' /usr/local/src/cpython-master/Python/bltinmodule.c

#### Python 程序的入口

     grep -i 'main(' /usr/local/src/cpython-master/Programs/python.c
