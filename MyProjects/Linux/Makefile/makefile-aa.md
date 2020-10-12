# makefile 总结

### Refers

- <https://www.gnu.org/software/make/manual/>
- <https://www.gnu.org/software/make/manual/html_node/Name-Index.html>
- <https://devhints.io/makefile>
	
### 基本概念

makefile 主要是用于编译项目的。

为什么有 makefile 呢？

> 因为项目的每个文件可能依赖都各不相同，所以 makefile 会提供相应的功能，方便用户管理这些文件的关系。
> 
> *为了文便用户，makefile 会自动设置一些常用东西。可用 `make -p` 查看。*

makefile 的大概执行过程

> 用户指定生成的目标，为生成目标，makefile 会检查其依赖文件是否满足生成目标的条件，如果某个依赖文件不满足则转到（类似于函数调用，因为最终会返回）该依赖的目标去生成这个目标，生成依赖的相应目标后，返回继续检查下一个目标。依此类推，最终生成目标，makefile 执行结束。*最终这个过程类似于函数的调用。*

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
    …
    
    
### makefile 的执行

`MAKECMDGOALS` 变量指定了要生成的目标。

*当用户不指定目标时，则生成 `.DEFAULT_GOAL` 目标指定的目标，默认是第一个目标。*

依赖满足生成目标的条件

- 依赖的修改时间比目标的修改时间晚，证明依赖文件没有被修改，所以不必转到依赖相应的目标了。否则，则转。
- 如果依赖文件不存在或依赖是 PHONY 的，则转到依赖的相应目标。
- 如果目标文件不存在或目标是 PHONY 的，则会执行生成目标的命令。
    
### How make Reads a Makefile

可分为两个阶段

> During the first phase it reads all the makefiles, included makefiles, etc. and internalizes all the variables and their values, implicit and explicit rules, and constructs a dependency graph of all the targets and their prerequisites. 
> 
> During the second phase, make uses these internal structures to determine what targets will need to be rebuilt and to invoke the rules necessary to do so.

> *综上，不严谨的说法，除了决定要执行哪些目标外，其他都是第一阶段的。延时赋值是第二阶段的。*
        
比如

- immediate expansion, deferred expansion

    在第一阶段被执行的 expansion，我们称为 immediate expansion

    在第二阶段被执行的 expansion，我们称为 deferred expansion
        
- Variable Assignment

        immediate = deferred
        immediate ?= deferred
        immediate := immediate
        immediate ::= immediate
        immediate += deferred or immediate
        immediate != immediate
        
- Conditional Directives

    Conditional directives are parsed immediately. This means, for example, that automatic variables ($@, $^, ...) cannot be used in conditional directives, as automatic variables are not set until the recipe for that rule is invoked. If you need to use automatic variables in a conditional directive you must move the condition into the recipe and use shell conditional syntax instead.

    *Conditional directives 是第一阶段执行的*

    *automatic var 是 recipe 被调用时才设置的，所以是第二阶段的。*
        
- Rule Definition

        immediate : immediate ; deferred        # target, prerequisites 都是在第一阶段执行的
            deferred
                    
## Rules

### Implicit Rules

`make -p|less -i` 搜索 `# Implicit Rules` 即可查看隐式规则。

*makefile 一个很方便的功能，用匹配模式来匹配文件。*

    Pattern Rules:
        target '%' 表示是非空的字符串
        prerequisites '%' 表示是 target '%' 代表的内容。
        for example:
            # `%.o` 匹配 `.o` 后缀的文件
            %.o : %.c:
                gcc -c $^
            
    Suffix Rules:
        double-suffix
            <sourceSuffix><targetSuffix>:
            # 等价于 %<targetSuffix>: %<sourceSuffix>
            
            for example:
                .c.o:
                # 等价于 %.o: %.c:
                
        single-suffix
            <singleSuffix>:
            # 等价于 % : %<singleSuffix>:

            for example:
                .c:
                # 等价于 %: %.c:

        `.SUFFIXES` 目标包含支持后缀，可用 `make -p` 查看。如果想支持其他后缀，可向其加入依赖即可。
                    
    Defining Last-Resort Default Rules
        '%:': match-anything pattern rule
        for example:
            all: abcefg
                echo $@
            %::
                echo $@

### Multiple Targets in a Rule

    ta tb: ra rb
        recipe

    等价于

    ta: ra rb
        recipe
    tb: ra rb
        recipe
            
