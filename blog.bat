@echo off
rem ============================================================
rem  Hexo 博客辅助脚本（Windows BAT 版）
rem  用法: blog.bat <命令> [参数]
rem    new "标题"     新建文章
rem    preview        本地预览 http://localhost:4000
rem    push "说明"    提交并推送，自动触发线上部署
rem    status         查看当前有哪些改动
rem    clean          清除缓存和构建产物 public/
rem ============================================================

cd /d %~dp0

if "%~1"=="" goto help
if /i "%~1"=="new" goto cmd_new
if /i "%~1"=="preview" goto cmd_preview
if /i "%~1"=="push" goto cmd_push
if /i "%~1"=="status" goto cmd_status
if /i "%~1"=="clean" goto cmd_clean
if /i "%~1"=="help" goto help
goto help

:cmd_new
if "%~2"=="" (
    echo [blog] 请提供文章标题，例如: blog.bat new "我的文章"
    exit /b 1
)
echo [blog] 创建文章: %~2
call npx hexo new post "%~2"
echo [blog] 文件已生成，编辑 source\_posts\ 下对应的 .md 即可开始写作
exit /b 0

:cmd_preview
echo [blog] 启动本地预览: http://localhost:4000 （按 Ctrl+C 停止）
echo [blog] 预览期间修改文章保存后会自动刷新
call npx hexo server
exit /b 0

:cmd_push
echo [blog] 当前改动:
git status --short
git add -A
if "%~2"=="" (
    call git commit -m "更新博客 %date%"
) else (
    call git commit -m "%~2"
)
if errorlevel 1 (
    echo [blog] 没有新改动需要提交
    exit /b 0
)
echo [blog] 推送到 GitHub，将自动触发线上部署...
call git push
if errorlevel 1 (
    echo [blog] 推送失败，请检查网络后重试
    exit /b 1
)
echo [blog] 完成！约 1 分钟后访问 https://wanglaobai123-lgtm.github.io
exit /b 0

:cmd_status
git status
exit /b 0

:cmd_clean
echo [blog] 清除缓存和构建产物
call npx hexo clean
exit /b 0

:help
echo Hexo 博客辅助脚本
echo.
echo 用法: blog.bat ^<命令^> [参数]
echo.
echo   new "标题"     新建文章（生成 source\_posts\ 下的 .md 文件）
echo   preview        本地预览 http://localhost:4000，Ctrl+C 停止
echo   push "说明"    提交并推送，约 1 分钟后线上生效
echo   status         查看当前有哪些改动
echo   clean          清除缓存和构建产物 public/
echo.
echo 也可以直接复制 .md 文件到 source\_posts\ 目录作为文章
exit /b 0
