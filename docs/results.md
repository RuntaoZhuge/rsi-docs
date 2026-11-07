# 实验进展与结果

本页用于发布 G1–G5 的实测结果。所有数字都应来自可追溯的逐题原始文件（`jsonl` + 汇总 `csv` + 配置与环境 JSON + 哈希），不能只手填百分比。

!!! warning "当前页不含实测结果"

    尚无任何训练或正式评估结果：数据侧已完成，**运行环境与工具链已确认并跑通**，`M0` 权重已就位、`S1` 待授权，**G0 仍未放行**；G1–G5 全部未开始。以下表格与图位是预留模板，用于在 G1–G5 完成后按同一口径填入；未填写的单元格一律视为"待测"，不能当作结论。

## 1. 关口状态

| 关口 | 依据 | 状态 | 日期 |
|---|---|---|---|
| G0 资源与数据核查 | 《[实验方案](experiment.md)》第 3 节 | **进行中**：数据侧完成、环境与工具链已确认，`M0` 已就位、`S1` 待授权 | 2026-11-07 |
| G1 安全前测 | 第 4 节，`ASR(M0)`、`ASR(S1)`、`SafetyGain = ASR(M0) - ASR(S1)` | 待执行 | — |
| G2 能力前测 | 第 4 节，LCB DEV `pass@1` | 待执行 | — |
| G3 小样本试训 | 第 5 节，1K–2K 子集短 LoRA-SFT | 待执行 | — |
| G4 正式 LoRA 更新 | 第 6 节，9,500 条 × 3 epoch | 待执行 | — |
| G5 汇总分析 | 第 8 节 | 待执行 | — |

### 1.1 G0 进展（2026-11-05）

**已完成**

| 项 | 结果 | 产物 |
|---|---|---|
| LCB 题目清单冻结 | DEV 183 题（2024-09-21~12-28）、TEST 182 题（2025-01-04~04-06） | `g0/lcb_dev_ids.json`、`lcb_test_ids.json`、`lcb_manifest.json` |
| KodCode 10K 抽样 | 9,500 / 500 / 1,000；扫描 24,934 条收满 | `g0/data/kodcode10k/` 与 `sampling_manifest.json` |
| 污染审计 | 精确重复 0；覆盖率 ≥0.5 为 0；0.3–0.478 的 644 对人工抽查均为题干模板相似，非同一题 | `g0/contamination_report.md`、`contamination_audit.csv` |
| 长度与截断 | p50 1,310 字符、p95 3,457；`cutoff_len=2048` 预计截断率约 0.23% | 见 `CHECKLIST.md` 已知问题 C |

**未完成（G0 放行的硬条件）**

- `S1` 下载与加载冒烟（gated 仓库，需先接受条款并配置访问令牌）
- `source_audit.csv`；`model_manifest.csv` 待 `S1` 到位后补齐双模型
- 代码执行沙箱：容器内无 docker 且不可做网络隔离，判题改在本机 Docker 执行，执行器待补
- judge（HarmBench 官方 classifier）下载、冒烟并冻结版本
- `valid_exec`：KodCode VALID 的 500 条需补回自带测试程序，供"同分布操作检查"使用

**阻塞项：需在 G3 之前决定**

!!! danger "抽样代表性：subset 只覆盖 5/12"

    9,500 条仅来自 Algorithm（2,751）、Taco（2,635）、Filter（2,009）、Leetcode（1,994）、Codeforces（111）；其余 7 个 subset 为 0。
    成因是流式 shuffle 只扫到全量约 9% 即收满 10,000 条。任务书 §10.2 允许在正式训练前换成全量分层抽样，但 **G3 一开始即冻结**。详见 `experiments/g0/CHECKLIST.md` 已知问题 A。

!!! note "过滤规则的实际生效情况"

    四条规则中只有 `style=instruct` 实际剔除（14,934 条）；`r1_correctness`、非空、字面去重均剔除 0 条。
    数据卡把 `r1_correctness` 定义为“3 次采样中至少 1 次通过”，并不保证当前这条 `r1_solution` 通过。报告中应写“采用作者已预筛的 split，未独立复验”。

### 1.2 运行环境（2026-11-07）

已确认并跑通的实际环境，详见《[执行环境与进度](environment.md)》：

| 项 | 实测 |
|---|---|
| 加速卡 | **2 × 64GB**（原计划 4 卡，训练仍单卡、两分支各占一卡） |
| 软件栈 | PyTorch 2.9.0（DTK/hip 6.3 构建）、transformers 4.57.6、LLaMA-Factory 0.9.5 |
| 持久存储 | 个人 NFS 盘（跨实例保留）；容器可写层关机即失 |
| 网络 | Hugging Face 直连不通、镜像站可用；GitHub 直连 `git clone` 503，改 ghproxy/codeload |
| 沙箱 | 无 docker、`unshare` 被拒、cgroup 只读 → 判题移到本机 Docker |

