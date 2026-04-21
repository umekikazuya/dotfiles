#!/usr/bin/env bash
#
# Mint Mono (yuru7) に Nerd Fonts のグリフをパッチして ~/Library/Fonts/ にインストールする。
# 依存: docker (colima 等), gh, unzip
# Usage:
#   ./scripts/build-mintmono-nf.sh                # 通常版 + 35 版 (default)
#   ./scripts/build-mintmono-nf.sh --variant normal # 通常版のみ
#   ./scripts/build-mintmono-nf.sh --variant 35     # 35 版のみ

set -euo pipefail

VARIANT="${VARIANT:-both}"
MINT_MONO_VERSION="${MINT_MONO_VERSION:-v0.0.1}"
WORK_DIR="${WORK_DIR:-$HOME/tmp/mintmono-nf}"
FONT_DIR="${FONT_DIR:-$HOME/Library/Fonts}"
PATCHER_IMAGE="nerdfonts/patcher:latest"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --variant) VARIANT="$2"; shift 2 ;;
    --work-dir) WORK_DIR="$2"; shift 2 ;;
    --version) MINT_MONO_VERSION="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,10p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
done

case "$VARIANT" in
  normal|35|both) ;;
  *) echo "--variant must be one of: normal, 35, both" >&2; exit 1 ;;
esac

for cmd in docker gh unzip; do
  command -v "$cmd" >/dev/null || { echo "required command not found: $cmd" >&2; exit 1; }
done

docker info >/dev/null 2>&1 || { echo "docker daemon not reachable (is colima running?)" >&2; exit 1; }

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

ZIP="MintMono_${MINT_MONO_VERSION}.zip"
if [[ ! -f "$ZIP" ]]; then
  echo "==> downloading $ZIP"
  gh release download "$MINT_MONO_VERSION" --repo yuru7/mint-mono --pattern "$ZIP" --dir .
fi

SRC_DIR="MintMono_${MINT_MONO_VERSION}"
if [[ ! -d "$SRC_DIR" ]]; then
  unzip -o "$ZIP"
fi

echo "==> pulling $PATCHER_IMAGE"
docker pull "$PATCHER_IMAGE" >/dev/null

patch_and_install() {
  local subdir="$1"   # MintMono or MintMono35
  local out="$WORK_DIR/out-$subdir"

  rm -rf "$out"; mkdir -p "$out"
  echo "==> patching $subdir"
  docker run --rm \
    -v "$WORK_DIR/$SRC_DIR/$subdir:/in" \
    -v "$out:/out" \
    "$PATCHER_IMAGE" \
    --complete --mono --careful >/dev/null

  echo "==> installing $subdir"
  cp "$out"/*.ttf "$FONT_DIR/"
  ls "$out"
}

case "$VARIANT" in
  normal) patch_and_install MintMono ;;
  35)     patch_and_install MintMono35 ;;
  both)   patch_and_install MintMono; patch_and_install MintMono35 ;;
esac

echo ""
echo "Done. Family names to use in your terminal config:"
echo "  - MintMono Nerd Font Mono     (normal)"
echo "  - MintMono35 Nerd Font Mono   (35)"
