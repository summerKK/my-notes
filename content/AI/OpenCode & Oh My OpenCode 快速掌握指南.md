
> 整理时间：2026-02-06

---

## 第一部分：OpenCode 快速上手

### 一、它是什么

OpenCode 是一个**开源 AI 编程助手**，提供终端 TUI、桌面应用和 IDE 扩展三种形态。你可以接入 Claude、GPT、Gemini 等任意模型。

- 官网：https://opencode.ai
- GitHub：https://github.com/anomalyco/opencode
- 文档：https://opencode.ai/docs/

---

### 二、安装

```bash
# 安装脚本（推荐）
curl -fsSL https://opencode.ai/install | bash

# 或通过 npm
npm install -g opencode-ai

# 或通过 Homebrew (macOS/Linux)
brew install anomalyco/tap/opencode
```

---

### 三、核心操作

| 操作 | 方式 | 说明 |
|------|------|------|
| **启动** | `opencode` | 在项目目录下运行 |
| **初始化项目** | `/init` | 生成 `AGENTS.md`，让 AI 理解你的项目 |
| **引用文件** | `@文件路径` | 模糊搜索，自动注入文件内容 |
| **执行 Shell** | `!命令` | 如 `!ls -la`，输出自动加入对话 |
| **撤销** | `/undo` | 撤销上一轮对话及所有文件改动 |
| **重做** | `/redo` | 恢复被撤销的改动 |
| **新会话** | `/new` | 开始全新对话 |
| **切换会话** | `/sessions` | 恢复之前的对话 |
| **压缩上下文** | `/compact` | 对话太长时压缩，节省 token |
| **分享对话** | `/share` | 生成链接分享给团队 |
| **配置 Provider** | `/connect` | 添加 API Key |
| **帮助** | `/help` | 查看所有命令 |

---

### 四、两种模式

按 **`Tab`** 键切换：

| 模式 | 用途 |
|------|------|
| **Plan 模式** | AI 只出方案不改代码，用于讨论设计 |
| **Build 模式** | AI 直接修改代码，用于实际开发 |

**最佳实践**：先 Plan → 确认方案 → 切 Build → 让它动手。

---

### 五、Leader 键快捷操作

默认 Leader 键是 **`Ctrl+X`**，先按 Leader 再按功能键：

| 快捷键            | 功能               |
| -------------- | ---------------- |
| `Ctrl+X` → `n` | 新会话              |
| `Ctrl+X` → `l` | 会话列表             |
| `Ctrl+X` → `m` | 切换模型             |
| `Ctrl+X` → `e` | 打开外部编辑器写长 prompt |
| `Ctrl+X` → `u` | 撤销               |
| `Ctrl+X` → `r` | 重做               |
| `Ctrl+X` → `c` | 压缩上下文            |
| `Ctrl+X` → `b` | 切换侧边栏            |
| `Ctrl+X` → `s` | 分享对话             |
| `Ctrl+X` → `t` | 切换主题             |
| `Ctrl+X` → `h` | 帮助               |
| `Ctrl+X` → `q` | 退出               |
| `F2`           | 快速切换最近用过的模型      |
| `Escape`       | 中断当前生成           |

---

### 六、高效 Prompt 技巧

1. **引用具体文件**：`看看 @src/auth.ts 的认证逻辑有什么问题`
2. **参考已有实现**：`参照 @src/notes.ts 的做法，给 settings 路由加上认证`
3. **拖入图片**：直接拖图片到终端，AI 能看图理解设计稿
4. **给足上下文**：像跟初级工程师说话一样，说清楚你要什么

---

### 七、自定义命令

在 `.opencode/commands/` 下创建 Markdown 文件，例如 `.opencode/commands/review.md`：

```markdown
---
description: 代码审查
agent: plan
---

审查 $ARGUMENTS 文件，检查：
1. 安全漏洞
2. 性能问题
3. 代码风格

!`git diff --cached`
```

然后用 `/review src/api.ts` 即可触发。

**支持的占位符**：
- `$ARGUMENTS` — 全部参数
- `$1`, `$2`, `$3` — 位置参数
- `` !`命令` `` — 注入 shell 输出
- `@文件路径` — 引用文件内容

**命令位置**：
- 全局：`~/.config/opencode/commands/`
- 项目级：`.opencode/commands/`

