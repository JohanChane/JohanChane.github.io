:: 该文件编码应为 cp936(GBK), 且是 windows 换行符

@echo off

goto :commentForDesc

# Windows Batch Scripting

### Refers

:commentForDesc

setlocal EnableDelayedExpansion

call :funcForEscape
call :funcForBranchCtrl
call :funcForLoopCtrl

goto :commentForCallFunc

:: ### Escape Characters, Delimiters, Quotes（双引号）
:: #### Escape Characters
call :funcForEscape
:: #### Delimiters
call :funcForDelimite
:: #### Quotes
call :funcForQuote

:: ### 变量
call :funcForVar

:: #### Parameter Expansion
call :funcForParamExpansion "C:\directory\filename.extend"
call :funcForParamExpansion ".\filename.extend"
call :funcForParamExpansion "filename"

:: for `%~$PATH:1`
call :funcForParamExpansion1 "System32"
call :funcForParamExpansion1 "C:\Windows\System32"
call :funcForParamExpansion1 ".\System32"

:: #### Delayed Expansion
call :funcForDelayedExpansion

:: ### substring and replace variable content
call :funForVarSubstr
call :funForVarReplace

:: ### Conditional Execution
call :funcForCondExec

:: ### Match filenames with Wildcards
call :funcForWildcards


:: ### Branch Control
call :funcForBranchCtrl
:: ### Loop Control
call :funcForLoopCtrl

:: ### functions
call :funcForFunction aa bb
echo %ret%

call :funcForFuncLocal

:commentForCallFunc

:: 退出脚本
exit /b 0

:: ### function definitions
:: ####################################################################################

