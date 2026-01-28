# Quartz 自动部署配置文档

> 本文档记录了从 Obsidian 笔记到 GitHub Pages 网站的完整自动化部署流程

## 📋 项目概述

### 目标
将 Obsidian 笔记自动发布为静态网站，实现：
- ✅ 在 Obsidian 中编辑笔记
- ✅ 自动同步到 GitHub
- ✅ 自动构建并部署到 GitHub Pages
- ✅ 完全自动化，无需手动操作

### 架构

```
Obsidian 笔记
    ↓ (自动同步)
Knowledge 仓库 (私有)
    ↓ (触发构建)
my-notes 仓库 (公开)
    ↓ (GitHub Actions)
GitHub Pages 网站
```

## 🗂️ 仓库信息

| 仓库 | 类型 | 用途 | URL |
|------|------|------|-----|
| **Knowledge** | 私有 | Obsidian 笔记存储 | https://github.com/summerKK/Knowledge |
| **my-notes** | 公开 | Quartz 网站源码 | https://github.com/summerKK/my-notes |

**本地路径**：
- Obsidian Vault: `/Users/summer/Docker/www/summer/Knowledge`
- Quartz 项目: `/Users/summer/Docker/www/summer/quartz`

**网站地址**: https://summerkk.github.io/my-notes/

## 🔧 技术栈

- **Quartz v4**: 静态网站生成器，专为 Obsidian 设计
- **GitHub Actions**: 自动化构建和部署
- **GitHub Pages**: 免费静态网站托管
- **Fine-grained Token**: 安全的仓库访问控制

## 📦 初始安装步骤

### 1. 克隆 Quartz 项目

```bash
cd /Users/summer/Docker/www/summer
git clone https://github.com/jackyzha0/quartz.git
cd quartz
```

### 2. 安装依赖

```bash
npm install
```

### 3. 配置内容源

由于 Knowledge 仓库是独立的 Git 仓库，我们直接复制内容：

```bash
# 删除默认 content 文件夹
rm -rf content

# 复制 Obsidian vault 内容
cp -r /Users/summer/Docker/www/summer/Knowledge content

# 删除 Git 相关文件
rm -rf content/.git content/.obsidian
```

### 4. 创建首页

在 Knowledge 仓库中创建 `index.md` 作为网站首页：

```markdown
# 欢迎来到我的知识库

这是我的个人知识库，记录了我的学习笔记和思考。

## 主要内容

- C++ 学习笔记
- 加密货币分析
- 网络技术学习
- 其他知识积累

---

*使用 [Quartz](https://quartz.jzhao.xyz/) 构建*
```

### 5. 配置 Quartz

编辑 `quartz.config.ts`：

```typescript
configuration: {
  pageTitle: "Summer's Knowledge Base",
  locale: "zh-CN",
  // ... 其他配置
}
```

**重要修改**：注释掉 `CustomOgImages` 插件（中文支持问题）：

```typescript
emitters: [
  // ...
  // Plugin.CustomOgImages(),  // 已注释
]
```

## 🔐 安全配置：Fine-grained Token

### 为什么使用 Fine-grained Token？

相比 Classic Token，Fine-grained Token 提供：
- ✅ 权限最小化（只能访问指定仓库）
- ✅ 更细粒度的权限控制
- ✅ 可设置过期时间
- ✅ 更好的安全审计

### 创建 Fine-grained Token

1. 访问：https://github.com/settings/personal-access-tokens/new

2. 配置：
   - **Token name**: `Quartz Auto Deploy`
   - **Expiration**: `90 days`
   - **Repository access**: Only select repositories
     - ✅ `summerKK/Knowledge`
     - ✅ `summerKK/my-notes`
   - **Permissions**:
     - **Actions**: Read and write ✅
     - **Contents**: Read and write ✅
     - **Workflows**: Read and write ✅
     - **Metadata**: Read-only (自动)

3. 生成并保存 token（格式：`github_pat_xxxxx...`）

### 配置 Secrets

