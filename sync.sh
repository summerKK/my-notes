#!/bin/bash

# Quartz 内容同步脚本

cd /Users/summer/Docker/www/summer/quartz

echo "📝 同步 Obsidian vault 内容..."
rsync -av --delete --exclude='.git' --exclude='.obsidian' /Users/summer/Docker/www/summer/Knowledge/ content/

echo "📦 提交更改..."
git add content
git commit -m "Update content: $(date '+%Y-%m-%d %H:%M:%S')"

echo "🚀 推送到 GitHub..."
git push

echo "✅ 完成！GitHub Actions 将自动部署网站"
echo "🌐 网站地址: https://summerkk.github.io/my-notes/"
