@echo off
setlocal enabledelayedexpansion
rem ���浱ǰ·��
set currentPath=%~dp0
rem ���浱ǰ�������̷�
set currentDriver=%~d0
rem ֱ��ʹ���������ļ������·��
%currentDriver%
cd "%currentPath%"

echo currentPath=%currentPath%

rem *****************************************************************************************************
rem * mysql5.7.21�²���ͨ����https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.21-winx64.zip
rem * 1. �ӵ�ǰĿ¼��ʼ�����ݿ�
rem * 2. ����Ĭ������Ϊroot123
rem *****************************************************************************************************

rem ָ��mysql�Ļ�����װ·��
set mysql_basedir=%currentPath%

rem *****************************************************************************************************
rem * �Ѳ���mysql_basedirĩβ��б��ȥ�� begin
rem *****************************************************************************************************
set /a n = 0
set str=%mysql_basedir%
:next_str_cal
if not "x%str%"=="x" (
	set /a n=n+1
	set curChar=%str:~0,1%
	set "str=%str:~1%"
	goto next_str_cal
)

set newstr=%mysql_basedir%
echo newstr=%newstr%
set new_basedir=
set /a i = 0
if not "x%curChar%"=="x\" (
	set new_basedir=%mysql_basedir%
)
if "x%curChar%"=="x\" (
	:next_str_cat
	if not "x%newstr%"=="x" (
		set /a i=i+1
		set cur_Char=%newstr:~0,1%
		set "newstr=%newstr:~1%"
		if %i% LSS %n% (
			set new_basedir=%new_basedir%%cur_Char%
		)
		goto next_str_cat
	)
)
set mysql_basedir=%new_basedir%
echo mysql_basedir=%mysql_basedir%
rem *****************************************************************************************************
rem * �Ѳ���mysql_basedirĩβ��б��ȥ�� end
rem *****************************************************************************************************


rem ָ��mysql��binĿ¼
set mysql_bin=%mysql_basedir%\bin
rem ָ��������ݵ�Ŀ¼(ע�������һ�������ڵĿ�Ŀ¼)
set mysql_data=%mysql_basedir%\data
rem ָ���Զ����ɵ�mysql�����ļ�
set mysql_ini_file=%currentPath%my.ini
set mysql_cnf_file=%mysql_basedir%\my.cnf
set mysql_install_bat=%currentPath%\Install.bat
set mysql_uninstall_bat=%currentPath%\UnInstall.bat
set mysql_start_bat=%currentPath%\start.bat
set mysql_stop_bat=%currentPath%\stop.bat
set mysql_reset_root_password_bat=%currentPath%\reset_root_password.bat


rem ** ���������Ҫ���ǲ��� **
set mysql_data=%currentPath%data

if not exist "%mysql_bin%\mysqld.exe" (
	echo ��ȷ�ϲ���mysql_basedir��û�ҵ�%mysql_bin%\mysqld.exe
	goto success_exit
)

if not exist "%mysql_bin%\mysql.exe" (
	echo ��ȷ�ϲ���mysql_basedir��û�ҵ�%mysql_bin%\mysql.exe
	goto success_exit
)

rem ��ʾ��ǰmysql�汾��
"%mysql_bin%\mysql.exe" --version

if exist "%mysql_data%" (
	echo ��ȷ�ϲ���mysql_data=%mysql_data%��������һ�������ڵĿ�Ŀ¼����ǰ��⵽Ŀ¼�Ѿ����ڣ�
	goto success_set
)

rem --initialize-insecure ��rootû����ĳ�ʼ��
rem --initialize ���ɵ�root�����������ʲô����
echo "%mysql_bin%\mysqld.exe" --initialize-insecure --user=mysql --basedir="%mysql_basedir%" --datadir="%mysql_data%"
"%mysql_bin%\mysqld.exe" --initialize-insecure --user=mysql --basedir="%mysql_basedir%" --datadir="%mysql_data%"
if %errorlevel% neq 0 (
	echo ��ʼ������Ŀ¼"%mysql_data%"����
	goto success_exit
)

rem SET PASSWORD FOR 'some_user'@'some_host' = PASSWORD('password');
rem SET PASSWORD FOR 'root'@'%' = PASSWORD('root123');
rem ����ʱ����--skip-grant-tables�����ͻ�����������֤�����Բ������ݣ���������������
rem �޸������ã�mysqladmin -u root -h 127.0.0.1 password "root123"
echo "%mysql_bin%\mysqld.exe" --defaults-file="%mysql_ini_file%" --console

