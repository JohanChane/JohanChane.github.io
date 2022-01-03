" # vim script cheet sheet

" ### 学习语言要了解的基本的东西
"   数据类型
"   传参方式
"   分支，循环
"   函数

" ### 其他
"   变量的剪切
"   用户命令

" ### 使用说明
"   结合我总结的 vim script 或 `help expression` 来学习
"   有 shell 或 python 脚本知识的，学习起来比较方便。

function FunctionForVariable()
    echo "### data type and variable"
    let number = 100
    let str1 = "ABC"
    let str2 = 'XYX'
    let str3 = str1 .. str2

    echo "number = " .. number .. ", str3 = " .. str3
    echo printf("number = %d, str3 = %s\n", number, str3)

    let myfloat = 1.5
    let myblod = 0zFF00.ED01.5DAF
    let mylist = [1, 2, ['a', 'bb']]
    let mylist[2][0] = 3
    let mylist[2][1] = 4
    " key 只能是 string 类型，这能用 number, 应该的解释器会自动转换
    let mydict = {'key1': 100, 200: 'value2', 'list': [2, 3], 'dict': {'key1': 3}}
    let mydict[200] = 'value3'
    let mydict['200'] = 'value4'
    let mydict['list'][0] = 2
    let mydict['list'][1] = 3
    let mydict['dict']['key1'] = 1
    " `echo myfloat` 是可以的，但是要字符拼接时，则要转换为 string 类型
    echo "floatNum = " .. myfloat->string() .. ", myblod = " .. myblod->string() .. ", mylist = " .. mylist->string() .. ", mydict = " .. mydict->string()

    " ### variabl scope
    " b: w: t: g: l: s: a: v: `help variable-scope`
    let b:bufVar = 'b'
    let w:winVar = 'w'
    let t:tabVar = 't'
    let l:locVar = 'l'
    " let s:
    " let a:
    let v:hlsearch = 0
    " 脚本退出后，v:hlsearch 回归原值，不了解修改 vim 变量的应用场景，这里只是为了学习
    echo "v:hlsearch = " .. v:hlsearch

    " ### register, option, environment variable
    " `help expr9, help :let-environment, help :let-register, help :let-option`
    " register, option variable 不能新建只修改已有的
    " register variable
    let @a = 100
    echo "@a = " .. @a
    " option variabl
    let &number = 1
    set number?
    echo "&number = " .. &number
    " environment variable
    let $MYENVIR = 100
    echo "$MYENVIR = " .. $MYENVIR

endfunction

call FunctionForVariable()

" ### substring or sublist
" `help expr-[:]`
function FunctionForSub()
    echo "### substring and sublist"
    " ### var
    let var = 'ABCDE'
    " 截断前面 1 个字符
    echo var[1:]
    " 截断最后 1 个字符
    echo var[:-2]
    " 取前面 1 个字符
    echo var[:0]
    " 取最后 1 个字符
    echo var[-1:]
    " 取中间
    echo var[2:-3]
    " 取第 N 个字符
    echo var[3:3]

    " ### list
    let mylist = [1, 2, 3, 4, 5]
    echo mylist[1:]
    echo mylist[:-2]
    echo mylist[:0]
    echo mylist[-1:]
    echo mylist[2:-3]
    echo mylist[3:3]

    " let mylist1 = mylist[:]          " shallow copy of a List. 浅复制. 有点像 python。可用于传参。

    " 不能对字典操作
    " let mydict = {1: 2}
    " " 不能对字典操作
    " let mydict1 = mydict[:]
    " echo mydict

endfunction

call FunctionForSub()

" ### the way of passing para
" 结论是，blob, list, dict 是传引用，其他是传副本
function FunctionForPassPara(num, float, string, blob, list, dict)
    echo "### the way of passing para"
    let num1 = a:num
    let float1 = a:float
    let string1 = a:string
    let blob1 = a:blob
    let list1 = a:list
    let dict1 = a:dict

    let num1 += 1
    let float1 += 1
    let string1 ..= 'END'
    let blob1 += 0z0001
    let list1[0] ..= 'LEND'
    let dict1['key1'] ..= 'DEND'
endfunction


let num = 1
let float = 1.5
let string = 'string'
let blob = 0z000F
let list = ['list']
let dict = {'key1': 'dict'}
call FunctionForPassPara(num, float, string, blob, list, dict)
" 浅复制
" call FunctionForPassPara(num, float, string, blob->copy(), list->copy(), dict->copy())
" 深复制
" call FunctionForPassPara(num, float, string, blob->deepcopy(), list->deepcopy(), dict->deepcopy())
echo num
echo float
echo string
echo blob
echo list[0]
echo dict['key1']

