# ── 環境変数 ──
export LANG=ja_JP.UTF-8
export PATH=/opt/homebrew/bin:$PATH

# GNU make (brew) — `make` が Xcode の xcodebuild 経由にならないようにする
if [[ -d /opt/homebrew/opt/make/libexec/gnubin ]]; then
  export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
elif [[ -d /usr/local/opt/make/libexec/gnubin ]]; then
  export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
fi

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# ── pnpm global ──
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ── MISE_GITHUB_TOKEN (ファイルキャッシュ / 1時間有効) ──
_gh_cache="$HOME/.cache/mise/gh-token"
if [[ -f "$_gh_cache" ]] && (( $(date +%s) - $(stat -f %m "$_gh_cache") < 3600 )); then
  export MISE_GITHUB_TOKEN="$(<$_gh_cache)"
else
  export MISE_GITHUB_TOKEN="$(gh auth token 2>/dev/null || true)"
  [[ -n "$MISE_GITHUB_TOKEN" ]] && { mkdir -p "${_gh_cache:h}"; echo "$MISE_GITHUB_TOKEN" > "$_gh_cache"; }
fi
unset _gh_cache

# ── mise (全てのランタイム・ツール管理はここに集約) ──
# --shims: precmd hook の代わりに shim PATH を使い起動を高速化
# 設定: ~/.config/mise/config.toml
eval "$(mise activate zsh --shims)"

# direnv — shim 経由で直接呼び出し (mise exec ラッパー不要)
eval "$(direnv hook zsh)"

# ── Starship prompt ──
eval "$(starship init zsh)"

# ── Zsh Plugins (sheldon) ──
# zsh-autosuggestions, zsh-syntax-highlighting 等を管理
# 設定: ~/.config/sheldon/plugins.toml
eval "$(sheldon source)"

# ── Git ──
function gitmain() {
  git config --global user.name "Masuda-1246"
  git config --global user.email "yaojiezengtian38@gmail.com"
}

function gitsub() {
  git config --global user.name "manamu1217"
  git config --global user.email "nagisa_nasu@manamu.jp"
}

# ── AWS (awsume) ──
# awsume はカレントシェルの AWS 環境変数を書き換えるため source 経由で実行する
unalias awsume 2>/dev/null
function awsume() {
  source "$(mise which awsume)" "$@"
}

# ── Aliases ──
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias slack="open -a 'Slack'"
alias chrome="open -a 'Google Chrome'"
alias brave="open -a 'Brave Browser'"
alias obsidian="open -a 'Obsidian'"
alias notion="open -a 'Notion'"

# ── Zsh Options ──
setopt auto_cd
setopt no_beep
setopt auto_pushd
setopt pushd_ignore_dups
setopt hist_ignore_all_dups
setopt share_history
setopt inc_append_history

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ── LM Studio CLI ──
export PATH="$PATH:$HOME/.lmstudio/bin"

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"
