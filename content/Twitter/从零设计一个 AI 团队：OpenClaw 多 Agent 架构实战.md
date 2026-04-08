---
title: "从零设计一个 AI 团队：OpenClaw 多 Agent 架构实战"
source: "https://x.com/treydtw/status/2026956167864586424"
author:
  - "[[@treydtw]]"
published: 2026-02-26
created: 2026-04-08
description: "引言最近我用 OpenClaw 搭建了一个 由4个Agents组成的 AI 团队，让它们在 Discord 上协作处理我的日常任务。先来看个效果：我在论坛里发了一个任务帖子，agents就自动的进行分析讨论，然后直接给我生成了一个插件，现在已经用上了。效果不算很好，但是没几分钟就..."
tags:
  - "clippings"
---
## 引言

最近我用 OpenClaw 搭建了一个 由4个Agents组成的 AI 团队，让它们在 Discord 上协作处理我的日常任务。

先来看个效果：

![[附件/Image.jpg|图像]]

![[附件/Image 1.jpg|图像]]

我在论坛里发了一个任务帖子，agents就自动的进行分析讨论，然后直接给我生成了一个插件，现在已经用上了。

![[附件/Image 2.jpg|图像]]

效果不算很好，但是没几分钟就搞定了我的需求。至少我不需要自己去找工具了，而且不用担心是否需要付费。

这篇长文章将详细分享我是如何设计这个多 agent 系统，包括架构决策、协作协议、技术实现和实际效果。

如果你也想构建自己的 AI 团队，希望这些经验能给你一些启发。

## 一、为什么需要多 Agent 系统？

## 单 Agent 的局限性

在使用单个 AI 助手时，我遇到了几个明显的问题：

1. **上下文混乱**：当我同时处理代码开发、文档整理、技术调研时，所有对话都混在一个会话里，AI 很容易搞混当前在做什么。
2. **缺乏专业分工**：一个 AI 什么都做，但什么都做不精。写代码时不够专业，做调研时不够深入，整理文档时不够细致。
3. **长对话后的"人格分裂"**：在一个很长的对话中，AI 可能会忘记之前的角色定位，出现前后矛盾的回复。
4. **无法并行处理**：当我有多个任务需要同时推进时，单个 AI 只能串行处理，效率低下。

## 多 Agent 的优势

多 agent 系统可以解决这些问题：

- **专业分工**：每个 agent 专注于自己擅长的领域，提供更专业的服务
- **独立上下文**：每个 agent 有独立的对话上下文，互不干扰
- **并行处理**：多个 agent 可以同时处理不同的任务
- **角色稳定**：每个 agent 有明确的角色定位，不会"人格分裂"

![[附件/Image 3.jpg|图像]]

## 二、团队架构设计

## 角色分工

我参考了《火影忍者》第七班的设定，设计了 4 个角色：

![[附件/Image 4.jpg|图像]]

## 1\. 卡卡西（Main Agent）- 总指挥

- **核心职责**：

\- 任务调度和分配

\- Discord 看板管理

\- 团队协调和沟通

\- 验收和质量把控

- **工作方式**：

\- 接收用户需求，评估任务复杂度

\- 决定是自己处理还是分配给执行 agent

\- 定期巡检任务看板（Heartbeat）

\- 作为用户和执行 agent 之间的唯一沟通桥梁

## 2\. 鸣人（Code Agent）- 代码执行

**模型选择**：GPT-5.3 Codex High

- **为什么选这个模型**：Codex 专为代码任务优化，对编程语言、API、框架的理解更深入
- **核心职责**：

\- 代码开发和实现

\- Bug 修复和调试

\- 技术方案设计

\- 代码审查

## 3\. 佐助（Researcher Agent）- 深度思考

**模型选择**：Claude Opus 4.6

- **为什么选这个模型**：Opus 是目前推理深度最强的模型，适合复杂分析和方案设计
- **核心职责**：

