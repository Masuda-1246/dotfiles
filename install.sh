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

echo "=== dotfiles installer ==="
echo ""

# ── 1. Homebrew ──
echo "[1/7] Homebrew"
if ! command -v brew &>/dev/null; then
  echo "  Homebrew をインストール中..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo "  brew bundle..."
brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock
echo ""

# ── 2. mise config ──
echo "[2/7] mise config"
backup_and_link "$DOTFILES_DIR/.config/mise/config.toml" "$HOME/.config/mise/config.toml"

# ── 3. uv config ──
echo "[3/7] uv config"
backup_and_link "$DOTFILES_DIR/.config/uv/uv.toml" "$HOME/.config/uv/uv.toml"

# ── 4. .npmrc ──
echo "[4/7] .npmrc"
backup_and_link "$DOTFILES_DIR/.npmrc" "$HOME/.npmrc"

# ── 5. .zshrc ──
echo "[5/7] .zshrc"
backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# ── 6. yabai + skhd ──
echo "[6/7] yabai + skhd"
backup_and_link "$DOTFILES_DIR/.yabairc" "$HOME/.yabairc"
backup_and_link "$DOTFILES_DIR/.skhdrc" "$HOME/.skhdrc"

echo "  yabai/skhd サービス起動..."
yabai --start-service 2>/dev/null || true
skhd --start-service 2>/dev/null || true
echo ""

# ── 7. mise tools ──
echo "[7/7] mise tools をインストール中..."
mise install --yes

echo ""
echo "=== 完了 ==="
echo "バックアップ: $BACKUP_DIR"
echo ""
echo "次のステップ:"
echo "  1. source ~/.zshrc"
echo "  2. mise ls"
echo "  3. yabai/skhd: アクセシビリティ権限を付与"
echo "     システム設定 → プライバシーとセキュリティ → アクセシビリティ"
echo "  4. 不要な brew パッケージを削除:"
echo "     brew uninstall nvm pyenv nodebrew rbenv tfenv poetry pipx virtualenv yarn"