---

### 八、配置文件

项目根目录创建 `opencode.json`：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "keybinds": {
    "leader": "ctrl+x"
  },
  "tui": {
    "scroll_acceleration": { "enabled": true }
  }
}
```

---

### 九、快速上手路径

1. 安装 → `/connect` 配置 API Key
2. 进入项目目录 → `opencode`
3. `/init` 初始化项目
4. `Tab` 切到 Plan 模式讨论方案
5. 确认后 `Tab` 切回 Build 让它写代码
6. 不满意就 `/undo`，改 prompt 重来

---

---

## 第二部分：Oh My OpenCode 快速掌握

### 一、它是什么

Oh My OpenCode（简称 OMO）是 OpenCode 的**插件/增强层**，把 OpenCode 从一个 AI 编码助手变成一个**多 Agent 协作系统**。

- GitHub：https://github.com/code-yeongyu/oh-my-opencode
- 28k+ Stars，免费开源

核心理念：**你不再是写代码的人，你是 AI 团队的经理。**

---

### 二、安装

让当前 Agent 帮你装最简单：

```
Install and configure oh-my-opencode by following the instructions here:
https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/refs/heads/master/docs/guide/installation.md
```

或手动：

```bash
bunx oh-my-opencode install
```

交互式安装器会问你有哪些 API provider（Claude、OpenAI、Gemini 等），自动生成最优配置。

**卸载**：

```bash
# 1. 从 opencode.json 移除插件
jq '.plugin = [.plugin[] | select(. != "oh-my-opencode")]' \
    ~/.config/opencode/opencode.json > /tmp/oc.json && \
    mv /tmp/oc.json ~/.config/opencode/opencode.json

