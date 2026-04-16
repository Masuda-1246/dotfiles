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
echo "[1/12] Homebrew"
if ! command -v brew &>/dev/null; then
  echo "  Homebrew をインストール中..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo "  brew bundle..."
brew bundle --file="$DOTFILES_DIR/Brewfile" || echo "  [warn] 一部の brew パッケージのインストールに失敗しました（上のログを確認）"
echo ""

# ── 2. mise config ──
echo "[2/12] mise config"
backup_and_link "$DOTFILES_DIR/.config/mise/config.toml" "$HOME/.config/mise/config.toml"

# ── 3. uv config ──
echo "[3/12] uv config"
backup_and_link "$DOTFILES_DIR/.config/uv/uv.toml" "$HOME/.config/uv/uv.toml"

# ── 4. starship config ──
echo "[4/12] starship config"
backup_and_link "$DOTFILES_DIR/.config/starship/starship.toml" "$HOME/.config/starship/starship.toml"

# ── 5. sheldon (zsh plugin manager) config ──
echo "[5/12] sheldon config"
backup_and_link "$DOTFILES_DIR/.config/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml"

# ── 6. .npmrc ──
echo "[6/12] .npmrc"
backup_and_link "$DOTFILES_DIR/.npmrc" "$HOME/.npmrc"

# ── 7. bunfig.toml ──
echo "[7/12] bunfig.toml"
backup_and_link "$DOTFILES_DIR/.config/bun/bunfig.toml" "$HOME/.config/bun/bunfig.toml"

# ── 8. .zshrc ──
echo "[8/12] .zshrc"
backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# ── 9. Claude Code ──
echo "[9/12] Claude Code"
backup_and_link "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
backup_and_link "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# ── 10. Codex CLI ──
echo "[10/12] Codex CLI"
backup_and_link "$DOTFILES_DIR/.codex/config.toml" "$HOME/.codex/config.toml"
backup_and_link "$DOTFILES_DIR/.codex/instructions.md" "$HOME/.codex/instructions.md"

echo "  pnpm global に @openai/codex をインストール..."
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
pnpm add -g @openai/codex 2>/dev/null || echo "  [warn] codex のインストールに失敗（pnpm setup が必要かも）"
echo ""

# ── 11. mise tools ──
echo "[11/12] mise tools をインストール中..."
mise install --yes

# ── 12. awsume autocomplete ──
echo "[12/12] awsume autocomplete"
if command -v awsume-autocomplete &>/dev/null; then
  mkdir -p "$HOME/.awsume/zsh-autocomplete"
  echo "  awsume autocomplete を設定済み"
else
  echo "  [skip] awsume-autocomplete が見つかりません（mise install 後に再実行してください）"
fi

echo ""
echo "=== 完了 ==="
echo "バックアップ: $BACKUP_DIR"
echo ""
echo "次のステップ:"
echo "  1. source ~/.zshrc"
echo "  2. mise ls"
echo "  3. 同じ内容の再実行は: make setup（GNU make は Brewfile / .zshrc で管理）"
echo "  4. Oh My Zsh が不要になったら削除:"
echo "     rm -rf ~/.oh-my-zsh ~/.p10k.zsh"
echo "  5. 不要な brew パッケージを削除:"
echo "     brew uninstall nvm pyenv nodebrew rbenv tfenv poetry pipx virtualenv yarn"
