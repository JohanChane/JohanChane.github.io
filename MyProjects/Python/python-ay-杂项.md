# Python 的杂项

## Python 编码风格

### References

-   [Python风格规范— Google 开源项目风格指南](https://zh-google-styleguide.readthedocs.io/en/latest/google-python-styleguide/python_style_rules/)
-   [Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/)

### 命名约定

[Python之父Guido推荐的规范](https://zh-google-styleguide.readthedocs.io/en/latest/google-python-styleguide/python_style_rules/#id16)

> Classes, Exceptions 应该用驼峰命名法，且首字母大写。<br>
> `Global/Class Constants` 全是大写，用下划线分隔单词。`Global/Class Variables` 全是小写，用下划线分隔单词。<br>
> 其他全是小写，用下划线分隔单词。<br>
> 如果是模块内部的，则用一个下划线作为前缀。

## Others

### PEPs (Python Enhancement Proposals)

[PEPs (Python Enhancement Proposals)](https://www.python.org/dev/peps/)

[pep 翻译](https://github.com/chinesehuazhou/peps-cn)

### python 的实现

[python 的实现](https://docs.python.org/zh-cn/3/reference/introduction.html#alternate-implementations)

- CPython

    这是最早出现并持续维护的 Python 实现，以 C 语言编写。新的语言特性通常在此率先添加。

- Jython
- Python for .NET
- IronPython
- PyPy

### urllib

[urllib](https://docs.python.org/zh-cn/3/library/urllib.html)

for example

```python
import urllib.request

response = urllib.request.urlopen("http://www.example.com")
html = response.read()
print(html)

html = html.decode("utf-8")
print(html)

print(response.info())
```

### Python GUI

[Tkinter(GUI)](https://docs.python.org/zh-cn/3/library/tk.html)

*linux 有名的 GUI 库是 `Qt` 和 `GTK+`，python 对它们的融合分别是 PyQt 和 PyGtk。*

EasyGUI 太简单了，功能不够强大。Tkinter 比较优秀，移植性比较高，被很多脚本语言（perl, ruby）使用，这也是 python 的默认 GUI 包。

PyQt, PyGtk 比 Tkinter 更加强大，但比 Tkinter 复杂。
