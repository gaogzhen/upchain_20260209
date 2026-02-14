#!/usr/bin/env bash
# 使用 forge 编译并导出合约 ABI 到 deployments/abi
# 用法: ./sh/gen-abi.sh  或从项目根目录: forge build && ./sh/gen-abi.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ABI_DIR="$ROOT_DIR/deployments/abi"
OUT_DIR="$ROOT_DIR/out"

cd "$ROOT_DIR"

echo "==> Building contracts (forge build)..."
if ! forge build; then
  echo "==> forge build 失败，尝试使用已有 out/ 目录导出 ABI..."
fi

if [[ ! -d "$OUT_DIR" ]]; then
  echo "错误: 未找到 $OUT_DIR，请先成功执行 forge build" >&2
  exit 1
fi

echo "==> Creating $ABI_DIR"
mkdir -p "$ABI_DIR"

echo "==> Exporting ABI JSON files..."
count=0
for artifact in "$OUT_DIR/"*/*.json; do
  [[ -f "$artifact" ]] || continue
  [[ "$artifact" == *.dbg.json ]] && continue
  name=$(basename "$artifact" .json)
  if jq -e '.abi' "$artifact" >/dev/null 2>&1; then
    jq '.abi' "$artifact" > "$ABI_DIR/${name}.json"
    echo "    ${name}.json"
    ((count++)) || true
  fi
done

echo "==> Done. $count ABI file(s) in deployments/abi/"
