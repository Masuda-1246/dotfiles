# グローバルルール

必ず日本語で応答すること。

## 開発環境

この環境は **mise** で一元管理されている。

### ツール管理

- ランタイム・CLI のバージョン管理: `mise`（`~/.config/mise/config.toml`）
- Node.js パッケージマネージャ: **pnpm のみ**（npm / yarn 禁止）
- Python パッケージマネージャ: **uv のみ**（pip / pipx 禁止）
- nvm / pyenv / conda / nodebrew 等は使わない

### コマンド対応表

| やりたいこと | 使うコマンド |
|---|---|
| Node パッケージ追加 | `pnpm add` / `pnpm install` |
| パッケージ実行 | `pnpm dlx`（npx 禁止） |
| Python 依存追加 | `uv add` |
| Python スクリプト実行 | `uv run` |
| ツールバージョン管理 | `mise use` / `mise install` |

### サプライチェーン攻撃対策

以下の設定が全レイヤーで有効。無効化禁止。

1. **mise**: `install_before = "7d"` — 7日未満のバイナリをブロック
2. **pnpm**: `minimum-release-age=10080`（.npmrc）— 7日未満の npm パッケージをブロック
3. **uv**: `exclude-newer = "P7D"`（uv.toml）— 7日未満の Python パッケージをブロック
4. ロックファイル（`pnpm-lock.yaml`, `uv.lock`）は必ずコミット

### 禁止事項

- `npm install`, `npm ci`, `npm run`, `npx` を実行しない
- `yarn add`, `yarn install` を実行しない
- `pip install`, `pip3 install` を実行しない
- `brew install` でランタイムや CLI ツールを入れない（mise にあるもの）
- `--no-lockfile`, `--ignore-lockfile` を使わない