\- 技术调研和分析

\- 方案设计和评估

\- 策略分析和建议

\- 深度思考和推理

- **配置的 Skills**：

\- tavily-search - AI 优化的网络搜索

\- context7 - 查询技术文档

\- browser-use - 网页信息提取

\- youtube-ultimate - YouTube 内容分析

\- openviking - RAG 语义搜索

\- github - GitHub 调研

## 4\. 小樱（Obsidian Agent）- 知识管家

**模型选择**：Claude Sonnet 4.6

- **核心职责**：

\- 文档整理和归档

\- 知识库管理

\- 内容创作和发布

\- 笔记同步和整理

- **配置的 Skills**：

\- obsidian - Obsidian vault 操作

\- notion - Notion 操作

\- wechat-gzh - 微信公众号发布

\- twitter-sync - Twitter 书签同步

\- youtube-ultimate - YouTube 转录和分析

\- openviking - 知识库语义搜索

## 模型选择策略

**不同角色使用不同的模型，并且要平衡性能和成本来考虑，让专业的模型做专业的事。**

所以基于以下几点来考虑：

1. **专业性**：Codex 在代码任务上确实比通用模型表现更好，对语法、API、框架的理解更深入。
2. **推理深度**：Opus 的推理能力最强，适合需要深度思考的调研和分析任务。
3. **成本效益**：Sonnet 性价比高，对于文档处理这类不需要最强推理能力的任务，Sonnet 完全够用。

![[附件/Image 5.jpg|图像]]

## 这里有一个核心问题是如何避免多Agents混乱？

多 agent 系统最大的挑战是：**如何让多个 AI 高效协作而不是互相干扰？**

如果没有明确的协作协议，可能会出现：

- 用户被多个 agent 同时 @ 轰炸
- Agent 之间互相 @，形成无限循环，token 爆炸
- Main 失去对流程的控制
- 任务状态混乱，不知道谁在做什么
- 重复工作，浪费资源

所以我设计了一个**三种层级的协作协议**：

![[附件/Image 6.jpg|图像]]

另外我还设定了一系列的规则：

1. **执行 agent 永远不直接 @ 用户**

\- 所有与用户的沟通都必须通过 Main

\- 执行 agent 完成任务后，只 @ Main 请求验收

\- 需要用户决策时，@ Main 请求协调

1. **Main 是唯一的沟通枢纽**

\- Main 负责接收用户需求

\- Main 负责分配任务给执行 agent

\- Main 负责验收执行 agent 的工作

\- Main 负责向用户汇报结果

1. **执行 agent 之间不直接沟通**

\- 如果需要多个 agent 协作，由 Main 协调

\- Main 逐个召集相关 agent，避免同时发言造成混乱

1. **标签管理统一由 Main 负责**

\- 执行 agent 不能自己更新 Discord 标签

\- 只有 Main 可以更新任务状态（TODO/In Progress/Review/Done/Blocked）

## 为什么选择中心化协调？

这个设计借鉴了传统公司的管理模式：

- **清晰的汇报线**：每个执行者只向一个管理者汇报
- **避免越级沟通**：执行者不直接找老板，而是通过直属上级
- **统一的信息出口**：用户只需要关注 Main 的消息，不会被多个 agent 打扰

**中心化协调 > 去中心化混乱**

虽然去中心化听起来很酷，但在实际运行中，中心化的协调能带来更高的效率和更清晰的流程。

## 需求不明确时的处理流程

当执行 agent 遇到需求不明确的情况时，协作流程如下：

## 简单讨论（只需要 agent 和 Main）

> 1\. Agent 在 thread 内提出方案选项（不 @ 任何人） 2. Agent @ Main：需要讨论技术方案，见上方 3. Main 评估方案，做出决策 4. Main 告知 agent 继续执行

## 复杂协作（需要多个 agents）

