#!/usr/bin/env bash

# 删除 markdown 字符串之后多余的空白符，并将 markdown 用后接两个空格的换行方式改为 `<br>`
# ===

# ### 说明
# 使用此脚本前应先备份数据。
# 使用之后，除了未尾只有两个空格的字符串的两个空格会补替换为 `<br>`，字符串未尾的空白符会被删除

# ### 删除多余的空白行
# 先删除只有空白符的行的空白符
find . -name '*.md' | xargs -I '{}' sed -i 's/^\s\+$//' '{}'
# 再删除未尾三个以上的空白符的行的未尾空格
find . -name '*.md'  | xargs -I '{}' file --mime-type '{}' | grep 'text/' | cut -d':' -f 1 | xargs -I '{}' sed -i 's/\s\{3,\}$//' '{}'

# 先 list2spaces，查看将要替换的行，然后 replaceAndDelete, 再然后可查看含有 `<br>` 的行
action="list2spaces replaceAndDelete listbr"
select i in $action; do
    case $REPLY in
        q | Q)
            break
            ;;
    esac

    if [[ "$i" = "list2spaces" ]]; then
        # 列出后面有两个空格的行
        find . -name '*.md'  | xargs -I '{}' file --mime-type '{}' | grep 'text/' | cut -d':' -f 1 | xargs -I '{}' grep -H '\ \ $' '{}'
    elif [[ "$i" = "replaceAndDelete" ]]; then
        # 将字符串后面的两个空格换成 `<br>`
        find . -name '*.md' | xargs -I '{}' sed -i 's/\ \ $/<br>/' '{}'
        # 删除字符串未尾的空白符（替换完之后，可能还有其他空白符）
        find . -name '*.md' | xargs -I '{}' sed -i 's/\s\+$//' '{}'
    elif [[ "$i" = "listbr" ]]; then
        # 列出有 <br> 的行
        find . -name '*.md' | xargs -I '{}' grep -H '<br>' '{}'
    fi
done