```bash
# 在 my-notes 仓库中添加 secret（用于访问私有的 Knowledge 仓库）
gh secret set KNOWLEDGE_TOKEN --repo summerKK/my-notes --body "your_token_here"

# 在 Knowledge 仓库中添加 secret（用于触发 my-notes 的构建）
gh secret set TRIGGER_TOKEN --repo summerKK/Knowledge --body "your_token_here"
```

## 🔄 自动同步机制

### 方案 1：定时同步（备份机制）

**文件**: `.github/workflows/sync-and-deploy.yml`

**触发条件**:
- 每小时自动执行一次
- 可手动触发

**工作流程**:
1. 检出 my-notes 仓库
2. 检出 Knowledge 仓库（使用 KNOWLEDGE_TOKEN）
3. 同步内容到 content 文件夹
4. 检测是否有变化
5. 如有变化，提交并构建
6. 部署到 GitHub Pages

**关键配置**:

```yaml
on:
  schedule:
    - cron: '0 * * * *'  # 每小时
  workflow_dispatch:
  push:
    branches:
      - v4

jobs:
  sync-and-build:
    steps:
      - name: Checkout Knowledge repo (private)
        uses: actions/checkout@v4
        with:
          repository: summerKK/Knowledge
          token: ${{ secrets.KNOWLEDGE_TOKEN }}
          path: knowledge-temp
```

### 方案 2：实时触发（主要机制）

**文件**: Knowledge 仓库的 `.github/workflows/trigger-quartz-build.yml`

**触发条件**:
- Knowledge 仓库有 push 时立即触发

**工作流程**:
1. Knowledge 仓库收到 push
2. 触发 workflow
3. 调用 GitHub API 触发 my-notes 的 workflow
4. my-notes 自动拉取最新内容并构建

**关键配置**:

```yaml
on:
  push:
    branches:
      - main

jobs:
  trigger-build:
    steps:
      - name: Trigger my-notes workflow
        run: |
          curl -X POST \
            -H "Authorization: token ${{ secrets.TRIGGER_TOKEN }}" \
            https://api.github.com/repos/summerKK/my-notes/actions/workflows/sync-and-deploy.yml/dispatches \
            -d '{"ref":"v4"}'
```

## 🚀 完整工作流程

```
1. 在 Obsidian 中编辑笔记
   ↓
2. Obsidian 自动同步到 Knowledge 仓库
   ↓
3. Knowledge 仓库触发 my-notes workflow (实时)
   ↓
4. my-notes 拉取 Knowledge 最新内容
   ↓
5. Quartz 构建静态网站
   ↓
6. 部署到 GitHub Pages
   ↓
7. 网站自动更新 (2-3 分钟)
```

**备份机制**: 如果实时触发失败，定时任务每小时会自动同步一次。

## 📝 日常使用

### 发布新笔记

1. 在 Obsidian 中编辑笔记
2. 保存（Obsidian 会自动同步到 Knowledge 仓库）
3. 等待 2-3 分钟，网站自动更新

**无需任何手动操作！**

### 手动触发构建

如果需要立即构建：

```bash
# 手动触发 my-notes 的构建
gh workflow run sync-and-deploy.yml --repo summerKK/my-notes
```

### 本地预览

```bash
cd /Users/summer/Docker/www/summer/quartz
npx quartz build --serve
```

访问：http://localhost:8080

## 🔍 监控和调试

### 查看构建状态

```bash
# 查看 Knowledge 仓库的触发状态
gh run list --repo summerKK/Knowledge

# 查看 my-notes 仓库的构建状态
gh run list --repo summerKK/my-notes

# 查看详细日志
gh run view --repo summerKK/my-notes --log
```

### 常见问题排查

#### 1. 构建失败

```bash
# 查看最近的失败日志
gh run list --repo summerKK/my-notes --status failure --limit 1
gh run view <run-id> --log
```

**常见原因**:
- Token 权限不足
- Knowledge 仓库访问失败
- 构建过程中的语法错误

#### 2. 触发失败

```bash
# 查看 Knowledge 仓库的触发日志
gh run list --repo summerKK/Knowledge --limit 5
```

