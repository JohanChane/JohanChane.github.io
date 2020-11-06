:: MAC16进制，共12*16bit = 24Byte
:: getmac /v /fo list	查看MAC
:: wmic nic where 'netconnectionid like "以太网%%"' get caption	查看Connection Name为"以太网%%"的网络
@echo off
@echo 请以管理员身份运行！
set "mac=74E6E206AA6E"
@wmic nic where 'netconnectionid like "以太网%%"' get caption
for /f "skip=1 delims=[]" %%i in ('wmic nic where 'netconnectionid like "以太网%%"' get caption') do (
	set numnet=%%i
	goto A
)
:A
@echo 请确认是否是上面数字的后4位：%numnet:~-4%
pause
set regpath=HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%numnet:~-4%
reg add "%regpath%" /v "NetworkAddress" /d "%mac%"
@echo 请确认路径:%regpath%
pause
reg delete "%regpath%" /v "NetworkAddress"
@echo 如果成功修改，请重启网卡
pause
