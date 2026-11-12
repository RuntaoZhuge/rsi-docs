<div class="dash">
<div class="dash-hero">
  <div class="dash-kicker">RSI 安全自我进化 · 组会简报 · 2026-11-12</div>
  <h1>安全收益，在能力更新后还剩多少？</h1>
  <p>同一份 KodCode、同一套 LoRA，把安全模型和原始模型各更新 3 个 epoch。看差距是保留、缩小，还是消失。</p>
  <div class="dash-pills">
    <span class="dash-pill ok">G0–G4 完成</span>
    <span class="dash-pill">seed-1</span>
    <span class="dash-pill">n = 1,200 / 状态</span>
    <span class="dash-pill warn">G5 待跑</span>
    <span class="dash-pill warn">第二 seed 未跑</span>
  </div>
</div>

<div class="dash-kpis">
  <div class="dash-kpi s1"><div class="v">13.6<span style="font-size:.55em">pp</span></div><div class="l">G(0) 安全基线差距</div></div>
  <div class="dash-kpi"><div class="v">16.1<span style="font-size:.55em">pp</span></div><div class="l">G(3) 三个 epoch 后，未缩小</div></div>
  <div class="dash-kpi"><div class="v">3 / 3</div><div class="l">TOST ±7pp 通过（原始 ASR）</div></div>
  <div class="dash-kpi m0"><div class="v">+28.8<span style="font-size:.55em">pp</span></div><div class="l">KodCode 同分布提升</div></div>
</div>

<div class="dash-alert"><strong>关键修正</strong>　ASR 与回答长度强相关。把长度分布对齐后，长度对齐后 G(0) 只剩 4.2–5.6pp（原始 13.6pp）；超过一半的基线优势来自“S1 更短/更常短拒答”；严格 ±7pp 等价在 E2 边缘失守。</div>

<h2>01 设计 <span>2 × 4 · 唯一变量是更新剂量</span></h2>
<div class="dash-grid2">
  <div class="dash-card">
    <div class="dash-flow">
      <div class="dash-flow-row">
        <div class="dash-tag m0">M0</div><div class="dash-arrow">→</div>
        <div class="dash-epoch"><b>B0</b>E0</div><div class="dash-epoch"><b>B1</b>1 ep</div><div class="dash-epoch"><b>B2</b>2 ep</div><div class="dash-epoch"><b>B3</b>3 ep</div>
      </div>
      <div class="dash-flow-row">
        <div class="dash-tag s1">S1</div><div class="dash-arrow">→</div>
        <div class="dash-epoch"><b>C0</b>E0</div><div class="dash-epoch"><b>C1</b>1 ep</div><div class="dash-epoch"><b>C2</b>2 ep</div><div class="dash-epoch"><b>C3</b>3 ep</div>
      </div>
      <div class="dash-flow-note">同一 KodCode 9.5K · 同一 LoRA-SFT · 3 epoch</div>
    </div>
  </div>
  <div class="dash-card">
    <div class="dash-note">
      <b>安全</b>　HarmBench ASR，400 行为 × 3 采样<br>
      <b>能力</b>　LCB DEV 183 题 + KodCode VALID 500 题<br>
      <b>代价</b>　XSTest 250 条 safe 题的过度拒绝<br>
      <b>判定</b>　G(t)=ASR(B)−ASR(C)，TOST 等价界 ±7pp<br>
      <b>放行</b>　G0 → G1 → G2 → G3 → G4 → G5
    </div>
  </div>
</div>

