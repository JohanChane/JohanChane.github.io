:: ���ļ�����ӦΪ cp936(GBK), ���� windows ���з�

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

:: ### Escape Characters, Delimiters, Quotes��˫���ţ�
:: #### Escape Characters
call :funcForEscape
:: #### Delimiters
call :funcForDelimite
:: #### Quotes
call :funcForQuote

:: ### ����
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

:: �˳��ű�
exit /b 0

:: ### function definitions
:: ####################################################################################

:funcForEscape
    echo ### funcForEscape

    :: ### `^` �� echo ���������ַ�
    echo ^^ ^>

    :: ### `%%` ת��ٷֺ�
    :: �������Ϊ `echo %`
    echo %%
    :: �������Ϊ `for %v in (aa) do echo %v`
    for %%v in (aa) do (echo %%v)

    :: �������Ϊ `for %v in (aa) do echo %v %%`
    for %%v in (aa) do (echo %%v %%%%)
    :: ������� `%%v` Ӧ�������ȱ�ݰ�
    :: for %%v in (aa) do echo %%v %%%%v

    :: ### `""` ת������
    echo "### quote"
    echo ^" | find """" 

    :: �������Ϊ `echo % | find "%"`
    echo %% | find "%%"

    :: ### `\<specialChar>`
    echo \ | findstr /R \\

    :: ### `^^!`
    echo ^!
    SETLOCAL EnableDelayedExpansion
    :: `^^!` ת��Ϊ `!`
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
    :: �������Ϊ `Set "_var=second" & Echo first`
    Set "_var=second" & Echo %_var%
    set "_var="

    SETLOCAL EnableDelayedExpansion
    :: `^^!` ת��Ϊ `!`
    set "_var="
    Set "_var=first"
    :: �������Ϊ `Set "_var=second" & Echo first second`
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
    :: ֧�� pattern
    echo %var:*C=%

    set "var=A B C D E"
    :: ɾ���ո�
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

    :: �г���ǰ·�����ļ�(������Ŀ¼)
    for  %%v in (.\*) do (echo %%v)
    :: �г���ǰ·����Ŀ¼
    for /d  %%v in (.\*) do (echo %%v)

    :: �г���ǰ·��������Ŀ¼�µ��ļ�(������Ŀ¼)
    for /r ".\"  %%v in (*) do (echo %%v)
    :: �г���ǰ·��������Ŀ¼�µ�Ŀ¼
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

    :: ����ļ�������Ŀ¼���Ƿ����
    type nul > "testfile"
    if exist "testfile" echo true
    del "testfile"

    mkdir "testdir"
    if exist "testdir" echo true
    rmdir "testdir"

    :: ���Ŀ¼�Ƿ����
    mkdir "testdir"
    if exist "testdir\" echo true
    rmdir "testdir"

    :: ����ļ�������Ŀ¼���Ƿ����
    echo. > "txtfile"
    if exist "txtfile" (if not exist "txtfile\" (echo true))
    del "txtfile"

goto :eof


:funcForLoopCtrl
    echo ### funcForLoopCtrl

    for %%v in (aa bb) do echo %%v
    :: ���������
    for %%v in ("aa" "bb") do echo %%v

    :: ### ���ɵȲ�����
    :: `FOR /L %%parameter IN (start,step,end) DO command `
    :: output: 0, 2, 4 ... 10
    for /l %%v in (0, 2, 10) do echo %%v

    :: ### `for /f`
    :: �г������ļ�������Ŀ¼��
    for /f %%v in ('dir /s /b') do echo %%v

    for /f "tokens=1,2,3" %%i in ("AA BB CC") do (echo %%i %%j %%k)
    for /f "delims=, tokens=1,2,3" %%i in ("AA,BB,CC") do (echo %%i %%j %%k)
    for /f "delims=, tokens=1-3" %%i in ("AA,BB,CC") do (echo %%i %%j %%k)
    :: �Ǻű�ʾȡʣ����ַ�
    for /f "delims=, tokens=1,*" %%i in ("AA,BB,CC") do (echo %%i %%j)

    :: ����� `/f` ���ļ���û������ʱ�����ȡ�ļ�
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