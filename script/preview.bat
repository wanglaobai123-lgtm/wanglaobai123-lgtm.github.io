@echo off
chcp 936 >nul
cd /d %~dp0..
echo.
echo ================================
echo   本地预览模式
echo   地址: http://localhost:4000
echo   停止: 按 Ctrl+C
echo ================================
echo.
npx hexo server
