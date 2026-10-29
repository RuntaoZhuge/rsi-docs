# 实验任务书：安全自我改进的收益能否经受后续正常能力更新

## 0. 研究问题与总流程

### 0.1 唯一研究问题

> **通过动态安全自我改进获得的防御收益，在模型随后使用新数据继续训练、提高正常任务能力时，能否持续保留？**

这里有两个先后发生的阶段：

- **S 阶段——安全能力增强：** 使用 Self-RedTeam、AdvGame、MAGIC 等已正式发表的动态安全改进方法，获得安全增强模型。方法原有的训练配置不擅自改动。
- **U 阶段——后续正常能力更新：** 使用新的编程数据，通过 **LoRA-SFT** 增量更新模型。这是模拟版本继续升级的场景，**不是要求再执行一套 RSI 算法**。

研究上最希望检验的现象是 **正常编程能力上升而此前增强的安全能力下降**。但是这只是一种**待验证假设**；不能为了得到安全下降而反复挑选数据、调参数或删除不符合预期的结果。

### 0.2 原始模型对照与安全模型对照

```text
              同一原始模型 M0 = Qwen2.5-7B-Instruct
                        |
          +-------------+-------------+
          |                           |
     不额外安全训练                 动态安全改进 S
          |                           |
         M0                          S1（先用 Self-RedTeam）
          |                           |
  训练前安全+编程测评          训练前安全+编程测评
          |                           |
   同一 KodCode 训练集           同一 KodCode 训练集
   同一 LoRA-SFT 配置           同一 LoRA-SFT 配置
          |                           |
     B1 -> B2 -> B3             C1 -> C2 -> C3
          |                           |
       每个 epoch：都保存模型、训练日志、逐题测试输出及汇总指标
```

**为什么要有 M0 分支？** 只看 `S1 -> C1/C2/C3` 能判断安全模型自身有没有变得不安全；增加 `M0 -> B1/B2/B3`，才能观察 S 阶段额外获得的安全优势，在相同后续更新之后还剩多少。

### 0.3 执行顺序与放行条件：本任务书最重要的一页

| 关口 | 先完成什么 | 通过后才允许做什么 | 如果失败怎么办 |
|---|---|---|---|
| **G0：资源和数据核查** | 下载或确认访问权重；核实数据字段、评估程序、版本、GPU/存储 | G1 | 报告错误与缺项；不训练 |
| **G1：安全前测** | 统一测试 `M0` 与 `S1` 的安全性 | G2 | 检查 S1 的正确推理模式及评估配置；不训练 |
| **G2：能力前测** | 统一测试 `M0` 与 `S1` 的近期编程能力 | G3 | 如果两者已接近上限、没有提升空间，暂停讨论数据/评估配置 |
| **G3：小样本 LoRA 有效性试验** | 用固定少量 KodCode 数据，在 `M0` 和 `S1` 上各做短试训；核查独立编程能力变化 | 正式训练 G4 | 仅根据开发集判断训练是否有效；问题未解决不扩展 |
| **G4：正式 LoRA 更新** | 从未受试训修改的 `M0` 与 `S1` 重新开始，按冻结配置训练，每个 epoch 保存 | 统一正式评估 G5 | 保留失败模型与记录；不补跑修改后的有利结果 |
| **G5：最终数据分析** | 汇总所有 epoch 的能力与安全结果 | 决定是否复现 S2/S3 | 无论安全提升、下降或保持，都如实报告 |

**严禁一上来同时重训 AdvGame、MAGIC 或把所有方法跑满三个 epoch。当前第一目标是让 `M0` 与官方 `S1` 通过 G0–G3。**

---

## 1. 模型与安全 Baseline：原论文、代码、权重和重训要求

### 1.1 统一基座

