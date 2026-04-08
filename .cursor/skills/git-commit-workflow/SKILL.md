---
name: git-commit-workflow
description: >-
  この dotfiles リポジトリでユーザーがコミット、push、変更の反映、リポジトリに上げて、
  など Git に載せる依頼をしたときに適用する。git status / diff を確認し、
  適切な日本語のコミットメッセージでコミットする。push は明示されたときのみ実行する。
---

# Git コミット・反映ワークフロー（dotfiles）

## いつ使うか

ユーザーが次のような依頼をしたときに **必ずこの手順で実行**する。

- 「コミットして」「commit」「push まで」「リモートに上げて」
- 「変更を Git に反映」「まとめてコミット」

## 手順

1. **調査**: `git status` と `git diff`（必要なら `git log --oneline -5`）を実行し、変更内容を把握する。
2. **ステージ**: 意図した変更だけを `git add` する。無関係なファイルは含めない。
3. **メッセージ**: Conventional Commits に近いプレフィックス（`fix:` / `feat:` / `chore:` / `docs:` など）と、**日本語の本文**で、何を・なぜ変えたかが分かる 1 行以上の説明にする。
4. **コミット**: `git commit` を実行する（heredoc で複数行メッセージ可）。
5. **push**: ユーザーが **push / リモート / origin / 上げて** 等を明示したときだけ `git push` する。「コミットだけ」のときは push しない。

## 禁止・注意

- ユーザーに「実行してください」と丸投げせず、エージェント側でコマンドを実行する。
- シークレット・トークン・個人のメール等をコミットに含めない。
- 空コミットや、説明のない `update` だけのメッセージは避ける。

## 例

```bash
git add -A
git commit -m "$(cat <<'EOF'
fix(starship): node モジュールを nodejs に修正

Starship 1.24+ では [node] が非対応のため Unknown key 警告が出ていた。
EOF
)"
```

push が必要なとき:

```bash
git push
```
