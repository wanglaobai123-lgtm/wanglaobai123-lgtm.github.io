@echo off
chcp 936 >nul
if "%~1"=="" (
    echo.
    echo   [用法] new-post.bat "文章标题"
    echo   [示例] new-post.bat "从 cat 和 echo 出发"
    echo.
    pause
    exit /b 1
)
cd /d %~dp0..
set "POST_TITLE=%~1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$t = $env:POST_TITLE; foreach ($c in [System.IO.Path]::GetInvalidFileNameChars()) { $t = $t.Replace([string]$c, '') }; if ($t -eq '') { Write-Host '  [错误] 标题清洗后为空，换个标题' -ForegroundColor Red; exit 1 }; $d = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'; $p = Join-Path 'source\_posts' ($t + '.md'); if (Test-Path $p) { Write-Host ('  [已存在] ' + $p) -ForegroundColor Red; Write-Host '  拒绝覆盖，换个标题或先编辑已有文章'; exit 1 }; $tpl = @('---', ('title: ' + $t), ('date: ' + $d), '# updated: 填了则显示固定更新时间，不填则跟随文件修改时间', '# tags: [标签1, 标签2]', '# categories: [分类名]', '# index_img: /img/cover.png', '# top: true', '---', '', '这里写摘要，会显示在首页的文章列表里。', '', '<!--more-->', '', '正文从这里开始写。') -join [char]10; [System.IO.File]::WriteAllText($p, $tpl, (New-Object System.Text.UTF8Encoding $false)); Write-Host ('  [已创建] ' + $p) -ForegroundColor Green; Write-Host '  下一步：用编辑器打开这个文件写内容'"
