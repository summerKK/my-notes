---
title: AI 编程工具的大脑之争：JetBrains MCP vs Serena MCP
date: 2026-02-27
tags:
  - AI
  - MCP
  - JetBrains
  - Serena
  - 编程工具
  - PSI
  - LSP
aliases:
  - JetBrains MCP vs Serena MCP
---

# AI 编程工具的大脑之争：JetBrains MCP vs Serena MCP

> [!abstract] TL;DR
> 当 AI 开始帮你写代码，它需要一个接口来「理解」你的项目。JetBrains 和 Serena 提供了两种截然不同的思路：一个是 **IDE 遥控器**，一个是 **AI 原生工作台**。而它们背后的核心差异，藏在一个叫 PSI 的引擎里。

## 什么是 MCP？

MCP（Model Context Protocol）是一种让 AI 大模型与外部工具交互的协议。简单来说，它让 ChatGPT、Claude 这类 AI 能够**读你的代码、搜索符号、执行重构**——而不只是生成一段文本让你自己粘贴。

你可以把 MCP 理解为 AI 和开发工具之间的一条「神经通路」。通路越粗、信号越丰富，AI 就越聪明。

## 两位选手登场

### 🏢 JetBrains 原生 MCP Server

JetBrains 自家出品，作为 IntelliJ IDEA 的插件运行在 IDE 内部。它的设计思路是：

> **把 IDE 的能力暴露给 AI。**

AI 可以通过它打开文件、运行程序、查看代码问题、执行重命名——本质上就是一个 ==IDE 遥控器==。

### 🔧 Serena MCP Server

Serena 是一个独立的第三方 MCP 服务器，专为 AI Agent 场景设计。它有两种运行模式：

- **LSP 模式**（免费）：自己启动语言服务器来分析代码
- **JetBrains 插件模式**（$70/年）：通过插件借用 JetBrains 的分析引擎

它的设计思路是：

> **让 AI 像开发者一样思考和操作代码。**

## 工具对比：谁能做什么？

### 代码理解能力

| 能力 | JetBrains MCP | Serena MCP |
|:--|:--|:--|
| 按名称查找符号 | ❌ 需要文件路径 + 行列号 | ✅ 按名称路径，如 `UserService/getUser` |
| 查找所有引用 | ❌ | ✅ |
| 符号概览（类有哪些方法） | ❌ | ✅ |
| 类型继承层次 | ❌ | ✅（JB 插件模式） |
| 代码问题检测 | ✅ IntelliJ Inspections，==非常强== | ❌ |

### 代码编辑能力

| 能力 | JetBrains MCP | Serena MCP |
|:--|:--|:--|
| 文本替换 | ✅ 纯文本匹配 | ✅ 支持文本 + 正则 |
| 按符号名替换函数体 | ❌ | ✅ `replace_symbol_body` |
| 在某个函数后插入新代码 | ❌ | ✅ `insert_after_symbol` |
| 语义重命名 | ✅ | ✅ |
| 代码格式化 | ✅ | ❌ |

### 工作流能力

| 能力 | JetBrains MCP | Serena MCP |
|:--|:--|:--|
| 跨会话记忆 | ❌ | ✅ Memory 系统 |
| 项目切换管理 | ❌ | ✅ |
| 运行程序 / 测试 | ✅ Run Configuration | ❌ |
| 打开文件到编辑器 | ✅ | ❌ |

> [!tip] 核心差异一句话
> JetBrains MCP 是 **"告诉 AI 你的 IDE 能做什么"**；Serena MCP 是 **"让 AI 自己能做什么"**。

### Serena 的杀手锏

Serena 最大的优势在于一套「符号级操作」组合拳：

```
find_symbol → replace_symbol_body → insert_after_symbol
```

AI 可以说：*"找到 `UserService` 类的 `getUser` 方法，在它后面插入一个新方法"*——**不需要知道任何行号**。

而 JetBrains MCP 的工作方式是基于行列号的，AI 必须先定位到具体位置，才能操作。这在复杂场景下效率差距明显。

### JetBrains 的护城河

反过来，JetBrains MCP 的 `get_file_problems`（代码问题检测）和 `execute_run_configuration`（运行程序）是 Serena 没有的。这两个能力在实际开发中非常有价值——AI 可以帮你检查代码质量、直接跑测试。

## 幕后大佬：PSI 引擎

说到两者的底层差异，就不得不提 JetBrains 的秘密武器——**PSI**。

### PSI 是什么？

PSI（Program Structure Interface）是 IntelliJ 平台的 ==核心代码分析引擎==。你在 JetBrains IDE 里用到的几乎所有「智能」功能——代码补全、跳转定义、重命名重构、代码检查——底层都是 PSI 在工作。

PSI 做的事情是：**把源代码解析成一棵带语义的结构树。**

