# 执行环境与进度

本页记录训练与评测实际跑的机器环境、已经验证过的链路，以及主链和扩展分支走到哪一步。
**不含实测研究结果**——结果统一发布在《[实验进展与结果](results.md)》。

最后更新：2026-11-25

!!! info "一句话现状"

    运行环境与工具链已全部跑通。**seed-1 主链 G0–G5 已完成**（M0/S1 的 LoRA 更新、逐 epoch 评估、
    LCB TEST 与锚点复跑）；**MAGIC（S3）U 阶段的 DEV + LCB TEST 也已完成**，
    推理路径已统一为未合并 adapter，D17 关闭。
    当前没有待跑实验，只剩第二 seed（资源允许时复现）与 S2（平台不可行）。

---

## 1. 平台与硬件

| 项 | 实测值 |
|---|---|
| 形态 | SCNet Notebook 容器实例，SSH 登录（容器内为 root） |
| 加速卡 | **2 × 64GB 国产加速卡**（Hygon BW），`torch` 可见 2 张，bf16 支持 |
| CPU / 内存 | 128 核 / 503 GiB，无 swap |
| 系统 | Ubuntu 22.04.5，kernel 5.15 |
| 平台限制 | 单实例连续运行 **72 小时**；长任务用 `nohup`/`tmux`，脚本内置窗口检查 |

!!! warning "与任务书排班的差异"

    任务书按 4 卡估算卡时。实际为 **2 卡**：训练仍是单卡即可（7B 的 LoRA 约 20–24GB），
    两条分支各占一卡并行；评估需排队复用同一批卡。

---

## 2. 软件栈

| 组件 | 版本 | 说明 |
|---|---|---|
| Python | 3.11.9 | 镜像自带 |
| PyTorch | 2.9.0（DAS/DTK 构建，`hip 6.3.26093`） | **不能 `pip install torch`**，否则卡不可见 |
| transformers | 4.57.6 | 由依赖约束钉死 |
| peft / accelerate / datasets / trl | 0.18.1 / 1.11.0 / 4.0.0 / 0.24.0 | 与 LLaMA-Factory 0.9.5 的约束一致 |
| LLaMA-Factory | 0.9.5 | 训练框架 |
| numpy / pyarrow | 1.26.4 / 16.1.0 | 需匹配 torch 的 NumPy 1.x ABI |

---

## 3. 存储与网络（决定实验能不能安全归档）

| 位置 | 持久性 | 用途 |
|---|---|---|
| 个人 NFS 盘（`private_data`） | ✅ 跨实例保留 | 权重、数据、adapter、逐题输出——**所有实验资产** |
| 容器可写层（`/`、`/workspace`、`/tmp`） | ❌ 关机即失 | 只放临时文件 |

| 目标 | 结果 |
|---|---|
| Hugging Face 直连 | ❌ 不通；镜像站可用（15GB 权重下载成功） |
| GitHub `git clone` | ❌ 代理 503；改用 ghproxy 克隆或 codeload tarball |
| PyPI | ✅ 走国内镜像 |
| apt | ✅ 可用 |

!!! danger "没有可用的代码执行沙箱"

    容器内没有 docker/podman/apptainer，`unshare` 被拒（缺 `CAP_SYS_ADMIN`），cgroup 只读。
    因此**模型生成的代码不在 GPU 容器里执行**：生成在容器、判题在本机 Docker
    （`--network none --memory 2g --cpus 2`），这也是任务书要求的"无外网、有限资源"沙箱。

---

## 4. 已经实测跑通的链路

| 动作 | 结果 |
|---|---|
| 环境初始化（venv + 钉版依赖 + 训练框架 + 三套评测器） | ✅ 可重入脚本，一次跑通 |
| 真人训练：0.5B 模型 20 步 LoRA | ✅ `train_loss=0.187`，adapter 正常落盘 |
| 7B 基座（`M0`/`S1`/`MAGIC`）加载 | ✅ 三个 15GB 权重均可加载，bf16 可用 |
| 7B 生成（HarmBench 提示） | ✅ 单卡多路生成；HarmBench 400 行为 × n=3 |
| HarmBench 官方 13B classifier 判题 | ✅ 25GB 判官已下载；主链 8 个状态 + MAGIC 8 个状态全部判完 |
| LiveCodeBench DEV / TEST | ✅ 183 / 182 题，与冻结清单一致；官方 codegen 判题 |
| KodCode 10K 上传与校验 | ✅ 9,500 / 500 / 1,000 |
| XSTest | ✅ 450 条提示，只统计 250 条 safe |
| 正式 LoRA 更新（3 epoch） | ✅ 3,564 步，M0/S1 双分支并行，墙钟 3h15m |
| MAGIC LoRA 更新（3 epoch） | ✅ 3,564 步，墙钟 3h30m，`train_loss=0.153` |
| adapter 挂载 / 合并两条推理路径 | ✅ 均可用；MAGIC 主结果已统一为未合并，合并版仅作 D17 审计 |
| LCB 代码**执行**判题 | ✅ 在本机 Docker；GPU 容器内直接执行返回 `-4 Runtime Error` |