### 多个 rule 的 recipes 相同时可以这样写

    targeta: prerequisites
    targetb: prerequisites
        recipes
        
    等价于

    targeta: prerequisites
        recipes
    targetb: prerequisites
        recipes

### Multiple Rules for One Target

问题：一个目标可对应多个规则的目标，那么该执行哪个呢？

> 对于显式规则而言，因为前面的规则会被覆盖，所以是执行最后一个规则。
> 
> 如果隐式规与显式规则同时存在，则先匹配显式规则，如果没有再匹配隐式规则。

for example:

    ta: ra rb
        recipe
    tb: ra rb
        recipe

    %: %
        recipe

    # `ta tb` 会覆盖上面 `ta`, `tb` 规则。
    ta tb: ra rb
        recipe

    make ta                 # 匹配 `ta tb`
    make sometarget         # 匹配 `%`
            

### Catalogue of Built-In Rules

*其实 makefile 会帮用户自动设置很多常用的东西。比如：CXX 变量的默认值 `g++`。还有各种语言的规则，比如：%.o: %.c。还有支持 `.SUFFIXES` 的规则等。这些东西都可用 `make -p` 查看。*

    C compilation .o 文件的依赖是 .c
    C++ compilation .o 文件的依赖是 .cpp, .cc, .C
    ...
        
    Chains of Implicit Rules:
        是如果查找 .o 文件的依赖文件的？也就是说应该用哪个 Built-In Rules。
            通过查找相关的文件是否存在或 makefile 是否有提及相关的文件。比如：<filename>.c 文件存在，
    则 <filename>.o 的依赖文件是 <filename>.c 。

    Variables Used by Implicit Rules
        比如：CXX 变量不用用户定义也是存在的，且默认值为 g++

### 伪目标

    .PHONY: targeta targetb ...
    伪目标不与同名的文件相联系。
        
### VPATH

    makefile 搜索文件的目录
            
### Directory Search for Link Librarieso

    -l 让你不用写 lib file name. 只适用于 prerequisites。

    for example:
        all: -lc
            echo $^
            # echo /usr/lib/x86_64-linux-gnu/libc.so

### Generating Prerequisites Automatically

    {g++ | gcc } -MM -M
     
## Recipes

### recipe 的执行

如何执行 recipe?