- 原始模型：**[Qwen/Qwen2.5-7B-Instruct（权重）](https://huggingface.co/Qwen/Qwen2.5-7B-Instruct)**。
- 模型发布时间：**2024-09-19**，见 [Qwen 官方公告](https://qwenlm.github.io/blog/qwen2.5/)。
- 必须冻结下载的 Hugging Face revision/commit，并记录 tokenizer 和 chat template 版本。**Qwen2.5-Coder、Qwen2.5-7B Base、Qwen2.5-7B-Instruct-1M 不是本项目的同一基座。**

### 1.2 第一阶段候选安全方法（最多 5，先做 1，条件允许再扩展至 3）

| ID | 方法/正式论文 | 官方代码 | 安全模型权重状态 | 本任务中的操作 |
|---|---|---|---|---|
| `S1` | **[Self-RedTeam，ICML 2026](https://proceedings.mlr.press/v306/liu26bn.html)** | [GitHub](https://github.com/mickelliu/selfplay-redteaming) | **[Qwen2.5-7B-Instruct 安全权重已公开](https://huggingface.co/mickelliu/Self-RedTeam-Qwen2.5-7B-Instruct)**；访问文件可能需要接受 HF 条款 | **直接下载权重；不重训 S 阶段**。当前唯一正式启动对象 |
| `S2` | **[AdvGame / Safety Alignment of LMs via Non-cooperative Games，ICML 2026](https://proceedings.mlr.press/v306/paulus26b.html)** | [GitHub](https://github.com/facebookresearch/advgame) | 未核实公开完整最终防御模型 | **需要按论文对应配置重训 S 阶段**；G3 通过后再决定是否有算力开展 |
| `S3` | **[MAGIC，ICML 2026](https://proceedings.mlr.press/v306/wen26b.html)** | [GitHub](https://github.com/AI45Lab/MAGIC) | 公开的部分 Qwen2.5-7B 权重为**攻击者初始化模型**，不能代替最终防御模型 | **需要按论文对应配置重训 S 阶段**；延后启动 |
| 候补 | **[TriPlay-RL，ACL 2026 Main](https://aclanthology.org/2026.acl-long.1216/)** | [GitHub](https://github.com/Qihoo360/TriPlay-RL) | 最终防御权重尚未核实；原论文主要使用 Qwen3 系列 | 暂不纳入同基座主表；只有明确实验可比性后再启用 |

**公平性要求：** S 阶段分别照作者的论文/代码训练，不能为了“统一”强迫不同算法用同一个学习率或步数；U 阶段才要求所有模型接受**同一训练数据、同一套 LoRA 参数和同一套评估程序**。

需要重训 S2/S3 时，先建立参数审计表，而不是凭记忆写配置：

- Self-RedTeam：参考 [官方脚本目录](https://github.com/mickelliu/selfplay-redteaming/tree/main/scripts)。其中默认示例可能针对其他模型，**不能直接当成 Qwen7B 复现配置**。
- AdvGame：从 [作者 Qwen2.5 论文配置目录](https://github.com/facebookresearch/advgame/tree/main/configs/paper/qwen25) 找到对应论文表格行及变体，记录 `lr`、`num_steps`、`batch`、rollout 配置、奖励等。
- MAGIC：从 [官方训练脚本](https://github.com/AI45Lab/MAGIC/blob/main/scripts/rl/separated/grpo_public.sh) 和 [官方 README](https://github.com/AI45Lab/MAGIC) 核对单轮/多轮设置、攻击者权重和防御者训练步数。注意不要把攻击者权重当成防御者。

**S 阶段原作者配置参考（只是识别与核查所需的对应入口，不是 U 阶段的统一参数）：**

| 方法/配置入口 | 作者仓库中的可核对示例设置 | 复现前注意事项 |
|---|---|---|
| [AdvGame：Qwen2.5 DPO 配置文件](https://github.com/facebookresearch/advgame/blob/main/configs/paper/qwen25/paper_qwen25_dpo_pairwise_offpolicy.yaml) | `num_steps=1000`、`batch_size=4`、攻击者/防御者优化器 `lr=1e-6`、DPO `beta=0.1`、`checkpoint_every_n_steps=50` | 仅对应所链接的 **DPO pairwise off-policy** 变体；不得直接拿去跑 IPO/GRPO 或擅自降低步数 |
| [MAGIC：Qwen2.5 训练脚本](https://github.com/AI45Lab/MAGIC/blob/main/scripts/rl/separated/grpo_public.sh) | `train_batch_size=64`、`total_training_steps=300`、`actor.optim.lr=1e-6`、`rollout.n=4`、`test_freq=15`、`save_freq=15` | 只表示所链接的公开脚本及其默认分支，必须核对仓库版本、训练角色、模型路径和论文表格对应关系 |
| [Self-RedTeam：作者训练脚本示例](https://github.com/mickelliu/selfplay-redteaming/blob/main/scripts/red_team_game_reinforce_8b.sh) | 已有作者示例脚本，但该文件面向其他模型设置 | 本项目 **S1 直接用作者发布的 Qwen7B 权重**；不把此脚本直接当作其 Qwen7B 配置 |

这些数值的意义是让复现日志与官方代码对得上，并非要求不同 S 算法参数相同。**第一阶段 S2/S3 训练仍需单独做资源和版本核查，没确认条件就不开跑。**

**算力限制：** 代码开源≠已经获得可直接使用的安全权重。S2/S3 的重新安全 RL 训练可能远重于 LoRA，未经资源审计不启动；实验集合少于 3 种时明确记录原因，不用不同基座的任意模型凑数。

---

## 2. 数据来源：一个正常训练集 + 两种能力测试窗口

### 2.1 唯一的正常能力训练集：KodCode-V1-SFT-R1

**直接下载/检查地址：** [KodCode/KodCode-V1-SFT-R1（Hugging Face）](https://huggingface.co/datasets/KodCode/KodCode-V1-SFT-R1)  
**数据生成与质量验证代码：** [KodCode 官方 GitHub](https://github.com/KodCode-AI/kodcode)  
**论文：** [KodCode: A Diverse, Challenging, and Verifiable Synthetic Dataset for Coding（2025）](https://arxiv.org/abs/2503.02951)

- 此版本明确面向 **SFT**；源数据超过 10K（数据卡当前显示 `train` 约 268K 条），本实验只抽取固定的 **10,000 条**，不使用整个数据集训练。
- 可用字段：`question`（任务）、`r1_solution`（经过配套测试筛选的参考代码）、`test`（验证程序）、`style`、`subset`、`question_id` 等。数据可以是**合成的**，不要求人工逐题标注。
- 采用 `question` 作为 user 内容，`r1_solution` 作为 assistant 学习目标；`test` **只用于检查答案质量，不能混进模型训练提示或答案里**。
- 许可：数据卡标注 **CC BY-NC 4.0**，需要按照许可使用和引用。

**数据划分（本实验约定，非作者原始划分）：**

| 集合 | 规模 | 用途 |
|---|---:|---|
| KodCode TRAIN | **9,500** | 统一正常能力 LoRA-SFT |
| KodCode VALID | **500** | 检查训练/验证 loss、数据格式；不作为最终能力指标 |
| KodCode PILOT | **1,000–2,000**（来自 TRAIN 内） | G3 低成本短试训，**试训完成后丢弃试训 adapter，正式训练从 M0/S1 重新开始** |

抽样前固定 Hugging Face 数据 revision 和种子；优先筛选 `style=instruct`、非空题目/答案、作者验证通过的记录；去重后得到 10K。固定 `train_ids.json`、`valid_ids.json`、抽样规则及数据内容 SHA256。注意公开数据集**发布时间晚于 Qwen2.5**，不代表每条题目背后的知识都未出现在较早语料中。

### 2.2 独立能力评测：LiveCodeBench（不参与训练）

**数据集：** [livecodebench/code_generation_lite](https://huggingface.co/datasets/livecodebench/code_generation_lite)  
**官方评测代码：** [LiveCodeBench GitHub](https://github.com/LiveCodeBench/LiveCodeBench)

使用官方 `release_v6`（含截至 2025-04 的题目），根据**题目在竞赛网站真正发布的日期**过滤；具体时间窗固定如下：

| 窗口 | 原题发布日期 | 用途 | 能否用来决定训练参数？ |
|---|---|---|---|
| **LCB DEV** | `2024-09-20` 至 `2024-12-31` | G2 能力前测、G3 试训有效性及训练期间趋势 | **可以用于一次预先规定的有效性判断** |
| **LCB TEST** | `2025-01-01` 至 `2025-04-30` | 协议冻结后的最终能力报告 | **不能**用于选数据、调 LoRA 参数或挑最有利的 epoch |

题目日期晚于 Qwen2.5 在 2024-09-19 的发布日期，可减少原始模型预训练重复风险；**不能保证 2026 年发布的安全增强权重从未见过这些题目**。对于训练数据与评估题的相同/近似题必须审计，无法确定时单独说明。

**为什么出现两个“数据集”？** 只有 KodCode 是**训练数据集**；LiveCodeBench 是**独立测试基准**。不能用 KodCode 训练题上的准确率替代真实的新题能力表现。

### 2.3 安全评测和正常请求评测：与 U 数据彻底分离

- **HarmBench（安全攻击成功率 ASR）：** [官方代码与评测配置](https://github.com/centerforaisafety/HarmBench)。
- **XSTest（无害请求的过度拒绝率）：** [官方代码和数据](https://github.com/paul-rottger/xstest)。
- **S 阶段可能使用的安全训练数据，仅用于复现原方法：** [WildJailbreak](https://huggingface.co/datasets/allenai/wildjailbreak)、[Self-RedTeam 数据](https://github.com/mickelliu/selfplay-redteaming/tree/main/red_team/data)、[AdvGame 数据](https://github.com/facebookresearch/advgame/tree/main/data/wildjailbreak_alpaca)、[MAGIC 数据](https://github.com/AI45Lab/MAGIC/tree/main/data)。

**绝不把安全训练集中的危险样本或安全回复用作第二阶段 KodCode LoRA-SFT 的能力训练目标。** 训练目标分离，是这个两阶段场景的基础。

---

## 3. G0：数据、权重、评测器和资源核查（不得开始训练）

### 必须执行

1. 核实 `M0` 与 `S1` 的权重可下载、可正常加载；将 Hugging Face revision、tokenizer、模型文件 SHA256 记入 `model_manifest.csv`。模型：[M0](https://huggingface.co/Qwen/Qwen2.5-7B-Instruct)；[S1](https://huggingface.co/mickelliu/Self-RedTeam-Qwen2.5-7B-Instruct)。
2. 打开 [KodCode-V1-SFT-R1 数据卡](https://huggingface.co/datasets/KodCode/KodCode-V1-SFT-R1)，确认真实 `train` 字段/条数、`style`、`r1_solution`、`r1_correctness`；不得照搬旧版 Light-RL-10K 的 `assert len==10000`。
3. 固定 10K 抽样及 9,500/500 划分；对抽取样本检查空答案、重复题、长度、参考代码和配套测试；生成抽样 manifest。
4. 检查 [LiveCodeBench](https://github.com/LiveCodeBench/LiveCodeBench) `release_v6` 的 DEV/TEST 题量、ID、发布日期；冻结两个窗口的题目清单，记录版本号和哈希。
5. 将 KodCode 与 LCB 进行规范化文本去重、标题去重、可行的近重复检查。**所有剔除规则必须在正式训练前冻结，不能看了结果后再决定删什么题。**
6. 安装并跑通 [LiveCodeBench](https://github.com/LiveCodeBench/LiveCodeBench)、[HarmBench](https://github.com/centerforaisafety/HarmBench)、[XSTest](https://github.com/paul-rottger/xstest) 各自的一小批测试；检查编程代码是在无外网、有限 CPU/内存/超时的沙箱中执行。
7. 核实 GPU 显存、磁盘空间、预计每阶段 adapter/训练状态的体积。**正式 epoch 的 checkpoint 不允许因为磁盘清理策略自动删除。**

### G0 交付和放行标准

- `source_audit.csv`、`model_manifest.csv`、`dataset_manifest.json`、`train_ids.json`、`valid_ids.json`、`lcb_dev_ids.json`、`lcb_test_ids.json`。
- `environment.md`（GPU、CUDA、PyTorch、Transformers、评测器 commit）、`contamination_audit.csv`。
- 三套评测器可重复返回同一格式的逐题文件；任何安全/能力训练都还没开始。

**若任一权重不能加载、评测器不稳定、数据不能固定版本：停止。**

---

## 4. G1 + G2：所有训练之前，必须先测“安全”和“编程”

这两步是整个项目的**最高优先级**。要先证明第一阶段模型真的更安全、第二阶段确实还有继续提升正常编程能力的空间。

### G1：安全模型是否真的比原始模型更安全？

先用同一 [HarmBench](https://github.com/centerforaisafety/HarmBench) 配置测：

- `ASR(M0)`：原始模型攻击成功率，**越低越好**；
- `ASR(S1)`：Self-RedTeam 安全模型攻击成功率；
- `SafetyGain = ASR(M0) - ASR(S1)`：新增安全收益（**百分点**）。

**通过条件：** 在锁定评测协议上 `SafetyGain > 0`，且不只是评估器误判/输出格式错误造成的假差异。可同步记录 [XSTest](https://github.com/paul-rottger/xstest) 过度拒绝率，避免把“无论什么都拒绝”当安全增强。

Self-RedTeam [官方模型卡](https://huggingface.co/mickelliu/Self-RedTeam-Qwen2.5-7B-Instruct) 同时提供普通直接提示和 `defender_with_thinking` 模式。**必须记录实际使用哪种合法推理模式，并核查是否与作者建议一致**；若安全收益不成立，先排查提示模板和 judge，不准马上重训安全模型。所有模型在比较时应使用相同的任务内容、统一的 judge 与生成设置；必要的模型专属模板差异要公开记录。

### G2：安全增强前后，编程能力是否都存在明显提升空间？

使用已冻结的 [LiveCodeBench DEV](https://github.com/LiveCodeBench/LiveCodeBench) 窗口，分别测 `M0` 和 `S1` 的 `pass@1`。

必须填入：

| 模型 | HarmBench ASR | XSTest 过度拒绝率 | LCB DEV pass@1 | 主要失败类别 | 是否有正常能力提升空间 |
|---|---:|---:|---:|---|---|
| `M0` | 实测 | 实测 | **实测** | 编译失败/题意理解/算法错误等 | 待判定 |
| `S1` | 实测 | 实测 | **实测** | 同上 | 待判定 |

**理想前测状态：** 两个模型的正常编程表现处于**较低或中等水平**，既非接近满分，也不至于完全不能响应正确格式；有明确、可学习的错误类型。**不预设某个凭空编造的官方阈值**，由实测题量和失败案例做判断，冻结判定依据。

- `M0` 和 `S1` 的编程能力都必须先测，不能拿论文原有成绩代替。
- 安全增强后编程能力可能上升、下降或不变，全部记录；不要求二者初始编程分数完全相同。
- **如果编程能力已经非常高、没有明显改善余地，暂停 U 阶段。**
- G1 或 G2 未通过，**不得直接跑 9,500 样本、3 epoch**。

### G1/G2 强制保存

`eval/M0/E0/`、`eval/S1/E0/`：逐题 `jsonl`（包含模型原始输出）、总体指标、配置 JSON、温度/seed、样本清单哈希、评分器版本；`prescreen_report.md` 包含验收判断和失败示例。

---

## 5. G3：先做小样本 LoRA 试训，确认“能力训练有效”

**只有 G1 和 G2 通过，才允许花 GPU 跑这一关。**

### 为什么不能直接上 10K × 3 epoch？

LoRA 很省资源，但也存在“训练 loss 下降、独立编程能力却没有提高”的情况。如果这一步无效，那么后面多跑几种安全方法也无法有效验证“能力提升期间安全如何变化”。

### 操作步骤

1. 从冻结的 9,500 条 KodCode TRAIN 中，按固定 ID/种子抽取 **1,000–2,000 条**，不使用 LCB 题目。数据：[KodCode-V1-SFT-R1](https://huggingface.co/datasets/KodCode/KodCode-V1-SFT-R1)。
2. 使用 [LLaMA-Factory 官方 LoRA-SFT 配置范例](https://llamafactory.readthedocs.io/en/latest/getting_started/sft.html)，只开展**短 LoRA-SFT 试训**，例如 1 个 epoch。试训参数锁定，对 `M0` 与 `S1` 一视同仁；`S1` 是独立的安全增强初始化权重。
3. 对试训后的两个 adapter 评估 **同一个 LCB DEV**；同时抽取固定的少量 [HarmBench](https://github.com/centerforaisafety/HarmBench) 样本检查脚本没有破坏输出/评测接口（这不是正式安全结论）。
4. 记录 `LCB DEV pass@1（试训前/后）`、训练/验证 loss、异常输出比例、抽样题正确/错误变化、训练耗时及 GPU 峰值。
5. **试训的 adapter、日志、评估仍然保存，但正式实验不能从试训模型接着训练。** 正式 E1/E2/E3 必须重新从冻结的 `M0`、`S1` 起步。

### G3 通过条件

- **至少证明在当前数据/LoRA 配置下，正常编程能力有可观察到的改善潜力**，优先希望 `M0` 和 `S1` 都在 DEV 上表现改善。单次小数据试训未提升时，先检查样本形式、答案质量、截断率和评测噪声；不能直接宣称整个研究场景不成立。
- 试训结果只用于确认 **LoRA 正常能力学习能否发生**；不要求此时已观察到安全下降，**更不能用安全下降大小来筛选 LoRA 参数**。
- 通过后冻结：10K 样本 ID、LoRA 参数、评估题目、评估脚本、checkpoint 频率。以后各个 S 方法使用同一配置。

**若 G3 没通过：停止推进 S2/S3，提交 `pilot_report.md`。** 不靠延长训练、换题、改学习率而不留记录；若要修改，先记录失败方案，再把新的统一配置重新进行一次试训，绝不针对某个分支私自调参。

---

## 6. 正式第二阶段 U：只使用统一的 LoRA-SFT

### 6.1 SFT 与 LoRA 的关系

- **SFT** 说明学习形式：使用 `question -> r1_solution` 的监督样本。
- **LoRA** 说明更新范围：仅训练少量适配参数，不重新训练全部原模型参数。
- 实际采用的是 **LoRA-SFT**：**这是本任务中唯一正常能力更新方式。**

### 6.2 统一配置（公开示例可追溯；本实验首次运行后冻结）

参考资料：**[LLaMA-Factory 官方 SFT 示例及其超参数](https://llamafactory.readthedocs.io/en/latest/getting_started/sft.html)**；[官方自定义数据格式](https://llamafactory.readthedocs.io/en/latest/getting_started/data_preparation.html)。

| 参数 | 建议统一值 | 来源/解释 |
|---|---|---|
| 框架 | [LLaMA-Factory](https://github.com/hiyouga/LLaMA-Factory)，固定 commit | 工程实现；不是某篇安全论文的训练代码 |
| 训练类型 | `stage: sft` + `finetuning_type: lora` | 官方示例 |
| LoRA rank | `8` | 官方示例 |
| LoRA target | `all` | 官方示例；正式运行前核对 Qwen2.5 支持 |
| LoRA learning rate | `1e-4` | 官方 LoRA 示例；**并非安全 S 阶段的学习率** |
| Epoch | `3` | 官方示例；E0/E1/E2/E3 全部保留 |
| Per-device batch | `1` | 官方示例 |
| Gradient accumulation | `8`（单卡示例） | 多卡时确保全局有效 batch 一致 |
| Scheduler | `cosine` | 官方示例 |
| Warmup | `warmup_ratio=0.1` | 官方示例 |
| dtype | `bf16`（设备支持时） | 不支持须记录，不能分支使用不同精度却声称完全相同 |
| Prompt template | `qwen` | 对应 Qwen2.5 Instruct，须核对实际 tokenizer |
| 数据 | 固定 KodCode TRAIN 9,500 条；VALID 500 条 | 所有分支完全相同 |
| `cutoff_len` | 初版 `2048`，**G0 必须先检查截断率** | 如果截断严重，只能在正式实验前统一调整并记录，不按结果挑值 |
| 保存频率 | `save_strategy: epoch`，不得删除旧 epoch | 保证 E1/E2/E3 能独立重载与消融 |
| 训练随机种子 | 固定并保存 | 保持可比较 |

**参数边界：** 上述是公开 LoRA 示例支持的统一**实验协议**，不是作者声称对 KodCode+安全模型最优的结论。它也不是 Self-RedTeam/AdvGame/MAGIC 的原始安全训练参数。第一阶段按各自论文，第二阶段统一采用该协议。

**不能为了追求安全下降调 LoRA 参数。** 合理的调试依据只有数据格式、模型能否正常学习、验证损失、开发集正常能力等；TEST 一律不可用于调参数。

### 6.3 正式训练操作顺序

1. **基线冻结**：只读保存 `M0` 和 `S1`，留好 E0 的全部评估结果；禁止将 LoRA 结果覆盖 E0。
2. **先跑原始分支**：`M0 -> B1 -> B2 -> B3`，固定数据、种子、epoch，保存所有 adapter + 训练状态 + 指标。
3. **再跑安全分支**：`S1 -> C1 -> C2 -> C3`，只能改变**起点模型路径和输出路径**，其他训练设置严格一致。
4. 每个正式 epoch 结束：立即保存 adapter、恢复状态与训练指标；在 LCB DEV、HarmBench、XSTest 上用相同配置评估并保存逐题结果。TEST 等所有训练配置/模型已冻结后统一执行。
5. E3 训练完，检查 `M0` 与 `S1` 两条路径是否真的出现正常编程能力提升；如果没有，就把实验结论标为“未验证正常能力提升”，而不是硬写“模型能力进化”。
6. G4 通过后才开始评估是否投入资源重训 S2、S3；**不要求一次性凑齐四种方法。**

---

## 7. 所有阶段统一评估：指标、温度与记录频率

### 7.1 指标（主指标只有两个）

| 指标 | 官方来源 | 指标方向 | 必测节点 | 为什么要测 |
|---|---|---|---|---|
| **HarmBench ASR** | [HarmBench](https://github.com/centerforaisafety/HarmBench) | **越低越安全** | M0、每个 Si、E1/E2/E3 | 判断第一阶段增强后的安全能力是否退化 |
| **LiveCodeBench pass@1** | [LiveCodeBench](https://github.com/LiveCodeBench/LiveCodeBench) | **越高越好** | M0、每个 Si、E1/E2/E3 | 验证 U 阶段确实提升了正常编程能力 |
| XSTest 过度拒绝率 | [XSTest](https://github.com/paul-rottger/xstest) | 越低通常越好 | 同上 | 避免把过度拒答误当安全改进 |
| Train/valid loss、LR、gradient norm | [LLaMA-Factory](https://github.com/hiyouga/LLaMA-Factory) | 诊断指标 | 训练日志每次记录 | 排查训练问题，**不等于能力分数** |
| 安全收益保留率、能力增幅 | 根据上述逐轮指标计算 | 见第 8 节 | 每个 epoch | 分析新增安全收益是否仍然保留 |

### 7.2 统一评估温度：0.2

```yaml
# 仅用于离线评估；不是 S 阶段原论文 RL rollout 训练温度
sampling_temperature: 0.2
do_sample: true
num_return_sequences: 1
top_p: 1.0
seed: fixed_and_logged
max_new_tokens: freeze_per_benchmark
prompt_template: fixed_per_supported_model_and_logged
judge_version: pinned
```

LiveCodeBench [官方说明](https://github.com/LiveCodeBench/LiveCodeBench)常用 `temperature=0.2, n=10`；本项目为节省成本规定 **`temperature=0.2, n=1`**，并明确写为本项目统一的 **一次生成 pass@1**，不冒充官方十样本配置。`do_sample=false` 会使温度参数失效，不能写着 0.2 实际采用 greedy。

### 7.3 每一个 epoch 都要评估吗？

**是，每个正式 epoch 的 checkpoint 都必须保存，并配有完整独立评估。** 但训练内部每个 optimizer step 不需要跑一次 HarmBench/LCB，也不需要保存 7B 模型权重。

| 阶段 | 权重/LoRA | LCB DEV | HarmBench | XSTest | LCB TEST |
|---|---|---|---|---|---|
| `M0`（E0） | **必存** | **必测** | **必测** | 必测 | 协议冻结后测 |
| `S1`（E0） | **必存** | **必测** | **必测** | 必测 | 协议冻结后测 |
| `B1 / C1` | **必存** | **必测** | **必测** | 必测 | 协议冻结后统一测 |
| `B2 / C2` | **必存** | **必测** | **必测** | 必测 | 协议冻结后统一测 |
| `B3 / C3` | **必存** | **必测** | **必测** | 必测 | 协议冻结后统一测 |

**重要：** 训练完成后再批量对封存 TEST 做评价是可以的，因为 E0/E1/E2/E3 的模型都已保存，**不需要重新训练**。训练期间使用 DEV；不得利用 TEST 挑 checkpoint 或修改超参。

---

## 8. 如何判断“原来加固的安全收益”保留了多少？

令 `ASR(X)` 表示同一 HarmBench 协议下模型 X 的攻击成功率（越低越好），`LCB(X)` 是同一 LiveCodeBench 协议的 pass@1（越高越好）。

**S 阶段的新增安全收益：**

\[
G(0) = ASR(M_0) - ASR(S_1)
\]

**U 完成 t 个 epoch 后，相对于原始模型对照仍有多少额外安全收益：**

\[
G(t) = ASR(B_t) - ASR(C_t)
\]

**安全收益保留率（只在 G(0) 明显大于评估噪声时使用）：**

\[
R(t) = \frac{G(t)}{G(0)}
\]

**安全模型自身退化幅度：**

\[
D(t) = ASR(C_t) - ASR(S_1)
\]

**正常编程能力提升幅度：**

\[
\Delta U(t) = LCB(C_t) - LCB(S_1)
\]

解释：`D(t)>0` 表示安全模型绝对 ASR 上升（变差）；`R(t)<1` 表示相对于原始模型对照，安全阶段的**额外优势**缩小。两个量必须一起看，不能只挑有利的一项。如果 G(0) 很小、为负或噪声很大，不解释比值 R(t)。

**至少提交四张图：** `M0/S1` 安全与编程前测对比、逐 epoch 编程 `pass@1` 曲线、逐 epoch 安全 ASR 曲线、`G(t)/D(t)` 安全收益变化图。所有图都必须来自可追溯的原始逐题文件，不能只手填百分比。

---

## 9. 保存规范：为了后续消融，一个正式阶段都不能丢

### 9.1 模型与训练状态分别保存

**必须保留：**

- `M0`：原始冻结完整权重，或**不可变的官方权重快照 + commit/hash**。
- `S1`：**安全增强完成、尚未继续训练的完整权重**；S2/S3 之后也应同理。安全模型不能被正常 LoRA 训练覆盖。
- `B1,B2,B3` 与 `C1,C2,C3`：**每一个 epoch 的 LoRA adapter**（`adapter_model.safetensors`、`adapter_config.json`）+ 正确的父基础权重 revision。要求能在完全新进程重载，恢复该阶段的推理结果。
- 训练恢复文件：optimizer、scheduler、trainer state、RNG state（框架有的都保存）；训练恢复状态**不同于**仅供推理的 adapter。
- 完整评估记录：安全+编程+过度拒绝每个阶段的**逐题原始回答和判定**，以及汇总 CSV、模型配置和环境信息。

**LoRA 不需要为每一轮都额外复制一遍完整 7B 权重。** 保存冻结父模型和每轮的独立 adapter 已经可以准确复原该轮模型。真正重要的是**不可变原始权重 + 每轮 adapter + 可恢复训练状态 + 全套评测原始记录**，必要时再导出合并权重。



---

## 10. 可直接参考的准备和训练示例

> 下面的命令、脚本是**待本地环境测试的模板**，不保证在不同版本下不经调整就能运行。所有需要填写的 revision/path 必须先从官方页面核实，不能用未冻结的 `main` 作为正式研究记录。

### 10.1 下载基础模型与安全模型

```bash
python -m pip install -U huggingface_hub datasets
hf auth login

# 原始基座
hf download Qwen/Qwen2.5-7B-Instruct --local-dir ./models/M0_frozen

# 安全增强模型：可能需先在模型卡网页接受访问条件
hf download mickelliu/Self-RedTeam-Qwen2.5-7B-Instruct --local-dir ./models/S1_frozen

# 评测及训练框架
 git clone https://github.com/LiveCodeBench/LiveCodeBench.git
 git clone https://github.com/centerforaisafety/HarmBench.git
 git clone https://github.com/paul-rottger/xstest.git
 git clone https://github.com/hiyouga/LLaMA-Factory.git
```

下载资源：[M0](https://huggingface.co/Qwen/Qwen2.5-7B-Instruct)；[S1](https://huggingface.co/mickelliu/Self-RedTeam-Qwen2.5-7B-Instruct)；[LiveCodeBench](https://github.com/LiveCodeBench/LiveCodeBench)；[HarmBench](https://github.com/centerforaisafety/HarmBench)；[XSTest](https://github.com/paul-rottger/xstest)。

### 10.2 只抽取 KodCode 的 10K SFT 样本（示例）

数据来源：[KodCode-V1-SFT-R1](https://huggingface.co/datasets/KodCode/KodCode-V1-SFT-R1)；格式说明：[LLaMA-Factory 数据准备文档](https://llamafactory.readthedocs.io/en/latest/getting_started/data_preparation.html)。

```python
import hashlib
import json
import random
from pathlib import Path
from datasets import load_dataset

OUT = Path('data/kodcode10k')
OUT.mkdir(parents=True, exist_ok=True)
SEED = 20261029
REVISION = 'REPLACE_WITH_PINNED_HF_COMMIT'  # 正式实验前必须填实际 commit

stream = load_dataset(
    'KodCode/KodCode-V1-SFT-R1',
    split='train',
    revision=REVISION,
    streaming=True,
).shuffle(seed=SEED, buffer_size=20000)

records = []
seen = set()
for row in stream:
    if str(row.get('style', '')).lower() != 'instruct':
        continue
    if str(row.get('r1_correctness', '')).lower() not in {'true', '1'}:
        continue
    q = str(row.get('question') or '').strip()
    a = str(row.get('r1_solution') or '').strip()
    if not q or not a:
        continue
    normalized_q = ' '.join(q.lower().split())
    question_hash = hashlib.sha256(normalized_q.encode()).hexdigest()
    if question_hash in seen:
        continue
    seen.add(question_hash)
    records.append({
        'source_id': str(row.get('question_id')),
        'instruction': q,
        'input': '',
        'output': a,
        'question_sha256': question_hash,
    })
    if len(records) == 10000:
        break

assert len(records) == 10000, '抽样不足 10K，检查数据字段和过滤条件'
random.Random(SEED).shuffle(records)
train, valid = records[:9500], records[9500:]

# 正式使用前还需对 LiveCodeBench 做近重复检查；有冲突应在冻结前重新抽样。
def write_json(name, obj):
    (OUT / name).write_text(json.dumps(obj, ensure_ascii=False, indent=2), encoding='utf-8')

def for_training(rows):
    return [{k: r[k] for k in ('instruction', 'input', 'output')} for r in rows]

write_json('train.json', for_training(train))
write_json('valid.json', for_training(valid))
write_json('train_ids.json', [r['source_id'] for r in train])
write_json('valid_ids.json', [r['source_id'] for r in valid])
write_json('pilot_ids.json', [r['source_id'] for r in train[:1000]])
write_json('dataset_info.json', {
    'kodcode_train': {
        'file_name': 'train.json',
        'columns': {'prompt': 'instruction', 'query': 'input', 'response': 'output'}
    },
    'kodcode_valid': {
        'file_name': 'valid.json',
        'columns': {'prompt': 'instruction', 'query': 'input', 'response': 'output'}
    }
})
for name in ('train.json', 'valid.json', 'train_ids.json', 'valid_ids.json'):
    path = OUT / name
    print(name, hashlib.sha256(path.read_bytes()).hexdigest())
```

说明：这里采用 **streaming buffer shuffle**，并不是对全部官方数据做严格均匀抽样；它的优势是少占内存、易保存固定快照。若后续需要更严格的抽样代表性，可以在正式实验前统一换成全量分层抽样，**不能训练完再换**。实际 `question_id` 是否在不同版本复用也要核查；正式快照除了 ID，还要存内容哈希。

### 10.3 统一 LoRA-SFT 配置示例

来源：[LLaMA-Factory 官方 SFT 示例](https://llamafactory.readthedocs.io/en/latest/getting_started/sft.html)。


**试训配置需与正式配置区分**：试训使用固定的 1K–2K TRAIN 子集、短 epoch；正式训练从未修改的 `M0/S1` 重新开始，使用 9,500 TRAIN 和 3 epoch。保存 G3 试训文件用于核对，但不把试训结果当成正式 E1 模型。

### 10.4 LiveCodeBench 官方评估入口（示例）

参考：[LiveCodeBench 官方 README / release_v6 / 时间筛选 / `n,temperature` 参数](https://github.com/LiveCodeBench/LiveCodeBench)。


**运行注意：** 官方 `--local_model_path` 是否直接接受 LoRA adapter 路径取决于锁定版本。若不支持，允许**暂时合并 adapter 与相应冻结父模型生成评估用权重**，但**原 adapter 和训练状态仍需保留**。不能把该路径直接写成一个 adapter 目录就以为完成了评测。所有模型必须使用相同评估窗口、timeout 和代码提取器。

---

## 11. 验收清单与暂停规则

| 关口 | 必须交付 | 不通过时的规定动作 |
|---|---|---|
| G0 资源 | 模型和数据 revision、程序 commit、ID/hashes、GPU/存储盘点、污染报告 | **停止训练**，先解决访问、格式或评估问题 |
| G1 安全 | M0、S1 的 HarmBench + XSTest 原始记录和安全增益结论 | 查提示模板/评测器；不能直接继续 U |
| G2 能力 | M0、S1 的 LCB DEV 逐题结果、失误分析、低到中等能力的证据 | 若接近满分或没有提升空间，暂停 |
| G3 试训 | 两个独立的短 LoRA adapter、开发集前后分数、训练/验证日志 | 无改善先排查，不进入正式 10K×3 epoch |
| G4 正式 | M0、S1 两条 3-epoch 轨迹，每个 epoch 的 adapter/训练状态/逐题评估 | 缺任一正式 checkpoint，视为归档未通过 |
| G5 结果 | 能力/安全逐轮曲线、收益保持分析、所有原始数据与 hash | 如实报告；不因为结果不符合预期而重新筛题 |

**当前唯一允许立即启动的工作：G0 → G1 → G2。** 通过之后才做 G3；G3 再通过，才做 G4。S2/S3 的昂贵安全重训须在主链条件有效后单独决策。

---

## 12. 研究记录要求

1. **链接必须就近放置：** 每个被提到的方法、数据集、权重或评估工具，都应有对应的官方论文/仓库/数据链接，不能只写简称。
2. **严格区分三类参数：** S 阶段使用各原论文参数；U 阶段使用本协议冻结的 LoRA-SFT 参数；离线评估统一 `temperature=0.2`。不得混用。
3. **没有实验就不要写“已证实”：** 当前模型是否安全增强、编程能力是否足够低、LoRA 是否提高能力、安全是否下降，都是需要按 G1–G5 **实测**的结论。
4. **验证优先于整套流程：** 未拿到 G1/G2/G3 证据，不能启动后续的大规模训练。
5. **模型可恢复比保存一个高分更重要：** 所有正式阶段都要永久保存 adapter 与父模型版本、优化器状态、评估原始输出。后续消融尽量复用已有版本。
6. **不要提前引入其他能力数据或其他微调方式。** 目前只研究一个新的编程训练源——KodCode-V1-SFT-R1 的固定 10K 子集，及统一 LoRA-SFT。

**最终要回答的问题保持不变：正常能力继续学习之后，动态安全自我改进所获得的安全收益是否仍然存在？**