**常见原因**:
- TRIGGER_TOKEN 过期或权限不足
- API 调用失败（403/404）

#### 3. 内容未更新

**检查步骤**:
1. 确认 Knowledge 仓库已更新
2. 检查 my-notes 的 workflow 是否被触发
3. 查看构建日志是否有错误
4. 清除浏览器缓存

### GitHub Actions 日志位置

- Knowledge 触发日志: https://github.com/summerKK/Knowledge/actions
- my-notes 构建日志: https://github.com/summerKK/my-notes/actions

## 🛠️ 维护指南

### Token 续期

Fine-grained Token 有效期为 90 天，到期前需要续期：

1. 访问：https://github.com/settings/personal-access-tokens
2. 找到 `Quartz Auto Deploy` token
3. 点击 "Regenerate token"
4. 更新两个仓库的 secrets：

```bash
gh secret set KNOWLEDGE_TOKEN --repo summerKK/my-notes --body "new_token"
gh secret set TRIGGER_TOKEN --repo summerKK/Knowledge --body "new_token"
```

### 调整同步频率

编辑 `.github/workflows/sync-and-deploy.yml`：

```yaml
schedule:
  - cron: '0 * * * *'      # 每小时
  # - cron: '*/30 * * * *'  # 每30分钟
  # - cron: '*/15 * * * *'  # 每15分钟
  # - cron: '0 */6 * * *'   # 每6小时
```

### 更新 Quartz

```bash
cd /Users/summer/Docker/www/summer/quartz

# 添加上游仓库
git remote add upstream https://github.com/jackyzha0/quartz.git

# 拉取更新
git fetch upstream
git merge upstream/v4

# 解决冲突后推送
git push
```

## 📊 性能优化

### 构建时间优化

- 平均构建时间：2-3 分钟
- 包含步骤：
  - 同步内容：~10 秒
  - 安装依赖：~30 秒
  - 构建网站：~20 秒
  - 部署：~10 秒

### 缓存策略

GitHub Actions 自动缓存：
- npm 依赖
- 构建产物

## 🔒 安全最佳实践

### ✅ 已实施

- [x] 使用 Fine-grained Token（权限最小化）
- [x] Token 仅能访问必要的 2 个仓库
- [x] Secrets 加密存储
- [x] 定期 Token 续期（90 天）
- [x] 私有仓库保护敏感内容

### ⚠️ 注意事项

- **不要**在公开仓库中提交 token
- **不要**在 workflow 日志中打印 secrets
- **定期**检查 token 使用情况
- **及时**撤销不再使用的 token

## 📚 相关资源

- [Quartz 官方文档](https://quartz.jzhao.xyz/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [GitHub Pages 文档](https://docs.github.com/en/pages)
- [Fine-grained Token 文档](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token)

## 🎯 快速参考

### 常用命令

```bash
# 本地预览
cd /Users/summer/Docker/www/summer/quartz && npx quartz build --serve

# 手动触发构建
gh workflow run sync-and-deploy.yml --repo summerKK/my-notes

# 查看构建状态
gh run list --repo summerKK/my-notes --limit 5

# 查看网站
open https://summerkk.github.io/my-notes/
```

### 重要文件

| 文件 | 位置 | 用途 |
|------|------|------|
| `sync-and-deploy.yml` | my-notes/.github/workflows/ | 主构建流程 |
| `trigger-quartz-build.yml` | Knowledge/.github/workflows/ | 触发器 |
| `quartz.config.ts` | quartz/ | Quartz 配置 |
| `index.md` | Knowledge/ | 网站首页 |

## 📝 更新日志

### 2026-01-28

- ✅ 初始化 Quartz 项目
- ✅ 配置 GitHub Pages 部署
- ✅ 实现定时同步机制
- ✅ 实现实时触发机制
- ✅ 升级到 Fine-grained Token
- ✅ 完成安全配置
- ✅ 测试验证通过

---

**配置完成时间**: 2026-01-28
**配置人员**: Claude Code
**文档版本**: 1.0
