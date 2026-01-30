# Google 大模型战争：从 Transformer 到 Gemini 3 的反击之路

> "The Thinking Game 不仅是一部纪录片的名字，更是 Google 在大模型时代的生存哲学。"

---

## 引子：2025 年 11 月的双重发布

2025 年 11 月 18 日，Google 同时做了两件事：发布了 Gemini 3 模型，并在 YouTube 上免费公开了历时五年拍摄的纪录片《The Thinking Game》。

前者在 LMArena 排行榜上以 1501 Elo 的突破性分数登顶，超越了所有竞争对手；后者记录了 DeepMind 创始人 Demis Hassabis 和他的团队追求人工通用智能（AGI）的漫长旅程，包括 AlphaFold 解决 50 年生物学难题并最终获得诺贝尔奖的历史性时刻。

这两个看似独立的事件，实际上构成了一个完整的叙事：**Google 如何从大模型战争的创造者变成追赶者，又如何通过科学的严谨和长期主义的坚持，完成了一次惊人的反击。**

这是一个关于创新者窘境、组织变革、技术突破和战略耐心的故事。

---

## 第一章：创造者的悖论

### Transformer：改变世界的论文

2017 年，Google 的研究团队发表了一篇名为《Attention is All You Need》的论文，提出了 Transformer 架构。这篇论文的 8 位作者可能没有想到，他们创造的这个架构将成为整个大模型时代的基石。

GPT、BERT、T5、LLaMA、Claude、Gemini——几乎所有今天我们熟知的大语言模型，都建立在 Transformer 的基础之上。这是 Google 对 AI 领域最深远的贡献之一。

然而，讽刺的是，**最终在产品化和商业化上领先的，却是基于这个架构的竞争对手 OpenAI。**

这就是创造者的悖论：发明了游戏规则的人，为什么会在游戏中落后？

### 黄金时代的学术统治

2018-2019 年，Google 在 AI 领域的学术影响力达到巅峰：

- **BERT（2018）**：开创了预训练-微调范式，在 11 个 NLP 任务上刷新了记录。几乎每个 NLP 研究者都在使用 BERT 或其变体。

- **T5（2019）**：提出了统一的"文本到文本"框架，将所有 NLP 任务统一为同一种形式。这种优雅的设计思想影响深远。

- **Switch Transformer（2021）**：探索了稀疏专家混合（MoE）架构，为后来的大规模模型提供了技术路径。

这些模型在学术界引发了巨大反响，论文被引用数万次，成为了 NLP 研究的标准工具。Google 似乎牢牢掌控着 AI 研究的方向。

**但问题在于：这些都是研究项目，不是产品。**

### LaMDA：错失的产品化机会

2021 年，Google 内部已经有了 LaMDA（Language Model for Dialogue Applications），一个专门为对话设计的大语言模型。从技术能力上看，LaMDA 并不逊色于同时期的模型。

2022 年，一位 Google 工程师甚至因为认为 LaMDA 具有"感知能力"而引发了轰动性的新闻。这说明 LaMDA 的对话能力已经足够令人印象深刻。

**但 LaMDA 始终没有成为一个面向公众的产品。**

Google 内部对于发布 AI 产品极为谨慎。他们担心模型的幻觉问题、伦理风险、对搜索广告业务的冲击。这种谨慎在当时看来是负责任的，但也让 Google 错失了先发优势。

---

## 第二章：ChatGPT 的冲击波

### 2022 年 11 月 30 日：Code Red

当 OpenAI 发布 ChatGPT 时，整个科技界都震惊了。但最震惊的可能是 Google。

ChatGPT 在 5 天内获得了 100 万用户，2 个月内达到 1 亿月活用户。这是互联网历史上增长最快的消费级应用。

更重要的是，**ChatGPT 证明了大语言模型可以成为一个成功的产品**，而不仅仅是一个研究工具。

Google CEO Sundar Pichai 宣布进入"Code Red"状态——这是 Google 内部用来描述公司级紧急状态的术语。上一次使用这个词，还是在 Facebook 推出移动应用威胁到 Google 的时候。

### 仓促应战：Bard 的挫折

2023 年 2 月，Google 匆忙推出了 Bard，基于 LaMDA 的对话 AI 产品。

但 Bard 的首次亮相是灾难性的。在发布会的演示视频中，Bard 给出了一个关于詹姆斯·韦伯太空望远镜的错误答案。这个错误被媒体广泛报道，Google 的股价当天下跌了 7.7%，市值蒸发了 1000 亿美元。

更糟糕的是，早期用户对 Bard 的评价普遍不佳。与 ChatGPT 相比，Bard 的回答显得保守、机械，缺乏创造性。

**Google 在自己创造的游戏中，被 OpenAI 打得措手不及。**

### 人才流失的代价

更深层的问题是人才流失。

Transformer 论文的 8 位作者中，有多位已经离开 Google 创业：
- Noam Shazeer 和 Daniel De Freitas 创立了 Character.AI
- Jakob Uszkoreit 创立了 Inceptive
- Llion Jones 加入了 Sakana AI

这些离开的研究者，带走的不仅是技术能力，还有对 Google 内部文化的失望：**过度的谨慎、缓慢的决策、产品化的困难。**

在快速迭代的 AI 时代，Google 的大公司病开始显现。

---

## 第三章：组织重组：Brain 与 DeepMind 的合并

### 两个 AI 实验室的竞争

在 ChatGPT 冲击之前，Google 内部实际上有两个世界级的 AI 研究团队：

1. **Google Brain**：由 Jeff Dean 领导，专注于深度学习基础研究和 TensorFlow 等工具开发。Transformer、BERT、T5 都出自这个团队。

2. **DeepMind**：2014 年被 Google 收购，由 Demis Hassabis 领导，以强化学习和 AGI 研究著称。AlphaGo、AlphaFold 是其代表作。

这两个团队各有优势，但也存在竞争和重复。在 AI 竞赛加速的背景下，这种分散的力量成为了劣势。

### 2023 年 4 月：历史性的合并

2023 年 4 月 20 日，Sundar Pichai 宣布将 Google Brain 和 DeepMind 合并为一个新的组织：**Google DeepMind**。

这次合并的权力结构设计很有意思：
- **Demis Hassabis** 担任 Google DeepMind CEO，负责执行和产品化
- **Jeff Dean** 升任 Google 首席科学家（Chief Scientist），负责整体 AI 战略

这不是一次简单的权力斗争，而是一次精心设计的互补：
- Demis 带来了 DeepMind 的科学严谨和对 AGI 的长期愿景
- Jeff 提供了 Google Brain 的工程能力和对 Google 产品体系的深刻理解

**合并的目标很明确：集中力量，加速 Gemini 的开发。**

### The Thinking Game：内部文化的展现

2024 年，纪录片《The Thinking Game》在 Tribeca 电影节首映，2025 年 11 月在 YouTube 免费发布。

这部由制作《AlphaGo》纪录片的团队历时 5 年拍摄的影片，提供了一个理解 Google AI 文化的独特视角。

纪录片记录了 AlphaFold 团队得知他们解决了蛋白质折叠这个 50 年生物学难题的瞬间。那种科学突破的纯粹喜悦，与商业竞争的焦虑形成了鲜明对比。

**这揭示了 Google 的核心矛盾：他们是一群追求科学突破的研究者，但现在必须在商业战场上与 OpenAI 这样的对手竞争。**

Demis Hassabis 在纪录片中说："我们不是在玩一个短期的游戏。我们在玩的是思考的游戏（The Thinking Game）——如何让机器真正理解和推理。"

这种长期主义的思维，既是 Google 的优势，也是他们在产品化上落后的原因。

---

## 第四章：Gemini 三部曲

### Gemini 1.0：多模态的基础（2023 年 12 月）

合并后的 Google DeepMind 迅速推出了第一个成果：Gemini 1.0。

Gemini 1.0 的核心创新是**原生多模态**。与 GPT-4V 先训练文本模型再添加视觉能力不同，Gemini 从一开始就被设计为能够理解文本、图像、音频、视频和代码的统一模型。

这种设计带来了更好的跨模态理解能力。例如，Gemini 可以分析一段视频中的物理现象，然后生成代码来模拟这个现象。

Gemini 1.0 还引入了**长上下文窗口**，最高可达 100 万 token，远超当时的竞争对手。

但 Gemini 1.0 的发布并没有引起太大轰动。人们仍然在使用 ChatGPT 和 GPT-4。

### Gemini 2.0：Agent 的基础（2024 年）

Gemini 2.0 的重点是**Agent 能力**——让 AI 不仅能回答问题，还能执行任务。

这一代模型引入了：
- 更强的工具使用能力
- 更好的规划和推理能力
- 更长的上下文窗口（保持在 100 万 token）

