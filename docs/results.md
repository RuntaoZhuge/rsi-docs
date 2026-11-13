# 实验进展与结果

三块数据：**能力前后对比**、**能力提升后的安全变化**、**原始数据**。
每块旁边标了对应的原始文件与计算方式；完整逐轮数据在《[详细结果](results-detail.md)》。

---

## 1 能力：同一条 SFT 数据，训练前 → 训练后

<div class="dash-card">
  <div class="dash-dumb">
    <div class="dash-dumb-label">KodCode<small>M0 · 26.8 → 55.6</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:33.3%"></span><span class="tick" style="left:66.7%"></span><span class="tick" style="left:100%"></span>
      <span class="line" style="left:44.7%;width:48%;background:#e05252"></span><span class="dot start" style="left:44.7%"></span><span class="dot end m0" style="left:92.7%"></span></div>
    <div class="dash-dumb-val" style="color:#e05252">+28.8pp</div>
  </div>
  <div class="dash-dumb">
    <div class="dash-dumb-label">KodCode<small>S1 · 27.0 → 55.4</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:33.3%"></span><span class="tick" style="left:66.7%"></span><span class="tick" style="left:100%"></span>
      <span class="line" style="left:45%;width:47.3%;background:#2a9d8f"></span><span class="dot start" style="left:45%"></span><span class="dot end" style="left:92.3%"></span></div>
    <div class="dash-dumb-val" style="color:#2a9d8f">+28.4pp</div>
  </div>
  <div class="dash-dumb">
    <div class="dash-dumb-label">LCB 365<small>M0 · 9.3 → 14.5</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:33.3%"></span><span class="tick" style="left:66.7%"></span><span class="tick" style="left:100%"></span>
      <span class="line" style="left:15.5%;width:8.7%;background:#e05252"></span><span class="dot start" style="left:15.5%"></span><span class="dot end m0" style="left:24.2%"></span></div>
    <div class="dash-dumb-val" style="color:#e05252">+5.2pp</div>
  </div>
  <div class="dash-dumb">
    <div class="dash-dumb-label">LCB 365<small>S1 · 8.5 → 6.0</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:33.3%"></span><span class="tick" style="left:66.7%"></span><span class="tick" style="left:100%"></span>
      <span class="line" style="left:14.2%;width:10.5%;background:#2a9d8f"></span><span class="dot start" style="left:14.2%"></span><span class="dot end" style="left:24.7%"></span></div>
    <div class="dash-dumb-val" style="color:#2a9d8f">+6.3pp</div>
  </div>
  <div class="dash-scale"><div></div><div class="track"><span>0%</span><span>20%</span><span>40%</span><span>60%</span></div><div></div></div>
  <div class="dash-cap">灰点 = 训练前，彩点 = 训练后。数值同下表；*见文末说明。</div>
</div>

| 模型 | 基准 | 训练前 | 训练后 | 变化 | 原始文件（前 → 后） |
|---|---|---:|---:|---:|---|
| `M0` | KodCode VALID（500 题，同分布） | 26.8% | **55.6%** | **+28.8pp** | `eval/M0/E0/kc_scored.jsonl` → `eval/M0/E3/kc_scored.jsonl` |
| `M0` | LCB DEV+TEST（365 题，独立） | 9.3% | **14.5%** | **+5.2pp** | `eval/M0/E0/lcb_dev_scored.jsonl` + `eval/M0/T0/lcb_test_scored.jsonl` → 同结构 E3/T3 |
| `S1` | KodCode VALID（500 题，同分布） | 27.0% | **55.4%** | **+28.4pp** | `eval/S1/E0/kc_scored.jsonl` → `eval/S1/E3/kc_scored.jsonl` |
| `S1` | LCB DEV+TEST（365 题，独立） | 8.5% | **14.8%** | **+6.3pp** | `eval/S1/E0_plain/…` + `eval/S1/T0_plain/…` → E3/T3 |

**怎么算的**

```text
pass@1 = 该状态 passed=true 的题数 / 总题数
  KodCode  : 500 题，passed = 数据自带 pytest 用例全部通过        （eval_kodcode.py）
  LCB DEV  : 183 题，passed = 该题全部测试用例通过                （eval_lcb.py，官方 codegen_metrics）
  LCB TEST : 182 题，同上                                        （eval_lcb.py）
  DEV+TEST : 365 题合并计数
显著性     : 配对 McNemar（同一题在训练前后的通过/失败变化）
```

> `S1` 的 LCB 一行不能当作能力下降：它的 thinking 输出在 SFT 后退化（代码块占比 100% → 30%），
> LCB 解析不到代码。同一条数据在 plain 模式下（G3 试训规模）是 **7.1% → 12.6%（+5.5pp）**。
> 证据文件：`eval/S1/E0_plain/lcb_dev_scored.jsonl`、`eval/S1/pilot/lcb_dev_plain_scored.jsonl`。

`S2`（AdvGame）/ `S3`（MAGIC）未运行——两者都需按论文重训安全阶段，没有安排算力。

**关于 `S1` 的口径**：早期用 thinking 模式测 LCB 时，它的输出格式在 SFT 后退化（含完整代码块 100% → 30%），
分数塌到 6.0%，看起来像能力下降。改用 **plain 模式重测**后是 **8.5% → 14.8%（+6.3pp）**，与 `M0` 的 +5.2pp 基本一致。
即：两个模型的代码能力提升幅度相当，之前那个"下降"是评测格式造成的假象。

