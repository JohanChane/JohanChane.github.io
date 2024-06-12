# Markdown 的数学公式

markdown 支持完整 LaTex 数学公式语法

### References

-   [帮助:数学公式](https://zh.wikipedia.org/wiki/Help:%E6%95%B0%E5%AD%A6%E5%85%AC%E5%BC%8F)
-   [LaTeX公式手册(全网最全)](https://www.cnblogs.com/1024th/p/11623258.html)
-   [LaTeX 公式篇](https://zhuanlan.zhihu.com/p/110756681)

## mathjax

[mathjax 支持 LaTeX](https://zh.wikipedia.org/wiki/MathJax)

$$
\mathbf{V}_1 \times \mathbf{V}_2 =  \begin{vmatrix}
\mathbf{i} & \mathbf{j} & \mathbf{k} \\
\frac{\partial X}{\partial u} &  \frac{\partial Y}{\partial u} & 0 \\
\frac{\partial X}{\partial v} &  \frac{\partial Y}{\partial v} & 0 \\
\end{vmatrix}
$$

### 基础

LATEX 的数学公式有两种：行中公式和独立公式（行间公式）。行中公式放在文中与其它文字混编，独立公式单独成行。

行中公式可以用如下方法表示：

    $ 数学公式 $

独立公式可以用如下方法表示：

    $$ 数学公式 $$

### 常用

*个人的风格*

空格

$$
A \quad A \qquad A
$$

`&`用于分隔列，`\`用于分隔行

$$
\begin{bmatrix}
1 & 2 & \cdots \\
67 & 95 & \cdots \\
\vdots  & \vdots & \ddots \\
\end{bmatrix}
$$

$$
D(x) = \begin{cases}
\lim\limits_{x \to 0} \frac{a^x}{b+c}, & x<3 \\
\pi, & x=3 \\
\int_a^{3b}x_{ij}+e^2 \mathrm{d}x,& x>3 \\
\end{cases}
$$

运算符

$$ +, -, \times, \div $$

> 字母之间相乘可用

$$ x \cdot y $$

关系符号（`\equiv` 表示恒等于）

$$ =, \neq, \equiv, \not\equiv $$
$$ <, \nless, >, \ngtr, \leq, \lneq, \geq, \gneq $$
$$ \approx $$

逻辑符号

$$ \forall, \exists $$
$$ \therefore, \because $$
$$ \or, \and $$
$$ \neg $$

分式

$$ f(x) = \frac{x}{y} $$

上下标

$$ X_{n}^{2} $$
$$ X_n^2 $$

> 前置上下标

$$ {}_1^2\!X_3^4 $$

根号

$$ \sqrt{x} $$
$$ \sqrt[n]{x} $$

积分、极限、求和、乘积

$$ \lim_{x \to \infty} x^2_{22} - \int_{1}^{5}x\mathrm{d}x + \sum_{n=1}^{20} n^{2} = \prod_{j=1}^{3} y_{j}  + \lim_{x \to -2} \frac{x-2}{x} $$

标准函数

$$ \ln c, \lg d, \log_{10} f $$
$$ \sin a, \cos b, \tan c, \cot d, \sec e, \csc f $$
$$ \arcsin a, \arccos b, \arctan c $$
$$ \arccot d, \arcsec e, \arccsc f $$
$$ \left\vert s \right\vert $$
$$ \min(x,y), \max(x,y) $$

方程组

$$
\begin{cases}
3x + 5y +  z \\
7x - 2y + 4z \\
-6x + 3y + 2z
\end{cases}
$$

向量

$$ \vec{a} + \overrightarrow{AB} + \overleftarrow{DE} $$

模算数

$$ s_k \equiv 0 \pmod{m} $$

$$ a \bmod b $$

矩阵

$$
\begin{bmatrix}
0      & \cdots & 0      \\
\vdots & \ddots & \vdots \\
0      & \cdots & 0
\end{bmatrix}
$$

上下划线

$$ \overline{x + y} $$
$$ \underline{x + y} $$

上下括号

$$ \begin{matrix} 5050 \\ \overbrace{ 1+2+\cdots+100 } \end{matrix} $$
$$ \begin{matrix} \underbrace{ a+b+\cdots+z } \\ 26 \end{matrix} $$

三圆点

$$ x_{1},x_{2},\ldots,x_{5}  \quad x_{1} + x_{2} + \cdots + x_{n} $$
$$
\begin{bmatrix}
0      & \cdots & 0      \\
\vdots & \ddots & \vdots \\
0      & \cdots & 0
\end{bmatrix}
$$

希腊字母

$$ \Delta \Theta $$
$$ \Pi $$
$$ \Sigma \Phi \Psi \Omega $$
$$ \alpha \beta \gamma \delta \epsilon \eta \theta $$
$$ \lambda \mu \nu \omicron \xi \pi $$
$$ \sigma \tau \upsilon \phi \psi \omega $$
$$ \varepsilon $$
$$ \vartheta \varphi $$

箭头

$$ \Rrightarrow, \Lleftarrow $$
$$ \Rightarrow, \Leftarrow $$
$$ \rightarrow, \leftarrow $$
