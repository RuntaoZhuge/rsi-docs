#!/usr/bin/env bash
# 把研究工作目录里的原始文档同步到本站 docs/。
# 用法：scripts/sync_docs.sh [源目录]      （默认源目录是仓库的上一级）
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${1:-$(dirname "$REPO")}"

[ -f "$SRC/RSI_Safety_Experiment.md" ] || { echo "找不到 $SRC/RSI_Safety_Experiment.md" >&2; exit 1; }
[ -f "$SRC/rsi_safety2026-10-22.md" ] || { echo "找不到 $SRC/rsi_safety2026-10-22.md" >&2; exit 1; }

# 动机文档自带 H1，直接复制
install -m 644 "$SRC/rsi_safety2026-10-22.md" "$REPO/docs/motivation.md"

# 任务书原文从 H2 开始，补一个 H1 作为页面标题
{
  printf '# 实验任务书：安全自我改进的收益能否经受后续正常能力更新\n\n'
  cat "$SRC/RSI_Safety_Experiment.md"
} > "$REPO/docs/experiment.md"

# 幻灯片
if [ -f "$SRC/RSI_Safety_Motivation_4slides.pptx" ]; then
  install -m 644 "$SRC/RSI_Safety_Motivation_4slides.pptx" \
    "$REPO/docs/assets/rsi-safety-motivation-4slides.pptx"
fi

echo "已同步到 $REPO/docs（源目录：$SRC）"
echo "提示：docs/index.md、docs/results.md、docs/slides.md 为本站原创页面，不会被覆盖。"