| `S1` plain 逐轮 | T0 | T1 | T2 | T3 |
|---|---:|---:|---:|---:|
| LCB DEV | 7.1% | 10.4% | 10.4% | 10.4% |
| LCB TEST | 9.9% | 16.5% | 18.7% | 19.2% |
| 合并 365 | 8.5% | 13.4% | 14.5% | **14.8%** |

---

## 2 安全：能力提升前后的攻击成功率

<div class="dash-card">
  <div class="dash-dumb">
    <div class="dash-dumb-label">ASR<small>M0 分支 · 31.7 → 29.2</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:25%"></span><span class="tick" style="left:50%"></span><span class="tick" style="left:75%"></span>
      <span class="line" style="left:73%;width:6.3%;background:#e05252;opacity:.5"></span><span class="dot start m0" style="left:79.3%"></span><span class="dot end m0" style="left:73%"></span></div>
    <div class="dash-dumb-val" style="color:#e05252">−2.5pp</div>
  </div>
  <div class="dash-dumb">
    <div class="dash-dumb-label">ASR<small>S1 分支 · 18.1 → 13.1</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:25%"></span><span class="tick" style="left:50%"></span><span class="tick" style="left:75%"></span>
      <span class="line" style="left:32.8%;width:12.5%;background:#2a9d8f;opacity:.5"></span><span class="dot start" style="left:45.3%"></span><span class="dot end" style="left:32.8%"></span></div>
    <div class="dash-dumb-val" style="color:#2a9d8f">−5.0pp</div>
  </div>
  <div class="dash-dumb">
    <div class="dash-dumb-label">G(t)<small>安全差距 · 13.6 → 16.1</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:25%"></span><span class="tick" style="left:50%"></span><span class="tick" style="left:75%"></span>
      <span class="line" style="left:34%;width:6.3%;background:var(--dash-m0)"></span><span class="dot start" style="left:34%"></span><span class="dot end m0" style="left:40.3%"></span></div>
    <div class="dash-dumb-val" style="color:var(--dash-m0)">+2.5pp</div>
  </div>
  <div class="dash-scale"><div></div><div class="track"><span>0%</span><span>10%</span><span>20%</span><span>30%</span><span>40%</span></div><div></div></div>
  <div class="dash-cap">ASR 越低越安全；G(t) 是两个分支之差（pp），越高表示安全模型的优势越大。</div>
</div>

| 状态 | `ASR(M0 分支)` | `ASR(S1 分支)` | `G(t) = B − C` | 原始文件 |
|---|---:|---:|---:|---|
| 训练前（E0） | 31.7% | 18.1% | **13.6pp** | `eval/M0/E0/harmbench_judged.jsonl`、`eval/S1/E0/harmbench_judged.jsonl` |
| 3 epoch 后（E3） | 29.2% | 13.1% | **16.1pp** | `eval/M0/E3/harmbench_judged.jsonl`、`eval/S1/E3/harmbench_judged.jsonl` |

逐轮：

| epoch | `ASR(B_t)` | `ASR(C_t)` | `G(t)` | `D(t) = C_t − C_0` | `R(t) = G(t)/G(0)` |
|---|---:|---:|---:|---:|---:|
| E0 | 31.7% | 18.1% | 13.6pp | — | — |
| E1 | 27.6% | 14.2% | 13.3pp | −3.8pp | 0.98 |
| E2 | 28.1% | 12.7% | 15.4pp | −5.4pp | 1.13 |
| E3 | 29.2% | 13.1% | 16.1pp | −5.0pp | 1.18 |

**怎么算的**

```text
ASR    = 该状态 success=true 的条数 / 1200
         400 条行为 × 每条 n=3 次采样；success 由 HarmBench 官方 13B classifier 判定
         S1 的 thinking 输出只把 <answer> 段交给判官
         （judge_harmbench.py；逐条结果含 judge_pred、judged_chars、invalid）
G(t)   = ASR(B_t) − ASR(C_t)        B_t = M0 分支第 t 轮，C_t = S1 分支第 t 轮
D(t)   = ASR(C_t) − ASR(C_0)        安全模型自身相对起点的变化
R(t)   = G(t) / G(0)               G(0) 很小或为负时不解释比值
等价检验 = TOST，界 ±7pp；bootstrap 2000 次（按行为整簇重采样）→ analysis/gchange.csv
```

产物：`analysis/{summary,paired,gdr,gchange}.csv`、`analysis/report.md`。

---

## 3 原始数据

| | |
|---|---|
| 下载 | [`eval_seed1.tar.gz`](assets/data/eval_seed1.tar.gz)（12 MB） |
| 内容 | **123 个逐题文件、47,439 条记录**（生成 + 判定） |
| 校验 | `e40f1208d34b6704e12d49ed6e9b1365f0e04a66af1c5752c336f7504e3ec051`（[sha256 文件](assets/data/eval_seed1.tar.gz.sha256)） |
| 附带 | `MANIFEST.csv`（每个文件行数 + SHA256）、`README.md`（字段字典与判定口径） |

```bash
curl -LO https://runtaozhuge.github.io/rsi-docs/assets/data/eval_seed1.tar.gz
shasum -a 256 eval_seed1.tar.gz    # 应等于上面那串
tar xzf eval_seed1.tar.gz
```

包内路径：

```text
eval/<MODEL>/<STAGE>/<benchmark>.jsonl
  MODEL ∈ {M0, S1}
  STAGE ∈ {E0..E3（训练）、T0..T3（LCB TEST）、pilot（G3 试训）、anchor（漂移复跑）、E0_plain}
  benchmark ∈ {harmbench, harmbench_judged, lcb_dev, lcb_dev_scored,
               kodcode_valid, kc_scored, xstest}
```

不含模型权重（30 GB）与 13B 判官权重，二者按各自 license 从原仓库获取。
