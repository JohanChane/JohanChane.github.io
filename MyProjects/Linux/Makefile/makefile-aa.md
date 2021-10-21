# makefile 总结

### Refers

- <https://www.gnu.org/software/make/manual/>

- <https://www.gnu.org/software/make/manual/html_node/Name-Index.html>

    根据 Functions, Variables, Directives 查找文档

- <https://devhints.io/makefile>

    Makefile cheatsheet

### 基本概念

makefile 主要是用于编译项目的。

为什么有 makefile 呢？

> 因为项目的每个文件可能依赖都各不相同，所以 makefile 会提供相应的功能，方便用户管理这些文件的关系。
>
> *为了文便用户，makefile 会自动设置一些常用东西。可用 `make -p` 查看。*

makefile 的大概执行过程

> 用户指定生成的目标，为生成目标，makefile 会检查其依赖文件是否满足生成目标的条件，如果某个依赖文件不满足则转到（类似于函数调用，因为最终会返回）该依赖的目标去生成这个目标（如果满足生成该目标的条件，则执行其 recipes），生成依赖后，返回继续检查下一个依赖。依此类推，最终生成目标，makefile 执行结束。*最终这个过程类似于函数的调用。*

for example

    # ### makefile
    all: da db
    da:
    db:

    # 当要生成 all 时，如果 db 都不满足生成 all 的条件时，则会转到 db 目标去生成 db，然后 da db 都满足生成 all 的条件了，生成 all 即可。


### 用于调试与反馈的命令

    make
        -n
            列出要运行的命令，但并没有运行。
        -p
            显示 makefile database

### What Makefiles Contain

Makefiles contain five kinds of things

- explicit rules
- implicit rules
- variable definitions
- directives

        include, define ...

- comments


### rule foramt

    target … : prerequisites …
        recipe
        …


### 什么时候执行 recipes

`MAKECMDGOALS` 为用户指定生成的目标。

`.DEFAULT_GOAL` 默认是第一个目标。如果 `MAKECMDGOALS` 没有定义时，则生成 `.DEFAULT_GOAL` 的目标。

满足生成目标的条件

- 依赖的修改时间比目标的修改时间晚，证明依赖文件没有被修改，所以不必转到依赖相应的目标了。否则，则转。
- 如果依赖文件不存在或依赖是 PHONY 的，则转到依赖的相应目标。
- 如果目标文件不存在或目标是 PHONY 的，则会执行生成目标的命令。

### [makefile 的解析](https://www.gnu.org/software/make/manual/html_node/Reading-Makefiles.html)

可分为两个阶段

- expand immediate context 的东西，解析 explicit rules, implicit rules 生成最终的 rules。
- 生成指定目标。

#### immediate expansion and deferred expansion

> expansion(展开) is immediate or deferred. immediate expansion 是直接的展开，deferred expansion 是延时的展开。

> 个人将在 deferred context 东西称为 deferred context string，而在 immediate context 东西称为 immediate context string。

> immediate context string 是在第一阶段展开的，而 deferred context string 只有被 immediate context string 引用或第二阶段生成目标有调用时，它们才会展开。

*`make -p` 里有已展开的 immediate context string，而 deferred context string 没有展开。会删除注释。*


for example

    # ### makefile
    # 第一阶段时，bar 的值没有被展开，所以其值不确定。
    foo = $(bar)
    # 第一阶段时，bar 的值会被展开，所以其值已确定为 abc。
    bar := abc

    all:
        # 第二阶段时，recipes 会被展开，所以 `$(foo)` 展开为 `abc`。
        echo $(foo)

##### deferred context and immediate context

- Variable Assignment

    ```
    immediate = deferred
    immediate ?= deferred
    immediate := immediate
    immediate ::= immediate
    immediate += deferred or immediate
    immediate != immediate

    define immediate
    deferred
    endef

    define immediate =
    deferred
    endef

    define immediate ?=
    deferred
    endef

    define immediate :=
    immediate
    endef

    define immediate ::=
    immediate
    endef

    define immediate +=
    deferred or immediate
    endef

    define immediate !=
    immediate
    endef
    ```

- Conditional Directives

    都是直接展开的。

- Rule Definition

    ```
    immediate : immediate ; deferred
            deferred
    ```

### [How Makefiles Are Parsed](https://www.gnu.org/software/make/manual/html_node/Parsing-Makefiles.html#Parsing-Makefiles)

