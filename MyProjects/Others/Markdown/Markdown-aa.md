# Markdown Tutorial

## References

-   markdown 教程

    -   [Markdown 的创建者编写的原始指南](https://daringfireball.net/projects/markdown/)
    -   <https://markdown.com.cn/>
    -   <https://www.markdownguide.org/>

        -   <https://www.markdownguide.org/cheat-sheet/>

    -   [Markdown style guide](https://github.com/google/styleguide/blob/3591b2e540cbcb07423e02d20eee482165776603/docguide/style.md)
    -   [typora 的 markdown 教程](http://support.typora.io/Markdown-Reference/)
    -   [GFM 语法](https://docs.github.com/en/github/writing-on-github/basic-writing-and-formatting-syntax)
    -   [GFM 规格](https://github.github.com/gfm/)

-   markdown 在线编辑器

    -   [支持所有功能的 Makrdown 编辑器](https://stackedit.io/)

## 基础概念

### markdown 的工作原理

![](https://d33wubrfki0l68.cloudfront.net/75cdd78aba218a9abbfe91d2ba2cf540a7502d8c/553fa/assets/images/process.png)

> markdown 的所有特点几乎都可以等价于 html 的某个特点。所以可以以 html 理解 markdown。 同时 markdown 还可使用 html tags。

### markdown flavors（方言）

*markdown 有基本语法与扩展语法。有些方言并不支持扩展语法，还有可能不同于基本语法。*

GFM: GitHub Flavored Markdown

### markdown 的作用

比 html 更加方便地排版文本。

## Basic Syntax

### 注释

和 html 的注释一样。

<!-- 这是一个注释 -->

### paragraph and newline

first paragraph

second paragraph

first line<br>
second line

first line<br />
second line

### 转义字符 \\

[参考](https://daringfireball.net/projects/markdown/syntax#backslash)

```
\   backslash
`   backtick
*   asterisk
_   underscore
{}  curly braces
[]  square brackets
()  parentheses
#   hash mark
+   plus sign
-   minus sign (hyphen)
.   dot
!   exclamation mark
```

***转义字符在 blockquote 中有效，codeblock 中无效***

### Heading

[refer](https://daringfireball.net/projects/markdown/syntax#header)

Markdown supports two styles of headers, Setext and atx.

```markdown
<!-- Setext-style -->

Heading level 1
===============

Heading level 2
----------------

<!-- Atx-style -->

# Heading level 1

## Heading level 2

### Heading level 3

#### Heading level 4

##### Heading level 5

###### Heading level
```

### List

list content 比 list 多缩进四个空格或一个 tab。list content 显示效果会自动缩进。

列表可以嵌套。

#### 有序列表

1. First item

    list content

1. Second item

#### 无序列表

- First item

    list content

- Second item

#### 兼容 GFM 方言

[refer](https://daringfireball.net/projects/markdown/syntax#list)

以四个空格对齐比较工整。

1.  First item
    -   First item

        list content

            list content

        ```
        list content
        ```

10. Second item

### Blockquote

在 Blockquote 中， ''>" 表示段落分隔符了。应用场景：表示引用别人的东西。

> Dorothy followed her through many of the beautiful rooms in her castle.<br>
> Dorothy followed her through many of the beautiful rooms in her castle.

> Dorothy followed her through many of the beautiful rooms in her castle.
>> Dorothy followed her through many of the beautiful rooms in her castle.

<!-- 更好 -->
> Dorothy followed her through many of the beautiful rooms in her castle.
> >
> > Dorothy followed her through many of the beautiful rooms in her castle.

[example of Blockquote](https://mermaid-js.github.io/mermaid/#/)

-   [Blockquote 可以不表示缩进, 不是进一步解释](https://mermaid-js.github.io/mermaid/#/?id=about-mermaid)
-   [Blockquote 表示缩进](https://mermaid-js.github.io/mermaid/#/?id=appreciation)

### Code

在 \`\` 中放置代码。

At the command prompt, type `nano`.<br>

#### 在 Code 中输出反引号

``Use `code` in your Markdown file.``

`` `code` ``

#### Others

使 URL 无效<br>

`http://www.example.com`

### Code Block

缩进四个空格或一个 tab 即可。

    <html>
        <head>
        </head>
    </html>

### Link

有两种风格

-   `\[<linkString>\](<url> ["<title>"])`
-   `\[<linkString>\]\[<label>\]; [<label>]: \<<url>\> ["<title>"]`

    label 是全局的，同名不会被覆盖，只会使用第一个匹配的 label。

for example

My favorite search engine is [Duck Duck Go](https://duckduckgo.com).<br>
My favorite search engine is [Duck Duck Go](https://duckduckgo.com "title").

[hobbit-hole][1]<br>
[hobbit-hole][id]<br>

[1]: https://en.wikipedia.org/wiki/Hobbit#Lifestyle
[1]: <https://en.wikipedia.org/wiki/Hobbit#Lifestyle> "Hobbit lifestyles"
[id]: <https://en.wikipedia.org/wiki/Hobbit#Lifestyle> "Hobbit lifestyles"

link 中的空格 [link](https://www.example.com/my%20great%20page)

#### 页内跳转

[jump to anchor](https://stackoverflow.com/questions/5319754/cross-reference-named-anchor-in-markdown/7335259#7335259)

###### <a name="anchorName"></a> headName
###### headName


<br /><br /><br /><br /><br />
<br /><br /><br /><br /><br />
<br /><br /><br /><br /><br />
<br /><br /><br /><br /><br />
<br /><br /><br /><br /><br />
<br /><br /><br /><br /><br />
<br /><br /><br /><br /><br />
<br /><br /><br /><br /><br />

[jump to head](#headname)

<!-- 这个的方式比较好维护，但是不方便。 -->
[jump to anchor](#anchorName)

#### URLs and Email Addresses

软件对待 \<\> 之中的文本为 URL OR Email Address 而不是纯文本。

<https://www.markdownguide.org><br>
<fake@example.com>

### 插入图片

title 是可选的。

```markdown
![alt text](<相对路径或绝对路径> "title")

![](https://img.shields.io/github/stars/pandao/editor.md.svg)
```

### Emphasis（加粗或变斜）

I just love **bold text**.
Italicized text is the *cat's meow*.
This text is ***really important***.

### 水平分隔线

注意：在单独在一个段落中。

---

## Extended Syntax

### 表格

| Syntax      | Description |
| ----------- | ----------- |
| Header      | Title       |
| Paragraph   | Text        |

| Syntax    | Description                |
| ----      | -------------------------- |
| Header    | Title                      |
| Paragraph | Text                       |

| Syntax    | Description | Test Text   |
| :---      | :----:      | ---:        |
| Header    | Title       | Here's this |
| Paragraph | Text        | And more    |

| Function name | Description                    |
| ------------- | ------------------------------ |
| `help()`      | Display the help window.       |
| `destroy()`   | **Destroy your computer!**     |

### Fenced Code Blocks

如果使用缩进四个空格或一个 tab 的方式不方便则可使用此方法。

```
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```

#### Syntax Highlighting

[language-support of github markdown](https://docs.github.com/en/github/writing-on-github/working-with-advanced-formatting/creating-and-highlighting-code-blocks#syntax-highlighting)

[highlight keyword of github markdown](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml)

[language-support](https://rdmd.readme.io/docs/code-blocks#language-support)

支持多种语言。

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```

### 脚注

*脚注只会向下寻找不会向上寻找*

Here's a simple footnote,[^1] and here's a longer one.[^bignote]

[^1]: This is the first footnote.
[^bignote]: Here's one with multiple paragraphs and code.
    Indent paragraphs to include them in the footnote.
    `{ my code }`
    Add as many paragraphs as you like.

### 标题 ID

可为标题添加 ID（有些 markdown 解析器不支持）。可用于 CSS 渲染。

```
### My Great Heading {#custom-id}
```

### Definition Lists

First Term
: This is the definition of the first term.

Second Term
: This is one definition of the second term.
: This is another definition of the second term.

### Strikethrough

~~The world is flat.~~ We now know that the world is round.

### Task Lists

- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media

### Emoji

***`:` 暂时无法转义。***

> [解决办法](https://stackoverflow.com/a/50662126)

Gone camping! :tent: Be back soon.<br>
That is so funny! :joy:
