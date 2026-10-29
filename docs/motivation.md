# 研究动机资料包：安全自我进化的收益，能否经受后续正常能力自我进化？


## 0. 核心结论：我们到底想研究什么？

**当前动态安全自我进化研究，主要关注如何在安全训练过程中持续发现并修复漏洞，使模型在安全训练完成时获得更强的防御能力。然而，模型的进化并不会因此停止：它还可能通过后续正常能力自我进化持续提升推理、编程、任务执行等能力。已有研究表明，正常能力训练本身可能损害先前建立的安全对齐。那么，通过动态安全自我进化获得的安全收益，在后续正常能力自我进化中能否持续保持？**

这就是我们目前唯一需要验证的核心研究问题。特别注意：

- 我们**不预设**后续正常能力自我进化必然破坏安全，也不预设退化一定越来越严重；这些都是开放问题。
- 我们**不把**“正常训练可能破坏安全对齐”当作新的发现；这是支撑我们提出问题的**已知证据**。
- 我们关心的是**先通过动态安全自我进化获得安全增益，再进入后续正常能力自我进化**这一连续生命周期，而非一般模型的一次常规微调。
- 我们暂时聚焦**模型训练／参数更新层面的安全自我改进与能力自我改进**。长期记忆积累、隐私传播等可作为相关背景，不与本课题的主要研究对象混在一起。

## 1. 首先区分两个不能混淆的研究场景

### 场景 A：安全训练期间，尽量保留正常能力（已有安全自我进化研究）

```text
初始模型 M0
    │
    ▼
动态安全自我进化：在线自博弈 / 攻防共进化 / 强化学习
    │
    ▼
安全改进后的模型 M_safe
    └── 评估：防御是否更强？当前正常任务能力是否大致保留？
```

这是 Self-RedTeam、TriPlay-RL、AdvGame 等工作的主要研究场景。它们可以同时关注安全和正常能力，但其关注点是**安全改进过程及完成时的安全—能力表现**。

### 场景 B：安全训练结束后，模型继续正常能力自我进化（我们的研究场景）

```text
初始模型 M0
    │
    ▼
动态安全自我进化
    │
    ▼
安全能力已经增强的模型 M_safe
    │
    ▼
后续正常能力自我进化（持续更新）
    │
    ├──► M1
    ├──► M2
    └──► ... ► MT

问题：M_safe 阶段获得的安全增益，在 M1、M2、...、MT 中能否保留？
```

**这不是同一个研究问题。**

| 区别 | 场景 A：安全自我进化过程 | 场景 B：安全之后的能力自我进化 |
|---|---|---|
| 主要训练目标 | 提升安全防御 | 提升正常任务能力 |
| 正常能力的位置 | 安全训练时需要兼顾或保持的能力 | 后续更新阶段主动提高的目标 |
| 安全能力的位置 | 当前要改进的主要目标 | 之前已经获得、现在需要考察能否保留的收益 |
| 时间关系 | 安全训练进行中及训练完成时 | **安全训练完成之后**的持续更新 |
| 核心问题 | 能否获得更强防御而不过度牺牲有用性？ | **此前获得的防御收益是否会在后续能力进化中变化？** |

这里的 **Safety** 指拒绝危险请求、抵御 Jailbreak 等安全防御能力；**Capability / Utility** 指推理、代码、正常任务完成等有用能力。两者可以共同测量，但不是同一个概念。

> **RSI 术语边界**：Self-RedTeam 等是**动态、迭代式安全自我改进**的可靠代表，但未必满足最严格的“改进算法本身也递归修改”定义。相应地，后续阶段也必须真实体现**持续能力自我改进／迭代更新**，不能仅靠把普通单次微调改叫 RSI 来建立研究区别。

## 2. 第一组核心支撑：动态安全自我进化已经能提升防御

这组论文回答：**为什么我们有理由把“安全自我进化之后的模型”作为研究起点？**