Gemini 2.5 Pro 在 2024-2025 年期间在 LMArena 排行榜上保持了超过 6 个月的领先地位。这是 Google 第一次在公开基准测试中持续领先。

但真正的突破还在后面。

### Gemini 3：全面反击（2025 年 11 月）

2025 年 11 月 18 日，Gemini 3 的发布标志着 Google 的全面反击。

**技术指标的全面领先：**

- **LMArena 排行榜**：1501 Elo，超越所有竞争对手
- **PhD 级推理**：Humanity's Last Exam 37.5%（无工具），GPQA Diamond 91.9%
- **数学能力**：MathArena Apex 23.4%，创造新纪录
- **多模态推理**：MMMU-Pro 81%，Video-MMMU 87.6%
- **事实准确性**：SimpleQA Verified 72.1%

**Gemini 3 Deep Think 模式：**

这是一个增强推理模式，在最困难的基准测试上表现更加出色：
- Humanity's Last Exam：41.0%（无工具）
- GPQA Diamond：93.8%
- ARC-AGI-2：45.1%（这是一个测试 AI 解决新颖问题能力的基准）

**产品化的加速：**

- **首次在发布当天整合进搜索**：AI Mode in Search 使用 Gemini 3，提供生成式 UI 体验
- **Gemini App**：6.5 亿月活用户
- **AI Overviews**：20 亿月活用户
- **开发者生态**：1300 万开发者使用 Google 的生成式模型

**Google Antigravity：重新定义开发体验**

与 Gemini 3 一起发布的还有 Google Antigravity，一个全新的 Agent 开发平台。

Antigravity 不是简单的 AI 辅助编程工具，而是一个让 AI Agent 能够自主规划和执行复杂软件任务的平台。Agent 可以直接访问编辑器、终端和浏览器，自主完成从规划到编码到测试的完整流程。

这是对 Cursor、GitHub Copilot 等工具的直接挑战。

---

## 第五章：反击的密码

### 科学严谨 vs 快速迭代

OpenAI 的策略是"快速发布，快速迭代"。ChatGPT 在发布时并不完美，但通过用户反馈快速改进。

Google 的策略是"科学验证，负责任发布"。Gemini 3 经过了"最全面的安全评估"，与英国 AISI、Apollo、Vaultis 等独立机构合作进行测试。

**AlphaFold 的诺贝尔奖证明了这种方法的价值。**

2024 年，Demis Hassabis 和 John Jumper 因 AlphaFold 获得诺贝尔化学奖。这是 AI 研究首次获得诺贝尔奖，也是对 DeepMind 科学方法论的最高认可。

这种科学严谨性最终也体现在了 Gemini 3 上：
- 更低的幻觉率
- 更强的事实准确性
- 更好的安全性（减少了谄媚行为，提高了对提示注入的抵抗力）

### 基础设施的优势

Google 拥有其他公司难以匹敌的基础设施优势：

1. **TPU（Tensor Processing Unit）**：Google 自研的 AI 芯片，专门为大规模模型训练优化。这让 Google 在训练成本和效率上有显著优势。

2. **数据中心规模**：Google 的全球数据中心网络可以支持超大规模的模型训练和推理。

3. **数据优势**：Google 拥有搜索、YouTube、Gmail、Google Maps 等产品产生的海量数据。

这些优势在短期内可能不明显，但在长期竞争中是决定性的。

### 长期主义的坚持

《The Thinking Game》纪录片拍摄了 5 年。AlphaFold 项目从启动到突破用了 4 年。Gemini 从立项到 3.0 用了近 3 年。

**这种长期主义与硅谷的"快速失败"文化形成了鲜明对比。**

Demis Hassabis 在接受采访时说："我们不是在优化下一个季度的收入，我们在优化未来 10 年的科学突破。"

这种思维在 Gemini 3 上得到了回报。那些看似"缓慢"的研究和测试，最终产生了一个在所有关键指标上都领先的模型。

### 组织整合的化学反应

Google Brain 和 DeepMind 的合并不是简单的 1+1=2，而是产生了化学反应：

- **Brain 的工程能力** + **DeepMind 的科学严谨** = 既有突破性研究，又能快速产品化
- **Jeff Dean 的战略视野** + **Demis Hassabis 的执行力** = 清晰的方向和高效的执行
- **Transformer 的技术积累** + **AlphaGo/AlphaFold 的方法论** = Gemini 的独特优势

合并后的 Google DeepMind 团队规模达到 6000 人，成为世界上最大的 AI 研究团队。

---

## 第六章：未来的战场

