@echo off

goto :commentForDesc

# Add `Right Click Context Menu` for the program(cmd)

:commentForDesc

SETLOCAL EnableDelayedExpansion

:: ### Right Context Menu ��ע���λ����Ϣ
set "regPosForFile=HKEY_CLASSES_ROOT\*\shell"
set "regPosForDir=HKEY_CLASSES_ROOT\Directory\shell"
set "regPosForDirBg=HKEY_CLASSES_ROOT\Directory\Background\shell"

:: ### �û�����
call :help

:: ### get options
:: ����һ����ѭ��
:args
SET param=%~1
SET arg=%~2
if /i "%param%"=="--program" (
    shift /1

    set "program=%arg%"

    shift /1

) else if /i "%param%"=="--icon" (
    shift /1

    set "icon=%arg%"

    shift /1

) else if /i "%param%"=="--menustr" (
    shift /1

    set "menuStr=%arg%"

    shift /1

) else if /i "%param%"=="--regkey" (
    shift /1

    set "regKeyForContextMenu=%arg%"

    shift /1
) else if /i "%param%"=="-h" (
    ::call :help
    exit /b 0
) else if /i "%param%"=="--help" (
    ::call :help
    exit /b 0
) else if /i "%param%"=="" (
    goto :endargs
) else (
    echo unknow option: %param%
    echo.
    call :help
    exit /b 0
)
goto :args
:endargs

echo parsed command:
echo    program=%program%
echo    icon=%icon%
echo    menuStr=%menuStr%
echo    regkey=%regKeyForContextMenu%
echo.

echo ���� command �Ƿ���ȷ������ y ��ʾ��ȷ�������������˳��ű�
echo.
set choice=
set /p "choice=choice: "
echo.

if "%choice%"=="" (
    exit /b 0
)

if not "%choice%"=="y" (
    exit /b 0
)

:: ### �������
call :help

:inputCmd
set cmd=
set /p "cmd=cmd: "
echo.
echo inputed cmd: %cmd%
echo.

if /i "%cmd%"=="help" (
    call :help
    goto :inputCmd
) else if /i "%cmd%"=="exits" (
    :: �˳��ű�
    exit /b 0
) else if /i "%cmd%"=="exit" (
    :: �˳��ն�
    exit 0
) 

:: ### ���� cmd

for /f "delims=; tokens=1-4" %%i in ("%cmd%") do (

    set "operator=%%i"
    set "bMenuForFile=%%j"
    set "bMenuForDir=%%k"
    set "bMenuForDirBg=%%l"
)

set "menuMode=%bMenuForFile% %bMenuForDir% %bMenuForDirBg%"
echo parsed cmd: !operator!;!bMenuForFile!;!bMenuForDir!;%!bMenuForDirBg!
echo. 

if "%operator%"=="add" (

    for /f "delims=; tokens=5-7" %%i in ("%cmd%") do (
        set "paramForFile=%%i"
        set "paramForDir=%%j"
        set "paramForDirBg=%%k"
    )

    echo "parsed params in cmd: !paramForFile!;!paramForDir!;!paramForDirBg!                "
    echo.
)

echo ���� cmd �Ƿ���ȷ������ y ��ʾ��ȷ��������������������
echo.
set choice=
set /p "choice=choice: "
echo.

if "%choice%"=="" (
    goto :inputCmd
)

if not "%choice%"=="y" (
    goto :inputCmd
)


:: ### ִ�� cmd
if "%operator%"=="add" (
    call :addContextMenu %menuMode%
    call :queryContextMenu  %menuMode%
) else if "%operator%"=="del" (
    call :delContextMenu %menuMode%
    call :queryContextMenu  %menuMode%
) else if "%operator%"=="query" (
    call :queryContextMenu %menuMode%
) else (
    echo "unknow operator %operator%"
    echo.

    call :help
    goto :inputCmd
)

pause
goto :inputCmd

exit /b 0

:: #######################################################################
:: ### ��������

