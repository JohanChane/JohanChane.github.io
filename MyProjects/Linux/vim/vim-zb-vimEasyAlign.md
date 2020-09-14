# vim easy align

### Refers

- <https://github.com/junegunn/vim-easy-align>

ga 是相当于一个 operator(c,d,y)。可参考 `help y, help operator, help forced-motion`。

语法格式（与 c, d, y 类似，是在最后加入一个对齐方案和一个对齐字符）

    # [<enter>]<对齐方案>]<对齐字符> 最终是在命令行下输入的。<enter> 是取反的意思。
    ga{motion}[<enter>][<对齐方案>]<对齐字符>          
    {Visual}ga[<enter>][<对齐方案>]<对齐字符>

### 对齐方案

- 如果不写对齐方案则默认为 1。
- `N`: 前面第 N 个对齐字符对齐。
- `-N`: 后面第 N 个对齐字符对齐
- `*`: 所有对齐字符对齐。
- `**` 单元格左-右对齐。第一个单元格为左，第二个为右，第三个为左，第四个为右，依此类推。

        # 单元格默认方案是左对齐。
        # `<enter>**` 则是单元格右-左对齐。第一个单元格为右，第二个为左，第三个为右，第四个为左，依此类推。
        # 所以单元格就有了四种对齐方案：左/右/左-右/右-左。

    for example:

    ```
    | Option| Type | Default | Description |
    | --|--|--|--|
    | threads | Fixnum | 1 | number of threads in the thread pool |
    | queues |Fixnum | 1 | number of concurrent queues |
    | queue_size | Fixnum | 1000 | size of each queue |
    | interval | Numeric | 0 | dispatcher interval for batch processing |
    | batch | Boolean | false | enables batch processing mode |
    | batch_size | Fixnum | nil | number of maximum items to be assigned at once |
    | logger | Logger | nil | logger instance for debug logs |

    # 用了 `+` 和空格方便理解，所以是特殊字符，如果正常输入 `+` 和空格则用 `\+`, `\ `表示。
    vip + ga + |
    vip + ga + 2|
    vip + ga + -1|
    vip + ga + -2|
    vip + ga + <enter>3|
    vip + ga + *|
    vip + ga + <enter>*|
    vip + ga + <enter>**|
    ```

*如果还不满足可进下一步学习。[vim easy align](https://github.com/junegunn/vim-easy-align)*