:success_set

rem ***************************************************************************
rem ����ini·������ini_mysql_basedir
set replaceValue=
set curChar=
set newStrValue=%mysql_basedir%
:next_mysql_basedir
if not "%newStrValue%"=="" (
	set curChar=%newStrValue:~0,1%
	if "%curChar%"=="\" ( 
		set replaceValue=%replaceValue%\\
	)
	if not "%curChar%"=="\" (
		set replaceValue=%replaceValue%%curChar%
	)
    set newStrValue=%newStrValue:~1%
    goto next_mysql_basedir
)
if "%curChar%"=="\" ( 
	set curChar=\\
)
if not "%curChar%"=="\" (
	set replaceValue=%replaceValue%%curChar%
)
set ini_mysql_basedir=%replaceValue%
echo ini_mysql_basedir=%replaceValue%

rem ***************************************************************************
rem ����ini·������ini_mysql_data
set replaceValue=
set curChar=
set newStrValue=%mysql_data%
:next_mysql_data
if not "%newStrValue%"=="" (
	set curChar=%newStrValue:~0,1%
	if "%curChar%"=="\" ( 
		set replaceValue=%replaceValue%\\
	)
	if not "%curChar%"=="\" (
		set replaceValue=%replaceValue%%curChar%
	)
    set newStrValue=%newStrValue:~1%
    goto next_mysql_data
)
if "%curChar%"=="\" ( 
	set curChar=\\
)
if not "%curChar%"=="\" (
	set replaceValue=%replaceValue%%curChar%
)
set ini_mysql_data=%replaceValue%
echo ini_mysql_data=%replaceValue%


rem ���������ļ�my.cnf
echo [client] > "%mysql_cnf_file%"
echo port=3306 >> "%mysql_cnf_file%"
echo character-sets-dir=%ini_mysql_basedir%\\share\\charsets >> "%mysql_cnf_file%"
echo default-character-set=utf8 >> "%mysql_cnf_file%"

rem ���������ļ�my.ini
echo [client] > "%mysql_ini_file%"
echo default-character-set=utf8 >> "%mysql_ini_file%"
echo [mysqld] >> "%mysql_ini_file%"
echo # set basedir to your installation path >> "%mysql_ini_file%"
echo basedir=%ini_mysql_basedir% >> "%mysql_ini_file%"
echo # set datadir to the location of your data directory >> "%mysql_ini_file%"
echo datadir=%ini_mysql_data% >> "%mysql_ini_file%"
echo character-set-server=utf8 >> "%mysql_ini_file%"

rem ����ע�ᰲװwindows����������Install.bat
echo "%mysql_bin%\mysqld.exe" --install mysql > "%mysql_install_bat%"

rem ����ж�ط���������
echo net stop mysql > "%mysql_uninstall_bat%"
echo "%mysql_bin%\mysqld.exe" --remove >> "%mysql_uninstall_bat%"

rem ������������������
echo net start mysql > "%mysql_start_bat%"

rem ����ֹͣ����������
echo net stop mysql > "%mysql_stop_bat%"

rem ������������������
echo "%mysql_bin%\mysqladmin.exe" -u root -h 127.0.0.1 password "root123" > "%mysql_reset_root_password_bat%"


echo ������������"%mysql_bin%\mysqld.exe" --defaults-file="%mysql_ini_file%" --console
echo �޸�root���룺"%mysql_bin%\mysqladmin.exe" -u root -h 127.0.0.1 password "root123"
echo ���������ӣ�"%mysql_bin%\mysql.exe" -uroot -proot123 -h 127.0.0.1
echo ��װ����install.bat
echo ж�ط���uninstall.bat
echo ��������start.bat
echo ֹͣ����stop.bat
echo ����root���룺reset_root_password.bat

call "%mysql_install_bat%"
call "%mysql_start_bat%"
call "%mysql_reset_root_password_bat%"

ping 127.0.0.1 -n 3 > nil

:success_exit

@echo off

echo show variables like "%char%"; | "%mysql_bin%\mysql.exe" -uroot -proot123 -h 127.0.0.1