:addContextMenu

    if "%1"=="1" (
        if not "!paramForFile!"=="" (
            set "paramForFile=!paramForFile:"=\"!"
        )

        reg add "%regPosForFile%\%regKeyForContextMenu%" /ve        /t "REG_SZ" /d "%menuStr% /f
        reg add "%regPosForFile%\%regKeyForContextMenu%" /v "icon"  /t "REG_SZ" /d "\"%icon%\"" /f


        reg add "%regPosForFile%\%regKeyForContextMenu%\command" /ve /t "REG_SZ" /d "\"%program%\" !paramForFile!" /f
    )

    if "%2"=="1" (
        if not "!paramForDir!"=="" (
            set "paramForDir=!paramForDir:"=\"!"
        )

        reg add "%regPosForDir%\%regKeyForContextMenu%" /ve        /t "REG_SZ" /d "%menuStr%" /f
        reg add "%regPosForDir%\%regKeyForContextMenu%" /v "icon"  /t "REG_SZ" /d "\"%icon%\"" /f

        reg add "%regPosForDir%\%regKeyForContextMenu%\command" /ve /t "REG_SZ" /d "\"%program%\" !paramForDir!" /f

    )

    if "%3"=="1" (
        if not "!paramForDirBg!"=="" (
            set "paramForDirBg=!paramForDirBg:"=\"!"
        )

        reg add "%regPosForDirBg%\%regKeyForContextMenu%" /ve        /t "REG_SZ" /d "%menuStr%" /f
        reg add "%regPosForDirBg%\%regKeyForContextMenu%" /v "icon"  /t "REG_SZ" /d "\"%icon%\"" /f

        reg add "%regPosForDirBg%\%regKeyForContextMenu%\command" /ve /t "REG_SZ" /d "\"%program%\" !paramForDir!" /f

    )

goto :eof

:queryContextMenu
    echo reg info:
    echo    �Ҳ������ʾɾ���ɾ���
    echo.
    if "%1"=="1" (
        echo regInfoForFile:
        reg query "%regPosForFile%\%regKeyForContextMenu%" /s
        echo.
    )

    if "%2"=="1" (
        echo regInfoForDir:
        reg query "%regPosForDir%\%regKeyForContextMenu%" /s
        echo.
    )
    if "%3"=="1" (
        echo regInfoForDirBg:
        reg query "%regPosForDirBg%\%regKeyForContextMenu%" /s
        echo.
    )

goto :eof

:delContextMenu

    if "%1"=="1" (
        reg delete "%regPosForFile%\%regKeyForContextMenu%" /f
    )

    if "%2"=="1" (
        reg delete "%regPosForDir%\%regKeyForContextMenu%" /f
    )

    if "%3"=="1" (
        reg delete "%regPosForDirBg%\%regKeyForContextMenu%" /f
    )

goto :eof

:help
    echo HELP START
    echo.

    echo ���Թ���Ա������У�
    echo.

    echo script usage:
    echo    ^<script^> --program ^<programpPath^> --icon ^<iconPath^> --menustr ^<menustr^> --regkey ^<regkeyForMenu^>
    :: ����հ���
    echo.

    echo cmd usage:
    echo    ����ʹ�� `!;`��param Ϊ��ʱ���ÿո���档
    echo    add;^<file^>;^<dir^>;^<dirgb^>;^<paramForFile^>;^<paramForDir^>;^<paramForDirBg^>
    echo    del;^<file^>;^<dir^>;^<dirgb^>
    echo    query;^<file^>;^<dir^>;^<dirgb^>
    echo    help
    echo    exits: exit script
    echo    exit
    echo.

    echo cmd example:
    echo    add;1;0;0;--param "arg" "%%V"; ; 
    echo    add;1;0;0;/p "arg" "%%V"; ; 
    echo    query;1;0;0
    echo    del;1;0;0
    echo.

    echo example:
    echo    add "Open Cmd Here"
    echo        ContextMenuMgr.bat  --program "C:\Windows\system32\cmd.exe" --icon "C:\Windows\system32\cmd.exe" --menustr "Open Cmd Here" --regkey "OpenCmdHere"
    echo.

    echo        add;0;1;1; ;/s /k "%%V";/s /k"%%V"
    echo        query;0;1;1
    echo        del;0;1;1
    echo.

    echo HELP END
    echo.

goto :eof