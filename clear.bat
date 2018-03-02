@echo off
setlocal enabledelayedexpansion
rem ���浱ǰ·��
set currentPath=%~dp0
rem ���浱ǰ�������̷�
set currentDriver=%~d0
rem ֱ��ʹ���������ļ������·��
%currentDriver%
cd "%currentPath%"

rem ָ��mysql�Ļ�����װ·��
set mysql_basedir=%currentPath%
rem ָ��mysql��binĿ¼
set mysql_bin=%mysql_basedir%\bin

if not exist "%mysql_bin%\mysqld.exe" (
	echo ��ȷ�ϲ���mysql_basedir��û�ҵ�%mysql_bin%\mysqld.exe
	goto success_exit
)

if not exist "%mysql_bin%\mysql.exe" (
	echo ��ȷ�ϲ���mysql_basedir��û�ҵ�%mysql_bin%\mysql.exe
	goto success_exit
)

rem �������
if exist "%currentPath%\UnInstall.bat" (
	call "%currentPath%\UnInstall.bat"
	del /q "%currentPath%\UnInstall.bat"
)

if exist "%currentPath%\Install.bat" (
	del /q "%currentPath%\Install.bat"
)

if exist "%currentPath%\start.bat" (
	del /q "%currentPath%\start.bat"
)

if exist "%currentPath%\stop.bat" (
	del /q "%currentPath%\stop.bat"
)

if exist "%currentPath%\reset_root_password.bat" (
	del /q "%currentPath%\reset_root_password.bat"
)

if exist "%currentPath%\my.ini" (
	del /q "%currentPath%\my.ini"
)

if exist "%currentPath%\my.cnf" (
	del /q "%currentPath%\my.cnf"
)

if exist "%currentPath%data" (
	del /q /s "%currentPath%data"
	rd /q /s "%currentPath%data"
)

:success_exit

@echo off