<h2>02 安全 <span>原始 ASR 口径：差距没有缩小</span></h2>
<div class="dash-chart">
  <div class="dash-cap"><b>HarmBench ASR</b> · 越低越安全 · 阴影为 G(t)</div>
  <svg viewBox="0 0 760 300" role="img" aria-label="M0 与 S1 的 HarmBench ASR 随 epoch 变化">
    <g stroke="currentColor" opacity=".13">
      <line x1="46" y1="250" x2="744" y2="250"/><line x1="46" y1="186" x2="744" y2="186"/>
      <line x1="46" y1="122" x2="744" y2="122"/><line x1="46" y1="58" x2="744" y2="58"/>
    </g>
    <g fill="currentColor" opacity=".5" font-size="11" text-anchor="end" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="38" y="254">0%</text><text x="38" y="190">10%</text><text x="38" y="126">20%</text><text x="38" y="62">30%</text>
    </g>
    <polygon points="46,47.1 278.7,73.4 511.3,70.2 744,63.1 744,166.2 511.3,168.7 278.7,159.1 46,134.2" fill="#4f46e5" opacity=".07"/>
    <polyline points="46,47.1 278.7,73.4 511.3,70.2 744,63.1" fill="none" stroke="#e05252" stroke-width="2.6" stroke-linejoin="round"/>
    <polyline points="46,134.2 278.7,159.1 511.3,168.7 744,166.2" fill="none" stroke="#2a9d8f" stroke-width="2.6" stroke-linejoin="round"/>
    <g fill="var(--md-default-bg-color)" stroke="#e05252" stroke-width="2.4">
      <circle cx="46" cy="47.1" r="4.4"/><circle cx="278.7" cy="73.4" r="4.4"/><circle cx="511.3" cy="70.2" r="4.4"/><circle cx="744" cy="63.1" r="4.4"/>
    </g>
    <g fill="var(--md-default-bg-color)" stroke="#2a9d8f" stroke-width="2.4">
      <circle cx="46" cy="134.2" r="4.4"/><circle cx="278.7" cy="159.1" r="4.4"/><circle cx="511.3" cy="168.7" r="4.4"/><circle cx="744" cy="166.2" r="4.4"/>
    </g>
    <g fill="#e05252" font-size="11.5" font-weight="700" text-anchor="middle" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="46" y="36">31.7</text><text x="278.7" y="62">27.6</text><text x="511.3" y="59">28.1</text><text x="744" y="52">29.2</text>
    </g>
    <g fill="#2a9d8f" font-size="11.5" font-weight="700" text-anchor="middle" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="46" y="151">18.1</text><text x="278.7" y="176">14.2</text><text x="511.3" y="186">12.7</text><text x="744" y="183">13.1</text>
    </g>
    <g fill="currentColor" opacity=".55" font-size="11.5" text-anchor="middle" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <text x="46" y="276">E0</text><text x="278.7" y="276">E1</text><text x="511.3" y="276">E2</text><text x="744" y="276">E3</text>
    </g>
    <g font-size="11.5" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
      <circle cx="592" cy="14" r="4" fill="#e05252"/><text x="602" y="18" fill="currentColor" opacity=".7">M0</text>
      <circle cx="644" cy="14" r="4" fill="#2a9d8f"/><text x="654" y="18" fill="currentColor" opacity=".7">S1</text>
    </g>
  </svg>
  <div class="dash-cap">S1 在 E1 变安全（18.1→14.2, p=0.018）；M0 边缘（31.7→27.6, p=0.071）。</div>
</div>

<h2>03 能力 <span>提升只在训练分布内</span></h2>
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
    <div class="dash-dumb-label">LCB DEV<small>M0 · 9.8 → 10.4</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:33.3%"></span><span class="tick" style="left:66.7%"></span><span class="tick" style="left:100%"></span>
      <span class="line" style="left:16.3%;width:1%;background:#e05252"></span><span class="dot start" style="left:16.3%"></span><span class="dot end m0" style="left:17.3%"></span></div>
    <div class="dash-dumb-val" style="color:var(--dash-muted)">+0.5pp</div>
  </div>
  <div class="dash-dumb">
    <div class="dash-dumb-label">LCB DEV<small>S1 · 6.0 → 6.0</small></div>
    <div class="dash-track"><span class="tick" style="left:0"></span><span class="tick" style="left:33.3%"></span><span class="tick" style="left:66.7%"></span><span class="tick" style="left:100%"></span>
      <span class="dot start" style="left:10%"></span><span class="dot end" style="left:10%"></span></div>
    <div class="dash-dumb-val" style="color:var(--dash-muted)">0.0pp</div>
  </div>
  <div class="dash-scale"><div></div><div class="track"><span>0%</span><span>20%</span><span>40%</span><span>60%</span></div><div></div></div>
  <div class="dash-cap">LCB 分辨率 11.5pp：小于它的变化不能叫“提升”，也不能叫“没提升”。</div>
</div>

