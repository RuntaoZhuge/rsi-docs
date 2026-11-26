# 实验进展与结果

seed-1。完整口径与逐轮明细见《[详细结果](results-detail.md)》。

---

## 1 能力

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
    <div class="dash-dumb-label">LCB 365<small>S1 · 8.5 → 14.8</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:33.3%"></span><span class="tick" style="left:66.7%"></span><span class="tick" style="left:100%"></span>
      <span class="line" style="left:14.2%;width:10.5%;background:#2a9d8f"></span><span class="dot start" style="left:14.2%"></span><span class="dot end" style="left:24.7%"></span></div>
    <div class="dash-dumb-val" style="color:#2a9d8f">+6.3pp</div>
  </div>
  <div class="dash-dumb">
    <div class="dash-dumb-label">KodCode<small>MAGIC<br>26.0 → 55.4</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:33.3%"></span><span class="tick" style="left:66.7%"></span><span class="tick" style="left:100%"></span>
      <span class="line" style="left:43.3%;width:49%;background:#4f46e5"></span><span class="dot start" style="left:43.3%"></span><span class="dot end" style="left:92.3%;background:#4f46e5"></span></div>
    <div class="dash-dumb-val" style="color:#4f46e5">+29.4pp</div>
  </div>
  <div class="dash-dumb">
    <div class="dash-dumb-label">LCB 365<small>MAGIC<br>7.9 → 15.1</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:33.3%"></span><span class="tick" style="left:66.7%"></span><span class="tick" style="left:100%"></span>
      <span class="line" style="left:13.2%;width:12%;background:#4f46e5"></span><span class="dot start" style="left:13.2%"></span><span class="dot end" style="left:25.2%;background:#4f46e5"></span></div>
    <div class="dash-dumb-val" style="color:#4f46e5">+7.1pp</div>
  </div>
  <div class="dash-scale"><div></div><div class="track"><span>0%</span><span>20%</span><span>40%</span><span>60%</span></div><div></div></div>
  <div class="dash-cap">灰点 = 训练前，彩点 = 训练后。</div>
</div>

| 模型 | 基准 | 训练前 | 训练后 | 变化 |
|---|---|---:|---:|---:|
| `M0` | KodCode VALID（500） | 26.8% | **55.6%** | **+28.8pp** |
| `M0` | LCB DEV+TEST（365） | 9.3% | **14.5%** | **+5.2pp** |
| `S1` | KodCode VALID（500） | 27.0% | **55.4%** | **+28.4pp** |
| `S1` | LCB DEV+TEST（365） | 8.5% | **14.8%** | **+6.3pp** |
| `MAGIC` | KodCode VALID（500） | 26.0% | **55.4%** | **+29.4pp** |
| `MAGIC` | LCB DEV+TEST（365） | 7.9% | **15.1%** | **+7.1pp** |

`pass@1 = passed / N`。S1 的 LCB 为 plain 复评（thinking 格式崩塌）。S2（AdvGame）未运行。

---

## 2 安全

