# reg command


### 基本概念

key(注册表项), value, data

    key 下可有多个 subkeys 或 values
    data 有多个数据类型

    entry 是一个 value, 名称为 `@(默认)`

reg

    /v <valueName>, /ve (表示 entry)
    /t <dataType>
    /d <data>

`.reg` 文件与 `.hiv` 文件

> .reg 保存 key, 而 .hiv 保存 subkeys 和 values (也包含 entry)

### [注册表参数](https://www.robvanderwoude.com/ntstart.php)

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

### reg

for example

```
:: ### 增删改查
:: key 表示注册表项
reg add "HKLM\Software\KeyName" /f
reg add "HKLM\Software\KeyName" /v "valueName1" /t REG_SZ /d "data1" /f

reg query "HKLM\Software\KeyName" /v "valueName1"

:: 转义字符是 `\`
reg add "HKLM\Software\KeyName" /v "valueName1" /t REG_SZ /d "data1\"data2" /f
:: 不可以用字符串拼接
:: reg add "HKLM\Software\KeyName" /v "valueName1" /t REG_SZ /d "data1""data2" /f

reg query "HKLM\Software\KeyName" /v "valueName1"

reg delete "HKLM\Software\KeyName" /v "valueName1" /f
reg query "HKLM\Software\KeyName"

reg delete "HKLM\Software\KeyName" /f
reg query "HKLM\Software\KeyName"

:: ### compare
reg add "HKLM\Software\KeyName" /f
reg add "HKLM\Software\KeyName1" /f
reg add "HKLM\Software\KeyName" /v "valueName1" /t REG_SZ /d "data1" /f
reg add "HKLM\Software\KeyName1" /v "valueName1" /t REG_SZ /d "data1" /f

reg compare "HKLM\Software\KeyName" "HKLM\Software\KeyName1"
reg compare "HKLM\Software\KeyName" "HKLM\Software\KeyName1" /v "valueName1"

reg delete "HKLM\Software\KeyName" /f
reg delete "HKLM\Software\KeyName1" /f

:: ### copy
:: 只能复制 key
reg add "HKLM\Software\KeyName" /f
reg add "HKLM\Software\KeyName" /v "valueName1" /t REG_SZ /d "data1" /f

reg copy "HKLM\Software\KeyName" "HKLM\Software\KeyName1"

reg delete "HKLM\Software\KeyName" /f
reg delete "HKLM\Software\KeyName1" /f

:: ### export and import key
reg add "HKLM\Software\KeyName" /f
reg add "HKLM\Software\KeyName" /v "valueName1" /t REG_SZ /d "data1" /f

reg export "HKLM\Software\KeyName" "KeyName.reg" /y
reg import "KeyName.reg"

reg delete "HKLM\Software\KeyName" /f

:: ### save, load, restore subkeys and entries
reg add "HKLM\Software\KeyName" /f
reg add "HKLM\Software\KeyName" /v "valueName1" /t REG_SZ /d "data1" /f

:: export, import 与 save, load, restore 的区别是操作 key 或 subkeys and entries
:: load 与 restore 区别是 restore 用于恢复原来的 key。当然也可以加载到别的 key。
reg save "HKLM\Software\KeyName" "KeyName.hiv" /y

reg add "HKLM\Software\KeyName1" /f
:: 出现拒绝访问错误
:: reg load "HKLM\Software\KeyName1" "KeyName.hiv"
reg delete "HKLM\Software\KeyName1" /f

reg restore "HKLM\Software\KeyName" "KeyName.hiv"
reg restore "HKLM\Software\KeyName1" "KeyName.hiv"

reg delete "HKLM\Software\KeyName" /f

:: ### 清除多余的东西
reg delete "HKLM\Software\KeyName" /f
reg delete "HKLM\Software\KeyName1" /f

del KeyName.reg KeyName.hiv
```
