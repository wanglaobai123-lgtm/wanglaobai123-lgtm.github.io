#!/usr/bin/env bash
# ============================================================
# Hexo 博客辅助脚本
# 用法: ./blog.sh <命令> [参数]
#   new "标题"     新建文章
#   preview        本地预览 http://localhost:4000
#   push "说明"    提交并推送，自动触发线上部署
#   status         查看当前有哪些改动
#   clean          清除缓存和构建产物 public/
# ============================================================

set -e

# 切换到脚本所在目录（仓库根目录），从任何位置运行都有效
cd "$(dirname "$0")"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${GREEN}[blog]${NC} $1"; }
warn() { echo -e "${YELLOW}[blog]${NC} $1"; }
err()  { echo -e "${RED}[blog]${NC} $1" >&2; }

cmd="${1:-help}"

case "$cmd" in
  new)
    if [ -z "$2" ]; then
      err "请提供文章标题，例如: ./blog.sh new \"我的文章\""
      exit 1
    fi
    info "创建文章: $2"
    npx hexo new post "$2"
    info "文件已生成，编辑 source/_posts/ 下对应的 .md 即可开始写作"
    ;;

  preview)
    info "启动本地预览: http://localhost:4000 （按 Ctrl+C 停止）"
    info "预览期间修改文章保存后会自动刷新"
    npx hexo server
    ;;

  push)
    msg="${2:-更新文章 $(date '+%Y-%m-%d %H:%M')}"
    info "即将提交以下改动:"
    git status --short
    git add -A
    if git commit -m "$msg" >/dev/null 2>&1; then
      info "推送到 GitHub，将自动触发线上部署..."
      git push
      info "完成！约 1 分钟后访问 https://wanglaobai123-lgtm.github.io"
    else
      warn "没有新改动需要提交"
      exit 0
    fi
    ;;

  status)
    git status
    ;;

  clean)
    info "清除缓存和构建产物"
    npx hexo clean
    ;;

  help|--help|-h|*)
    echo "Hexo 博客辅助脚本"
    echo ""
    echo "用法: ./blog.sh <命令> [参数]"
    echo ""
    echo "  new \"标题\"     新建文章（生成 source/_posts/ 下的 .md 文件）"
    echo "  preview        本地预览 http://localhost:4000，Ctrl+C 停止"
    echo "  push \"说明\"    提交并推送，约 1 分钟后线上生效"
    echo "  status         查看当前有哪些改动"
    echo "  clean          清除缓存和构建产物 public/"
    echo ""
    echo "也可以直接复制 .md 文件到 source/_posts/ 目录作为文章"
    ;;
esac