:funcForEscape
    echo ### funcForEscape

    :: ### `^` 在 echo 中是特殊字符
    echo ^^ ^>

    :: ### `%%` 转义百分号
    :: 最终语句为 `echo %`
    echo %%
    :: 最终语句为 `for %v in (aa) do echo %v`
    for %%v in (aa) do (echo %%v)

    :: 最终语句为 `for %v in (aa) do echo %v %%`
    for %%v in (aa) do (echo %%v %%%%)
    :: 不能输出 `%%v` 应该是设计缺陷吧
    :: for %%v in (aa) do echo %%v %%%%v

    :: ### `""` 转义引号
    echo "### quote"
    echo ^" | find """" 

    :: 最终语句为 `echo % | find "%"`
    echo %% | find "%%"

    :: ### `\<specialChar>`
    echo \ | findstr /R \\

    :: ### `^^!`
    echo ^!
    SETLOCAL EnableDelayedExpansion
    :: `^^!` 转义为 `!`
    :: echo ^!
    echo ^^!
    ENDLOCAL

goto :eof

:funcForDelimite
    echo ### funcForDelimite

    for %%v in (aa,bb) do echo %%v
    for %%v in (aa;bb) do echo %%v
    for %%v in (aa=bb) do echo %%v
    for %%v in (aa bb) do echo %%v
    for %%v in (aa   bb) do echo %%v

goto :eof

:funcForQuote
    echo ### funcForQuote

    if "str"=="str" echo true
goto :eof

:funcForVar
    echo ### funcForVar

    set "var=ABC"
    echo %var%

    :: unset var
    set | find "var"
    set "var="
    set | find "var"

goto :eof


:funcForVar
    echo ### funcForVar

    set "var=ABC"
    echo %var%

    :: unset var
    set | find "var"
    set "var="
    set | find "var"

goto :eof


:funcForParamExpansion
    echo ### funcForParamExpansion

    echo f %~f1
    echo d %~d1
    echo p %~p1
    echo n %~n1
    echo x %~x1
    echo %~1
    echo dp %~dp1
    echo dp %~nx1
    echo dp %~dpnx1

goto :eof

:: for `%~$PATH:1`
:funcForParamExpansion1
    echo ### funcForParamExpansion1

    echo %PATH%
    echo %~1
    echo %~$PATH:1

goto :eof

:funcForParamExpansion
    echo ### funcForParamExpansion

    echo f %~f1
    echo d %~d1
    echo p %~p1
    echo n %~n1
    echo x %~x1
    echo %~1
    echo dp %~dp1
    echo dp %~nx1
    echo dp %~dpnx1

goto :eof


:funcForDelayedExpansion
    echo ### funcForDelayedExpansion

    set "_var="
    Set "_var=first"
    :: 最终语句为 `Set "_var=second" & Echo first`
    Set "_var=second" & Echo %_var%
    set "_var="

    SETLOCAL EnableDelayedExpansion
    :: `^^!` 转义为 `!`
    set "_var="
    Set "_var=first"
    :: 最终语句为 `Set "_var=second" & Echo first second`
    Set "_var=second" & Echo %_var% !_var!
    set "_var="
    SETLOCAL DisableDelayedExpansion

goto :eof

:funForVarSubstr
    echo ### funForVarSubstr

    set "var=ABCDE"
    echo %var:~1%
    echo %var:~0,-1%
    echo %var:~0,1%
    echo %var:~-1,1%
    echo %var:~2,1%

goto :eof

:funForVarReplace
    echo ### funForVarReplace

    set "var=ABCDE"
    echo %var:ABC=abc%
    :: 支持 pattern
    echo %var:*C=%

    set "var=A B C D E"
    :: 删除空格
    echo %var: =%

goto :eof



:funcForCondExec
    echo ### funcForCondExec

    echo aa & echo bb
    echo aa && echo bb
    echo aa || echo bb

goto :eof


:funcForWildcards
    echo ### funcForWildcards

    :: 列出当前路径的文件(不包含目录)
    for  %%v in (.\*) do (echo %%v)
    :: 列出当前路径的目录
    for /d  %%v in (.\*) do (echo %%v)

    :: 列出当前路径及其子目录下的文件(不包含目录)
    for /r ".\"  %%v in (*) do (echo %%v)
    :: 列出当前路径及其子目录下的目录
    for /d /r ".\"  %%v in (*) do (echo  %%v)

goto :eof


:funcForBranchCtrl
    echo ### funcForBranchCtrl

    if 0 equ 1 (
        type nul
    ) else if "str"=="str" (
        type nul
    ) else (
        type nul
    )

    if not 0 equ 1 echo true
    if "str"=="str" echo true

    :: 检测文件（包含目录）是否存在
    type nul > "testfile"
    if exist "testfile" echo true
    del "testfile"

    mkdir "testdir"
    if exist "testdir" echo true
    rmdir "testdir"

    :: 检测目录是否存在
    mkdir "testdir"
    if exist "testdir\" echo true
    rmdir "testdir"

    :: 检测文件（不是目录）是否存在
    echo. > "txtfile"
    if exist "txtfile" (if not exist "txtfile\" (echo true))
    del "txtfile"

goto :eof


:funcForLoopCtrl
    echo ### funcForLoopCtrl

    for %%v in (aa bb) do echo %%v
    :: 会输出引号
    for %%v in ("aa" "bb") do echo %%v

    :: ### 生成等差数列
    :: `FOR /L %%parameter IN (start,step,end) DO command `
    :: output: 0, 2, 4 ... 10
    for /l %%v in (0, 2, 10) do echo %%v

    :: ### `for /f`
    :: 列出所有文件（包含目录）
    for /f %%v in ('dir /s /b') do echo %%v

    for /f "tokens=1,2,3" %%i in ("AA BB CC") do (echo %%i %%j %%k)
    for /f "delims=, tokens=1,2,3" %%i in ("AA,BB,CC") do (echo %%i %%j %%k)
    for /f "delims=, tokens=1-3" %%i in ("AA,BB,CC") do (echo %%i %%j %%k)
    :: 星号表示取剩余的字符
    for /f "delims=, tokens=1,*" %%i in ("AA,BB,CC") do (echo %%i %%j)

    :: 如果有 `/f` 且文件名没有引号时，会读取文件
    echo AA,BB,CC> txtfile
    for /f "delims=, tokens=1,2,3" %%i in (txtfile) do (echo %%i %%j %%k)
    del txtfile

goto :eof


:funcForFunction
    echo ### funcForFunction

    echo %*
    echo %0, %1, %2

    set "ret=retValue"

goto :eof


:funcForFuncLocal
    echo ### funcForFuncLocal

    set "var=10"
    setlocal
    set "var=100"
    endlocal

    echo %var%

goto :eof