<div class="dash-card">
  <div class="dash-dumb">
    <div class="dash-dumb-label">ASR<small>M0 · 31.7 → 29.2</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:25%"></span><span class="tick" style="left:50%"></span><span class="tick" style="left:75%"></span>
      <span class="line" style="left:73%;width:6.3%;background:#e05252;opacity:.5"></span><span class="dot start m0" style="left:79.3%"></span><span class="dot end m0" style="left:73%"></span></div>
    <div class="dash-dumb-val" style="color:#e05252">−2.5pp</div>
  </div>
  <div class="dash-dumb">
    <div class="dash-dumb-label">ASR<small>S1 · 18.1 → 13.1</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:25%"></span><span class="tick" style="left:50%"></span><span class="tick" style="left:75%"></span>
      <span class="line" style="left:32.8%;width:12.5%;background:#2a9d8f;opacity:.5"></span><span class="dot start" style="left:45.3%"></span><span class="dot end" style="left:32.8%"></span></div>
    <div class="dash-dumb-val" style="color:#2a9d8f">−5.0pp</div>
  </div>
  <div class="dash-dumb">
    <div class="dash-dumb-label">G(t)<small>13.6 → 16.1</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:25%"></span><span class="tick" style="left:50%"></span><span class="tick" style="left:75%"></span>
      <span class="line" style="left:34%;width:6.3%;background:var(--dash-m0)"></span><span class="dot start" style="left:34%"></span><span class="dot end m0" style="left:40.3%"></span></div>
    <div class="dash-dumb-val" style="color:var(--dash-m0)">+2.5pp</div>
  </div>
  <div class="dash-scale"><div></div><div class="track"><span>0%</span><span>10%</span><span>20%</span><span>30%</span><span>40%</span></div><div></div></div>
  <div class="dash-cap">ASR 越低越安全；G(t) 为两分支 ASR 之差。</div>
</div>

| 状态 | `ASR(M0)` | `ASR(S1)` | `G(t)` |
|---|---:|---:|---:|
| E0 | 31.7% | 18.1% | **13.6pp** |
| E3 | 29.2% | 13.1% | **16.1pp** |

| epoch | `ASR(M0)` | `ASR(S1)` | `G(t)` | `D(t)` | `R(t)` |
|---|---:|---:|---:|---:|---:|
| E0 | 31.7% | 18.1% | 13.6pp | — | — |
| E1 | 27.6% | 14.2% | 13.3pp | −3.8pp | 0.98 |
| E2 | 28.1% | 12.7% | 15.4pp | −5.4pp | 1.13 |
| E3 | 29.2% | 13.1% | 16.1pp | −5.0pp | 1.18 |

`ASR = success / 1200`（400 行为 × n=3）。TOST ±7pp，bootstrap 2000；`D(t)=ASR(S1_t)−ASR(S1_0)`，`R(t)=G(t)/G(0)`。

---

## 3 MAGIC（S3）

与 S1 同一套 KodCode LoRA-SFT（rank 8 / lr 1e-4 / 3 epoch / seed 42），起点 `XiaoyuWen/MAGIC-Qwen2.5-7B-Instruct`；E0 18.0% ≈ S1 18.1%。

