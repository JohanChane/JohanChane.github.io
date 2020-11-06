# windows 注册表

### refer

- <https://blog.csdn.net/meng_suiga/article/details/79485855>
    
    注册表参数

## 添加右键菜单

### 添加右键菜单的方法

*在相应的 shell 目录下做如工作即可*

    shell\<Key>
        @="<prompt>"
        icon="<iconpath>"
        ; 有这个值时，按 shift + RightClick 才能显示 
        "Extended"=""
    shell\<Key>\command
        @=<命令>
	    
#### 注册表参数

| Parameter | Evaluates to                               |
| --        | --                                         |
| %1        | Long fully qualified path of file          |
| %D        | Long fully qualified path of file          |
| %H        | 0                                          |
| %I        | :number:number                             |
| %L        | Long fully qualified path of file          |
| %S        | 1                                          |
| %V        | Long fully qualified path of file          |
| %W        | Long fully qualified path of parent folder |

### 相应的 shell

    ; 文件
    HKEY_CLASSES_ROOT\*\shell\

    ; 目录
    HKEY_CLASSES_ROOT\Directory\shell
    HKEY_CLASSES_ROOT\Directory\Background\shell\

    ; 库文件
    HKEY_CLASSES_ROOT\LibraryFolder\shell\
    HKEY_CLASSES_ROOT\LibraryFolder\background\shell\

    ; 驱动
    HKEY_CLASSES_ROOT\Drive\shell\
		
### 删除注册表“项”

    [-<key>]

### 例子

#### Open Cmd Here

*按住 shift + 右键，在当前目录下打开 DOS*


- 添加右键菜单

    ```
    Windows Registry Editor Version 5.00

    [HKEY_CLASSES_ROOT\Directory\shell\OpenCmdHere]
    @="Open Cmd window here"
    "Icon"="cmd.exe"
    "Extended"=""

    [HKEY_CLASSES_ROOT\Directory\shell\OpenCmdHere\command]
    @="cmd /k cd %v"


    [HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmdHere]
    @="Open Cmd window here"
    "Icon"="cmd.exe"
    "Extended"=""

    [HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmdHere\command]
    @="cmd /k cd %v"

    [HKEY_CLASSES_ROOT\Drive\shell\OpenCmdHere]
    @="Open Cmd window here"
    "Icon"="cmd.exe"

    [HKEY_CLASSES_ROOT\Drive\shell\OpenCmdHere\command]
    @="cmd /k cd %v"

    [HKEY_CLASSES_ROOT\LibraryFolder\background\shell\OpenCmdHere]
    @="Open Cmd window here"
    "Icon"="cmd.exe"
    "Extended"=""

    [HKEY_CLASSES_ROOT\LibraryFolder\background\shell\OpenCmdHere\command]
    @="cmd /k cd %v"
    ```

- 删除右键菜单

    ```
    Windows Registry Editor Version 5.00

    [-HKEY_CLASSES_ROOT\Directory\shell\OpenCmdHere]
    [-HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCmdHere]
    [-HKEY_CLASSES_ROOT\Drive\shell\OpenCmdHere]
    [-HKEY_CLASSES_ROOT\LibraryFolder\background\shell\OpenCmdHere]
    ```

#### Eidt with Vim

*用 vim 编辑文件*

- 添加右键菜单

    ```
    Windows Registry Editor Version 5.00

    ; ######################################## 在文件上右键 ########################################
    ; EditWithGVim
    [HKEY_CLASSES_ROOT\*\shell\EditWithGVim]
    @="Edit with gVim"
    "Icon"="D:\\PortableProgramFiles\\Vim\\gvim.exe"

    [HKEY_CLASSES_ROOT\*\shell\EditWithGVim\command]
    @="D:\\PortableProgramFiles\\Vim\\gvim.exe \"%1\""

    ; ######################################## 在目录背景上右键 ########################################
    ; EditWithGVim
    [HKEY_CLASSES_ROOT\Directory\Background\shell\EditWithGVim]
    @="Edit with gVim"
    "Icon"="D:\\PortableProgramFiles\\Vim\\gvim.exe"

    [HKEY_CLASSES_ROOT\Directory\Background\shell\EditWithGVim\command]
    @="D:\\PortableProgramFiles\\Vim\\gvim.exe"
    ```

- 删除右键菜单

    ```
    Windows Registry Editor Version 5.00

    [-HKEY_CLASSES_ROOT\*\shell\EditWithGVim]
    [-HKEY_CLASSES_ROOT\Directory\Background\shell\EditWithGVim]
    ```