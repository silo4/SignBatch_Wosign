@echo off
title ����Ǵ���ǩ������--Wosign���
color 06
echo          ��������������  ����  ��������������
echo.
echo             ������Ӧ��΢��signtool���ߣ���������Ϊ�����������ǩ��
echo.
echo               ����������ǰ�᣺��Wosign�����֤�鶼��ȷ������MS OS
echo.
echo               �����֤�鵼�뼰ǩ�����軹��ο����µ�ַ
echo.
echo               https://www.wosign.com/support/SignTool_guide.htm           
echo.
echo          �������������������������������
echo.
echo.
echo.
echo  ���������ʼ...
pause >nul
cls

rem  ����Ƿ���signtool.exe
echo.
if not exist tool\signtool.exe (
   echo.
   echo.
   echo  �Բ����Ҳ�������signtool.exe
   goto end
)

echo.
echo         ��������������  ��ʼǩ��  ��������������
echo.
echo.
echo.

:setinput
if exist tool\filelist.txt del tool\filelist.txt /q /s >nul
echo.
echo  �������ǩ���ĳ����������ڵ��ļ���·��
echo.
echo  ��ʾ����ֱ����ק����
echo.

echo.
set input=:
set /p input=        ����·����
set "input=%input:"=%"
if "%input%"==":" goto setinput

if not exist "%input%" (
echo.
echo      ..........��Ŷ��·��������..........
echo.
goto setinput
)

rem �ж����ļ��л����ļ�
pushd "%input%">nul 2>nul && (popd & set what=dir)||(set what=file)

goto is%what%

rem ���ļ�
:isfile
cls
echo.
Echo    ---------�����ļ�ǩ����ʼ----------
tool\signtool.exe  sign /v /s my /t http://timestamp.wosign.com/timestamp "%input%"
echo.
:choice1
echo.
Echo    ---------�����ļ�ǩ�����(0�˳���1����ǩ��)----------
echo.
set choice1=
set /p choice1=                     ��ѡ��(0/1):
if /i "%choice1%"=="0" goto end
if /i "%choice1%"=="1" goto setinput
Echo          �����ѡ��
goto choice1

:isdir
cls
for /r "%input%" %%i in (*.exe *.dll *.cab *.ocx *.mui *.vbs *.msi) do echo %%~fi>>tool\filelist.txt
echo.
echo    -----------��������ǩ����ʼ-------------
if not exist tool\filelist.txt (
	echo �Բ����б�����ʧ��
	goto end
)

for /f "delims=" %%1 in (tool\filelist.txt) do tool\signtool.exe  sign /v /s my /t http://timestamp.wosign.com/timestamp "%%~1"
echo.
:choice2
echo.
echo     ----------��������ǩ�����(0�˳��� 1����ǩ��)-------------
echo.    
set choice2=
set /p choice2=                     ��ѡ��(0/1):
if /i "%choice2%"=="0" goto end
if /i "%choice2%"=="1" goto setinput
Echo          �����ѡ��
goto choice2

:end
echo.
echo.
echo.
echo  ллʹ�ã��밴���������...
pause >nul