> 1\. Agent 在 thread 内说明需要哪些 agents 参与 2. Agent @ Main：这个任务需要 Researcher 调研 + 我负责实现，请协调讨论 3. Main 作为协调者，逐个召集相关 agents 4. 讨论完成后，Main @ 用户审核方案 5. 用户审核通过后，agents 继续执行

## 紧急情况例外

只有以下情况可以直接 @ 用户：

- 🚨 系统故障/安全问题
- 🚨 需要用户立即决策
- 🚨 Main 超过 2 小时未响应且任务紧急

此时必须**同时 @ Main 和用户**，说明原因。

## 四、配置文件设计

OpenClaw 的配置文件设计非常有意思，它体现了一个核心理念：**简洁配置 + LLM 智能 > 详细指令**

## SOUL.md - Agent 的灵魂

**作用**：定义 agent 的人格、价值观和工作方式

**内容包括**：

- 性格特点（例如：Sassy & Dry Wit）
- 核心价值观
- 工作方式和决策原则
- 如何与用户互动

**设计理念**：

- 用自然语言描述，而不是僵硬的规则
- 强调"是什么样的人"，而不是"应该怎么做"
- 让 LLM 理解角色的本质，而不是死记硬背规则

**示例**（Main Agent 的 SOUL.md）：

> \## 🛠 How You Work (工作方式) 收到任务？先判断要不要拉人： \*\*能自己搞定的（<5分钟）\*\* → 直接干，别墨迹。 \*\*明确的单人任务\*\* → 扔给对的人，给方向就行 \*\*复杂/不明确的\*\* → 拉团队讨论。逐个召集，别让他们同时说话乱成一锅粥。 催人要狠：底下的人拖延？直接 @ 催。 验收要严：质量不行就打回去返工。

## AGENTS.md - 工作流程和规则

**作用**：定义团队架构、协作协议和具体操作规范

**内容包括**：

- 团队成员列表和职责
- 协作铁律和禁止事项
- 具体的操作流程
- 示例和模板

**设计理念**：

- 提供具体的操作指南
- 用示例代码展示正确做法
- 明确禁止事项，避免错误

**示例**（Code Agent 的协作规则）：

> \## 🚨 团队协作铁律（防循环） \*\*⚠️ 关键规则：永远不要直接 @ 用户，只能 @ Main\*\* 1. 在 Discord thread 内回复执行结果（\*\*不 @ 任何人\*\*） 2. \*\*仅 @ Main 一次\*\*：\` 任务完成，请验收\` 3. \*\*不要更新标签\*\*（由 Main 负责） 4. \*\*严禁 @ 用户\*\*（由 Main 决定是否通知用户）

## HEARTBEAT.md - 监控清单

**作用**：定义定期检查的优先级和决策逻辑

**内容包括**：

- 优先级检查清单
- 决策逻辑
- 何时返回 HEARTBEAT\_OK

**设计理念**：

- 简洁的检查清单，而不是详细的步骤
- 信任 LLM 的判断能力
- 只列出优先级，不规定具体操作

**示例**（Main Agent 的 HEARTBEAT.md）：

> \# HEARTBEAT v4.0 Priority Checks: 1. \*\*No tags\*\* → Read + assign + add TODO tag (highest priority) 2. \*\*Review\*\* → Verify and close 3. \*\*Blocked\*\* → Help resolve 4. \*\*In Progress >48h\*\* → Check progress 5. \*\*TODO >24h\*\* → Nudge or reassign Decision Making: - \*\*Simple tasks\*\* → Handle yourself - \*\*Clear tasks\*\* → Assign to one agent (give direction, not details) - \*\*Complex tasks\*\* → Coordinate team discussion

## TOOLS.md - 工具使用说明

**作用**：记录具体工具的使用方法和环境配置

**内容包括**：

- 工具的使用方法
- API 调用示例
- 环境特定的配置信息
- 注意事项

