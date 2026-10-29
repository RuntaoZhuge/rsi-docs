# 实验进展与结果

本页用于发布 G1–G5 的实测结果。所有数字都应来自可追溯的逐题原始文件（`jsonl` + 汇总 `csv` + 配置与环境 JSON + 哈希），不能只手填百分比。

!!! warning "当前页不含实测结果"

    实验尚未开始。以下表格与图位是预留模板，用于在 G1–G5 完成后按同一口径填入；未填写的单元格一律视为"待测"，不能当作结论。

## 1. 关口状态

| 关口 | 依据 | 状态 | 日期 |
|---|---|---|---|
| G0 资源与数据核查 | 《[实验方案](experiment.md)》第 3 节 | 待执行 | — |
| G1 安全前测 | 第 4 节，`ASR(M0)`、`ASR(S1)`、`SafetyGain = ASR(M0) - ASR(S1)` | 待执行 | — |
| G2 能力前测 | 第 4 节，LCB DEV `pass@1` | 待执行 | — |
| G3 小样本试训 | 第 5 节，1K–2K 子集短 LoRA-SFT | 待执行 | — |
| G4 正式 LoRA 更新 | 第 6 节，9,500 条 × 3 epoch | 待执行 | — |
| G5 汇总分析 | 第 8 节 | 待执行 | — |

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