```
PsiJavaFile
  └─ PsiClass (UserService)
       ├─ PsiField (userRepository)
       ├─ PsiMethod (getUser)
       │    ├─ PsiParameterList
       │    └─ PsiReturnStatement
       │         └─ PsiMethodCallExpression
       │              → 能解析到 userRepository.findById() 的定义位置
       └─ PsiMethod (saveUser)
```

这不是简单的语法树（AST），而是一个**可导航、可解析、可修改的完整语义模型**：

- 每个节点知道自己的类型、作用域、可见性
- 引用可以被**解析**——点击一个方法调用，PSI 知道它定义在哪里
- 支持跨文件、跨模块、甚至跨依赖库的解析
- 增量更新——改一行代码只需重新解析受影响的部分

> [!info] 类比理解
> 如果把代码比作一本书，AST 只是目录和段落结构，而 PSI 是一个**全文索引 + 交叉引用系统**——它知道每个概念在哪里被定义、在哪里被引用、它们之间的关系是什么。

### PSI vs LSP：引擎级别的差距

LSP（Language Server Protocol）是微软提出的通用语言分析协议，被 VS Code 等编辑器广泛使用。它和 PSI 的本质区别在于：

| 维度 | PSI | LSP |
|:--|:--|:--|
| 运行方式 | IDE 内部，直接操作内存中的语义树 | 独立进程，通过 JSON-RPC 通信 |
| 数据模型 | 完整的语义树对象，可遍历、可修改 | 请求-响应模式，返回扁平结果 |
| 引用解析 | 直接返回目标对象 | 返回文件路径 + 行列号 |
| 类型推断 | 深度推断，理解泛型、继承、重载 | 取决于具体语言服务器实现 |
| 外部依赖 | 能索引所有依赖库的源码 | 大多只索引项目内代码 |
| 多语言协作 | 跨语言引用解析（Java ↔ Kotlin ↔ XML） | 每种语言独立，互不感知 |

> [!quote] 一句话本质
> PSI 是 **in-process 的全量语义模型**，LSP 是 **out-of-process 的查询协议**。

## 两个 MCP 如何使用 PSI？

了解了 PSI，回头看两个 MCP 的架构就清晰了：

```
JB 原生 MCP:   LLM ←→ JB MCP Plugin ←→ PSI 引擎（IDE 内，同进程）
Serena JB 模式: LLM ←→ Serena MCP ←→ JB Plugin（HTTP）←→ PSI 引擎（IDE 内）
Serena LSP 模式: LLM ←→ Serena MCP ←→ Language Server（LSP 协议）
```

- **JetBrains 原生 MCP** → 100% 使用 PSI，是 PSI 的一层薄封装
- **Serena JB 插件模式** → 间接使用 PSI，多了一层 HTTP 中转
- **Serena LSP 模式** → 完全不用 PSI，依赖各语言的 Language Server

## PSI 的实际价值在哪里？

PSI 比 LSP 强的地方，日常体现为四个方面：

**1. 外部库索引**
PSI 能解析 `.jar` / `.class` 文件里的符号。你用 Spring 的 `@Autowired`，PSI 知道注入的是哪个 Bean。LSP 通常做不到这么深。

**2. Inspections 质量**
JetBrains 花了 ==20 年打磨的代码检查规则库==（空指针检测、未使用代码、性能问题……），全部基于 PSI 的深度语义分析。这是其他工具难以复制的。

**3. 重构可靠性**
PSI 的重命名能处理字符串里的类名引用、XML 配置里的 bean 名、注解里的值。LSP 的重命名通常只处理代码引用。

**4. 多语言项目**
一个 Spring Boot 项目里有 Java + Kotlin + XML + SQL + HTML，PSI 能跨语言解析引用。LSP 模式下每种语言是独立的服务器，互相不知道对方的存在。

## 怎么选？

> [!example] 选择建议
>
> **写 Java / Kotlin 大项目 → JetBrains 原生 MCP + Serena JB 插件模式**
> PSI 的深度分析在大型项目中优势明显，两者搭配使用可以同时获得 IDE 控制能力和 AI Agent 工作流。
>
> **写 TypeScript / Python → Serena LSP 模式通常就够了**
> 这些语言的 Language Server（如 TypeScript Language Server、Pyright）本身已经足够成熟，PSI 的边际收益不大。
>
> **想要 AI 全自动工作 → Serena 是更好的选择**
> 它的符号级操作 + Memory 系统 + 项目管理，天然为 AI Agent 场景设计。
>
> **需要代码质量检查 + 运行测试 → JetBrains 原生 MCP 不可替代**
> IntelliJ Inspections 和 Run Configuration 是 Serena 没有的独家能力。

---

> [!note] 写在最后
> Serena 的 JetBrains 插件要 $70/年，买的不是 Serena 的功能，买的是 **PSI 引擎的接入权**。理解了 PSI 是什么，这个定价逻辑就清楚了——你花钱买的是 JetBrains 20 年积累的代码理解能力。