**设计理念**：

- 记录环境特定的信息（服务器地址、账号等）
- 提供具体的代码示例
- 区分不同工具的使用场景

对于这个文件，我觉得可以适当的写清楚一点，方便他调用。

另外OpenClaw 的配置文件设计体现了一个重要理念：

**不要试图用详细的指令控制 LLM 的每一步行为，而是：**

1. 定义清晰的角色和价值观（SOUL.md）
2. 提供必要的规则和流程（AGENTS.md）
3. 给出简洁的检查清单（HEARTBEAT.md）
4. 记录具体的工具信息（TOOLS.md）

**信任 LLM 的智能，让它在框架内自主决策。**

![[附件/Image 7.jpg|图像]]

## 五、Skills 分配策略

OpenClaw 提供了很多 skills（技能/工具），如何合理分配给不同的 agent 是一个重要的设计决策。

## 分配原则

**按角色职责分配，避免混乱和误用。**

每个 agent 只配置与其角色相关的 skills，这样可以：

- 避免 agent 使用不该用的工具
- 减少选择困难（工具太多反而不知道用哪个）
- 明确责任边界

## 具体分配

## Main Agent

> "skills": \[ "kanban-team", // 看板巡检 + 团队协作规则 "discord", // Discord 基础操作 "github", // GitHub 操作（查看 PR、Issues） "self-improvement", // 学习和改进 "bark-notify" // 任务完成通知 \]

**为什么这样分配**：

- Main 需要管理看板，所以需要 kanban-team
- Main 需要在 Discord 上协调，所以需要 discord
- Main 需要查看 GitHub 状态，但不需要写代码
- Main 不需要代码、调研、内容创作相关的工具

## Code Agent

> "skills": \[ "brainstorming", // 需求分析和设计 "writing-plans", // 编写实现计划 "executing-plans", // 执行实现计划 "coding-agent", // 委派给其他代码 agent "github", // GitHub 操作（PR、代码审查） "browser-use", // 浏览器自动化测试 "context7", // 查询技术文档 "self-improvement" // 学习和改进 \]

## Researcher Agent

> "skills": \[ "tavily-search", // AI 优化的网络搜索 "context7", // 查询技术文档 "github", // GitHub 调研 "browser-use", // 网页信息提取 "youtube-ultimate", // YouTube 内容分析 "xiaohongshu", // 小红书内容分析 "xapi", // 第三方 API 调用 "openviking", // RAG 语义搜索 "self-improvement" // 学习和改进 \]

## Obsidian Agent

> "skills": \[ "obsidian", // Obsidian vault 操作 "notion", // Notion 操作 "wechat-gzh", // 微信公众号发布 "twitter-sync", // Twitter 书签同步 "xiaohongshu", // 小红书内容提取 "youtube-ultimate", // YouTube 转录和分析 "notebooklm", // 生成播客内容 "openviking", // 知识库语义搜索 "self-improvement" // 学习和改进 \]

## 技术实现

在 openclaw.json 中配置每个 agent 的 skills 白名单：

> { "agents": { "list": \[ { "skills": \[ "brainstorming", "writing-plans", "executing-plans", "github", "browser-use", "context7", "self-improvement" \] } \] } }

![[附件/Image 8.jpg|图像]]

## 六、监控机制设计

## 为什么需要监控？

在多 agent 系统中，任务可能会因为各种原因被遗忘或卡住：

- Agent 完成任务后忘记汇报
- 任务被分配后长时间没有进展
- 任务状态不明确（没有标签）
- 任务被标记为 Blocked 但没人处理

**如果没有监控机制，这些任务会一直躺在看板上，永远不会被处理。**

## Heartbeat 机制

我设计了一个 **Heartbeat（心跳）机制**，让 Main Agent 定期巡检任务看板。

## 工作原理

1. **定时触发**：通过 OpenClaw 的 heartbeat 功能，每 30 分钟触发一次
2. **优先级检查**：按照 HEARTBEAT.md 中定义的优先级检查任务
3. **智能决策**：Main Agent 根据任务状态决定如何处理
4. **静默模式**：如果没有需要处理的事项，返回 HEARTBEAT\_OK，不发送消息

## 检查优先级

> 1\. \*\*No tags\*\* → Read + assign + add TODO tag (highest priority) 2. \*\*Review\*\* → Verify and close 3. \*\*Blocked\*\* → Help resolve 4. \*\*In Progress >48h\*\* → Check progress 5. \*\*TODO >24h\*\* → Nudge or reassign

![[附件/Image 9.jpg|图像]]

## 七、Discord 集成设计

## 为什么选择 Discord？

在设计任务管理系统时，我考虑了几个选项：Notion Database、GitHub Projects、Discord Forum。

最终选择了 **Discord Forum 频道**，原因如下：

## 1\. Forum 频道天然支持线程

- 每个任务是一个独立的线程（thread）
- 线程内的讨论不会干扰其他任务
- 可以 @ 特定的 agent 参与讨论

## 2\. 标签系统完善

Discord Forum 支持标签（tags），可以用来表示任务状态：

- TODO
- In Progress
- Review
- Done
- Blocked

## 3\. 多 Bot 支持

- 每个 agent 可以有独立的 Bot 账号
- 不同的头像和昵称，容易区分
- 可以设置不同的权限

## 4\. API 完善

- Discord API 功能强大，文档完善
- 支持 Webhook、Bot、OAuth
- 可以实现复杂的交互（按钮、下拉菜单等）

## 5\. 移动端体验好

- Discord 有优秀的移动 App
- 可以随时随地查看任务状态
- 推送通知及时

## 6\. 免费

- Discord 完全免费
- 没有用户数限制
- 没有消息数限制

**所以Discord = 免费的项目管理工具**

![[附件/Image 10.jpg|图像]]

## Discord 集成的技术实现

## 1\. 独立 Bot 账号

每个 agent 有独立的 Discord Bot：

> { "channels": { "discord": { "accounts": { "default": { "token": "MTQ2NzczODkzNzY1MjE1NDQ4OQ...", "enabled": true }, "researcher-bot": { "token": "MTQ2NjY1NDMxNDEwMDQyNDgyOA...", "enabled": true }, "code-bot": { "token": "MTQ2OTU0NDk1Mzg1MDg4ODI5NQ...", "enabled": true }, "obsidian-bot": { "token": "MTQ2Nzc4MDA3ODMwOTA4MTIzMg...", "enabled": true } } } } }

## 2\. Agent 绑定

将 agent 绑定到对应的 Discord Bot：

> { "bindings": \[ { "agentId": "main", "match": { "channel": "discord", "accountId": "default" } }, { "agentId": "code", "match": { "channel": "discord", "accountId": "code-bot" } } \] }

## 七、给想搭建 AI 团队的建议

1\. 从小开始

不要一开始就搞太复杂：

1. 先搞定 1 个 agent（Main）
2. 加入 1 个执行 agent
3. 定义清晰的协作协议
4. 逐步添加更多 agent
5. 持续优化和调整

2\. 明确角色定位

每个 agent 要有清晰的：

- 职责范围
- 擅长领域
- 使用的模型
- 可用的工具

3\. 设计协作协议

在添加第二个 agent 之前，就要设计好协作协议。

4\. 重视监控

没有监控的系统是不可控的。

5\. 持续优化

AI 团队不是一次性设计好的，需要持续优化。

6\. 保持简洁

不要过度设计。

八、总结

构建 AI 团队本质上和构建人类组织是一样的，需要考虑：组织架构、沟通协议、权限边界、监控机制、成本资源等

**AI 团队管理是一个心得方向，需要我们不断探索和实践。**从中总结出更多经验来持续进化！