<h2>04 机制 <span>ASR 下降几乎全部来自“回答变短”</span></h2>
<div class="dash-stack">
  <div class="dash-chart">
    <div class="dash-cap"><b>E0 → E3 的构成分解</b> · 对称分解，无交互残差</div>
    <svg viewBox="0 0 720 210" role="img" aria-label="S1 与 M0 的 ASR 变化分解为长度构成与同长度内变化">
      <g stroke="currentColor" opacity=".12"><line x1="40" y1="190" x2="680" y2="190"/></g>
      <line x1="520" y1="34" x2="520" y2="178" stroke="currentColor" opacity=".25" stroke-dasharray="3 3"/>
      <g font-size="11" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
        <rect x="120" y="57" width="400" height="26" rx="5" fill="#2a9d8f" opacity=".9"/>
        <text x="320" y="74" text-anchor="middle" fill="#fff" font-weight="700">−5.0 构成</text>
        <text x="528" y="74" fill="#2a9d8f" font-weight="700">+0.0 组内</text>
        
        <rect x="208" y="127" width="312" height="26" rx="5" fill="#2a9d8f" opacity=".9"/>
        <text x="364" y="144" text-anchor="middle" fill="#fff" font-weight="700">−3.9 构成</text>
        <rect x="208" y="127" width="112" height="26" rx="5" fill="#d97706" opacity=".92"/>
        <text x="264" y="144" text-anchor="middle" fill="#fff" font-weight="700">+1.4</text>
        
      </g>
      <g fill="currentColor" font-size="12" font-weight="700" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
        <text x="40" y="46">S1 · 总 −5.0</text><text x="40" y="116">M0 · 总 −2.5</text>
      </g>
      <g fill="currentColor" opacity=".5" font-size="10.5" text-anchor="middle" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
        <text x="120" y="205">−6</text><text x="200" y="205">−4</text><text x="360" y="205">−2</text><text x="520" y="205">0</text><text x="680" y="205">+2</text>
      </g>
    </svg>
    <div class="dash-cap">单位：pp。条形从 0 出发；S1 的下降全部是构成，M0 同长度内反而 +1.4。</div>
  </div>
  <div class="dash-card">
    <div class="dash-note">
      <b>长度对齐后 G(0)：13.6 → 4.2–5.6pp</b><br><br>
      超过一半的“安全优势”来自 S1 更短、更常短拒答，而不是同等篇幅下更少有害细节。<br><br>
      拒答率本身没升：S1 73.3%→74.6%，M0 53.5%→52.0%。<br><br>
      <span style="color:var(--dash-amber);font-weight:700">所以不能写“SFT 提升了对齐/安全”。</span>
    </div>
  </div>
</div>

<h2>05 等价性 <span>原始口径通过；长度调整后不稳健</span></h2>
<div class="dash-stack">
  <div class="dash-chart">
    <div class="dash-cap"><b>ΔG = G(3) − G(0)</b> · 点与 90% CI · 绿带为 ±7pp 等价界</div>
    <svg viewBox="0 0 760 250" role="img" aria-label="不同口径下 Delta G 的点估计与 90% 置信区间">
      <rect x="82.5" y="30" width="595" height="166" fill="#16a34a" opacity=".06"/>
      <line x1="82.5" y1="30" x2="82.5" y2="196" stroke="#16a34a" stroke-dasharray="4 4" opacity=".45"/>
      <line x1="677.5" y1="30" x2="677.5" y2="196" stroke="#16a34a" stroke-dasharray="4 4" opacity=".45"/>
      <line x1="380" y1="30" x2="380" y2="196" stroke="currentColor" opacity=".3"/>
      <g stroke="currentColor" opacity=".12"><line x1="40" y1="200" x2="720" y2="200"/></g>
      <g font-size="10.5" fill="currentColor" opacity=".5" text-anchor="middle" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
        <text x="40" y="218">−8</text><text x="210" y="218">−4</text><text x="380" y="218">0</text><text x="550" y="218">+4</text><text x="720" y="218">+8</text>
        <text x="90" y="30" text-anchor="start">−7pp</text><text x="670" y="30" text-anchor="end">+7pp</text>
      </g>
      <g font-size="11.5" font-family="ui-sans-serif, -apple-system, 'Noto Sans SC', sans-serif">
        <text x="40" y="50" fill="currentColor" opacity=".7" font-weight="700">原始 ASR · 3/3 通过</text>
        <line x1="324.8" y1="72" x2="639.3" y2="72" stroke="#4f46e5" stroke-width="4" stroke-linecap="round" opacity=".65"/>
        <circle cx="486.3" cy="72" r="6" fill="#4f46e5"/>
        <text x="40" y="108" fill="currentColor" opacity=".7" font-weight="700">长度对齐 · 四档 · E2 边缘未过</text>
        <line x1="290.8" y1="128" x2="647.8" y2="128" stroke="#2a9d8f" stroke-width="4" stroke-linecap="round" opacity=".65"/>
        <circle cx="469.3" cy="128" r="6" fill="#2a9d8f"/>
        <text x="40" y="166" fill="currentColor" opacity=".7" font-weight="700">长度对齐 · 五档 · 三档全未过</text>
        <line x1="337.5" y1="184" x2="703" y2="184" stroke="#d97706" stroke-width="4" stroke-linecap="round" opacity=".7"/>
        <circle cx="520.3" cy="184" r="6" fill="#d97706"/>
      </g>
    </svg>
    <div class="dash-cap">同一批数据，换一种长度分箱，等价判定就翻转：结论只能写“未见侵蚀”，不能写“严格等价”。</div>
  </div>
  <div class="dash-card">
    <div class="dash-note">
      <b>原始 ASR</b>　+2.5pp，90% CI [−1.3, +6.1]　✅ 通过<br>
      <b>四档对齐</b>　+2.1pp，90% CI [−2.1, +6.3]　✅；E2 上界 7.5，超界 0.5<br>
      <b>五档对齐</b>　+3.3pp，90% CI [−1.0, +7.6]　❌ 未通过<br><br>
      <span style="color:var(--dash-amber);font-weight:700">不是结论反转，是等价性对长度调整不稳健。</span>
    </div>
  </div>
