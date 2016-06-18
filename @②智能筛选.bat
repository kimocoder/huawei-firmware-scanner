@echo off
for %%i in (%~dp0\正在查询版本\*.xml)do if %%~zi gtr 256 move "%%i" "%~dp0\整理有效版本"
cls
echo.
echo.
echo.
echo.
echo        已经完成筛选
ping 127.1 -n 2 >nul
exit