### Agent 时代的竞争

Gemini 3 在 Vending-Bench 2 上的表现展示了其长期规划能力。这个基准测试模拟了管理一个自动售货机业务一整年的过程，测试模型是否能保持一致的决策而不偏离任务。

Gemini 3 Pro 在这个测试中显著超越了其他模型，这意味着它可以更好地处理复杂的、多步骤的现实世界任务。

**这预示着 AI 竞争的下一个战场：Agent 能力。**

不再是简单的问答，而是能够代表用户执行复杂任务的 AI Agent。Google 已经在 Gemini App 中为 Ultra 订阅用户提供了 Gemini Agent，可以帮助组织邮件、预订服务等。

### 与 OpenAI o1 的推理竞赛

OpenAI 的 o1 系列模型专注于推理能力，在数学和编程任务上表现出色。

Gemini 3 Deep Think 是 Google 的回应。在 ARC-AGI-2 上 45.1% 的成绩，展示了其解决新颖问题的能力。

**推理能力将成为下一代 AI 模型的核心竞争力。**

这不仅仅是在基准测试上刷分，而是关系到 AI 能否真正理解复杂问题、进行多步推理、解决开放性挑战。

### 多模态的深化

Gemini 3 在视频理解上的突破（Video-MMMU 87.6%）开辟了新的应用场景：

- 分析体育比赛视频，提供专业级的技术指导
- 理解教学视频，生成交互式学习材料
- 处理长达 3 小时的视频内容

**视频理解能力将是 AI 应用的下一个爆发点。**

### 开发者生态的争夺

Google Antigravity、Cursor、GitHub Copilot、Replit——开发者工具市场正在成为 AI 公司的必争之地。

谁能赢得开发者，谁就能建立更强大的生态系统。

Google 的优势在于：
- Gemini 3 的 Vibe Coding 能力（WebDev Arena 1487 Elo）
- 与 Google Cloud、Firebase 等产品的深度整合
- 免费的 AI Studio 和 Gemini CLI

但 OpenAI 也在通过 GitHub Copilot 和 ChatGPT 的 Code Interpreter 争夺这个市场。

---

## 尾声：思考游戏的真正含义

2025 年 11 月，当《The Thinking Game》纪录片在 YouTube 上免费发布时，它不仅仅是一部关于 DeepMind 的纪录片，更是 Google 在 AI 时代的一份宣言。

**The Thinking Game 有三层含义：**

1. **科学的游戏**：追求真理和突破，而不仅仅是商业成功。AlphaFold 的诺贝尔奖证明了这条路的价值。

2. **长期的游戏**：不被短期的竞争压力左右，坚持做正确的事情。Gemini 3 的成功证明了耐心的回报。

3. **思考的游戏**：真正的 AI 不是简单的模式匹配，而是深度的推理和理解。这是通向 AGI 的唯一道路。

从 2017 年的 Transformer 论文，到 2022 年被 ChatGPT 冲击，再到 2025 年 Gemini 3 的反击，Google 走过了一条曲折但最终向上的道路。

**这个故事告诉我们：**

- **创新者的窘境是真实存在的**：发明技术和产品化是两回事。
- **组织变革是必要的**：Google Brain 和 DeepMind 的合并释放了巨大的能量。
- **长期主义会有回报**：科学的严谨和战略的耐心最终战胜了短期的焦虑。
- **竞争推动进步**：没有 OpenAI 的挑战，可能就没有今天的 Gemini 3。

2026 年，AI 战争还在继续。OpenAI、Anthropic、Meta、Google——每个玩家都在推动边界。

但 Google 已经证明：**在这场思考的游戏中，他们不仅没有出局，反而可能正在重新定义游戏规则。**

---

## 参考资料

1. Google Blog: "A new era of intelligence with Gemini 3" (2025-11-18)
2. Google DeepMind: "The Thinking Game" Documentary (2025-11-25)
3. Google Blog: "Google DeepMind: Bringing together two world-class AI teams" (2023-04-20)
4. Vaswani et al.: "Attention is All You Need" (2017)
5. Devlin et al.: "BERT: Pre-training of Deep Bidirectional Transformers" (2018)
6. Raffel et al.: "Exploring the Limits of Transfer Learning with T5" (2019)
7. Jumper et al.: "Highly accurate protein structure prediction with AlphaFold" (2021)
8. Nobel Prize in Chemistry 2024: Demis Hassabis and John Jumper

---

*本文写于 2026 年 1 月，基于公开信息和官方发布。*
