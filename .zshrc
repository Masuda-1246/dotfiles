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

# ── mise (全てのランタイム・ツール管理はここに集約) ──
# node, python, go, deno, pnpm, uv, terraform, kubectl, starship, etc.
# 設定: ~/.config/mise/config.toml
eval "$(mise activate zsh)"

# mise管理のdirenvを有効化
eval "$(mise exec direnv -- direnv hook zsh)"

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