### 4.1 环境侧已解决的主要问题

| 现象 | 处理 |
|---|---|
| `datasets` 导入失败（NumPy 2 vs 1） | 钉 `numpy==1.26.4` + `pyarrow==16.1.0` |
| 训练框架缺 `torchaudio`（DTK 无轮子） | 提供"导入可用、调用即报错"的桩模块，不改训练代码 |
| 生成报 `flash_attn_2_cuda*.so` 缺失 | 全部改用 `attn_implementation="eager"` |
| `git clone` 走代理 503 | ghproxy 克隆，失败退回 codeload tarball |
| LCB 依赖新版 `anthropic` | 降到 0.34.2 |
| LCB 提示模块按相对路径读文件 | 调用前切到仓库根目录，路径先转绝对路径 |
| LCB 判题并发过高触发 OOM | 判题改分块（`--chunk`），并发从 16 降到 4–6 |
| Mistral tokenizer 正则告警 | 三个基座的 `tokenizer_config.json` 一致，仅告警，不影响分词 |

---

## 5. 卡时与步骤状态

主链在 2 卡上串行推进，关键实测墙钟：

| 阶段 | 内容 | 墙钟 | 备注 |
|---|---|---:|---|
| G1 | M0/S1 HarmBench 400×3 + 判题 | 1h38m | 双分支并行 |
| G2 | M0 LCB DEV 183 + 判题 | 1h00m | |
| G3 | 1,000 条 × 1 epoch 试训 + KodCode 判题 | 1h48m | 双分支并行 |
| G4 训练 | KodCode 9,500 × 3 epoch | 3h15m | 两个 LoRA 同时训 |
| G4 评估 | E1 / E2 / E3 各一轮四套评测 | 4h09m / 4h18m / 3h56m | 双分支并行 |
| G4 合计 | 训练 + 三轮评估 | **15h38m** | 不含排队与空转 |
| MAGIC 训练 | KodCode 9,500 × 3 epoch | 3h30m | 单分支 |
| MAGIC 评估 | E1–E3 各一轮四套评测 | 约 3h | 次日串行 |
| MAGIC TEST | T0–T3，两两并行 | 1h16m | 2026-11-24 |
| MAGIC D17 复跑 | E1/E2 未合并并行 + E3 单跑 | 3h05m / 3h16m | 2026-11-24 |

步骤状态：

| 步骤 | 内容 | 状态 |
|---|---|---|
| S1 | 环境初始化 | ✅ |
| S2 | 训练链路验证（小模型） | ✅ |
| S3 | 下载 `M0` | ✅ |
| S4 | 下载 `S1`（gated） | ✅ 已授权并下载 |
| S5 | 数据上传与哈希核对 | ✅（KodCode / LCB 均核对） |
| S6 | 生成冒烟 | ✅ |
| S7 | G0 收尾（manifest / 冒烟 / 判官 / 镜像） | ✅ 2026-11-10 |
| S8 | G1 安全前测 | ✅ 2026-11-10 |
| S9 | G2 能力前测 | ✅ 2026-11-10 |
| S10 | G3 小样本试训 | ✅ 2026-11-10 |
| S11 | G4 正式训练 | ✅ 2026-11-11 |
| S12 | 逐 epoch 评估 | ✅ 2026-11-11 |
| S13 | G5 汇总分析（LCB TEST + 锚点） | ✅ 2026-11-13 |
| S14 | MAGIC（S3）U 阶段 DEV 期 | ✅ 2026-11-19/20 |
| S15 | MAGIC LCB TEST（T0–T3） | ✅ 2026-11-24 |
| S16 | D17 一致性检查（E1–E3 未合并复跑） | ✅ 2026-11-25，D17 关闭 |
| S17 | 第二 seed | ❌ 未运行（见 §6） |
| S18 | S2（AdvGame） | ❌ 平台不可行（见 §7） |

---

## 6. 下一步

1. **第二 seed**：主链与 MAGIC 的结论目前都是单 seed，资源允许时应各复现一次。
2. **S2（AdvGame）**：官方训练栈依赖 CUDA 版 torch、Slurm/Ray 与多节点，当前 DCU 平台不可行；
   已写 `S2_FEASIBILITY.md` 记录原因，不用别的基座凑数。

!!! note "资产位置"

    所有实验资产在 NFS `/root/private_data/rsi`。2026-11-24 复核：三个 15GB 基座、
    13B 判官、KodCode 数据、`runs/{M0,S1,MAGIC}` 的 checkpoint 与 `eval/` 逐题文件均在；
    当前实例为 0 卡模式，无法继续训练/评测，但资产不受关机影响。
