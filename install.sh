#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

backup_and_link() {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -a "$dest" "$BACKUP_DIR/$(basename "$dest")"
    echo "  [backup] $dest → $BACKUP_DIR/$(basename "$dest")"
    rm -rf "$dest"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  echo "  [link]   $src → $dest"
}

echo "=== mise dotfiles installer ==="
echo ""

echo "[1/5] mise config"
backup_and_link "$DOTFILES_DIR/.config/mise/config.toml" "$HOME/.config/mise/config.toml"

echo "[2/5] uv config"
backup_and_link "$DOTFILES_DIR/.config/uv/uv.toml" "$HOME/.config/uv/uv.toml"

echo "[3/5] .npmrc"
backup_and_link "$DOTFILES_DIR/.npmrc" "$HOME/.npmrc"

echo "[4/5] .zshrc"
backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

echo "[5/5] Installing mise tools..."
mise install --yes

echo ""
echo "=== 完了 ==="
echo "バックアップ: $BACKUP_DIR"
echo ""
echo "次のステップ:"
echo "  1. source ~/.zshrc  (シェルをリロード)"
echo "  2. mise ls           (インストール済みツールを確認)"
echo "  3. ~/node_modules と ~/package.json は不要なら削除可能"
echo ""
echo "注意: pnpmのminimum-release-ageにはpnpm >= 10.16が必要です"
echo "  mise install pnpm@latest で最新版にアップデートしてください"
