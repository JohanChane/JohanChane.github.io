# Python 与 C/C++ 相互调用

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

## Python 调用 C/C++

for example: ctype

```
# ## python 调用 C
```

```c
# ### pycallc.c
/* gcc -o libpycallc.so -shared -fPIC pycallc.c */

long add(long a, long b) {
    return a + b;
}
```

```python
# ### pycallc.py
import ctypes

loadLibrary = ctypes.cdll.LoadLibrary
libpycallc = loadLibrary("./libpycallc.so")
print('sum = {}'.format(libpycallc.add(1, 2)))
```

```
# ## python 调用 C++
```

```cpp
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
```

```python
# ### pycallcpp.py
import ctypes

loadLibrary = ctypes.cdll.LoadLibrary
libpycallcpp = loadLibrary("./libpycallcpp.so")
print("sum = {}".format(libpycallcpp.add(1, 2)))
```

### 用 C/C++ 扩展 Python

#### 用 C/C++ 扩展 Python 的函数

用 C/C++ 实现一个函数，然后在 Python 中调用这个函数。

[*CPython 用 C 添加 builtin 函数 print。(搜索 `builtin_print`)*](https://github.com/python/cpython/blob/master/Python/bltinmodule.c)

for example

```
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
```

```c
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
```

```python
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
```

```python
# ## test.py

#!/usr/bin/python3

// ### 测试 module
import cext

print("sum = {}".format(cext.add(1, 2)))
```

#### 用 C/C++ 扩展 Python 的类型

[用 C/C++ 扩展 Python 的类型](https://docs.python.org/zh-cn/3/extending/newtypes_tutorial.html)

用 C/C++ 实现一个 Python 类型。

[*CPython 用 C 添加 builtin 类型(搜索 `INIT_TYPE(`)*](https://github.com/python/cpython/blob/master/Objects/object.c)

for example

```
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
```

```c
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
```

```c
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
```

```python
# ## setup.py

from distutils.core import setup, Extension
setup(name="custom", version="1.0",
    ext_modules=[
        Extension("custom", ["custom.c"]),
        Extension("custom2", ["custom2.c"]),
        ])
```

```python
# ## test.py

import custom
import custom2

mycustom = custom.Custom()

mycustom2 = custom2.Custom('myfirst', 'mylast')

print(dir(mycustom2))
print(mycustom2.first)
print(mycustom2.last)
print(mycustom2.name())
```

## C/C++调用 Python

for exmple: 通过 Python C/C++ API 调用 C/C++ 函数

```python
# ## ccallpy.py
def add(a, b):
    return a + b
```

```c
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
```
