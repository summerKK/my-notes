---
created: 2026-01-12T11:42:04+08:00
reviewed: 2026-01-12T12:00:00+08:00
url: "https://thehackernews.com/2026/01/muddywater-launches-rustywater-rat-via.html"
title: "MuddyWater 通过鱼叉式钓鱼在中东地区发起 RustyWater RAT 攻击"
author:
  - "Ravie Lakshmanan"
published: 2026-01-10T18:35:00+08:00
description: "伊朗黑客组织 MuddyWater 使用基于 Rust 的 RustyWater RAT，通过 Word 宏钓鱼攻击中东地区组织"
tags:
  - 威胁情报
  - APT
  - 伊朗
  - 恶意软件
  - RAT
aliases:
  - RustyWater 攻击
  - MuddyWater 2026
threat-actor: MuddyWater
malware-family: RustyWater
attack-vector: 鱼叉式钓鱼
target-region: 中东
severity: high
status: active
---

#webclip/read #threat-intelligence #apt #iran

# MuddyWater 通过鱼叉式钓鱼在中东地区发起 RustyWater RAT 攻击

[![MuddyWater 攻击示意图](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhJ8l0NucKedkyhQLr7E5BKEvF8JlDztA0fBd3dL1lku0PJHK4PqEpa1mkpxpWhYKq4MpxuL1fr9p6NbpkU8GfhFTct25hVf6bMPsTJDTfQz71Y_aQD0gv0ln0gYFDYMEbTQ1s-52sSJz0OgoVjhaDkq1TExIJzTdIrLUjmZPwe1tzKEHDO_7-JKV9_BDRQ/s790-rw-e365/1000046762.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhJ8l0NucKedkyhQLr7E5BKEvF8JlDztA0fBd3dL1lku0PJHK4PqEpa1mkpxpWhYKq4MpxuL1fr9p6NbpkU8GfhFTct25hVf6bMPsTJDTfQz71Y_aQD0gv0ln0gYFDYMEbTQ1s-52sSJz0OgoVjhaDkq1TExIJzTdIrLUjmZPwe1tzKEHDO_7-JKV9_BDRQ/s790-rw-e365/1000046762.jpg)

## 📋 概述

> [!abstract] 威胁摘要
> 伊朗威胁行为者 [[MuddyWater]] 被归因于一场针对中东地区外交、海事、金融和电信实体的鱼叉式钓鱼攻击活动，使用代号为 ==RustyWater== 的基于 Rust 的植入程序。
>
> **关键信息**：
> - 🎯 **威胁组织**：MuddyWater (MOIS)
> - 🦠 **恶意软件**：RustyWater RAT
> - 📧 **攻击方式**：鱼叉式钓鱼 + Word 宏
> - 🌍 **目标地区**：中东、以色列

## 🎯 威胁行为者

> [!danger] MuddyWater 组织档案
> **MuddyWater** 组织信息：
> - **别名**：Mango Sandstorm、Static Kitten、TA450
> - **隶属**：伊朗情报与安全部（MOIS）
> - **活跃时间**：自 2017 年至今
> - **特征**：持续演进攻击工具链

## 🔧 攻击活动详情

### 攻击目标
- 🏛️ 外交机构
- ⚓ 海事组织
- 💰 金融机构
- 📡 电信公司

### 攻击链

> [!info] CloudSEK 研究报告
> CloudSEK 研究员 Prajwal Awasthi 在[本周发布的报告](https://www.cloudsek.com/blog/reborn-in-rust-muddywater-evolves-tooling-with-rustywater-implant)中指出：
>
> "该攻击活动使用图标欺骗和恶意 Word 文档来投放基于 Rust 的植入程序，具备异步 C2 通信、反分析、注册表持久化和模块化后渗透能力扩展功能。"

> [!example]- 攻击流程详解
> 1. **初始访问**：鱼叉式钓鱼邮件伪装成网络安全指南
> 2. **载荷投递**：附带恶意 Microsoft Word 文档
> 3. **用户交互**：诱导受害者点击"[启用内容](https://thehackernews.com/2024/06/hackers-use-ms-excel-macro-to-launch.html)"
> 4. **恶意执行**：激活 VBA 宏部署 Rust 植入程序二进制文件

## 🦠 RustyWater RAT 技术分析

> [!bug] 恶意软件档案
> **别名**：
> - Archer RAT
> - RUSTRIC
>
> **C2 服务器**：`nomercys.it[.]com`

### 核心功能

| 功能类别 | 具体能力 |
|---------|---------|
| 🔍 信息收集 | 收集受害者机器信息 |
| 🛡️ 安全检测 | 检测已安装的安全软件 |
| 📌 持久化 | 通过 Windows 注册表键建立持久化 |
| 🌐 C2 通信 | 与命令控制服务器建立联系 |
| 📁 文件操作 | 执行文件操作 |
| 💻 命令执行 | 远程命令执行 |

### 技术特点

> [!tip] Rust 技术优势
> - **编程语言**：Rust
> - **通信方式**：异步 C2
> - **反分析能力**：检测虚拟环境和安全软件
> - **持久化机制**：Windows 注册表
> - **架构设计**：模块化、低噪音

## 🔄 工具演进

MuddyWater 的最新发展反映了其攻击技术的持续演进，该组织已逐步[减少对合法远程访问软件的依赖](https://thehackernews.com/2026/01/threatsday-bulletin-rustfs-flaw-iranian.html#iranian-group-evolves)作为后渗透工具，转而使用多样化的自定义恶意软件武器库。

> [!note]- 历史工具
> - PowerShell 加载器
> - VBS 加载器
> - 合法远程访问软件

> [!warning] 当前工具链
> - 🦀 **[[RustyWater]]** (Rust-based RAT)
> - 🔥 **[Phoenix](https://thehackernews.com/2025/12/muddywater-deploys-udpgangster-backdoor.html)**
> - 📡 **[UDPGangster](https://thehackernews.com/2025/12/muddywater-deploys-udpgangster-backdoor.html)** (后门)
> - 😴 **[BugSleep](https://thehackernews.com/2025/12/iran-linked-hackers-hits-israeli_2.html)** (又名 MuddyRot)
> - 🐍 **[MuddyViper](https://thehackernews.com/2025/12/iran-linked-hackers-hits-israeli_2.html)**

> [!quote] CloudSEK 分析
> "历史上，MuddyWater 依赖 PowerShell 和 VBS 加载器进行初始访问和后渗透操作。引入基于 Rust 的植入程序代表了工具演进的重要里程碑，朝着更结构化、模块化和低噪音的 RAT 能力发展。"

## 🇮🇱 相关攻击活动

> [!info] Operation IconCat
> 值得注意的是，Seqrite Labs 在上个月末[标记](https://thehackernews.com/2025/12/threatsday-bulletin-stealth-loaders-ai.html#israel-targeted-phishing)了 RUSTRIC 的使用，作为针对以色列的攻击活动的一部分。
>
> **以色列攻击目标**：
> - 信息技术（IT）公司
> - 托管服务提供商（MSP）
> - 人力资源部门
> - 软件开发公司
>
> **活动代号**：
> - UNG0801
> - Operation IconCat

## 🛡️ 防御建议

> [!success] 防护措施
> 1. **邮件安全**：加强对钓鱼邮件的识别和过滤
> 2. **宏禁用**：默认禁用 Office 文档宏执行
> 3. **用户培训**：提高员工对社会工程攻击的警觉性
> 4. **端点防护**：部署能够检测 Rust 恶意软件的安全解决方案
> 5. **网络监控**：监控异常的 C2 通信行为
> 6. **注册表监控**：监控可疑的注册表持久化机制

## 📚 参考资料

- [CloudSEK 完整报告](https://www.cloudsek.com/blog/reborn-in-rust-muddywater-evolves-tooling-with-rustywater-implant)
- [MuddyWater 历史活动](https://thehackernews.com/2025/10/iran-linked-muddywater-targets-100.html)
- [UDPGangster 后门分析](https://thehackernews.com/2025/12/muddywater-deploys-udpgangster-backdoor.html)
- [以色列攻击活动](https://thehackernews.com/2025/12/iran-linked-hackers-hits-israeli_2.html)

---

## 🔗 相关笔记

- [[MuddyWater]] - 威胁组织档案
- [[RustyWater]] - 恶意软件分析
- [[鱼叉式钓鱼攻击]] - 攻击技术
- [[Rust 恶意软件]] - 技术趋势
- [[伊朗 APT 组织]] - 地缘政治威胁

## 📊 威胁情报标签

#muddywater #rustywater #apt #iran #mois #spear-phishing #rat #rust-malware #middle-east #israel #operation-iconcat

**可视化分析**：![[webclips/MuddyWater RustyWater Attack Analysis.canvas]]