| 文献 | 正式发表 | 论文解决的问题与证据 | 对我们动机的作用 |
|---|---|---|---|
| **[Chasing Moving Targets with Online Self-Play Reinforcement Learning for Safer Language Models（Self-RedTeam）](https://proceedings.mlr.press/v306/liu26bn.html)** | **ICML 2026，CCF A** | 通过一个策略扮演攻击者与防御者，在线自博弈，并持续强化防御，避免仅依赖静态攻击集合。 | **最直接的主线来源**：安全能力可以通过动态自博弈获得提升。 |
| **[TriPlay-RL: Tri-Role Self-Play Reinforcement Learning for LLM Safety Alignment](https://aclanthology.org/2026.acl-long.1216/)** | **ACL 2026 Main，CCF A** | 攻击者、防御者、评估器在闭环强化学习中共同迭代，论文报告安全防御能力提升且正常推理能力没有明显下降。 | 说明动态安全进化不局限于单一攻防方案。 |
| **[Safety Alignment of LMs via Non-cooperative Games（方法：AdvGame）](https://proceedings.mlr.press/v306/paulus26b.html)** | **ICML 2026，CCF A** | 攻击者与防御者在非零和博弈中在线共同训练，优化安全和有用性的权衡。 | 进一步支持安全能力可由动态对抗更新获得；**AdvGame 是方法名，不是论文正式标题**。 |

**三篇论文共同支持的前提：** 动态攻防、强化学习和自博弈已经可以持续增强模型安全能力，因而“安全自我改进带来的增益”是一个真实存在、可被研究的对象。[1–3]

**我们与它们的分界：** 这些研究在安全训练过程中也可能关心通用能力，但这**不等于**已经系统考察了“安全训练完成之后，模型进入独立的、持续的正常能力自我改进阶段，已获得的安全增益还能保持多久”。


## 3. 第二组核心支撑：正常能力训练可能破坏已有安全能力

这组论文回答：**为什么有理由怀疑安全进化的收益未必能在后续能力更新中自动保留？**

| 文献 | 正式发表 | 直接支持的事实 | 使用时需要把握的证据边界 |
|---|---|---|---|
| **[Fine-tuning Aligned Language Models Compromises Safety, Even When Users Do Not Intend To!](https://proceedings.iclr.cc/paper_files/paper/2024/hash/83b7da3ed13f06c13ce82235c8eedf35-Abstract-Conference.html)** | **ICLR 2024，CCF A** | 即使没有恶意意图，使用正常数据进行定制微调，也可能无意削弱原有安全对齐。 | 直接支持“良性更新存在安全风险”，但不证明所有良性微调都导致下降。 |
| **[Benign Samples Matter! Fine-tuning On Outlier Benign Samples Severely Breaks Safety](https://proceedings.mlr.press/v267/guan25c.html)** | **ICML 2025，CCF A** | 一部分从良性数据中筛选出的异常样本会强烈损害安全对齐。 | 论文有针对性地筛选了高风险样本，**不能据此断言一般正常训练必然产生同等严重退化**。 |
| **[Unintended Misalignment from Agentic Fine-Tuning: Risks and Mitigation](https://ojs.aaai.org/index.php/AAAI/article/view/41077)** | **AAAI 2026，AI Alignment Special Track** | 为提升 Agent 的工具使用和任务执行能力而进行微调，可能导致模型更愿意执行危险任务、降低安全拒绝倾向。 | 研究对象更接近能力提升型 Agent，但其训练并不自动等同于 RSI；特别方向的具体成果认定依院校规则。 |

**三篇论文共同支持的前提：** 后续正常能力训练并不天然保持此前的安全状态；提升任务能力与维持安全能力是需要区分的两件事。[4–6]

**这正是动机材料，而不是反对材料。** 第二组论文的对象往往是普通对齐模型，并不妨碍它们成为本研究的前提：

1. 它们已经证明：**安全对齐在后续正常更新中可能受到破坏**；
2. 第一组论文已经证明：**安全能力可以由动态安全自我进化增强**；
3. 因此自然产生新的、尚需检验的问题：**由动态安全自我进化增强的安全收益，进入后续正常能力自我进化后，是否仍然能够保留？**

**关键逻辑界限：** 前两点是已有研究提供的证据，第三点是我们提出的**问题**，而不是由前两点逻辑必然推出的**结论**。

## 4. 两组文献如何组成完整动机

```text
事实 A（Self-RedTeam / TriPlay-RL / AdvGame）
    动态安全自我进化能够增强模型防御能力
                         │
                         ▼
    安全进化带来的“新增安全收益”是一个值得单独考察的对象
                         ▲
                         │
事实 B（ICLR 2024 / ICML 2025 / AAAI 2026）
    之后的正常能力训练可能损害已有安全对齐
                         │
                         ▼
                 我们的研究空白
  安全自我进化获得的增益，能否在后续持续的
        正常能力自我进化中长期保留？
```

### 为什么这个问题值得提出？

安全自我进化研究不能隐含“模型一旦完成安全改进就永远不再更新”。真实的自我进化过程仍可能以能力提升为目标继续运行。**安全改进完成时的防御成绩**与**随后能力进化过程中的安全成绩**属于两个不同的时间状态。已有良性微调风险研究说明，前一个状态不能被直接当成后一个状态的保证。

我们**不需要**先证明安全增益必然丢失才能提出问题，也**不应该**先假定它一定丢失。研究动机的正当表述是：**安全收益在后续能力自我进化中的保持情况尚不明确，且有必要进行专门验证。**

## 5. 与相近工作之间的真实边界：不要只靠措辞区别

| 相近工作 | 它真正研究的问题 | 为什么不等于我们的动机 |
|---|---|---|
| **[Continual Safety Alignment via Gradient-Based Sample Selection](https://aclanthology.org/2026.findings-acl.942/)**（ACL Findings 2026） | 模型持续适应新的正常任务时，已有的安全对齐如何发生退化。 | **其起点不是动态安全自我进化刚获得的安全增益**；它研究普通持续适配的安全保持，我们研究安全自我进化之后的后续能力自我进化。这是研究对象与阶段顺序的差异，不只是改写一句话。 |
| **[Hair-Trigger Alignment: Black-Box Evaluation Cannot Guarantee Post-Update Alignment](https://proceedings.mlr.press/v306/bakman26a.html)**（ICML 2026） | 当前通过静态安全检查，不能保证模型经历后续参数更新仍保持安全。 | 它支持“当前安全不保证更新后安全”的基本逻辑，但没有以**动态攻防自我进化所获得的安全收益**为核心研究对象。 |



## 6. 正式参考文献与原始链接

### A. 核心文献：动态安全自我进化

**[1]** Liu, M., et al. **Chasing Moving Targets with Online Self-Play Reinforcement Learning for Safer Language Models.** ICML 2026.  
论文：https://proceedings.mlr.press/v306/liu26bn.html  
代码：https://github.com/mickelliu/selfplay-redteaming  
模型：https://huggingface.co/collections/mickelliu/self-redteam

**[2]** Tan, Z., et al. **TriPlay-RL: Tri-Role Self-Play Reinforcement Learning for LLM Safety Alignment.** ACL 2026 Main.  
论文：https://aclanthology.org/2026.acl-long.1216/  
代码：https://github.com/Qihoo360/TriPlay-RL

**[3]** Paulus, A., et al. **Safety Alignment of LMs via Non-cooperative Games.** ICML 2026.  
方法名：AdvGame。  
论文：https://proceedings.mlr.press/v306/paulus26b.html  
代码：https://github.com/facebookresearch/advgame

### B. 核心文献：正常能力更新导致的安全风险

**[4]** Qi, X., et al. **Fine-tuning Aligned Language Models Compromises Safety, Even When Users Do Not Intend To!** ICLR 2024.  
论文：https://proceedings.iclr.cc/paper_files/paper/2024/hash/83b7da3ed13f06c13ce82235c8eedf35-Abstract-Conference.html

**[5]** Guan, Z., et al. **Benign Samples Matter! Fine-tuning On Outlier Benign Samples Severely Breaks Safety.** ICML 2025.  
论文：https://proceedings.mlr.press/v267/guan25c.html

**[6]** Hahm, D., et al. **Unintended Misalignment from Agentic Fine-Tuning: Risks and Mitigation.** AAAI 2026, AI Alignment Special Track.  
论文：https://ojs.aaai.org/index.php/AAAI/article/view/41077

### C. 相近但不等同的研究及讨论背景

**[7]** Bach, T., et al. **Continual Safety Alignment via Gradient-Based Sample Selection.** ACL Findings 2026.  
论文：https://aclanthology.org/2026.findings-acl.942/

**[8]** Bakman, Y. F., et al. **Hair-Trigger Alignment: Black-Box Evaluation Cannot Guarantee Post-Update Alignment.** ICML 2026.  
论文：https://proceedings.mlr.press/v306/bakman26a.html

**[9]** Zheng, J., et al. **ReSI: Recursive Safety Improvement toward Resistant and Resilient AI.** arXiv 2026，预印本（当前不作为正式顶会 Baseline）。  
论文：https://arxiv.org/abs/2610.12233