# 2. 删除配置文件（可选）
rm -f ~/.config/opencode/oh-my-opencode.json
rm -f .opencode/oh-my-opencode.json
```

---

### 三、两种工作模式（最重要）

#### 模式 1：`ultrawork` / `ulw`（懒人模式）

在 prompt 里加上 **`ultrawork`** 或 **`ulw`**，剩下的全自动：

```
ulw 给我的 Next.js 项目加上用户认证
```

Agent 会自动：
1. 探索代码库理解现有模式
2. 通过专业 Agent 研究最佳实践
3. 按你的代码风格实现功能
4. 用诊断和测试验证
5. 持续工作直到完成

**适合**：日常开发、快速任务、不想操心细节的时候。

#### 模式 2：Prometheus（精确模式）

按 **`Tab`** 切换到 Prometheus（规划者）模式：

```
1. Tab → 进入 Prometheus 模式
2. 描述需求 → Prometheus 会像顾问一样采访你，边研究代码库边提问
3. 确认方案 → 生成详细工作计划（保存在 .sisyphus/plans/*.md）
4. 运行 /start-work → 自动分配任务给各专业 Agent 执行
```

**适合**：复杂重构、生产环境变更、跨多文件的大型任务、多天项目。

> ⚠️ **注意**：Prometheus 和 Atlas（编排器）是一对，必须一起用。不要单独使用 Atlas。

---

### 四、Agent 团队

| Agent | 角色 | 擅长 | 推荐模型 |
|-------|------|------|----------|
| **Sisyphus** | 主 Agent / 团队 Lead | 协调、实现、决策 | Opus 4.5 High（强烈推荐） |
| **Hephaestus** | 自主深度工作者 | 给目标就能独立完成，不需要步骤指令 | GPT 5.2 Codex Medium |
| **Oracle** | 高智商顾问（只读） | 架构设计、疑难 debug、多系统权衡 | GPT 5.2 Medium |
| **Librarian** | 文档/代码搜索 | 查官方文档、开源实现、GitHub 搜索 | Claude Sonnet 4.5 |
| **Explore** | 快速代码探索 | 代码库内搜索定位（上下文 Grep） | Claude Haiku 4.5 |
| **Prometheus** | 规划者 | 需求分析、采访式制定计划 | 按 Tab 激活 |
| **Metis** | 预规划顾问 | 发现隐藏需求、歧义、AI 失败点 | - |
| **Momus** | 方案审查员 | 审查计划的清晰度、可验证性、完整性 | - |
| **Frontend Engineer** | 前端专家 | UI/UX 开发 | Gemini 3 Pro |
| **Multimodal Looker** | 多模态分析 | 看图、看 PDF、分析设计稿 | - |

---

### 五、日常使用速查

| 你想做什么 | 怎么做 |
|-----------|--------|
| 快速完成一个任务 | `ulw 你的需求描述` |
| 精确规划复杂任务 | `Tab` → 跟 Prometheus 对话 → `/start-work` |
| 让 Agent 查文档 | 直接提需求，Sisyphus 会自动派 Librarian |
| 让 Agent 探索代码 | 直接提需求，Sisyphus 会自动派 Explore |
| 遇到疑难 bug | 描述问题，Sisyphus 会在需要时咨询 Oracle |
| 前端 UI 任务 | 描述需求，会自动委派给前端专家 |
| 中断后继续工作 | `/sessions` 恢复会话，Todo 系统会记住进度 |
| 查看所有可用模型 | `opencode models` |

---

### 六、关键特性

1. **后台并行 Agent**：多个 Agent 同时工作，像真正的开发团队
2. **LSP + AST-Grep**：重构不靠文本替换，用语义级工具，更安全更精确
3. **Todo 强制续航**：Agent 不会半途而废，系统会强制它继续（"bouldering" 模式）
4. **注释检查器**：防止 AI 生成过多注释，代码看起来像人写的
5. **Session 工具**：可以搜索、回顾、分析历史对话
6. **自定义命令/技能**：`.opencode/commands/` 和 `.opencode/skills/`
7. **Claude Code 兼容层**：完整的 Hook 系统（PreToolUse, PostToolUse, UserPromptSubmit, Stop）
8. **内置 MCP**：
   - Exa（Web 搜索）
   - Context7（官方文档查询）
   - Grep.app（GitHub 代码搜索）
9. **Tmux 集成**：支持交互式终端操作

---

### 七、配置

配置文件位置：
- **项目级**：`.opencode/oh-my-opencode.json`
- **用户级**：`~/.config/opencode/oh-my-opencode.json`
- 支持 JSONC 格式（允许注释和尾逗号）

示例配置（按需覆盖，其余自动选择最优模型）：

```jsonc
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  "agents": {
    // 只覆盖你想改的，其余走自动 fallback chain
    "atlas": { "model": "anthropic/claude-sonnet-4-5", "variant": "max" },
    "librarian": { "model": "anthropic/claude-sonnet-4-5" },
    "explore": { "model": "opencode/gpt-5-nano" },
    "multimodal-looker": { "model": "google/gemini-3-flash" }
  },
  "categories": {
    // 按任务类型优化成本
    "quick": { "model": "opencode/gpt-5-nano" },
    "unspecified-low": { "model": "opencode/gpt-5-nano" }
  },
  "experimental": {
    "aggressive_truncation": true
  }
}
```

**模型 Fallback 机制**：每个 Agent 有 provider 优先链，系统按顺序尝试直到找到可用模型。例如：
```
multimodal-looker: google → openai → anthropic → opencode
                   gemini    gpt-5.2   haiku      gpt-5-nano
```

---

### 八、快速上手路径

```
1. 装好 OMO 后，进入项目目录运行 opencode
2. 简单任务 → 输入 "ulw 你的需求"，喝咖啡等结果
3. 复杂任务 → Tab → 跟 Prometheus 对话 → /start-work
4. 不满意 → /undo 撤销，改 prompt 重来
5. 想了解代码库 → 直接问，Agent 会自动派探索者去查
6. 中断了 → /sessions 恢复，Todo 系统记住了进度
```

**核心心法**：你不需要告诉 Agent 怎么做，只需要告诉它**做什么**。`ulw` 三个字母就够了。

---

## 参考链接

- OpenCode 官网：https://opencode.ai
- OpenCode 文档：https://opencode.ai/docs/
- Oh My OpenCode GitHub：https://github.com/code-yeongyu/oh-my-opencode
- OMO 功能文档：https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/features.md
- OMO 配置文档：https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/configurations.md
- OMO 编排系统：https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/guide/understanding-orchestration-system.md
- Ultrawork 宣言：https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/ultrawork-manifesto.md
- Discord 社区：https://discord.gg/PUwSMR9XNk