</div>

<h2>06 讨论 <span>六个需要一起想清楚的问题</span></h2>
<div class="dash-topics">
  <div class="dash-topic">
    <div class="num">A1 · 结论口径</div>
    <h3>主结论用原始 ASR，还是长度对齐后的 ASR？</h3>
    <p>原始 ASR 是预注册主终点，E1–E3 的 TOST 全过；长度对齐后点估计仍为正，但 E2 的 90% 上界 7.5pp 超界，五档分箱三档全不过。把长度调整升成主终点，等于改问“同等篇幅下是否更少有害细节”——这是一个更窄、也更难回答的问题。</p>
    <div class="q">拍板：raw ASR 主报、长度作 sensitivity（推荐），还是设双主终点？</div>
  </div>
  <div class="dash-topic">
    <div class="num">A2 · 收益定义</div>
    <h3>“更短、更常短拒答”算不算安全收益？</h3>
    <p>如果 S1 的优势主要来自回答更短、更常短拒答，它在部署上仍是安全行为（用户拿不到可操作细节）；但它和“同等篇幅下更少有害内容”不是同一种能力。XSTest 过度拒绝只有 3–5%，说明代价不高；真正的风险是这种收益能否迁移到别的攻击分布。</p>
    <div class="q">讨论：我们在论文里要不要区分 refusal propensity 与 harm reduction？</div>
  </div>
  <div class="dash-topic">
    <div class="num">A3 · 内容审计</div>
    <h3>怎么证明“长回答真的更少可操作细节”？</h3>
    <p>抽 E0/E3 各 100 条“&gt;1500 字符且未拒答”样本做盲评，编码四件事：是否给出可执行步骤、是否具体到参数/工具、拒绝是否只是开头套话、是否含安全免责声明。两人独立编码并报 Cohen's κ；如果同长度内确实更少可操作细节，“SFT 让模型更安全”才站得住。</p>
    <div class="q">拍板：谁来做、本周能否完成、编码表用哪一版？</div>
  </div>
  <div class="dash-topic">
    <div class="num">B1 · 种子复现</div>
    <h3>第二 seed 值不值得现在跑？</h3>
    <p>单 seed 是目前最大的外部效度缺口。第二 seed 不必重跑全部：只复现主终点（训练 + HarmBench/LCB DEV），长度分析可直接用落盘输出补。若两个 seed 的 ΔG 方向不一致，主结论要降级为“seed-dependent”，而不是继续写“保留”。</p>
    <div class="q">讨论：预算/卡时是否允许？只复现主终点，还是连长度分析一起？</div>
  </div>
  <div class="dash-topic">
    <div class="num">B2 · 判官稳健性</div>
    <h3>单一 13B judge 会不会把“长度”当成“危害”？</h3>
    <p>ASR 与回答长度强相关，但“判官本身对长度敏感”尚未验证：可能是长回答确实更可操作，也可能是 judge 看到更多细节就更容易判成功。抽 200 条按行为分层，用第二判官盲评，报 Cohen's κ 与两种判官下的 ASR 差值；κ&lt;0.6 时所有 ASR 结论都要加不确定性说明。</p>
    <div class="q">讨论：第二判官用哪个模型/API？200 条够不够？</div>
  </div>
  <div class="dash-topic">
    <div class="num">B3 · G5 与交付</div>
    <h3>TEST 跑完之后，交给写论文的人什么？</h3>
    <p>G5 要跑 LCB TEST 182 题 × 8 状态 + M0/E0 的 DEV anchor 复跑：anchor 排除环境漂移，TEST 回答“DEV 上的结论是不是题集特性”。论文由合作者主笔，我们需要交付主表（ASR/能力/长度）、三张主图和“必须一起报的限制清单”，避免对方写出数据支持不了的句子。</p>
    <div class="q">拍板：G5 本周是否跑完？交付清单谁维护？</div>
  </div>
</div>

<h2>07 已知限制</h2>
<div class="dash-card">
  <div class="dash-pills" style="margin-top:0">
    <span class="dash-pill warn">单 seed</span>
    <span class="dash-pill warn">单一判官</span>
    <span class="dash-pill warn">LCB 分辨率 11.5pp</span>
    <span class="dash-pill warn">G5 未跑</span>
    <span class="dash-pill">S1 只判 &lt;answer&gt;</span>
    <span class="dash-pill">长度分析为事后（D15）</span>
  </div>
  <div class="dash-cap" style="margin-top:.55rem">数字来源：<a href="../results/">结果页</a> · <a href="../experiment/">实验方案</a> · analysis/report.md · analysis/length_report.md</div>
</div>
</div>
