# Myspace — Hexo 博客

个人 Hexo 博客。**源码和网站在同一个仓库**（`wanglaobai123-lgtm.github.io`）：
main 分支存放源码，GitHub Actions 自动构建并发布到 <https://wanglaobai123-lgtm.github.io>。

## 本地开发

```bash
npm install        # 安装依赖
npx hexo server    # 本地预览 http://localhost:4000
npx hexo new post "文章标题"   # 新建文章
npx hexo generate  # 生成静态页面到 public/
```

## 发布流程

1. 在 `source/_posts/` 写文章（或 `npx hexo new post "标题"` 自动生成）
2. `git add . && git commit -m "..." && git push`
3. GitHub Actions 自动构建并部署，约 1 分钟后线上生效

## 目录说明

| 目录/文件 | 作用 |
|---|---|
| `source/_posts/` | 文章（Markdown） |
| `_config.yml` | 站点配置 |
| `scaffolds/` | 新建文章的模板 |
| `.github/workflows/pages.yml` | 自动部署流程 |
| `public/` | 构建产物，**不要手动修改**（已 gitignore，由 CI 生成） |
| `node_modules/` | 依赖，**不要提交**（已 gitignore） |

## 换主题

编辑 `_config.yml` 的 `theme:` 字段，主题放到 `themes/` 目录
（当前用的是 npm 包形式的 landscape）。

## Windows 辅助脚本

`script/` 下每个功能一个 `.bat`，在博客根目录执行：

```
script\new-post.bat "文章标题"   # 创建带模板的文章
script\preview.bat               # 本地预览 localhost:4000
script\push.bat "提交说明"       # 检查改动→提交→推送（不带说明则用时间戳）
```

**改这些脚本前必须知道**：`.bat` 文件必须存为 **GBK 编码 + CRLF 换行**——
UTF-8 存的 bat 在中文命令行里全是乱码；LF 换行会让 cmd 错位解析。
仓库的 `.gitattributes` 已锁定该规则，但用记事本编辑时仍不要手动改编码。
