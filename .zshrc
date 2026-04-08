# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh ──
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(`#git` web-search zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# ── 環境変数 ──
export LANG=ja_JP.UTF-8
export PATH=/opt/homebrew/bin:$PATH

# ── Git ──
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }

function gitmain() {
  git config --global user.name "Masuda-1246"
  git config --global user.email "yaojiezengtian38@gmail.com"
}

function gitsub() {
  git config --global user.name "manamu1217"
  git config --global user.email "nagisa_nasu@manamu.jp"
}

# ── mise (全てのランタイム・ツール管理はここに集約) ──
# node, python, go, deno, pnpm, uv, terraform, kubectl, etc.
# 設定: ~/.config/mise/config.toml
eval "$(mise activate zsh)"

# mise管理のdirenvを有効化
eval "$(mise exec direnv -- direnv hook zsh)"

# ── Aliases ──
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
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

# ── Powerlevel10k ──
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PS1="%1~ %C/"

# ── LM Studio CLI ──
export PATH="$PATH:$HOME/.lmstudio/bin"
