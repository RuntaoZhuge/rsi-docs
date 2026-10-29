# rsi-docs

研究文档站：**通过动态安全自我改进获得的防御收益，在模型随后使用新数据继续训练、提高正常任务能力时，能否持续保留？**

站点地址：<https://runtaozhuge.github.io/rsi-docs/>

## 站点内容

| 页面 | 文件 | 内容 |
|---|---|---|
| 首页 | `docs/index.md` | 研究问题、实验主线、主要指标、关口进度 |
| 研究动机 | `docs/motivation.md` | 两组文献如何组成动机、与相近工作的边界、参考文献 |
| 实验方案（任务书） | `docs/experiment.md` | G0–G5 关口、数据与评测协议、统一 LoRA-SFT 配置、保存规范、验收清单 |
| 实验进展与结果 | `docs/results.md` | 关口状态、前测与逐 epoch 结果、收益保留分析（当前为待填模板） |
| 幻灯片 | `docs/slides.md` | 研究动机 4 页幻灯片下载 |

## 本地预览

```bash
python3 -m pip install -r requirements.txt
mkdocs serve          # http://127.0.0.1:8000
mkdocs build --strict # 与 CI 相同的构建方式，输出到 site/
```

## 发布

推送到 `main` 后由 GitHub Actions（`.github/workflows/deploy.yml`）构建并用 GitHub Pages 发布：

```bash
git add -A
git commit -m "更新文档"
git push
```

## 更新原始文档

`docs/motivation.md`、`docs/experiment.md` 与 `docs/assets/*.pptx` 是研究工作目录中原始文档的副本。原始文件更新后运行：

```bash
scripts/sync_docs.sh            # 默认从仓库上一级目录读取
scripts/sync_docs.sh ~/path/to/research
```

`docs/index.md`、`docs/results.md`、`docs/slides.md` 是本站原创页面，不会被同步脚本覆盖。

## 约定

- 论文、数据集、权重、评测工具都链接到官方来源，本站不替代一手资料。
- 未做实验不写"已证实"：所有结论以《实验进展与结果》页的实测记录为准。
- 每个正式阶段（E0/E1/E2/E3）的 adapter、训练状态与逐题评估原件必须归档，页面只呈现可追溯的汇总。