makefile 是一行一行地解析的。

### rule context

不能在 rule context 中定义变量。

for example

    all:
    # <the rule context>
    # 不能定义变量，但是可用 Directives。比如：ifeq。
    # var := abc

## 变量

### 变量的定义或赋值、引用

#### [变量的种类](https://www.gnu.org/software/make/manual/html_node/Flavors.html#Flavors)

有两种变量，分别是 recursively expanded variable(递归展开变量), simply expanded variables(直接展开变量)

递归展开变量表示变量的值是 deferred context string，所以其值是延时展开的，所以其值还没有确定。同理，直接展开变量的值是 immediate context string，所以执行此语句后，其值是确定的。

因为 `:=, ::=` 之后是 immediate context string，所以定义或赋值递归展开变量用 `:=, ::=`。同理，定义或赋值递归展开变量用 `=`。

for example

    # ### makefile
    foo = $(bar)
    bar = $(ugh)
    ugh = Huh?

    # `$(foo)` 在 deferred context 所以会在命令执行时，才会展开这个变量。而这个变量的值延时展开的，因为已完成第一阶段，所以已解析上面的命令，所以变量最终展开为 `Huh?`。
    all:;echo $(foo)

    # ### makefile
    foo = $(bar)
    # test 是值是 `$(foo)` 展开的结果。因为其值是直接展开的，而 `$(foo)` 还没有定义，所以为空。
    test := $(foo)
    bar = $(ugh)
    ugh = Huh?

    # `$(test)` 在 deferred context 所以会在命令执行时，才会展开这个变量。而这个变量的值是空的。
    all:;echo $(test)

#### 变量的定义的方式

    <var> := <value>
    <var> ::= <value>
    <var> = <value>

    # 相当于 `define <var> =`
    define <var>
    <value>
    endef

    define <var> [:= | ::= | =]
    <value>
    endef


#### [变量的引用](https://www.gnu.org/software/make/manual/html_node/Reference.html#Reference)

变量的引用方式

    # `$<var>` 的变量名只能是一个字符。
    $<var>, $(<var>), ${<var>}

#### undefine variable

for example

    foo := foo
    bar = bar

    undefine foo
    undefine bar

    $(info $(origin foo))
    $(info $(flavor bar))

#### 使用变量时要注意的地方

##### 变量与词法分析

变量会被当成一个整体。这点与 Shell 不同。

for example

    arg1 := aa,bb
    arg2 := cc

    define func
        echo $(1)
        echo $(2)
    endef

    all:
        # $(arg1) 会被当成是第一个参数
        $(call func,$(arg1),$(arg2))

##### makefile 的特殊字符

`$$` 表示转义 `$`
`\#` 表示转义 `#`
`\\` 表示转义 `\`

for example

    # ### makefile

    # make -p
    var := A$$A B\#B C\\#C
    all:

##### 变量与空白符

变量名周围的空白符与等号之后的空白符会忽略，但变量值后面空白符不会忽略。井号之后的字符（包含井号）会被当成注释。

for example

    # ### makefile
    # var 的值是 `aa<space>`。这样写会好看点 `var = aa # end of line`。
    var = aa
    all:
        echo A$(var)A

因为等号的空白符会被忽略，那么如何定义一个有前导空白符的变量？利用变量会被当成一个整体即可。

for example

    nullstring :=

    $(space) := $(nullstring) # end of line

    all:
        echo A$(space)A


