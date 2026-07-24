---
name: 書籍キックオフ
about: 次冊の執筆開始 — 正本・フォーマット・章Issue一覧を決める
title: "[企画] "
labels: phase:meta
assignees: ''
---

## 書籍情報

- **タイトル**:
- **スラッグ**（フォルダ名）: `<!-- 例: japanism-tasogare -->`
- **副題**:
- **目標語数**:

## 配布フォーマット方針（先に固定）

> **次冊以降のデフォルト出力は EPUB（横書き）** です。

- [ ] **必須**: 横書き EPUB（`build.py --format epub-horizontal --no-cover`）
- [ ] 縦書き EPUB（基本は作らない。必要時のみ `format:epub-v` Issue を別起票）
- [ ] DOCX（KDP 入稿が必要なときのみ `format:docx` Issue を別起票）
- **表紙**: あり / なし（<!-- 推奨: なし -->）
- **目次**: あり（`book.md` 結合時に自動生成）

## ディレクトリ準備

- [ ] `manuscript/<slug>/book.md` — **唯一の正本**（結合スクリプト出力先）
- [ ] `drafts/<slug>/` — 章ドラフト
- [ ] `notes/<slug>/` — 用語集・data-pack
- [ ] `scripts/<slug>/` — `combine_drafts.py` + `build.py`（kokka-shugi をコピーして改変）
- [ ] `output/<slug>/` — 配布物

## 章 Issue 一覧

| 章 | Issue | 状態 |
|----|-------|------|
| 序章 | # | OPEN |
| 第1章 | # | |
| … | | |

## 標準ビルドコマンド（Issue に必ず1行で書く）

```bash
python3 scripts/<slug>/build.py --format epub-horizontal --no-cover --verify
```

## 関連

- 企画リポジトリ:
- 前冊との連続性:

## メモ

<!-- Issue #15 提案B/F 実装テンプレ / 2026-06-20 -->