<div class="dash-chart">
  <div class="dash-cap"><b>HarmBench ASR</b> · 越低越安全 · 阴影为 <code>G_MAGIC(t)</code></div>
  <svg viewBox="0 0 760 300" role="img" aria-label="M0 与 MAGIC 的 HarmBench ASR 随 epoch 变化">
    <g stroke="currentColor" opacity=".13">
      <line x1="46" y1="250" x2="744" y2="250"/><line x1="46" y1="186" x2="744" y2="186"/>
      <line x1="46" y1="122" x2="744" y2="122"/><line x1="46" y1="58" x2="744" y2="58"/>
    </g>
    <g fill="currentColor" opacity=".5" font-size="11" text-anchor="end" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="38" y="254">0%</text><text x="38" y="190">10%</text><text x="38" y="126">20%</text><text x="38" y="62">30%</text>
    </g>
    <polygon points="46,47.1 278.7,73.4 511.3,70.2 744,63.1 744,164.9 511.3,151.4 278.7,155.3 46,134.8" fill="#4f46e5" opacity=".07"/>
    <polyline points="46,47.1 278.7,73.4 511.3,70.2 744,63.1" fill="none" stroke="#e05252" stroke-width="2.6" stroke-linejoin="round"/>
    <polyline points="46,134.8 278.7,155.3 511.3,151.4 744,164.9" fill="none" stroke="#4f46e5" stroke-width="2.6" stroke-linejoin="round"/>
    <g fill="var(--md-default-bg-color)" stroke="#e05252" stroke-width="2.4">
      <circle cx="46" cy="47.1" r="4.4"/><circle cx="278.7" cy="73.4" r="4.4"/><circle cx="511.3" cy="70.2" r="4.4"/><circle cx="744" cy="63.1" r="4.4"/>
    </g>
    <g fill="var(--md-default-bg-color)" stroke="#4f46e5" stroke-width="2.4">
      <circle cx="46" cy="134.8" r="4.4"/><circle cx="278.7" cy="155.3" r="4.4"/><circle cx="511.3" cy="151.4" r="4.4"/><circle cx="744" cy="164.9" r="4.4"/>
    </g>
    <g fill="#e05252" font-size="11.5" font-weight="700" text-anchor="middle" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="46" y="36">31.7</text><text x="278.7" y="62">27.6</text><text x="511.3" y="59">28.1</text><text x="744" y="52">29.2</text>
    </g>
    <g fill="#4f46e5" font-size="11.5" font-weight="700" text-anchor="middle" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="46" y="151">18.0</text><text x="278.7" y="171">14.8</text><text x="511.3" y="167">15.4</text><text x="744" y="181">13.3</text>
    </g>
    <g fill="currentColor" opacity=".55" font-size="11.5" text-anchor="middle" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="46" y="276">E0</text><text x="278.7" y="276">E1</text><text x="511.3" y="276">E2</text><text x="744" y="276">E3</text>
    </g>
    <g font-size="11.5" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <circle cx="560" cy="14" r="4" fill="#e05252"/><text x="570" y="18" fill="currentColor" opacity=".7">M0</text>
      <circle cx="620" cy="14" r="4" fill="#4f46e5"/><text x="630" y="18" fill="currentColor" opacity=".7">MAGIC</text>
    </g>
  </svg>
  <div class="dash-cap">G_MAGIC：13.7 → 12.8 → 12.7 → <b>15.8pp</b>；TOST 3/3 通过。</div>
</div>

| 状态 | `ASR` | `KodCode` | `LCB DEV` | `LCB TEST` | `LCB 365` | `XSTest ↓` |
|---|---:|---:|---:|---:|---:|---:|
| E0 | 18.0% | 26.0% | 6.0% | 9.9% | 7.9% | 6.8% |
| E1 | 14.8% | 54.4% | 11.5% | 15.9% | 13.7% | 4.0% |
| E2 | 15.4% | 55.4% | 10.9% | 17.0% | 14.0% | 4.8% |
| E3 | 13.3% | 55.4% | 13.1% | 17.0% | **15.1%** | 6.8% |

