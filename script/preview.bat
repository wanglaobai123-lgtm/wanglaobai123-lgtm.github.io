@echo off
chcp 936 >nul
cd /d %~dp0..

echo ================================
echo   Hexo 本地预览模式
echo   地址: http://localhost:4000
echo ================================
echo.

netstat -ano | findstr ":4000 " | findstr LISTENING >nul
if not errorlevel 1 (
  echo [提示] 4000 端口已被占用，可能是上次预览没有关干净。
  echo        请先关闭之前弹出的 "Hexo 预览" 窗口，再重新运行。
  echo.
  pause
  exit /b 1
)

echo 正在启动本地服务器，起好后浏览器会自动打开...
start "Hexo 预览（关闭此窗口即停止）" npx hexo server

set /a tries=0
:waitserver
timeout /t 1 /nobreak >nul
netstat -ano | findstr ":4000 " | findstr LISTENING >nul
if not errorlevel 1 goto openbrowser
set /a tries+=1
if %tries% lss 20 goto waitserver

:openbrowser
start "" http://localhost:4000
echo.
echo 浏览器已打开。之后每次保存 .md 文章，刷新页面即可看到效果。
echo 停止预览：关闭标题为 "Hexo 预览" 的黑色窗口。
echo.
pause
