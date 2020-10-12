# linux 包管理总结

### refer:

man page


有用过 linux 的发行版：centos, debian, archlinux。这里简单地从用户管理包的需要哪些功能的方向来谈谈 linux 包管理的设计。
    
目的：对 centos, debian, archlinux 的包管理进行了简单地总结。能使大家更快地上手 centos, debian, archlinux 这些 linux 发行版本的包管理。
    
适用人群：对其中一种 linux 发行版的包管理有初步地了解，想更加方便地使用 linux 包管理。
    
### linux 的发行版的包管理软件

- centos

	yum, rpm（本地）
	
- debian

	apt, dpkg（本地）
	
- archlinux

	pacman
            
### linux 包管理与 windows 程序管理对比

这里我以 windows 下的软件管理展开，大家都知道 window 软件安装目录都是放在一个文件夹中的，配置文件可能放在安装目录下或 HOME 目录下。软件的依赖文件可能是系统盘的一些 DLL 文件，当然还有一些依赖软件，但是 window 软件的常用做法是单独提供这些依赖的东西，并放在安装目录下。而 linux 做法则是不提供依赖的东西，你要用户自己去安装提供这些依赖的软件（有了包管理软件就不需要了）。而且根据 FHS（文件系统层次化标准）软件的文件一般不放在一个目录下的。

linux 的发行版的包管理软件在系统中是有相应的记录的，比如：安装了哪些软件。这与 windows 的“程序与功能”类似，相比于 windows 对于软件记录的信息会更加详细，在后面会说。但是 tarball 安装的软件系统是不会记录的，这也与 windows 的免安装版本软件类似，系统也是不会记录的。但是通过安装包安装则会记录，这点也与 windows 一样。比如：.rpm, .deb ...

卸载包是可选择保留配置文件。linux 与 windows 都提供这样的功能。linux 更高级的是还会记录配置文件是否被修改过，如果修改过可选择保留，没有修改过则不保留。
    
#### linux 包管理独特的方面

提供软件仓库，仓库中有多款软件，且可缓存软件提供的文件名。这个比 windows 要上软件的官网下载软件好用多了。用一条命令就可安装软件，且只要记住软件的提供的一个文件名就可查出软件名。
        
### 包的依赖树

既然 linux 的软件不单独提供依赖的东西，那么要解决的一个问题是，卸载包时，如何解决包的依赖问题。这就要讲到包的依赖树了。

假如 ABC 是三个软件，它们的依赖关系是， B, C 依赖 A。B，C 没有被别的软件包依赖。所以是 B, C 是 A 的儿子且 B，C 是叶子结点。当用户卸载 B，C 时，直接卸载即可，但是卸载 A 呢？有两种解决方案，一：提示用户只能卸载叶子结点，让用户手动删除 B，C 再删除 A，这样会比较安全。二：一起卸载 ABC 即可。这两种方案最终结果都是剩下的软件都不会缺少依赖。卸载问题就解决了。一般来说，pacman 用第一种方案，yum 用第二种方案，当然选择哪种方案都是可以设置的，要看具体设置。

对于包的安装，应该很容易理解吧。如果用户安装 A 则安装 A 即可。安装 B 则安装 A，B 即可。安装 C 则安装 A，C。
         
### 安装理由

在 “linux 包管理与 windows 程序管理对比” 中有讲到 linux 软件安装记录比 windows 更加详细，这些我要提一下“安装理由”了。感觉这个设计比较好。

linux 包管理系统会记录软件是以什么理由安装的。比如：作为依赖安装，用户指定安装。举个例子，接着“包依赖树的例子”，安装 B，会安装 A，B。A，B 的安装理由分别是“作为依赖安装”，“用户指定安装”。安装理由的作用：

- 用户卸载 B 时，如果 A 没有作为别的软件的依赖，那么就可以同时卸载 A 了，因为 A 的安装理由是“作为依赖安装”。如果 A 是“用户指定安装”，则要用户
指定卸载 A 才会卸载 A。

