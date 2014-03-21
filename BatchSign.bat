@echo off
title ☆酷星代码签名工具--Wosign版☆
color 06
echo          ☆☆☆☆☆☆☆☆☆☆☆☆☆  声明  ☆☆☆☆☆☆☆☆☆☆☆☆☆
echo.
echo             本程序应用微软signtool工具，可批量或为单个代码添加签名
echo.
echo               本程序适用前提：将Wosign的相关证书都正确导入了MS OS
echo.
echo               具体的证书导入及签名步骤还请参考如下地址
echo.
echo               https://www.wosign.com/support/SignTool_guide.htm           
echo.
echo          ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
echo.
echo.
echo.
echo  按任意键开始...
pause >nul
cls

rem  检测是否有signtool.exe
echo.
if not exist tool\signtool.exe (
   echo.
   echo.
   echo  对不起，找不到工具signtool.exe
   goto end
)

echo.
echo         ☆☆☆☆☆☆☆☆☆☆☆☆☆  开始签名  ☆☆☆☆☆☆☆☆☆☆☆☆☆
echo.
echo.
echo.

:setinput
if exist tool\filelist.txt del tool\filelist.txt /q /s >nul
echo.
echo  请输入待签名的程序或程序所在的文件夹路径
echo.
echo  提示：可直接拖拽进来
echo.

echo.
set input=:
set /p input=        程序路径：
set "input=%input:"=%"
if "%input%"==":" goto setinput

if not exist "%input%" (
echo.
echo      ..........啊哦，路径不存在..........
echo.
goto setinput
)

rem 判断是文件夹还是文件
pushd "%input%">nul 2>nul && (popd & set what=dir)||(set what=file)

goto is%what%

rem 是文件
:isfile
cls
echo.
Echo    ---------单个文件签名开始----------
tool\signtool.exe  sign /v /s my /t http://timestamp.wosign.com/timestamp "%input%"
echo.
:choice1
echo.
Echo    ---------单个文件签名完成(0退出，1继续签名)----------
echo.
set choice1=
set /p choice1=                     请选择(0/1):
if /i "%choice1%"=="0" goto end
if /i "%choice1%"=="1" goto setinput
Echo          错误的选择
goto choice1

:isdir
cls
for /r "%input%" %%i in (*.exe *.dll *.cab *.ocx *.mui *.vbs *.msi) do echo %%~fi>>tool\filelist.txt
echo.
echo    -----------批量代码签名开始-------------
if not exist tool\filelist.txt (
	echo 对不起，列表生成失败
	goto end
)

for /f "delims=" %%1 in (tool\filelist.txt) do tool\signtool.exe  sign /v /s my /t http://timestamp.wosign.com/timestamp "%%~1"
echo.
:choice2
echo.
echo     ----------批量代码签名完成(0退出， 1继续签名)-------------
echo.    
set choice2=
set /p choice2=                     请选择(0/1):
if /i "%choice2%"=="0" goto end
if /i "%choice2%"=="1" goto setinput
Echo          错误的选择
goto choice2

:end
echo.
echo.
echo.
echo  谢谢使用，请按任意键结束...
pause >nul