function FunctionForFlow(num)
    echo "### flow"
    if a:num < 0
        return "less then 0"
    elseif a:num == 0
        return "equal to 0"
    else
        return "greater than 0"
    endif       " 每个 if 都有一个 endif 对应，elseif 没有。
endfunction

echo FunctionForFlow(-1)
echo FunctionForFlow(0)
echo FunctionForFlow(1)

function FunctionForLoop()
    echo "### Loop"
    " for 的 in 之后要接 list or blob
    echo "#### fori"
    for i in [1, [1, 2]]
        echo i
    endfor
    " i 还可以被访问
    "echo i

    " list 的元素全是 list 时，可用此方法
    echo "#### forlist"
    for [x, y] in [[1, 2], [3, 4]]
      echo x .. ", " .. y
    endfor

    echo "#### blob"
    for j in 0zFF00.00FF
        echo j
    endfor

    let k = 1
    let sum = 0
    while k < 10
        let sum += k
        let k += 1
    endwhile
    echo "sum = " sum

    " 还有 break, continue. 没有 switch, do while

endfunction

call FunctionForLoop()

function FunctionForErrHandling()
    echo "### error handling"

    try
        throw "error"
    catch /.*/
    finally
        echomsg "cleanup"
    endtry

    " 只能抛出 string?, 且无法保存 throw 的表达式
    " try
    "     throw 100
    "     throw ['ABC']
    " catch /100/
    "     echo "error"
    " endtry

    " cat vim error
    try
        " 要测试时再打开
        " sleep 100
    catch /^VIM:Interrupt$/         " dos 用 C-break, 实测没有捕获。。。
        echo "catch VIM:Interrupt"
    catch /^Vim\%((\a\+)\)\=:E/	 " catch all Vim errors
        echo "catch all vim error"
    catch /.*/
        echo "catch all error"
    endtry
endfunction

call FunctionForErrHandling()

" ### function
" #### for parameter
function FunctionForPara(para1, para2)
    echo "### function for para"
    " 参数是只读的
    "let a:para1 += 1
    "let a:para2 += 1
    " 参数要加前缀访问
    "let myLocalVar1 = para1 + para2
    let myLocalVar1 = a:para1 + a:para2
    return myLocalVar1

endfunction

echo FunctionForPara(1, 2)

" #### for range
function FunctionForRange() range
    echo "### function for range"
    echo a:firstline .. ", " .. a:lastline
endfunction

" 文件行数必须有 8 行
1, 2call FunctionForRange()

" for dict. 只有加了 dict 才有 self
function FunctionForDict() dict
    echo "### function for dict"
    let self.data[0] = 100
   return self.data        " self 是指调用函数的字典
endfunction

" #### call function
let mydict = {'data': [0, 1, 2, 3], 'len': function("FunctionForDict")}
echo mydict.len()
" echo mydict['len']()

" for Closure
function FunctionForClosure()
    echo "### function for closure"
    let x = 0

    function! Bar() closure
        let x += 1
        return x
    endfunction

    return funcref('Bar')

endfunction

" get funcRef of Bar
let TheBar = FunctionForClosure()

echo TheBar()
echo TheBar()

" #### for script function
function s:FunctionForScriptFunc(x, y)
    echo "### function for script function"
    return a:x + a:y
endfunction

" 不能这样调用，要显示加 `s:`
" call FunctionForScriptFunc()
echo s:FunctionForScriptFunc(1, 2)
fun /FunctionForScriptFunc$
" 脚本函数只能在函数中的使用的实现(其他脚本结束后，还是再调用的)，是将 `s:` 替换成一个前缀，类似 python 的 name mangling。 

" 这里娱乐一下，不要用这种方法调用脚本函数
let scriptFuncName = execute('fun /FunctionForScriptFunc$')
let scriptFuncName = matchstr(scriptFuncName, "<SNR>.*FunctionForScriptFunc")
" 用到了 curly-braces-names
echo {scriptFuncName}(3, 4)

" ### curly-braces-names
function FunctionForCurlyBN()
    echo "### curly braces names"

    let usera="johan"
    let userb="kerry"
    let johanVar=10
    let kerryVar=100
    " 相当于 echo johanVar
    echo {usera}Var
    " 相当于 echo kerryVar
    echo {userb}Var
endfunction

call FunctionForCurlyBN()

" ### user command
function FunctionForUserCmd()
    echo "### user command"
    " var 表示补全 user variables
    com! -nargs=1 -complete=var MyCmd echo <args>
endfunction

call FunctionForUserCmd()

call FunctionForUserCmd()

" 列出 `MyCmd` 开头的用户命令
com MyCmd

" 测试
" :MyCmd <C-d>/tab     " 会补全变量
" :MyCmd 'Hello MyCmd'
