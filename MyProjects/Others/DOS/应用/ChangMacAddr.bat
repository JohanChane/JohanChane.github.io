:: MAC16���ƣ���12*16bit = 24Byte
:: getmac /v /fo list	�鿴MAC
:: wmic nic where 'netconnectionid like "��̫��%%"' get caption	�鿴Connection NameΪ"��̫��%%"������
@echo off
@echo ���Թ���Ա������У�
set "mac=74E6E206AA6E"
@wmic nic where 'netconnectionid like "��̫��%%"' get caption
for /f "skip=1 delims=[]" %%i in ('wmic nic where 'netconnectionid like "��̫��%%"' get caption') do (
	set numnet=%%i
	goto A
)
:A
@echo ��ȷ���Ƿ����������ֵĺ�4λ��%numnet:~-4%
pause
set regpath=HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%numnet:~-4%
reg add "%regpath%" /v "NetworkAddress" /d "%mac%"
@echo ��ȷ��·��:%regpath%
pause
reg delete "%regpath%" /v "NetworkAddress"
@echo ����ɹ��޸ģ�����������
pause
