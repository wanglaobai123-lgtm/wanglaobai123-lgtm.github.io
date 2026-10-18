@echo off
chcp 936 >nul
cd /d %~dp0..

rem ---- 检查有没有改动 ----
git status --porcelain | findstr /r "." >nul
if errorlevel 1 (
    echo.
    echo   [无改动] 工作区干净，没有需要推送的内容
    echo.
    pause
    exit /b 0
)

rem ---- 确定提交说明 ----
if "%~1"=="" (
    for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd HH:mm'"`) do set "COMMIT_MSG=更新博客 %%i"
) else (
    set "COMMIT_MSG=%~1"
)

echo.
echo   [1/3] 暂存改动...
git add -A
if errorlevel 1 goto :err

echo   [2/3] 提交: %COMMIT_MSG%
git commit -m "%COMMIT_MSG%"
if errorlevel 1 goto :err

echo   [3/3] 推送到 GitHub...
git push
if errorlevel 1 goto :err

echo.
echo   [完成] 已推送，约1分钟后线上生效
echo   部署状态: https://github.com/wanglaobai123-lgtm/wanglaobai123-lgtm.github.io/actions
echo.
pause
exit /b 0

:err
echo.
echo   [失败] 上一步出错，请仔细看上面的输出
echo.
pause
exit /b 1