参考 [makefile 二次处理](#How make Reads a Makefile)

> 每一行 recipe 会在一个由 `SHELL` 变量指定的 subshell 中执行，证明每一行 recipe 都会开辟一个新的 shell 进程来运行。
> 
> `$` 在 recipe 中有特殊作用，如果想在 shell 中使用 `$`，则要用 `$$`。makefile 的第一阶段处理时，会将其转换的。当然还有命令前缀（@, -, ...）也是特殊的。
> 
> 将第二阶段的 recipe 传到 shell 中执行。不处理 backslash 和 newline, 将它们转到 shell, shell 是如何处理就
如何处理。如果 backslash 或 newline 的第一个字符是 recipe prefix character（默认是 tab），则会删除这个字符。
        

for example
    
    # 如果想用 shell 的 if, while for 等语句时，要用将它们写在一行。
    all:
        if [[ 1 -eq 1 ]]; then \
            echo true \
        fi

        echo $$$$

#### `.ONESHELL`

每个 target 的所有 recipes 都以进程号都相同。

for example:

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
        
#### 命令前缀

    Recipe Echoing
        @recipe
            不会显示该命令，而只是显示命令执行的输出。一般用于输出语句. 

    Errors in Recipes
        -recipe
            命令出错时，make 还继续执行。
    Instead of Executing Recipes
        +recipe
        [就算是 'make -n' (or 'make -t' or 'make -q') 命令也会照常执行。](https://stackoverflow.com/questions/3477292/what-do-and-do-as-prefixes-to-recipe-lines-in-make)

#### Empty recipe

    for example:
        target: ;
        
## 变量

for example
    
    var = abc           # 创建或赋值变量
    all:
        echo $(var)     # 使用变量

### 变量的赋值方式

根据 make 读makefile 的两个阶段，变量有两个赋值方式

    recursive expansion
        =           # 延时赋值
    Simply expansioni
        :=, ::=     # 直接赋值

#### Overriding Variables

`make oVar=oValue` 表示 oVar 是一个 Overriding Variable。这种变量会覆盖同名的变量，且用延时或直接赋值都无法改变其值。只能用 `override variable = value` 的方式改变。

for example

    oVar = abc
    # override oVar = abc

    all: 
        echo $(oVar)

    make oVar=xyz

### Setting Variables

    +=
        内容连接
    ?=
        变量没有被定义时，才会赋值。
    !=
        用 shell 命令的赋值？
            hash != printf '\043' 等价于 hash := $(shell printf '\043')

### 引用变量

    Substitution References
        将 .o 改成 .c
            foo := a.o b.o c.o
            bar := $(foo:.o=.c)
            bar := $(foo:%.o=%.c)
    Computed Variable Names(nested variable reference)
        x = y
        y = z
        a := $($(x))
        
### 变量的作用范围

设置对于目标的变量值

    Target-specific Variable Values
        target … : variable-assignment          # 比如： prog : CFLAGS = -g
    Pattern-specific Variable Values
        pattern … : variable-assignment         # 比如：%.o : CFLAGS = -O. 表示为每个 .o 文件都设置一个变量

    for example
        var=abc
        start: all foo.o
                echo $(var)
        all: var=allValue
        all: test.o main.o
                echo all $(var)
        # 继承 all 的 var
        main.o:
                echo main.o $(var)
        # var 为 abc
        foo.o:
                echo foo.o $(var)
               
    Suppressing Inheritance
        通过 private 使相对于目标的变量值只针对一个目标。其依赖不会继承这个变量。
        
    for example
        var=abc
        start: all foo.o
                echo $(var)
        all: private var=allValue
        all: test.o main.o
                echo all $(var)
        # var 为 abc
        main.o:
                echo main.o $(var)
        # var 为 abc
        foo.o:
                echo foo.o $(var)

### Automatic Variables

不能用 ifeq 语句，因为在调用 recips 时，它们才被赋值。[makefile 二次处理](#How make Reads a Makefile)

    $@: target
    $^: all prerequisite 
    $*: the stem（去掉茎(或梗)的）。当 target pattern 为 a.%.b，目标为 dir/a.foo.b 时，$* 为  dir/foo。
    $<: the first prerequisite 
    ...

### 特殊变量

MAKECMDGOALS 变量

    用户指定目标。比如：make clean, 则 $(MAKECMDGOALS) 为 clean。

    for example
        ifneq ($(MAKECMDGOALS),clean)
        include $(sources:.c=.d)
        endif
            
## Others

### Using Wildcard Characters in File Names

`The wildcard characters in make are ‘*’, ‘?’ and ‘[…]’, the same as in the Bourne shell. `

[`wildcard 可用于 recipe(由 shell 处理), prerequisites, function`](https://www.gnu.org/software/make/manual/html_node/Wildcards.html)
        
### 函数

    Function Call Syntax
    Functions for String Substitution and Analysis
    Functions for File Names
    
    $(shell find ...) 的结果与 shell 中的 $(find ...) 相同，其结果都是用空格连接各行成一行。

#### 常用函数

    匹配相关的文件名
        $(wildcard *.cpp)
    
    替换
        $(subst EE,ee,fEEt on the street)
            # feet on the street
    
    加前缀或后缀
        $(addprefix prefix,names…)
        $(addsuffix suffix,names…)
    
    运行 shell 命令
        $(shell ...)
            如果结果是多行，则每行用一个空格隔开，形成一行。
            
            for example:
                $(shell find .)
    
### Conditional Parts of Makefiles

    Syntax of Conditionals
        elif: else ifeq
    
    使用 shell if for 等语句时，这些语句只能在一行。
        for example:
            all:
                if [[ ! -e includea ]]; then \
                    mkdir includea; \
                fi

### include

### define

    define <varName>[=]
    <varValue>
    endef

#### [Defining Canned Recipes](https://www.gnu.org/software/make/manual/html_node/Canned-Recipes.html#Canned-Recipes)

The canned sequence is actually a variable, so the name must not conflict with other variable names.

每一行都以一个新的进程来运行。

for example:

    define CannedRecipes =
    echo $$$$
    echo $$$$
    endef

    all:
        $(CannedRecipes)
        @$(CannedRecipes)


#### [Defining Multi-Line Variables](https://www.gnu.org/software/make/manual/html_node/Multi_002dLine.html)

定义内容有换行的变量

for example:

    # 空两行代表一个换行符
    define newline


    endef

    # 定义一个有换行符的变量
    define multiLineVar=
    first line
    second line
    endef

    all:
        echo -e '$(subst $(newline),\n,${multiLineVar})'

    
### [Makefile Conventions](https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html)

    Standard Targets for Users  
        
### Others

    Parallel Execution
        make -j <n>
