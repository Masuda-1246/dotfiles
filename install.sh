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
echo "[1/10] Homebrew"
if ! command -v brew &>/dev/null; then
  echo "  Homebrew をインストール中..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo "  brew bundle..."
brew bundle --file="$DOTFILES_DIR/Brewfile" || echo "  [warn] 一部の brew パッケージのインストールに失敗しました（上のログを確認）"
echo ""

# ── 2. mise config ──
echo "[2/10] mise config"
backup_and_link "$DOTFILES_DIR/.config/mise/config.toml" "$HOME/.config/mise/config.toml"

# ── 3. uv config ──
echo "[3/10] uv config"
backup_and_link "$DOTFILES_DIR/.config/uv/uv.toml" "$HOME/.config/uv/uv.toml"

# ── 4. starship config ──
echo "[4/10] starship config"
backup_and_link "$DOTFILES_DIR/.config/starship/starship.toml" "$HOME/.config/starship/starship.toml"

# ── 5. .npmrc ──
echo "[5/10] .npmrc"
backup_and_link "$DOTFILES_DIR/.npmrc" "$HOME/.npmrc"

# ── 6. .zshrc ──
echo "[6/10] .zshrc"
backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# ── 7. yabai + skhd ──
echo "[7/10] yabai + skhd"
backup_and_link "$DOTFILES_DIR/.yabairc" "$HOME/.yabairc"
backup_and_link "$DOTFILES_DIR/.skhdrc" "$HOME/.skhdrc"

echo "  yabai/skhd サービス起動..."
yabai --start-service 2>/dev/null || true
skhd --start-service 2>/dev/null || true
echo ""

# ── 8. Claude Code ──
echo "[8/10] Claude Code"
backup_and_link "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
backup_and_link "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# ── 9. Codex CLI ──
echo "[9/10] Codex CLI"
backup_and_link "$DOTFILES_DIR/.codex/config.toml" "$HOME/.codex/config.toml"
backup_and_link "$DOTFILES_DIR/.codex/instructions.md" "$HOME/.codex/instructions.md"

echo "  pnpm global に @openai/codex をインストール..."
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
pnpm add -g @openai/codex 2>/dev/null || echo "  [warn] codex のインストールに失敗（pnpm setup が必要かも）"
echo ""

# ── 10. mise tools ──
echo "[10/10] mise tools をインストール中..."
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
echo "  4. Oh My Zsh が不要になったら削除:"
echo "     rm -rf ~/.oh-my-zsh ~/.p10k.zsh"
echo "  5. 不要な brew パッケージを削除:"
echo "     brew uninstall nvm pyenv nodebrew rbenv tfenv poetry pipx virtualenv yarn"
