# 实验进展与结果

四块数据：**能力前后对比**、**能力提升后的安全变化**、**第二个安全方法 MAGIC**、**原始数据**。
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

`S2`（AdvGame）未运行——需要按论文重训安全阶段，当前 DCU 平台不可行（见详细结果）。
`S3`（MAGIC）已完成 U 阶段的 DEV 期评估（E0–E3）；LCB TEST 尚未跑，见 §3。

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

## 3 第二个安全方法：MAGIC（S3）

MAGIC 的 U 阶段与 S1 使用**完全同一套** KodCode LoRA-SFT（rank 8 / lr 1e-4 / 3 epoch / seed 42），
只把起点换成 `XiaoyuWen/MAGIC-Qwen2.5-7B-Instruct`。它的 E0 安全水平（18.0%）与 S1（18.1%）几乎相同，
因此可以直接比较「同一起点水平下，两种安全方法的收益在能力更新后是否都保留」。

| 状态 | `ASR(MAGIC 分支)` | `KodCode VALID` | `LCB DEV` | `XSTest 过度拒绝` |
|---|---:|---:|---:|---:|
| E0 | 18.0% | 26.0% | 6.0% | 6.8% |
| E1 | 14.3% | 54.4% | 9.3% | 3.6% |
| E2 | 16.2% | 56.2% | 9.8% | 4.8% |
| E3 | 14.1% | 55.2% | 12.0% | 6.0% |

`G_MAGIC(t) = ASR(M0/B_t) − ASR(MAGIC/D_t)`：

| t | `ASR(M0/B_t)` | `ASR(MAGIC/D_t)` | `G_MAGIC(t)` | `ΔG` | 90% CI | TOST ±7pp |
|---:|---:|---:|---:|---:|---|---|
| 0 | 31.7% | 18.0% | **13.7pp** | — | — | — |
| 1 | 27.6% | 14.3% | 13.2pp | −0.4 | [−3.9, +3.2] | 通过 |
| 2 | 28.1% | 16.2% | 11.9pp | −1.7 | [−5.2, +1.5] | 通过 |
| 3 | 29.2% | 14.1% | **15.1pp** | +1.4 | [−1.8, +4.8] | 通过 |

**结论**：与 S1 同向——安全收益在 ±7pp 内保留，MAGIC 自身 ASR 也从 18.0% 降到 14.1%；
KodCode 同分布 **+29.2pp**，与 M0/S1 的 +28.4~28.8pp 同量级。

**还没做**：MAGIC 的 LCB TEST（182 题，T0–T3）尚未运行，因此上表的 LCB DEV +6.0pp
仍低于 183 题的分辨率（约 11.5pp），**不能据此写「独立基准能力提升」**；
TEST 跑完后才能做 DEV+TEST 合并分析。另外 E1–E3 生成使用了合并后的 adapter，
与 M0/S1 的未合并路径存在一处推理差异（D17），待一致性检查。

产物：`eval/MAGIC/E0..E3/`、`analysis/magic_report.md`、`analysis/magic_gchange.csv`。

---

## 4 原始数据

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

### MAGIC（S3）单独打包

`eval_seed1.tar.gz` 只包含 M0/S1。MAGIC 的 E0–E3 逐题文件单独打包：

| | |
|---|---|
| 下载 | [`eval_magic.tar.gz`](assets/data/eval_magic.tar.gz)（3.9 MB） |
| 内容 | **66 个文件**：MAGIC E0–E3 的生成、判定与日志 |
| 校验 | `125f8dd7c93cfa93e5dc718fcaa2718950c38a984235d8dbbb23607a06c77ff5`（[sha256 文件](assets/data/eval_magic.tar.gz.sha256)） |

```bash
curl -LO https://runtaozhuge.github.io/rsi-docs/assets/data/eval_magic.tar.gz
shasum -a 256 eval_magic.tar.gz    # 应等于上面那串
tar xzf eval_magic.tar.gz          # 解出 MAGIC/E0..E3/
```

包内路径 `MAGIC/E<t>/`，外加 `MANIFEST.csv`（行数 + SHA256）与 `README.md`（协议与口径）。
不含 MAGIC 的 LCB TEST（尚未运行）与模型权重。
