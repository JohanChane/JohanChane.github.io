# 将 VSCode 打造成一款独立的精简版文本编辑器

### refer

- <https://code.visualstudio.com/docs/editor/portable>

    制作 portable vscode 的官方教程

- <https://github.com/JohanChane/JohanChane.github.io/blob/master/Others/DOS/%E6%B3%A8%E5%86%8C%E8%A1%A8/%E6%B7%BB%E5%8A%A0%E5%8F%B3%E9%94%AE%E8%8F%9C%E5%8D%95-aa.md>

    windows 添加右键菜单教程

- <https://shd101wyy.github.io/markdown-preview-enhanced/#/>

    markdown-preview-enhanced 官方教程

- <https://github.com/JohanChane/JohanChane.github.io/blob/master/MyProjects/Others/Markdown/markdown-aa.md>

    我的 markdown 测试文件，也是我的 markdown 学习笔记，内有数学公式， mermaid 等一些图。

### 原因

- Notepad++ 支持港独。决定不再使用。
- vim 很强大，但是先入为主的原因，还是改不了在 windows 编辑的习惯。
- notepad3 虽然不错，但是不能添加插件，所以不支持 markdown(最近学了 markdown)。
- typora 支持 markdown, 但是有小瑕疵。
- vscode 很强大，但是已经装了很多插件，可用来编辑文本和写 markdown，但启动有点慢。

***综上原因，我需要一款能快速启动且能安装各种插件的文本编辑器。***

### 方法

- 制作 Portable VSCode

    VSCode 有 zip 版，解压后，在解压目录添加一个 data 目录，就成了一个 Portable VSCode 了，之后更新保留 data 目录就行了。

    比如：我将 zip 版 VSCode 解压到此目录 D:\PortableProgramFiles\VSCodeForText，再添加 D:\PortableProgramFiles\VSCodeForText\data, 最后启动。

    - 安装插件

        - Chinese (Simplified) Language Pack for Visual Studio Code

        - Markdown Preview Enhanced
        
            vscode 已经支持 markdown 了，如果还想支持数学公式和 mermaid 等图，则用此插件。直接安装就能使用。

    - 配置 VSCode

        ctrl + shift + p, 搜索 'settings.json'，选择“首选项：打开设置”。

        *这是只是参考，我是用 Unix 换行符的。*

        ```json
        {
            // ### tab 与 indent 设置
            "editor.tabSize": 4,                // 设置 tab 显示空格数
            "editor.useTabStops": true,         // 根据 tabSize 来插入与删除空格
            "editor.insertSpaces": true,        // 按 Tab 时插入空格, 而不是 tab。（如果不想这样可关闭此选项，按 S-tab 来代替）
            "editor.detectIndentation": false,  // 不根据文件内容检测 tabSize 和 insertSpaces
            
            // ### 设置换行符
            "files.eol": "\n",

            // ### [language specific settings](https://code.visualstudio.com/docs/getstarted/settings)
            // 可利用状态栏搜索语言的名称
            "[makefile]": {
                // 使用 makefile 文件能输入 tab
                "editor.insertSpaces": false
            },
            "[bat]": {
                // 使 batch 脚本不会因为中文乱码
                "files.eol": "\r\n"
            },
            
            // ### 关闭推荐
            "extensions.ignoreRecommendations": true,
            "extensions.showRecommendationsOnlyOnDemand": true,
            "update.enableWindowsBackgroundUpdates": false,

            // ### 设置 window title
            // 为了区分原来的 VScode
            "window.title": "${dirty}${activeEditorShort}${separator}${rootName}${separator}${appName} For Text"
        }
        ```

- 添加右键菜单，Edit With VSCodeForText

    *这是按我的解压的路径来的，你要根据自己的实际路径来修改*

    - VSCodeForText 添加右键菜单

        ```
        Windows Registry Editor Version 5.00

        ; ######################################## 在文件上右键 ########################################
        ; EditWithVSCodeForText
        [HKEY_CLASSES_ROOT\*\shell\EditWithVSCodeForText]
        @="Edit with VSCodeForText"
        "Icon"="D:\\PortableProgramFiles\\VSCodeForText\\Code.exe"

        [HKEY_CLASSES_ROOT\*\shell\EditWithVSCodeForText\command]
        @="D:\\PortableProgramFiles\\VSCodeForText\\Code.exe \"%1\""

        ; ######################################## 在目录背景上右键 ########################################
        ; EditWithVSCodeForText
        [HKEY_CLASSES_ROOT\Directory\Background\shell\EditWithVSCodeForText]
        @="Edit with VSCodeForText"
        "Icon"="D:\\PortableProgramFiles\\VSCodeForText\\Code.exe"

        [HKEY_CLASSES_ROOT\Directory\Background\shell\EditWithVSCodeForText\command]
        @="D:\\PortableProgramFiles\\VSCodeForText\\Code.exe"
        ```

    - VSCodeForText 删除右键菜单

        ```
        Windows Registry Editor Version 5.00

        [-HKEY_CLASSES_ROOT\*\shell\EditWithVSCodeForText]
        [-HKEY_CLASSES_ROOT\Directory\Background\shell\EditWithVSCodeForText]
        ```

- 测试 VSCodeForText

    测试的 markdown 文件可在 refer 中找。如果有错则可重装 Markdown Preview Enhanced 试试。

---

最终这个 VSCodeForText 是不影响你当前的 VSCode 的，这样你就拥有了一个能快速启动且能安装各种插件（还是 VSCode 的插件哦）的文本编辑器了。还是跨平台，开源的那种哦。
