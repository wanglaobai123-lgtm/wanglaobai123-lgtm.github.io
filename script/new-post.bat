@echo off
rem ============================================================
rem  new-post.bat - 创建博客文章模板
rem  用法: new-post.bat "文章标题"
rem  效果: 在 source\_posts\ 下生成带完整 front-matter 的 .md 文件
rem ============================================================

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0new-post.ps1" %*
exit /b %errorlevel%