<div class="dash-chart">
  <div class="dash-cap"><b>LCB DEV+TEST（365）</b> · 三条分支同一时间窗</div>
  <svg viewBox="0 0 760 300" role="img" aria-label="M0、S1 与 MAGIC 的 LCB DEV+TEST pass@1 随 epoch 变化">
    <g stroke="currentColor" opacity=".13">
      <line x1="46" y1="250" x2="744" y2="250"/><line x1="46" y1="202" x2="744" y2="202"/>
      <line x1="46" y1="154" x2="744" y2="154"/><line x1="46" y1="106" x2="744" y2="106"/><line x1="46" y1="58" x2="744" y2="58"/>
    </g>
    <g fill="currentColor" opacity=".5" font-size="11" text-anchor="end" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="38" y="254">0%</text><text x="38" y="206">5%</text><text x="38" y="158">10%</text><text x="38" y="110">15%</text><text x="38" y="62">20%</text>
    </g>
    <polyline points="46,160.7 278.7,126.2 511.3,83.9 744,110.8" fill="none" stroke="#e05252" stroke-width="2.4" stroke-linejoin="round" opacity=".85"/>
    <polyline points="46,168.4 278.7,121.4 511.3,110.8 744,107.9" fill="none" stroke="#2a9d8f" stroke-width="2.4" stroke-linejoin="round" opacity=".85"/>
    <polyline points="46,174.2 278.7,118.5 511.3,115.6 744,105.0" fill="none" stroke="#4f46e5" stroke-width="3" stroke-linejoin="round"/>
    <g fill="var(--md-default-bg-color)" stroke="#4f46e5" stroke-width="2.6">
      <circle cx="46" cy="174.2" r="4.6"/><circle cx="278.7" cy="118.5" r="4.6"/><circle cx="511.3" cy="115.6" r="4.6"/><circle cx="744" cy="105.0" r="5"/>
    </g>
    <g fill="#4f46e5" font-size="11.5" font-weight="700" text-anchor="middle" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="46" y="191">7.9</text><text x="278.7" y="108">13.7</text><text x="511.3" y="105">14.0</text><text x="744" y="95">15.1</text>
    </g>
    <g fill="currentColor" opacity=".55" font-size="11.5" text-anchor="middle" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="46" y="276">E0</text><text x="278.7" y="276">E1</text><text x="511.3" y="276">E2</text><text x="744" y="276">E3</text>
    </g>
    <g font-size="11.5" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <circle cx="510" cy="14" r="4" fill="#e05252"/><text x="520" y="18" fill="currentColor" opacity=".7">M0</text>
      <circle cx="570" cy="14" r="4" fill="#2a9d8f"/><text x="580" y="18" fill="currentColor" opacity=".7">S1</text>
      <circle cx="630" cy="14" r="4" fill="#4f46e5"/><text x="640" y="18" fill="currentColor" opacity=".7">MAGIC</text>
    </g>
  </svg>
  <div class="dash-cap">E0→E3：M0 +5.2pp、S1 +6.3pp、<b>MAGIC +7.1pp</b>（p=4.2e-5）。</div>
</div>

| t | `ASR(M0)` | `ASR(MAGIC)` | `G(t)` | `ΔG` | 90% CI | TOST |
|---:|---:|---:|---:|---:|---|---|
| 0 | 31.7% | 18.0% | **13.7pp** | — | — | — |
| 1 | 27.6% | 14.8% | 12.8pp | −0.8 | [−4.5, +2.7] | 通过 |
| 2 | 28.1% | 15.4% | 12.7pp | −1.0 | [−4.3, +2.4] | 通过 |
| 3 | 29.2% | 13.3% | **15.8pp** | +2.2 | [−0.9, +5.3] | 通过 |

`ASR 18.0→13.3；KodCode +29.4pp；LCB 365 +7.1pp（p=4.2e-5）；TOST 3/3。`

E1–E3 为未合并 adapter；合并版在 `eval/MAGIC/E{1,2,3}_merged/`（D17）。产物：`analysis/magic_{report.md,summary.csv,gchange.csv,d17_compare.csv}`。

---

## 4 原始数据

| 数据包 | 内容 | 大小 | SHA256 |
|---|---|---:|---|
| [`eval_seed1.tar.gz`](assets/data/eval_seed1.tar.gz) | M0/S1 · 123 个逐题文件 · 47,439 条 | 12 MB | [`e40f1208…c051`](assets/data/eval_seed1.tar.gz.sha256) |
| [`eval_magic.tar.gz`](assets/data/eval_magic.tar.gz) | MAGIC · 133 个文件 | 6.9 MB | [`bacadbac…68dbc`](assets/data/eval_magic.tar.gz.sha256) |

```bash
curl -LO https://runtaozhuge.github.io/rsi-docs/assets/data/eval_seed1.tar.gz
curl -LO https://runtaozhuge.github.io/rsi-docs/assets/data/eval_magic.tar.gz
shasum -a 256 eval_seed1.tar.gz eval_magic.tar.gz
```

`eval_seed1`：`eval/<MODEL>/<STAGE>/<benchmark>.jsonl`（M0/S1）。
`eval_magic`：`MAGIC/{E,T}<t>/` + `audit_merged/` + `D17_COMPARE.md`。
均含 `MANIFEST.csv` 与 `README.md`，不含模型权重。
