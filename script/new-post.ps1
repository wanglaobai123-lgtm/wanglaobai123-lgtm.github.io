# ============================================================
#  new-post.ps1 - 创建博客文章模板（由 new-post.bat 调用）
#  生成 source/_posts/<标题>.md，带完整 front-matter
# ============================================================

param([string]$Title)

$ErrorActionPreference = 'Stop'

# script/ 的上一级就是博客根目录
$root = Split-Path -Parent $PSScriptRoot
$postsDir = Join-Path $root 'source\_posts'

# 没带标题参数就交互输入
if (-not $Title) {
    $Title = Read-Host '请输入文章标题'
}
$Title = $Title.Trim()
if (-not $Title) {
    Write-Host '[new-post] 标题不能为空' -ForegroundColor Red
    exit 1
}

# 去掉 Windows 文件名非法字符
$safeName = $Title -replace '[\\/:*?"<>|]', ''
$file = Join-Path $postsDir "$safeName.md"

if (Test-Path $file) {
    Write-Host "[new-post] 文件已存在: source\_posts\$safeName.md" -ForegroundColor Red
    Write-Host '换个标题，或直接编辑那个文件'
    exit 1
}

$now = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

$template = @"
---
title: $Title
date: $now
# updated: 2026-01-01 12:00:00   # 填了则显示固定更新时间；不填则跟随文件修改时间
# tags: [标签1, 标签2]
# categories: [分类名]
# index_img: /img/cover.png      # 文章封面图，图片放到 source/img/ 下
# top: true                      # 取消注释即可置顶这篇文章
---

这里写摘要，会显示在首页的文章列表里。

<!--more-->

正文从这里开始写。
"@

New-Item -ItemType Directory -Force -Path $postsDir | Out-Null
[System.IO.File]::WriteAllText($file, $template, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "[new-post] 已创建: source\_posts\$safeName.md" -ForegroundColor Green
Write-Host ''
Write-Host '下一步:'
Write-Host "  1. 用编辑器打开 source\_posts\$safeName.md 写内容"
Write-Host '  2. 写完推送到 GitHub 发布上线'