- 用户可列出自己指定安装了哪些软件。这是不是比 windows 的“程序与功能”好用多了，至少不列出作为依赖安装的软件。
            
### 包管理常用的功能

- 安装软件

        archlinux
            pacman -S
        centos
            yum install
        debian
            apt-get install

- 卸载软件

        archlinux
            pacman -R[n][s] <package...>
                n 是不保留 backup file（一般是配置文件）。
                s 是会尝试移除包的依赖，如果依赖包没有被其他包依赖，且该包是作为依赖而安装的会被移除。
        centos
            yum {remove | erase}
                remove 与 erase 一样。
                移除包时，不会尝试移除包的依赖。但是会尝试移除依赖该包的包（注意这里是采用方案二）。
                可在 /etc/yum.conf 中设置 remove 的行为
                    remove_leaf_only=1              # 采用方案一
                    clean_requirements_on_remove=1
        debian
            apt-get remove
                不删除已被修改的配置文件。
            apt-get purge
                删除的配置文件，且可以在 remove 包之后用。
            apt-get auto-remove
                移除包时，会尝试移除包的依赖，如果依赖包没有被其他包依赖，且该包是作为依赖而安装的会被移除。
        
	    卸载包时，管理配置文件的思路
            记录包配置的 md5 之类的数据，这样可知配置文件是否被修改。
            如果配置文件被修改了，卸载时，可以保留或改名（rpm .rpmsave; pacman .pacsave;）。


- 列出/查看配置文件是否被更改

        archlinux
            pacman -Sii
                列出所有配置文件及它们的状态
        centos
            rpm -qc
            rpm -V
        debian
            dpkg-query -s
            debsums -ce

- 查看软件说明信息

        archlinux
            pacman -{Q | S}i
        centos
            yum info
        debian
            apt-cache show
    
- 搜索软件

        archlinux
        	pacman -Ss <regexp>
        		搜索 package names or descriptions
        centos
        	yum search
        debian
        	apt-cache search <regexp>
        		查找范围包含包的描述。
    
- 查看软件提供的文件

        archlinux
            pacman -Fl [package...]
        centos
            repoquery -ql
            centos8: dnf repoquery -l
        debian
            apt-file list

- 根据软件提供的文件查询软件名

        archlinux
            pacman -Fx <regex>
        centos
            yum whatprovides
        debian
            apt-file -x search <regex>

- 用户指定安装的包
        
        archlinux
            pacman -Qe
        centos
            yumdb search reason user
        debian
            apt-mark showmanual
    
- 作为依赖而安装的包
        
        archlinux
            pacman -Qd
        centos
            yumdb search reason dep
        debian
            apt-mark showauto

- 查看安装理由

        archlinux
            pacman -Qi 
    
- 查看依赖
        
        archlinux
        	pacman -Qi 
        		可查看安装理由与依赖
        centos
        	yum deplist
        		该包依赖的东西
        	repoquery -q --whatrequires
        		依赖该包的东西
        debian
        	apt-cache depends
        		该包依赖的东西
        	apt-cache rdepends
        		依赖该包的东西

### 实践：

知道软件提供的命令，但是不知道软件名？

> 可用<根据软件提供的文件查询软件名>查询出软件，再安装即可。不用上网查了。比如：`pacman -Fx '/bin/locate$'`。

linux 很多软件都是要配置的，那么它的配置文件有哪些？

> `<查看软件提供的文件> | grep '/etc/'` 即可查出有哪些配置文件。比如：`pacman -Ql mlocate | grep '/etc/'`。
> 
> OR
> 
> `<查看软件提供的文件>         # 还可以找出其日志文件哦`
> 
> 有些软件并没有说明哪个文件是其配置文件，这时就要用到 FHS 知识了，到 `/etc` 目录下找找。