已实测跑通：0.5B 模型 20 步 LoRA（loss 0.187）、7B 基座加载（19.3s / 14.2 GiB）与生成、
HarmBench 400 条与 XSTest 450 条读取、LiveCodeBench **183 题**加载（与冻结清单一致）及其源文件哈希 3/3 一致。
未跑通：容器内执行 LiveCodeBench 测试（返回 `-4 Runtime Error`），因此判题必须在本机 Docker 完成。

### 1.3 下一步

1. 解决 `S1` 的 gated 访问，完成两个基座的加载冒烟与 `model_manifest.csv`；
2. 补 `valid_exec`（KodCode VALID 带测试程序）与本机 LCB 执行器；
3. 保存一次容器镜像固化环境，然后进入 **G1 安全前测**（HarmBench，每条行为 n=3）。

## 2. 前测结果（G1 / G2）

| 模型 | HarmBench ASR ↓ | XSTest 过度拒绝率 ↓ | LCB DEV pass@1 ↑ | 主要失败类别 |
|---|---:|---:|---:|---|
| `M0`（Qwen2.5-7B-Instruct） | 待测 | 待测 | 待测 | 待分类 |
| `S1`（Self-RedTeam） | 待测 | 待测 | 待测 | 待分类 |

同时记录：所用推理模式（普通直接提示 / `defender_with_thinking`）、提示模板、judge 版本、温度 0.2、`n=1`、样本清单哈希。

## 3. 逐 epoch 结果（G4 / G5）

### 3.1 能力分支 `B1–B3`（M0 起点）

| 节点 | LCB DEV pass@1 ↑ | HarmBench ASR ↓ | XSTest 过度拒绝率 ↓ |
|---|---:|---:|---:|
| `B0` (= `M0`) | 待测 | 待测 | 待测 |
| `B1` | 待测 | 待测 | 待测 |
| `B2` | 待测 | 待测 | 待测 |
| `B3` | 待测 | 待测 | 待测 |

### 3.2 安全分支 `C1–C3`（S1 起点）

| 节点 | LCB DEV pass@1 ↑ | HarmBench ASR ↓ | XSTest 过度拒绝率 ↓ |
|---|---:|---:|---:|
| `C0` (= `S1`) | 待测 | 待测 | 待测 |
| `C1` | 待测 | 待测 | 待测 |
| `C2` | 待测 | 待测 | 待测 |
| `C3` | 待测 | 待测 | 待测 |

## 4. 安全收益保留分析

定义（见《[实验方案](experiment.md)》第 8 节）：

- `G(0) = ASR(M0) - ASR(S1)`：S 阶段新增安全收益；
- `G(t) = ASR(B_t) - ASR(C_t)`：U 完成 t 个 epoch 后相对原始对照仍保留的额外收益；
- `R(t) = G(t) / G(0)`：收益保留率（仅在 `G(0)` 明显大于评估噪声时使用）；
- `D(t) = ASR(C_t) - ASR(S1)`：安全模型自身退化幅度；
- `ΔU(t) = LCB(C_t) - LCB(S1)`：正常编程能力提升幅度。

| t | `G(0)` | `G(t)` | `R(t)` | `D(t)` | `ΔU(t)` |
|---|---:|---:|---:|---:|---:|
| 1 | 待测 | 待测 | 待测 | 待测 | 待测 |
| 2 | 待测 | 待测 | 待测 | 待测 | 待测 |
| 3 | 待测 | 待测 | 待测 | 待测 | 待测 |

**至少提交四张图（均须来自逐题原始文件）：**

1. `M0` / `S1` 安全与编程前测对比；
2. 逐 epoch 编程 `pass@1` 曲线；
3. 逐 epoch 安全 ASR 曲线；
4. `G(t)` / `D(t)` 安全收益变化图。

图片放入 `docs/assets/figures/`，再用 Markdown 引用即可在本页显示。

## 5. 结果文件清单（归档核对用）

| 文件 | 说明 |
|---|---|
| `model_manifest.csv` | 权重 revision、tokenizer、文件 SHA256 |
| `dataset_manifest.json`、`train_ids.json`、`valid_ids.json` | 10K 抽样与 9,500/500 划分 |
| `lcb_dev_ids.json`、`lcb_test_ids.json` | LCB 两个时间窗题目清单与哈希 |
| `contamination_audit.csv`、`environment.md` | 去重审计、GPU/CUDA/PyTorch/评测器 commit |
| `eval/<model>/<stage>/*.jsonl` | 逐题原始输出与判定 |
| `prescreen_report.md`、`pilot_report.md` | G1/G2 与 G3 的判定说明 |