[使用变量的值包含换行符](https://www.gnu.org/software/make/manual/html_node/Multi_002dLine.html)

for example

    # ### makefile
    # 一个空行代表一个换行符。因为 endef 之前的一个空行会被忽略，所以要留两个空行。
    define newline


    endef

    # 定义一个有换行符的变量
    define multiLineVar=
    first line
    second line
    endef

    all:
        # 把 newline 换成 `\n` 再输出。
        echo -e '$(subst $(newline),\n,${multiLineVar})'

[变量过长该如何换行？](https://www.gnu.org/software/make/manual/html_node/Splitting-Lines.html#Splitting-Lines)

for example

    # ### makefile
    # make -p
    # 先解析成 `aa$ bb`，因为 `$<space>` 变量为空，所以最终解析成 `aabb`
    var := aa$\
            bb
    all:

### Automatic Variables

不能用 ifeq 语句，因为在调用 recips 时，它们才被赋值。[makefile 二次处理](#How make Reads a Makefile)

    $@: target
    $^: all prerequisite
    $*: the stem（去掉茎(或梗)的）。当 target pattern 为 a.%.b，目标为 dir/a.foo.b 时，$* 为  dir/foo。
    $<: the first prerequisite
    ...

### 变量的 substring

for example

    # 将 .o 改成 .c
    foo := a.o b.o c.o
    bar := $(foo:.o=.c)
    bar := $(foo:%.o=%.c)

### Overriding Variables

定义或赋值 Overriding Variables

    override <oVar> [:= | =] <value>
    override <oVar> = <value>

Overriding Variables 会覆盖同名的变量。只能用 `override variable = value` 的方式才能改变其值。

`make <oVar>=<value>` 也会定义一个 Overriding Variables，且它最早定义的。

for example

    # ### makefile
    # make oVar = def
    override oVar := abc
    oVar := xyz
    oVar = uvw
    all:
        @echo $(oVar)

### 目标变量的作用范围

定义目标变量的格式

    Target-specific Variable Values
        target … : variable-assignment          # 比如： prog : CFLAGS = -g
    Pattern-specific Variable Values
        pattern … : variable-assignment         # 比如：%.o : CFLAGS = -O. 表示为每个 .o 文件都设置一个变量

依赖会继承目标的变量

for example

    # ### makefile
    var := xyz

    all: testObjVar bar

    testObjVar: var := abc
    testObjVar: foo
        @echo $(var)
    foo:
        @echo $(var)
    bar:
        @echo $(var)


Suppressing Inheritance

> 通过 private 使相对于目标的变量值只针对一个目标。其依赖不会继承这个变量。

for example

    # ### makefile
    var := xyz

    all: testObjVar bar

    testObjVar: private var := abc
    testObjVar: foo
        @echo $(var)
    foo:
        @echo $(var)
    bar:
        @echo $(var)

### 特殊变量

#### MAKECMDGOALS 变量

用户指定目标。比如：make clean, 则 $(MAKECMDGOALS) 为 clean。

for example

    ifneq ($(MAKECMDGOALS),clean)
    include $(sources:.c=.d)
    endif

### [builtin 隐式规则使用的变量](https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html)

$(CC) 默认为 cc, $(CXX) 默认为 g++。还有 $(CFLAGS), $(CXXFLAGS) 等都会被 Implicit Rules 用到。可用 `make -p` 查看 Implicit Rules。

## Rules

### 规则的生成

#### [目标中含有多个目标时](https://www.gnu.org/software/make/manual/html_node/Multiple-Targets.html)

for example

    ta tb: da db
        recipe

    等价于

    ta: da db
        recipe for ta
    tb: da db
        recipe for tb


#### [存在相同的目标时](https://www.gnu.org/software/make/manual/html_node/Multiple-Targets.html)

for example

    ta: da
        recipe for ta1
    ta: db
        recipe for ta2

    等价于

    ta: da db
        recipe for ta2

### Implicit Rules（隐式规则）

Implicit Rules 有 pattern rules 和 suffix rules 。

#### 如何匹配规则的？

[先匹配显式规则，如果匹配显式规则之后都没有目标的 recipes 时，才会使用隐式规则。](https://www.gnu.org/software/make/manual/html_node/Multiple-Rules.html)只会匹配到一条隐式规则。如果其隐式规则不生效则也不会匹配其他隐式规则。优先匹配 pattern rules 再到 suffix rules。

for example

    # ### makefile
    # 优先匹配显式规则
    .SUFFIXES: .foo .bar
    .PHONY: test.foo
    all: test.bar
        @echo in all
    test.bar:
        @echo explicit rules
    .foo.bar:
        @echo suffix rules
    %.bar: %.foo
        @echo pattern rules

    # ### makefile
    # 匹配隐式规则，且优先匹配 pattern rules
    .SUFFIXES: .foo .bar
    .PHONY: test.foo
    all: test.bar
        @echo in all
    test.bar:

    .foo.bar:
        @echo suffix rules
    %.bar: %.foo
        @echo pattern rules

    # ### makefile
    # 匹配隐式规则，虽然匹配到 pattern 规则，但是不生效。就算不生效，也不会匹配下一个隐式规则。
    .SUFFIXES: .foo .bar
    .PHONY: test.foo
    all: test.bar
        @echo in all
    .foo.bar:
        @echo suffix rules
    %.bar: %.foo

#### 隐式规则生效的条件

虽然可以使用隐式规则，但它可能是不生效的。隐式规则生效生效时，会自动为匹配的目标生成显式的规则。

隐式规则生效的条件

> [匹配 target（不能是伪目标） 且 prerequisites 必须是一个已存在的目标或文件。还有该隐式规则的 recipes 不能为空。](https://www.gnu.org/software/make/manual/html_node/Pattern-Match.html#Pattern-Match)


for example

    # ### target 不能是伪目标
    # `test.bar` 不能是伪目标
    .PHONY: test.foo test.bar
    all: test.bar
        @echo in all
    %.bar: %.foo
        @echo pattern rules

    # ### 隐式规则的依赖必须是一个已存在的目标或文件。

    # #### makefile
    .PHONY: test.foo
    all: test.bar
        @echo in all
    %.bar: %.foo
        @echo pattern rules


    # ### 隐式规则有 recipes 才会生成相应的 rule

    # #### makefile
    .PHONY: test.foo
    all: test.bar
        @echo in all
    %.bar: %.foo


#### pattern rules 之间的优先级

与定义的顺序无关，与 pattern 的范围有关。

for example

    # ### makefile
    all: ABC
        @echo in all
    AB%:
        @echo AB%
    A%:
        @echo A%


#### Pattern Rules 对目标的匹配规则

`%` 表示非空的字符串。

pattern string 没有斜杠时只匹配文件名，而有斜杠时匹配路径。

for example

    # ### makefile
    .PHONY: all src/app/foo.c
    all: src/app/foo.o
    # 因为 pattern string 没有有斜杠了，所以只匹配文件名。
    f%.o: f%.c
    # s%.o: s%.c
        @echo $*

    # ### makefile
    .PHONY: all src/app/foo.c
    all: src/app/foo.o
    # 因为 pattern string 有斜杠了，所以百分号匹配路径了。
    src/ap%.o: src/ap%.c
        @echo $*

#### 自定义 suffix rules

for example

    # ### makefile
    .SUFFIXES: .foo .bar
    .PHONY: test.foo
    all: test.bar
    .foo.bar:
        @echo my suffix rule

#### [Defining Last-Resort Default Rules](https://www.gnu.org/software/make/manual/html_node/Last-Resort.html)

[只有 `%` 时，会使 make 变慢](https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules)

    '%:': match-anything pattern rule
    for example:
        all: abcefg
            echo $@
        %::
            echo $@

### [Catalogue of Built-In Rules](https://www.gnu.org/software/make/manual/html_node/Catalogue-of-Rules.html)

*其实 makefile 会帮用户自动设置很多常用的东西。比如：CXX 变量的默认值 `g++`。还有各种语言的规则，比如：%.o: %.c。还有支持 `.SUFFIXES` 的规则等。这些东西都可用 `make -p` 查看。*

### [VPATH](https://www.gnu.org/software/make/manual/html_node/General-Search.html) and [vpath](https://www.gnu.org/software/make/manual/html_node/Selective-Search.html)

VPATH, vpath 是依赖的搜索路径。一般用于搜索非当前目录的依赖。指定 VPATH, vpath 后，还会搜索当前目录的。

vpath 与 VPATH 类似，只是符合 pattern 的依赖才会到指定路径下搜索。

指定多个路径: `VPATH = foo:bar` OR `VPATH = foo bar`

for example

    # ### makefile
    # mkdir src; touch src/foo.c
    .PHONY: all
    VPATH := src
    all: foo.c
        echo all
    # rm -rf src

    # ### makefile
    # mkdir src; touch src/foo.c
    .PHONY: all
    vpath %.c src
    all: foo.c
        echo all
    # rm -rf src

### [链接库作为依赖](https://www.gnu.org/software/make/manual/html_node/Libraries_002fSearch.html)

只适用于 prerequisites。

for example

    all: -lc
        # echo /usr/lib/x86_64-linux-gnu/libc.so
        echo $^

### [Generating Prerequisites Automatically](https://www.gnu.org/software/make/manual/html_node/Automatic-Prerequisites.html)

    {g++ | gcc } -MM -M

## Recipes

### 命令前缀

- Recipe Echoing

    `@recipe`

        不会显示该命令，而只是显示命令执行的输出。一般用于输出语句.

- Errors in Recipes

    `-recipe`

        命令出错时，make 还继续执行。

- Instead of Executing Recipes

    `+recipe`

    [就算是 'make -n' (or 'make -t' or 'make -q') 命令也会照常执行。](https://stackoverflow.com/questions/3477292/what-do-and-do-as-prefixes-to-recipe-lines-in-make)



### 使用 shell if for 等语句

使用 shell if for 等语句时，只能在一个逻辑行上，因为每个逻辑行都会创建新的进程来执行。

for example

    var := aa bb cc
    all:
        for i in $(var); do\
            if test ! -z $$i; then\
                    echo $$i;\
            fi;\
        done

### [Empty recipe](https://www.gnu.org/software/make/manual/html_node/Empty-Recipes.html)

    target: ;


### `.ONESHELL`

每个 recipe 都会单独创建一个进程来运行。但可用 `.ONESHELL` 使每个 target 的所有 recipes 都以同一个进程号运行。

for example:

    # ### makefile
    # 每个 target 的所有 recipes 都以进程号都相同。
    .ONESHELL

    .PHONY: all ta tb

    all: ta tb
        echo all $$$$
    ta:
        echo ta1 $$$$
        echo ta2 $$$$
    tb:
        echo tb1 $$$$
        echo tb2 $$$$



## 函数

其实函数也是一个变量。比如：[函数的调用方式是 ${<var>}, $(<var>)](https://www.gnu.org/software/make/manual/html_node/Reference.html#Reference)。[$(call variable,param,param,…)](https://www.gnu.org/software/make/manual/make.html#Call-Function)返回函数的内容。

### [定义函数](https://www.gnu.org/software/make/manual/html_node/Canned-Recipes.html#Canned-Recipes)

for example

    # ### makefile
    # 每一行都以一个新的进程来运行。
    define CannedRecipes :=
    echo $$$$
    echo $$$$
    endef

    all:
        $(CannedRecipes)
        @$(CannedRecipes)

函数可有参数

for example

    define func :=
        echo $(0)
        echo $(1) $(2)
    endef

    all:
        # 返回值是函数内容
        $(call func,aa,bb)


### 函数中无法转义的特殊字符

`()`,`{}`

> `${}` 与 `$()` 几乎无区别，区别是在于 `${}` 的无法转义特殊字符是 `{}`, 而 `$()` 的无法转义特殊字符是 `()`。

> 所以如果要转义 `()` 则用 `${}`, 转义 `{}` 则用 `$()`。还有一种办法，利用变量在语法上是一个整体，将无法转义特殊字符放入变量即可解决问题。

for example

    # ### makefile
    # make -n
    all:
        $(shell echo {)

    # ### makefile
    # make -n
    all:
        ${shell echo \(}

    # ### makefile
    # make -n
    var := {
    all:
        ${shell echo $(var)}

#### 常用函数

- 匹配相关的文件名

        $(wildcard *.cpp)

- 替换

        $(subst EE,ee,fEEt on the street)
            # feet on the street

        # 换后缀
        $(patsubst %.o,%.c,aa.c aa.b)

- 加前缀或后缀

        $(addprefix prefix,names…)
        $(addsuffix suffix,names…)

- 运行 shell 命令

        $(shell ...)
            如果结果是多行，则每行用一个空格隔开，形成一行。

        for example
            $(shell find .)

- 删除后缀

        # `src/file`
        $(basename src/file.txt)

- 过虑

        # 删除 `aa`
        $(filter-out aa,aa bb)

## Others

### Using Wildcard Characters in File Names

`The wildcard characters in make are ‘*’, ‘?’ and ‘[…]’, the same as in the Bourne shell. `

[`wildcard 可用于 recipe(由 shell 处理), prerequisites, function`](https://www.gnu.org/software/make/manual/html_node/Wildcards.html)


### [Conditional Parts of Makefiles](https://www.gnu.org/software/make/manual/html_node/Conditional-Syntax.html#Conditional-Syntax)

for example

    # ### makefile
    all:
    ifeq (aa,bb)
        @echo foo
    else ifneq (aa,bb)
        @echo bar
    endif

    # ### makefile
    all:
    ifeq (aa,bb)
        @echo foo
    else
    ifneq (aa,bb)
        @echo bar
    endif
    endif

### include

include 的东西相当于依赖，因为目标不存在所以都会转到它们相应的目标。

for example

    # ### makefile

    include foo.d bar.d
    all:
    %.d:
        @echo $@


### [Makefile Conventions](https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html)

    Standard Targets for Users。比如：all。

### Others

    Parallel Execution
        make -j <n>