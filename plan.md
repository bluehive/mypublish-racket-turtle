# plan.md — Racket タートルグラフィックス入門

## ステータス

| 項目 | 状態 |
|------|------|
| タイトル | 『Racket タートルグラフィックス入門』 |
| 第1章 | `#lang htdp/bsl` |
| 第2章 | `#lang htdp/bsl` + `teachpacks/racket-turtle` |
| 第3章 | `#lang htdp/isl` + turtle。**再帰ではなくループ**（`repeat` / `build-list` / `map`） |
| 終章 | 薄い |
| 今版外 | フラクタル本線・Processing・明示的再帰 |

## 次の執筆タスク

1. ~~第3章をループ版に書き直し~~（`ch03-loops` / `drafts` へ旧稿退避）
2. 終章を薄く刈る
3. 未収録（フラクタル）ファイルの退避／削除判断

## 言語方針（今版）

| 段階 | 言語 | 用途 |
|------|------|------|
| 第1章 | `htdp/bsl` | 式・関数・テスト |
| 第2章 | `htdp/bsl` + turtle | 基本図形 |
| 第3章 | `htdp/isl` + turtle | 繰り返しで複雑な図形 |
